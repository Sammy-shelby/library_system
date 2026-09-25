const express = require('express');
const mysql = require('mysql2');
const path = require('path');

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'campus_library'
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed:', err);
    } else {
        console.log('Database Connected successfully to XAMPP!');
    }
});

app.get('/search-books', (req, res) => {
    const search = req.query.q || '';
    const sql = 'SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?';
    const queryTerm = `%${search}%`;

    db.query(sql, [queryTerm, queryTerm, queryTerm], (err, results) => {
        if (err) {
            console.error("SQL Error fetching books:", err);
            return res.status(500).json({ error: 'Failed to fetch catalog.' });
        }
        res.json(results);
    });
});

app.post('/borrow-book', (req, res) => {
    const { isbn, studentId } = req.body;

    const studentIdRegex = /^\d{6,8}$/;
    if (!studentId || !studentIdRegex.test(studentId)) {
        return res.status(400).json({ error: 'Invalid Student ID format. Must be 6-8 digits.' });
    }

    const findBookSql = 'SELECT book_id FROM books WHERE isbn = ?';
    db.query(findBookSql, [isbn], (err, bookResults) => {
        if (err || bookResults.length === 0) {
            return res.status(404).json({ error: 'Book not found.' });
        }

        const bookId = bookResults[0].book_id;
        const updateBookSql = 'UPDATE books SET status = "Borrowed" WHERE isbn = ?';

        db.query(updateBookSql, [isbn], (err) => {
            if (err) return res.status(500).json({ error: 'Failed to update status.' });

            const logRecordSql = `
                INSERT INTO borrow_records (student_id, book_id, borrow_date, due_date, is_approved) 
                VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY), 0)
            `;

            db.query(logRecordSql, [studentId, bookId], (err) => {
                if (err) {
                    console.error("Error inserting borrow record:", err);
                    return res.status(500).json({ error: 'Failed to log transaction.' });
                }
                res.json({ success: true, message: 'Book reserved successfully!' });
            });
        });
    });
});


app.post('/return-book', (req, res) => {
    const { isbn } = req.body;
    
    // Check if librarian has approved the return (is_approved = 1)
    const checkApprovalSql = `
        SELECT is_approved FROM borrow_records 
        WHERE book_id = (SELECT book_id FROM books WHERE isbn = ?) 
        ORDER BY transaction_id DESC LIMIT 1
    `;

    db.query(checkApprovalSql, [isbn], (err, results) => {
        if (err) return res.status(500).json({ error: 'Database check failed.' });

        if (results.length > 0 && Number(results[0].is_approved) === 0) {
            return res.json({ pending: true, message: "Pending approval from librarian." });
        }
        
        res.json({ success: true, message: "Book returned successfully!" });
    });
});


app.post('/login', (req, res) => {
    const { username, password } = req.body;

    // Hardcoded check or query your admin table
    if (username === 'admin' && password === 'library2026') { 
        return res.json({ success: true, message: 'Login successful' });
    }

    res.status(401).json({ success: false, error: 'Invalid credentials' });
});
// Add New Book
app.post('/add-book', (req, res) => {
    const { title, author, isbn, shelf_loc } = req.body;
    const sql = 'INSERT INTO books (title, author, isbn, shelf_loc, status) VALUES (?, ?, ?, ?, "Available")';

    db.query(sql, [title, author, isbn, shelf_loc], (err) => {
        if (err) return res.status(500).json({ error: 'Failed to register book.' });
        res.json({ success: true });
    });
});

// Fetch Transactions for Approvals Dashboard
app.get('/admin/transactions', (req, res) => {
    
    const sql = `
        SELECT 
            br.transaction_id, 
            br.student_id, 
            br.borrow_date, 
            IFNULL(br.due_date, NOW()) AS due_date, 
            IFNULL(br.is_approved, 0) AS is_approved, 
            IFNULL(b.title, 'Unknown Title') AS title, 
            IFNULL(b.isbn, '') AS isbn 
        FROM borrow_records br
        LEFT JOIN books b ON br.book_id = b.book_id
        ORDER BY br.transaction_id DESC
    `;

    db.query(sql, (err, results) => {
        if (err) {
            console.error("SQL Error in /admin/transactions:", err);
            // Return an empty array so frontend doesn't throw TypeError: data.forEach is not a function
            return res.status(500).json([]); 
        }
        res.json(results);
    });
});


app.post('/admin/approve-return', (req, res) => {
    const { transactionId, isbn } = req.body;
    const approveSql = 'UPDATE borrow_records SET is_approved = 1, return_date = NOW() WHERE transaction_id = ?';
    const makeAvailableSql = 'UPDATE books SET status = "Available" WHERE isbn = ?';

    db.query(approveSql, [transactionId], (err) => {
        if (err) return res.status(500).json({ error: 'Failed to update record.' });

        db.query(makeAvailableSql, [isbn], (err) => {
            if (err) return res.status(500).json({ error: 'Failed to update book.' });
            res.json({ success: true, message: 'Return approved!' });
        });
    });
});


process.on('uncaughtException', (err) => {
    console.error('Caught exception:', err);
});

app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});