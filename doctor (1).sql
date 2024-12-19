-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 19, 2024 at 04:17 AM
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
-- Database: `doctor`
--

-- --------------------------------------------------------

--
-- Table structure for table `doctordetails`
--

CREATE TABLE `doctordetails` (
  `id` int(255) NOT NULL,
  `doctor_id` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` varchar(10) NOT NULL,
  `gender` varchar(15) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `specialization` varchar(40) NOT NULL,
  `location` varchar(200) NOT NULL,
  `imagePath` varchar(255) NOT NULL,
  `hospital_affiliation` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctordetails`
--

INSERT INTO `doctordetails` (`id`, `doctor_id`, `name`, `age`, `gender`, `mobile`, `email`, `specialization`, `location`, `imagePath`, `hospital_affiliation`) VALUES
(1, '1', 'Dr. John Smith', '45', 'Male', '1234567890', 'john.smith@example.com', 'Cardiology', 'New York', '/images/dr_john_smith.jpg', ''),
(2, '10', 'Dr. Barbara Wilson', '42', 'Female', '8899001122', 'barbara.wilson@example.com', 'Psychiatry', 'Austin', '/images/dr_barbara_wilson.jpg', ''),
(3, '2', 'Dr. Emily Johnson', '38', 'Female', '0987654321', 'emily.johnson@example.com', 'Pediatrics', 'Los Angeles', '/images/dr_emily_johnson.jpg', ''),
(4, '3', 'Dr. Michael Brown', '50', 'Male', '1122334455', 'michael.brown@example.com', 'Orthopedics', 'Chicago', '/images/dr_michael_brown.jpg', ''),
(5, '4', 'Dr. Sarah Davis', '30', 'Female', '2233445566', 'sarah.davis@example.com', 'Dermatology', 'Houston', '/images/dr_sarah_davis.jpg', ''),
(6, '5', 'Dr. David Wilson', '55', 'Male', '3344556677', 'david.wilson@example.com', 'Neurology', 'Phoenix', '/images/dr_david_wilson.jpg', ''),
(7, '6', 'Dr. Laura Garcia', '40', 'Female', '4455667788', 'laura.garcia@example.com', 'General Practice', 'San Antonio', '/images/dr_laura_garcia.jpg', ''),
(8, '7', 'Dr. James Martinez', '60', 'Male', '5566778899', 'james.martinez@example.com', 'Oncology', 'San Diego', '/images/dr_james_martinez.jpg', ''),
(9, '8', 'Dr. Patricia Rodriguez', '35', 'Female', '6677889900', 'patricia.rodriguez@example.com', 'Gynecology', 'Dallas', '/images/dr_patricia_rodriguez.jpg', ''),
(10, '9', 'Dr. Charles Lee', '48', 'Male', '7788990011', 'charles.lee@example.com', 'Endocrinology', 'San Jose', '66e7f511af2d6.jpg', ''),
(11, 'doc_8UI', 'bharath', '0', '', '', '19211111.sse@saveetha.com', '', '', '', ''),
(16, 'doc_929', 'balaji', '', '', '', 'balaji@gmail.com', '', '', '', ''),
(12, 'doc_AmtB', 'jashwanthr ', '20', 'male', '8667327637', 'r.jashwanth@gmail.com', 'nothing', 'chennai', '6719febaac01d.jpg', 'saveethan'),
(17, 'doc_ElfTs', 'jashwanthnoir', '', '', '', '192111114@gmail.com', '', '', '', ''),
(18, 'doc_Gc5', 'dark', '', '', '', '192111114.sse@saveethe.com', '', '', '', ''),
(15, 'doc_hmGG', 'kishore', '21', 'male', '8667327637', 'kishore@gmail.com', 'nanosurgeon', 'chennai', '66fb92b6a2ace.jpg', 'saveetha '),
(13, 'doc_RBm', 'jash', '19', 'male', '8667327637', 'r.jashwanth@gmail.com', 'new', 'chennai', '', 'saveethan'),
(14, 'doc_TDzkP', 'rahul', '70', 'male', '866', 'life.saveetha.com', 'noir', 'Chennai ', '66f9abe04cd21.jpg', 'saveetha');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `id` int(55) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `doctor_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`id`, `username`, `password`, `name`, `email`, `doctor_id`) VALUES
(20, 'jash', '$2y$10$4MpygY.fSw7o5VJ3P3moY.u4vMu.QZ0D/A9IEnb/tz2cqlH8fCjvi', 'jashwanth', 'r.jashwanth170@gmail.com', 'doc_AmtB'),
(21, 'ragu', '$2y$10$E2k3EpR57hVcZRUL3oVrb.23qmqAqUUjx9GM4Iw8ETtxD3fq5Avga', 'rahul', 'life.saveetha.com', 'doc_TDzkP'),
(22, 'kish', '$2y$10$mKQ/x2jlOIFkvpHNPkSWU.j7LBspM3Ut5qWv36On5qCvj5lzgnzc.', 'kishore', 'kishore@gmail.com', 'doc_hmGG'),
(23, 'bala', '$2y$10$pUtQsHLJ4OfGFN.k/TwGPe5Kb6N121phIhS1mcybaOzE1Qb/RhzlC', 'balaji', 'balaji@gmail.com', 'doc_929'),
(24, 'jashw', '$2y$10$b2q3Rq0xsyZ4bTAIcZatseyUE/gj0SRJpFjT2Cun1yASx1mvl5nta', 'jashwanthnoir', '192111114@gmail.com', 'doc_ElfTs'),
(25, 'samm', '$2y$10$krEIp42HHH5KprLEU2J.N.ow0xt1MDy/MMWcDpUIbXv7Z7qvhTFYu', 'dark', '192111114.sse@saveethe.com', 'doc_Gc5');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` int(200) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(10) NOT NULL,
  `gender` varchar(30) NOT NULL,
  `number` varchar(10) NOT NULL,
  `pid` varchar(100) NOT NULL,
  `address` varchar(150) NOT NULL,
  `date` varchar(30) NOT NULL,
  `imagePath` varchar(255) NOT NULL,
  `doctor_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`id`, `name`, `age`, `gender`, `number`, `pid`, `address`, `date`, `imagePath`, `doctor_id`) VALUES
(23, 'Jashwanth R', 96, 'male', '8667327637', 'ffj', 'yc', '13', 'C:/xampp/htdocs/entry/uploads/66e7f511af2d6.jpg', 'doc_AmtB'),
(28, 'Wolverine ', 195, 'male', '8667327637', 'dodo123', 'afsghsh', '13-04-2004', 'C:/xampp/htdocs/entry/uploads/66f13e174ad02.jpg', 'doc_AmtB'),
(29, 'wolverine', 195, 'male', '8667327637', 'dgto', 'shevjdu', '13-04-2004', '67036651858e0.jpg', 'doc_AmtB'),
(30, 'jashu', 20, 'male', '8667327637', 'jas3434', 'nothing ', '13-04-2004', 'C:/xampp/htdocs/entry/uploads/66f29283159b9.jpg', 'doc_AmtB'),
(68, 'dharun', 22, 'male', '8667327637', 'yshsj', 'peacock', '29-09-2003', '66fb9751dcefd.jpg', 'doc_hmGG'),
(69, 'gsj', 64, 'eghe', '5494648184', 'peacock', 'twhwi', '13-04-2004', '66fb986ba8c14.jpg', 'doc_hmGG'),
(70, 'jashh', 94, 'male', '086454894', 'peacocks', 'sfwhi', '13-04-2004', '66fb9a47e799c.jpg', 'doc_hmGG'),
(71, 'aswiniiii', 21, 'male', '6374241858', 'mr.white', '6 Vivekanadar theru, Dubai kurukku sandhu, dubai main road, Dubai', '30-02-2003', '66fd80d75daa3.jpg', 'doc_AmtB'),
(72, 'vish', 22, 'male', '64989', 'ydhjo', 'jasgy', '13-04-2004', '66fe4a0eed319.jpg', 'doc_AmtB'),
(73, 'sujith', 22, 'male', '866732763', 'gshsi', 'death', '13-04-2004', '66fd85c751ab3.jpg', 'doc_AmtB'),
(74, 'vishnu', 94, 'vwj', '64949', 'hwuwjnq', 'ywuwjnwj', '11-30-2004', '', 'doc_AmtB'),
(76, 'siva', 999, 'male', '8667327637', 'mdkjh', 'adddu', '13-04-2004', '6729cbf63d413.jpg', 'doc_AmtB'),
(79, 'Ragul', 16, 'Male', '8667327763', 'gosg', 'sthhwiywgw', '13-04-2004', '6703771e3dee8.jpg', 'doc_AmtB'),
(80, 'ishaaq', 13, 'Male', '8667327637', 'gst', 'hshsjeiognoosu', '13-04-2004', '670377e3cb94f.jpg', 'doc_AmtB'),
(82, 'Jash', 13, 'Male', '8667327637', 'pid13', '6 netaji nagar,dubai main road,dubai Kuruku Sandhu,dubai', '13-04-2004', '6704a9599779c.jpg', 'doc_AmtB');

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

CREATE TABLE `score` (
  `id` int(200) NOT NULL,
  `totalUpper` int(10) NOT NULL,
  `totalWrist` int(10) NOT NULL,
  `totalHand` int(10) NOT NULL,
  `totalSpeed` int(10) NOT NULL,
  `totalSensation` int(10) NOT NULL,
  `totalJointMotion` int(10) NOT NULL,
  `totalJointPain` int(10) NOT NULL,
  `pid` varchar(100) NOT NULL,
  `doctor_id` varchar(100) NOT NULL,
  `day` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `score`
--

INSERT INTO `score` (`id`, `totalUpper`, `totalWrist`, `totalHand`, `totalSpeed`, `totalSensation`, `totalJointMotion`, `totalJointPain`, `pid`, `doctor_id`, `day`) VALUES
(17, 30, 10, 3, 49, 9, 5, 1, 'gshk', 'doc_AmtB', 0),
(18, 36, 10, 14, 6, 12, 13, 5, 'gwjjjjjjj', 'doc_AmtB', 0),
(19, 7, 6, 5, 4, 3, 2, 1, 'fwhi', 'doc_AmtB', 0),
(20, 7, 6, 5, 4, 3, 2, 1, 'fwhi', 'doc_AmtB', 0),
(21, 1, 3, 2, 5, 5, 8, 10, 'qi134', 'doc_hmGG', 0),
(22, 13, 5, 11, 1, 5, 9, 11, 'mdkjh', 'doc_AmtB', 0),
(23, 13, 5, 11, 1, 5, 9, 11, 'mdkjh', 'doc_AmtB', 1),
(24, 2, 2, 3, 5, 7, 9, 9, 'mdkjh', 'doc_AmtB', 7),
(28, 1, 2, 3, 4, 5, 6, 7, 'gst', 'doc_AmtB', 1),
(30, 12, 9, 10, 5, 10, 7, 17, 'pid13', 'doc_AmtB', 1),
(34, 2, 2, 3, 5, 5, 5, 5, 'gosg', 'doc_AmtB', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `doctordetails`
--
ALTER TABLE `doctordetails`
  ADD PRIMARY KEY (`doctor_id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `score`
--
ALTER TABLE `score`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `doctordetails`
--
ALTER TABLE `doctordetails`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `id` int(55) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int(200) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT for table `score`
--
ALTER TABLE `score`
  MODIFY `id` int(200) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
