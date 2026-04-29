-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 29, 2026 at 11:13 PM
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
(112, 'Tuesday 7:00 AM', NULL),
(113, 'Thursday 5:00 PM', NULL),
(114, 'Saturday 9:00 AM', NULL),
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
(142, 'Monday 7:00 AM', NULL),
(143, 'Tuesday 6:00 PM', NULL),
(144, 'Friday 8:00 AM', NULL),
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
(170, 'Friday 8:00 PM', 51),
(171, '[object Object]', NULL),
(172, '[object Object]', NULL),
(173, '[object Object]', NULL),
(174, '[object Object]', NULL),
(175, '[object Object]', NULL),
(176, '[object Object]', NULL),
(177, '[object Object]', NULL),
(178, '[object Object]', NULL),
(179, '[object Object]', NULL),
(180, '[object Object]', NULL),
(181, '[object Object]', NULL),
(182, '[object Object]', NULL),
(185, 'Monday 11:00 AM', NULL),
(186, 'Wednesday 14:00 PM', NULL),
(187, 'Friday 12:00 AM', NULL),
(188, 'Monday 10:00 AM', NULL),
(189, 'Thursday 9:00 AM', NULL),
(190, 'Saturday 5:00 PM', NULL),
(191, 'Monday 11:00 AM', NULL),
(192, 'Wednesday 14:00 PM', NULL),
(193, 'Friday 12:00 AM', NULL),
(194, 'Monday 10:00 AM', NULL),
(195, 'Thursday 9:00 AM', NULL),
(196, 'Saturday 5:00 PM', NULL),
(197, 'Monday 11:00 AM', NULL),
(198, 'Wednesday 14:00 PM', NULL),
(199, 'Friday 12:00 AM', NULL),
(200, 'Monday 10:00 AM', NULL),
(201, 'Thursday 9:00 AM', NULL),
(202, 'Saturday 5:00 PM', NULL),
(203, 'Monday 11:00 AM', NULL),
(204, 'Wednesday 14:00 PM', NULL),
(205, 'Friday 12:00 AM', NULL),
(206, 'Monday 10:00 AM', NULL),
(207, 'Thursday 9:00 AM', NULL),
(208, 'Saturday 5:00 PM', NULL),
(209, 'Monday 11:00 AM', 42),
(210, 'Wednesday 14:00 PM', 42),
(211, 'Friday 12:00 AM', 42),
(212, 'Monday 10:00 AM', 42),
(213, 'Thursday 9:00 AM', 42),
(214, 'Saturday 5:00 PM', 42),
(221, 'Monday 6:00 AM', 52),
(222, 'Wednesday 6:00 AM', 52),
(223, 'Friday 6:00 AM', 52),
(224, 'Saturday 8:00 AM', 52),
(225, 'Tuesday 5:00 PM', 52),
(226, 'Thursday 5:00 PM', 52),
(227, 'Monday 7:00 AM', 53),
(228, 'Wednesday 9:00 AM', 53),
(229, 'Friday 7:00 AM', 53),
(230, 'Saturday 10:00 AM', 53),
(231, 'Tuesday 6:00 PM', 53),
(232, 'Sunday 8:00 AM', 53),
(233, 'Tuesday 7:00 AM', 54),
(234, 'Thursday 7:00 AM', 54),
(235, 'Saturday 9:00 AM', 54),
(236, 'Monday 5:00 PM', 54),
(237, 'Wednesday 5:00 PM', 54),
(238, 'Friday 4:00 PM', 54),
(239, 'Monday 8:00 AM', 55),
(240, 'Wednesday 8:00 AM', 55),
(241, 'Friday 9:00 AM', 55),
(242, 'Saturday 7:00 AM', 55),
(243, 'Tuesday 4:00 PM', 55),
(244, 'Sunday 10:00 AM', 55),
(245, 'Tuesday 6:00 AM', 56),
(246, 'Thursday 6:00 AM', 56),
(247, 'Saturday 6:00 AM', 56),
(248, 'Monday 12:00 PM', 56),
(249, 'Wednesday 12:00 PM', 56),
(250, 'Friday 12:00 PM', 56),
(251, 'Monday 10:00 AM', 57),
(252, 'Wednesday 11:00 AM', 57),
(253, 'Friday 10:00 AM', 57),
(254, 'Saturday 12:00 PM', 57),
(255, 'Tuesday 3:00 PM', 57),
(256, 'Thursday 3:00 PM', 57),
(257, 'Monday 7:00 PM', 58),
(258, 'Wednesday 7:00 PM', 58),
(259, 'Friday 7:00 PM', 58),
(260, 'Tuesday 8:00 AM', 58),
(261, 'Thursday 8:00 AM', 58),
(262, 'Saturday 11:00 AM', 58),
(263, 'Tuesday 5:00 AM', 59),
(264, 'Thursday 5:00 AM', 59),
(265, 'Saturday 5:00 AM', 59),
(266, 'Monday 6:00 PM', 59),
(267, 'Wednesday 6:00 PM', 59),
(268, 'Sunday 7:00 AM', 59),
(269, 'Monday 6:00 AM', 60),
(270, 'Wednesday 8:00 AM', 60),
(271, 'Friday 5:00 PM', 60),
(272, 'Tuesday 7:00 AM', 60),
(273, 'Thursday 9:00 AM', 60),
(274, 'Saturday 11:00 AM', 60),
(275, 'Monday 9:00 AM', 61),
(276, 'Wednesday 6:00 AM', 61),
(277, 'Friday 8:00 AM', 61),
(278, 'Tuesday 5:00 PM', 61),
(279, 'Thursday 7:00 PM', 61),
(280, 'Sunday 9:00 AM', 61),
(281, 'Monday 7:00 AM', 62),
(282, 'Wednesday 5:00 PM', 62),
(283, 'Friday 6:00 AM', 62),
(284, 'Tuesday 10:00 AM', 62),
(285, 'Thursday 6:00 PM', 62),
(286, 'Saturday 8:00 AM', 62),
(287, 'Monday 11:00 AM', 63),
(288, 'Wednesday 7:00 AM', 63),
(289, 'Friday 9:00 AM', 63),
(290, 'Tuesday 6:00 AM', 63),
(291, 'Thursday 8:00 AM', 63),
(292, 'Sunday 10:00 AM', 63),
(293, 'Monday 5:00 PM', 64),
(294, 'Wednesday 9:00 AM', 64),
(295, 'Friday 7:00 PM', 64),
(296, 'Tuesday 8:00 AM', 64),
(297, 'Thursday 10:00 AM', 64),
(298, 'Saturday 6:00 AM', 64),
(299, 'Monday 8:00 AM', 65),
(300, 'Wednesday 6:00 PM', 65),
(301, 'Friday 10:00 AM', 65),
(302, 'Tuesday 9:00 AM', 65),
(303, 'Thursday 5:00 AM', 65),
(304, 'Sunday 8:00 AM', 65),
(305, 'Monday 10:00 AM', 66),
(306, 'Wednesday 10:00 AM', 66),
(307, 'Friday 11:00 AM', 66),
(308, 'Tuesday 7:00 PM', 66),
(309, 'Thursday 6:00 AM', 66),
(310, 'Saturday 9:00 AM', 66),
(311, 'Tuesday 7:00 AM', NULL),
(312, 'Thursday 7:00 AM', NULL),
(313, 'Saturday 9:00 AM', NULL),
(314, 'Monday 5:00 PM', NULL),
(315, 'Wednesday 5:00 PM', NULL),
(316, 'Friday 4:00 PM', NULL),
(317, 'Tuesday 7:00 AM', 517),
(318, 'Thursday 7:00 AM', 517),
(319, 'Saturday 9:00 AM', 517),
(320, 'Monday 5:00 PM', 517),
(321, 'Wednesday 5:00 PM', 517),
(322, 'Friday 4:00 PM', 517),
(395, 'Monday 8:00 AM', 517),
(396, 'Wednesday 6:00 PM', 517),
(397, 'Friday 5:00 PM', 517),
(398, 'Sunday 4:00 PM', 517),
(403, 'Monday 5:00 PM', 519),
(404, 'Tuesday 7:00 AM', 519),
(405, 'Thursday 6:00 PM', 519),
(406, 'Saturday 11:00 AM', 519),
(407, 'Monday 6:00 AM', 520),
(408, 'Wednesday 7:00 AM', 520),
(409, 'Friday 6:00 PM', 520),
(410, 'Sunday 9:00 AM', 520),
(411, 'Monday 6:00 PM', 521),
(412, 'Tuesday 10:00 AM', 521),
(413, 'Thursday 5:00 PM', 521),
(414, 'Saturday 9:00 AM', 521),
(415, 'Monday 9:00 AM', 522),
(416, 'Wednesday 5:00 PM', 522),
(417, 'Friday 7:00 AM', 522),
(418, 'Sunday 10:00 AM', 522),
(419, 'Monday 8:00 AM', 523),
(420, 'Tuesday 5:00 PM', 523),
(421, 'Thursday 7:00 AM', 523),
(422, 'Saturday 12:00 PM', 523),
(423, 'Monday 7:00 PM', 524),
(424, 'Wednesday 6:00 AM', 524),
(425, 'Friday 5:00 PM', 524),
(426, 'Sunday 11:00 AM', 524),
(427, 'Monday 10:00 AM', 525),
(428, 'Wednesday 4:00 PM', 525),
(429, 'Friday 9:00 AM', 525),
(430, 'Sunday 6:00 PM', 525),
(431, 'Monday 11:00 AM', NULL),
(432, 'Wednesday 6:00 PM', NULL),
(433, 'Friday 7:00 AM', NULL),
(434, 'Sunday 6:00 PM', NULL),
(435, 'Monday 11:00 AM', NULL),
(436, 'Wednesday 6:00 PM', NULL),
(437, 'Friday 7:00 AM', NULL),
(438, 'Sunday 6:00 PM', NULL),
(439, 'Monday 11:00 AM', 526),
(440, 'Wednesday 6:00 PM', 526),
(441, 'Friday 7:00 AM', 526),
(442, 'Sunday 6:00 PM', 526);

