-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 25, 2026 at 07:33 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `campus_library`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `isbn` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Available',
  `shelf_loc` varchar(50) DEFAULT 'General Shelves'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `title`, `author`, `isbn`, `status`, `shelf_loc`) VALUES
(1, 'Totems of the Kisii', 'Abel O\'Keragori', '9966-884-74-2', 'Available', 'General Shelves'),
(2, 'ONE EARTH, ONE HOME', 'Dr. M.K. Tolba', '9280711474', 'Available', '2nd floor, shelf DS1'),
(3, 'The thorn in the Flesh', 'R.T. Kendall', '1-59185-612-4', 'Available', '1st floor shelf C'),
(4, 'Dangerous Relations ', 'Nancy Van Pelt', '978-1-906381-47-9', 'Available', 'Ground floor, shelf 23A'),
(5, 'Unbroken Curses', 'Rebecca Brown, M.D.', '978-32536-7-0', 'Borrowed', '2nd floor, shelf DS2');

-- --------------------------------------------------------

--
-- Table structure for table `borrow_records`
--

CREATE TABLE `borrow_records` (
  `transaction_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `student_id` varchar(50) NOT NULL,
  `borrow_date` date NOT NULL DEFAULT current_timestamp(),
  `return_date` date DEFAULT NULL,
  `is_ approved` tinyint(1) NOT NULL DEFAULT 0,
  `due_date` date DEFAULT NULL,
  `is_approved` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrow_records`
--

INSERT INTO `borrow_records` (`transaction_id`, `book_id`, `student_id`, `borrow_date`, `return_date`, `is_ approved`, `due_date`, `is_approved`) VALUES
(2, 2, '1061296', '2026-07-15', '2026-09-07', 0, NULL, 1),
(3, 2, '1061296', '2026-07-15', '2026-09-07', 0, NULL, 1),
(4, 3, '1061296', '2026-07-16', '2026-09-07', 0, NULL, 1),
(6, 1, '1061296', '2026-07-21', '2026-09-07', 0, '2026-07-26', 1),
(7, 2, '1061296', '2026-07-23', '2026-09-07', 0, '2026-07-28', 1),
(8, 2, '1061296', '2026-07-23', '2026-09-07', 0, '2026-07-28', 1),
(9, 2, '1234567', '2028-01-01', '2026-09-07', 0, '2028-01-06', 1),
(10, 3, '1026137', '2026-09-02', '2026-09-07', 0, '2026-09-07', 1),
(11, 4, '1061296', '2026-09-08', '2026-09-08', 0, '2026-09-13', 1),
(12, 1, '1071365', '2026-09-08', '2026-09-08', 0, '2026-09-13', 1),
(13, 1, '142396', '2026-09-08', '2026-09-08', 0, '2026-09-13', 1),
(14, 2, '136295', '2026-09-08', '2026-09-08', 0, '2026-09-13', 1),
(15, 5, '1042391', '2026-09-12', NULL, 0, '2026-09-17', 0),
(16, 4, '1061296', '2026-09-12', '2026-09-12', 0, '2026-09-17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `student_id` varchar(50) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `campus_branch` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`);

--
-- Indexes for table `borrow_records`
--
ALTER TABLE `borrow_records`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`student_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `borrow_records`
--
ALTER TABLE `borrow_records`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
