-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 27, 2026 at 07:38 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gym_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `time_slot`
--

CREATE TABLE `time_slot` (
  `id` int(11) NOT NULL,
  `slot` varchar(255) NOT NULL,
  `trainerId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `time_slot`
--

INSERT INTO `time_slot` (`id`, `slot`, `trainerId`) VALUES
(112, 'Tuesday 7:00 AM', 42),
(113, 'Thursday 5:00 PM', 42),
(114, 'Saturday 9:00 AM', 42),
(115, 'Monday 9:00 AM', 43),
(116, 'Wednesday 4:00 PM', 43),
(117, 'Friday 11:00 AM', 43),
(118, 'Monday 10:00 AM', 44),
(119, 'Wednesday 7:00 PM', 44),
(120, 'Saturday 10:00 AM', 44),
(121, 'Tuesday 8:00 AM', 45),
(122, 'Thursday 6:00 PM', 45),
(123, 'Sunday 9:00 AM', 45),
(124, 'Tuesday 9:00 AM', 46),
(125, 'Thursday 7:00 PM', 46),
(126, 'Saturday 11:00 AM', 46),
(127, 'Wednesday 8:00 AM', 47),
(128, 'Friday 6:00 PM', 47),
(129, 'Sunday 10:00 AM', 47),
(130, 'Wednesday 9:00 AM', 48),
(131, 'Friday 4:00 PM', 48),
(132, 'Sunday 11:00 AM', 48),
(133, 'Thursday 10:00 AM', 49),
(134, 'Saturday 7:00 PM', 49),
(135, 'Monday 10:00 AM', 49),
(136, 'Thursday 8:00 AM', 50),
(137, 'Saturday 6:00 PM', 50),
(138, 'Tuesday 9:00 AM', 50),
(139, 'Friday 9:00 AM', 51),
(140, 'Sunday 7:00 PM', 51),
(141, 'Wednesday 11:00 AM', 51),
(142, 'Monday 7:00 AM', 42),
(143, 'Tuesday 6:00 PM', 42),
(144, 'Friday 8:00 AM', 42),
(145, 'Monday 11:00 AM', 43),
(146, 'Thursday 9:00 AM', 43),
(147, 'Saturday 5:00 PM', 43),
(148, 'Tuesday 10:00 AM', 44),
(149, 'Friday 7:00 PM', 44),
(150, 'Sunday 8:00 AM', 44),
(151, 'Wednesday 6:00 PM', 45),
(152, 'Friday 10:00 AM', 45),
(153, 'Monday 8:00 PM', 45),
(154, 'Tuesday 7:00 PM', 46),
(155, 'Thursday 11:00 AM', 46),
(156, 'Sunday 6:00 PM', 46),
(157, 'Monday 9:00 PM', 47),
(158, 'Wednesday 10:00 AM', 47),
(159, 'Saturday 8:00 AM', 47),
(160, 'Tuesday 11:00 AM', 48),
(161, 'Thursday 4:00 PM', 48),
(162, 'Sunday 9:00 PM', 48),
(163, 'Monday 6:00 PM', 49),
(164, 'Wednesday 7:00 AM', 49),
(165, 'Friday 5:00 PM', 49),
(166, 'Tuesday 8:00 PM', 50),
(167, 'Thursday 9:00 PM', 50),
(168, 'Saturday 9:00 PM', 50),
(169, 'Wednesday 5:00 PM', 51),
(170, 'Friday 8:00 PM', 51);

-- --------------------------------------------------------

--
-- Table structure for table `trainer`
--

CREATE TABLE `trainer` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `speciality` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trainer`
--

INSERT INTO `trainer` (`id`, `name`, `email`, `password`, `speciality`) VALUES
(42, 'Brad Schoenfeld', 'vin1', '$2b$10$0za2Oza/gniQ./E9fX0YeOxoUD1hToOIYHqdpLh31yhPIOO.o9WVK', 'Pilates'),
(43, 'Matt Roberts', 'vin2', '$2b$10$xaXFUlTbfMceCuKk.jwVdehESBWhL1lW2Zm7GcScFPZ.EktOuMFqy', 'Body-building'),
(44, 'Louise Parker', 'vin3', '$2b$10$O.YSVNw10UA4.orsdnVi.uw1/GTOp7Ncn4pYHn.SR5dcR2lbc27je', 'Body-building'),
(45, 'Shaun Stafford', 'vin4', '$2b$10$zApYPUBNvS8aOqMAvhXxXuFKmX5HGQnDx2Dhsz8lDTNGLnxRR44kK', 'Body-building'),
(46, 'Scott Laidler', 'vin5', '$2b$10$brcku7R6Bi41FzGURAjT2Oqwo1NZRqX1SCCySBXm0SUpwBNMU0oqi', 'Supercar'),
(47, 'Emma Chan', 'vin7', '$2b$10$sS1.r77KUGrNZHhD0EviwOzr3CuUYis7CgOZR6veWWpaapRgSAqoC', 'Pilates'),
(48, 'CSS Fitness', 'vin8', '$2b$10$zuFkgRwvZQ.wv2LX/iPDL.LKPah70FgINC0GdMAIwVwgSApYegEt2', 'Cardio'),
(49, 'Leading Edge NY', 'vin9', '$2b$10$gVPvCLr1dWuMPVgBJnqsW.Q7Dilf.XbYeeG5Im8gXdVju/oaHWNoC', 'Cardio'),
(50, 'Recharged Personal Training', 'vin10', '$2b$10$BqJsg1HPXrnxf/Xnt.XpIeL2kcCePGgeYI/cVDuYQkrSB5iJeN7vK', 'Cardio'),
(51, 'Benjamin Stone', 'vin12', '$2b$10$ZKITZWlZkvKl2xDwD/KJuu635F6/G3ArG1xWxnGrsd0AWmnwMhwPi', 'Body-building');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `email`, `password`, `role`) VALUES
(12, 'John', 'john@example.com', '$2b$10$Txzu2JDgxYtbk951eZne.e0/WLofOfgK1xNXj/Jk5GTybuuwEcCoG', 'user'),
(13, 'Alice', 'alice@example.com', '$2b$10$u0PGZaDv4lonzMlIpC20We/Cgq98c23oNPl9nXK0OOLf341HHI6/K', 'user'),
(14, 'Bob', 'bob@example.com', '$2b$10$/ig2Jop.KQyzUDseaZj0XuaAhKXGzBVWjAPPSu4w27ad7wbwq1JPS', 'user'),
(15, 'Emily', 'emily@example.com', '$2b$10$9rICH2EeN5HdIEuKnEr2D.cI3NotXpN7a1Bxvqts0eRNUsGmC4kVW', 'user'),
(16, 'Michael', 'michael@example.com', '$2b$10$UbcLwsNHqx0hY88Zmv3iDu5ucR77EXcUk/rx926.hasJXLXcTgGva', 'user'),
(17, 'Sarah', 'sarah@example.com', '$2b$10$VP7hHD3B4Ve7Su7vNWE8HuakTSbAVnxoWbwzmh/t.6VAhnlpmaJnq', 'user'),
(18, 'David', 'david@example.com', '$2b$10$ZN0mV..2daYbMjg/D4640u50bvcnCiMyFPxuz16I6X03eD7fUDYna', 'user'),
(19, 'Jennifer', 'jennifer@example.com', '$2b$10$rLHs4JQroU7jwRjujIsGceDrVv6pJgPdOGr/MpZYbOZX/3oWJbDKq', 'user'),
(20, 'Daniel', 'daniel@example.com', '$2b$10$aMt4vL79NG6vyfPHOL6Lq.kM7XY0R1RJ0sE9XNOFVb6o4A.yVKkM.', 'user'),
(21, 'Jessica', 'jessica@example.com', '$2b$10$4btjxvhJXVeq7LHUCxRYCugLeBa8dVsRnnjpy37jyvAy8ln9JkZ6W', 'user'),
(25, 'Jelena', '1@1', '$2b$10$tfPlw5Ngq3RUntbbMCVnCuozUQyHW2d3sayuCtCUCw1/FLqU4RB6m', 'user'),
(26, 'Jelena', '1@12', '$2b$10$gTW/EMm./wYjKBFQpPfZOudc1h8GDyYAEJTuSjFWLjKkbKqOOoM16', 'user'),
(27, 'Jelena', '1@14', '$2b$10$CGD5zqvKjFWQGEqi1vKAa.3sLaoawWa9dY/t5kE39tVNfm37rrUTa', 'user'),
(28, 'j', '1@144', '$2b$10$KtUiXRfbAvscGfh67sIiM.3.h8w0JvlwkuSeudormOakIiw8tQeDO', 'user'),
(29, 'j', '3@3', '$2b$10$WAAuGy9I5Ux3fd83TQfB7u2cK1oFldGxGZ8vggNBK/Uwj.e396sHi', 'user'),
(30, 'uros', '1@5', '$2b$10$PGOS5RLaV6fP5AfFH1IUmuPdsTmhs5K.t5tAIbxJCo2FzLtcTu3K.', 'user'),
(32, 'uros', 'uros123l@gmail.com', '$2b$10$ZLU3CGXte8jqKCIP2EC51.4hkyjsBPCWrughyoZNtPtHgMWbqFU0q', 'user'),
(33, 'uros1', 'uros1@gmail.com', '$2b$10$BnyNeZk3OO8eUUX446nYrOfoOaxi1HDjoXE0y6EIhqMpwEuaSleLW', 'user'),
(35, 'admin', 'admin@gmail.com', '$2b$10$wPun5vPvcN7JhbdySUnmHOl1/xWaAnRoMxacuggD7NxVRk4Jf0vgi', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `user_trainer`
--

CREATE TABLE `user_trainer` (
  `user_id` int(11) NOT NULL,
  `trainer_id` int(11) NOT NULL,
  `timeSlot_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_trainer`
--

INSERT INTO `user_trainer` (`user_id`, `trainer_id`, `timeSlot_id`) VALUES
(12, 43, 116),
(12, 44, 120),
(12, 45, 122),
(12, 46, 125),
(12, 48, 131),
(12, 50, 137),
(25, 43, 116),
(25, 47, 129),
(25, 48, 131),
(33, 43, 115);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `time_slot`
--
ALTER TABLE `time_slot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_0510418774ea497c4ac1959ba43` (`trainerId`);

--
-- Indexes for table `trainer`
--
ALTER TABLE `trainer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_trainer`
--
ALTER TABLE `user_trainer`
  ADD PRIMARY KEY (`user_id`,`trainer_id`,`timeSlot_id`),
  ADD KEY `FK_7070ab40d166494e3780d4806e8` (`trainer_id`),
  ADD KEY `FK_0870e71c10ae13b9905ef0aa229` (`timeSlot_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `time_slot`
--
ALTER TABLE `time_slot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=171;

--
-- AUTO_INCREMENT for table `trainer`
--
ALTER TABLE `trainer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `time_slot`
--
ALTER TABLE `time_slot`
  ADD CONSTRAINT `FK_0510418774ea497c4ac1959ba43` FOREIGN KEY (`trainerId`) REFERENCES `trainer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `user_trainer`
--
ALTER TABLE `user_trainer`
  ADD CONSTRAINT `FK_0870e71c10ae13b9905ef0aa229` FOREIGN KEY (`timeSlot_id`) REFERENCES `time_slot` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_7070ab40d166494e3780d4806e8` FOREIGN KEY (`trainer_id`) REFERENCES `trainer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_d55d91b4cf29ff57803a7ad05ab` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