-- --------------------------------------------------------

--
-- Table structure for table `trainer`
--

CREATE TABLE `trainer` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `speciality` varchar(255) NOT NULL,
  `bio` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trainer`
--

INSERT INTO `trainer` (`id`, `name`, `email`, `password`, `speciality`, `bio`) VALUES
(42, 'Brad Schoenfeld', 'brad.schoenfeld@gymapp.com', '$2b$10$0za2Oza/gniQ./E9fX0YeOxoUD1hToOIYHqdpLh31yhPIOO.o9WVK', 'Pilates', 'World-renowned fitness researcher and Pilates expert with over 20 years of experience. Author of multiple bestselling fitness books and professor of exercise science.'),
(43, 'Matt Roberts', 'matt.roberts@gymapp.com', '$2b$10$xaXFUlTbfMceCuKk.jwVdehESBWhL1lW2Zm7GcScFPZ.EktOuMFqy', 'Body-building', 'Celebrity personal trainer based in London, known for transforming clients through elite bodybuilding programs. Former trainer to top-tier athletes and TV personalities.'),
(44, 'Louise Parker', 'louise.parker@gymapp.com', '$2b$10$O.YSVNw10UA4.orsdnVi.uw1/GTOp7Ncn4pYHn.SR5dcR2lbc27je', 'Body-building', 'Renowned body transformation coach with a holistic approach to bodybuilding. Specializes in sustainable physique change through lifestyle, nutrition and strength training.'),
(45, 'Shaun Stafford', 'shaun.stafford@gymapp.com', '$2b$10$zApYPUBNvS8aOqMAvhXxXuFKmX5HGQnDx2Dhsz8lDTNGLnxRR44kK', 'Body-building', 'Two-time WBFF World Fitness Champion and elite bodybuilding coach. Passionate about helping clients unlock their athletic potential through structured strength programs.'),
(46, 'Scott Laidler', 'scott.laidler@gymapp.com', '$2b$10$brcku7R6Bi41FzGURAjT2Oqwo1NZRqX1SCCySBXm0SUpwBNMU0oqi', 'Supercar', 'London-based personal trainer specializing in functional fitness and body conditioning. Has worked with actors, executives and professional athletes across Europe.'),
(47, 'Emma Chan', 'emma.chan@gymapp.com', '$2b$10$sS1.r77KUGrNZHhD0EviwOzr3CuUYis7CgOZR6veWWpaapRgSAqoC', 'Pilates', 'Certified Pilates instructor with a background in dance and rehabilitation. Focuses on core strength, flexibility and mindful movement for all fitness levels.'),
(48, 'CSS Fitness', 'info@cssfitness.com', '$2b$10$zuFkgRwvZQ.wv2LX/iPDL.LKPah70FgINC0GdMAIwVwgSApYegEt2', 'Cardio', 'A results-driven fitness studio offering expert cardio coaching and group training. Known for high-energy sessions that push endurance and torch calories.'),
(49, 'Leading Edge NY', 'info@leadingedgeny.com', '$2b$10$gVPvCLr1dWuMPVgBJnqsW.Q7Dilf.XbYeeG5Im8gXdVju/oaHWNoC', 'Cardio', 'New York based elite training facility specializing in cardio performance and endurance coaching. Trusted by runners, cyclists and competitive athletes.'),
(50, 'Recharged Personal Training', 'info@rechargedpt.com', '$2b$10$BqJsg1HPXrnxf/Xnt.XpIeL2kcCePGgeYI/cVDuYQkrSB5iJeN7vK', 'Cardio', 'Specialized cardio and recovery training studio focused on heart health, stamina building and injury prevention. Ideal for clients returning from injury or starting fresh.'),
(51, 'Benjamin Stone', 'benjamin.stone@gymapp.com', '$2b$10$ZKITZWlZkvKl2xDwD/KJuu635F6/G3ArG1xWxnGrsd0AWmnwMhwPi', 'Body-building', 'Competitive bodybuilder and certified strength coach with a passion for muscle hypertrophy and contest prep. Helps clients build serious size with smart, science-backed programming.'),
(52, 'Chris Hemsworth', 'chris.hemsworth@gymapp.com', '$2b$10$0za2Oza/gniQ./E9fX0YeOxoUD1hToOIYHqdpLh31yhPIOO.o9WVK', 'Body-building', 'Hollywood physique coach and strength training expert. Specializes in functional muscle building and athletic performance for demanding physical roles.'),
(53, 'Kayla Itsines', 'kayla.itsines@gymapp.com', '$2b$10$xaXFUlTbfMceCuKk.jwVdehESBWhL1lW2Zm7GcScFPZ.EktOuMFqy', 'Cardio', 'World-famous HIIT and cardio coach, creator of the Bikini Body Guide program. Helped millions of women worldwide transform through high-intensity interval training.'),
(54, 'Jeff Nippard', 'jeff.nippard@gymapp.com', '$2b$10$O.YSVNw10UA4.orsdnVi.uw1/GTOp7Ncn4pYHn.SR5dcR2lbc27je', 'Body-building', 'Natural competitive bodybuilder and science-based coach. Known for evidence-based hypertrophy programming and detailed breakdowns of muscle-building mechanics.'),
(55, 'Cassey Ho', 'cassey.ho@gymapp.com', '$2b$10$zApYPUBNvS8aOqMAvhXxXuFKmX5HGQnDx2Dhsz8lDTNGLnxRR44kK', 'Pilates', 'Certified Pilates instructor and founder of Blogilates. Known for making Pilates accessible, fun and challenging through pop-culture themed routines.'),
(56, 'Andy Speer', 'andy.speer@gymapp.com', '$2b$10$brcku7R6Bi41FzGURAjT2Oqwo1NZRqX1SCCySBXm0SUpwBNMU0oqi', 'Cardio', 'Elite trainer and endurance coach based in New York. Combines strength and cardio to build complete athletes. Featured coach on Nike Training Club.'),
(57, 'Kira Stokes', 'kira.stokes@gymapp.com', '$2b$10$sS1.r77KUGrNZHhD0EviwOzr3CuUYis7CgOZR6veWWpaapRgSAqoC', 'Pilates', 'Celebrity Pilates and functional training coach. Her Stoked Method blends Pilates, strength and athleticism for a total-body transformation experience.'),
(58, 'Ngo Okafor', 'ngo.okafor@gymapp.com', '$2b$10$zuFkgRwvZQ.wv2LX/iPDL.LKPah70FgINC0GdMAIwVwgSApYegEt2', 'Body-building', 'Two-time Mr. New York State champion and celebrity trainer. Helps high-profile clients build elite physiques through disciplined bodybuilding and lifestyle coaching.'),
(59, 'Robin Arzon', 'robin.arzon@gymapp.com', '$2b$10$gVPvCLr1dWuMPVgBJnqsW.Q7Dilf.XbYeeG5Im8gXdVju/oaHWNoC', 'Cardio', 'VP of Fitness Programming at Peloton and ultramarathon runner. Passionate about cardio endurance and mental resilience training for all levels.'),
(60, 'Chris Hemsworth', 'chris.hemsworth@gymapp.com', '$2b$10$0za2Oza/gniQ./E9fX0YeOxoUD1hToOIYHqdpLh31yhPIOO.o9WVK', 'Body-building', 'Hollywood physique coach and strength training expert. Specializes in functional muscle building and athletic performance for demanding physical roles.'),
(61, 'Kayla Itsines', 'kayla.itsines@gymapp.com', '$2b$10$xaXFUlTbfMceCuKk.jwVdehESBWhL1lW2Zm7GcScFPZ.EktOuMFqy', 'Cardio', 'World-famous HIIT and cardio coach, creator of the Bikini Body Guide program. Helped millions of women worldwide transform through high-intensity interval training.'),
(62, 'Jeff Nippard', 'jeff.nippard@gymapp.com', '$2b$10$O.YSVNw10UA4.orsdnVi.uw1/GTOp7Ncn4pYHn.SR5dcR2lbc27je', 'Body-building', 'Natural competitive bodybuilder and science-based coach. Known for evidence-based hypertrophy programming and detailed breakdowns of muscle-building mechanics.'),
(63, 'Cassey Ho', 'cassey.ho@gymapp.com', '$2b$10$zApYPUBNvS8aOqMAvhXxXuFKmX5HGQnDx2Dhsz8lDTNGLnxRR44kK', 'Pilates', 'Certified Pilates instructor and founder of Blogilates. Known for making Pilates accessible, fun and challenging through pop-culture themed routines.'),
(64, 'Andy Speer', 'andy.speer@gymapp.com', '$2b$10$brcku7R6Bi41FzGURAjT2Oqwo1NZRqX1SCCySBXm0SUpwBNMU0oqi', 'Cardio', 'Elite trainer and endurance coach based in New York. Combines strength and cardio to build complete athletes. Featured coach on Nike Training Club.'),
(65, 'Kira Stokes', 'kira.stokes@gymapp.com', '$2b$10$sS1.r77KUGrNZHhD0EviwOzr3CuUYis7CgOZR6veWWpaapRgSAqoC', 'Pilates', 'Celebrity Pilates and functional training coach. Her Stoked Method blends Pilates, strength and athleticism for a total-body transformation experience.'),
(66, 'Ngo Okafor', 'ngo.okafor@gymapp.com', '$2b$10$zuFkgRwvZQ.wv2LX/iPDL.LKPah70FgINC0GdMAIwVwgSApYegEt2', 'Body-building', 'Two-time Mr. New York State champion and celebrity trainer. Helps high-profile clients build elite physiques through disciplined bodybuilding and lifestyle coaching.'),
(517, 'Robin Arzo', 'robin.arzon@gymapp.com', '$2b$10$gVPvCLr1dWuMPVgBJnqsW.Q7Dilf.XbYeeG5Im8gXdVju/oaHWNoC', 'Cardio', 'VP of Fitness Programming at Peloton and ultramarathon runner. Passionate about cardio endurance and mental resilience training for all levels.'),
(519, 'David Laid', 'david.laid@gymapp.com', '$2b$10$placeholderhashdavid', 'Body-building', 'Fitness influencer and physique athlete known for transformation content, aesthetic bodybuilding, and strength-focused training programs.'),
(520, 'Lazar Angelov', 'lazar.angelov@gymapp.com', '$2b$10$placeholderhashlazar', 'Body-building', 'Bulgarian fitness model and bodybuilder famous for classic aesthetic physique and disciplined hypertrophy training style.'),
(521, 'Michelle Lewin', 'michelle.lewin@gymapp.com', '$2b$10$placeholderhashmichelle', 'Cardio', 'International fitness model and influencer specializing in fat loss, glute training, and high-intensity workouts.'),
(522, 'Calum Von Moger', 'calum.moger@gymapp.com', '$2b$10$placeholderhashcalum', 'Body-building', 'Classic physique bodybuilder inspired by Arnold Schwarzenegger style training and old-school bodybuilding principles.'),
(523, 'Chul Soon', 'chul.soon@gymapp.com', '$2b$10$placeholderhashchul', 'Body-building', 'South Korean bodybuilder and fitness model known for extreme aesthetics, symmetry, and stage-ready conditioning.'),
(524, 'Pamela Reif', 'pamela.reif@gymapp.com', '$2b$10$placeholderhashpamela', 'Cardio', 'German fitness influencer famous for no-equipment home workouts, fat-burning routines, and lifestyle fitness content.'),
(525, 'Noel Deyzel', 'noel.deyzel@gymapp.com', '$2b$10$placeholderhashnoel', 'Body-building', 'South African bodybuilder and coach known for motivational content, hypertrophy training, and beginner-friendly gym education.'),
(526, 'Bradley Martyn', 'bradley.martyn@gymapp.com', '$2b$10$placeholderhashbradley', 'Body-building', 'Fitness entrepreneur and strength athlete focused on powerlifting, hypertrophy training, and gym motivation content.');

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
(27, 'Jelena', '1@14', '$2b$10$CGD5zqvKjFWQGEqi1vKAa.3sLaoawWa9dY/t5kE39tVNfm37rrUTa', 'user'),
(30, 'uros', '1@5', '$2b$10$PGOS5RLaV6fP5AfFH1IUmuPdsTmhs5K.t5tAIbxJCo2FzLtcTu3K.', 'user'),
(32, 'uros', 'uros123l@gmail.com', '$2b$10$ZLU3CGXte8jqKCIP2EC51.4hkyjsBPCWrughyoZNtPtHgMWbqFU0q', 'user'),
(33, 'uros1', 'uros1@gmail.com', '$2b$10$BnyNeZk3OO8eUUX446nYrOfoOaxi1HDjoXE0y6EIhqMpwEuaSleLW', 'user'),
(35, 'admin', 'admin@gmail.com', '$2b$10$wPun5vPvcN7JhbdySUnmHOl1/xWaAnRoMxacuggD7NxVRk4Jf0vgi', 'admin'),
(36, 'Uros Perovic', 'urosveliki03@gmail.com', '', 'user'),
(37, 'uros', 'UROS@gmail.com', '$2b$10$7gj/lK4uaJrq04a8XBypuemeuQOj8wtXvvnO9MMVDr3gvbx63q482', 'user'),
(38, 'Person', 'person@gmail.com', '$2b$10$8kjtC0mwjiCZTH1FrGR6Eu9fEeORRfPAellGjUTOZtHxBuW3hJAMi', 'user');

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
(33, 43, 115),
(36, 44, 118),
(36, 49, 135),
(36, 51, 140),
(36, 56, 246),
(36, 59, 266),
(36, 60, 273),
(36, 61, 279),
(36, 63, 290),
(37, 45, 121),
(38, 44, 120),
(38, 49, 164),
(38, 51, 139),
(38, 52, 221);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=443;

--
-- AUTO_INCREMENT for table `trainer`
--
ALTER TABLE `trainer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=527;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

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
