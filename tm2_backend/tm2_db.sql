-- Adminer 4.8.1 MySQL 11.6.2-MariaDB-ubu2404 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

INSERT INTO `course` (`id`, `name`) VALUES
(1,	'Projet 3'),
(3,	'Systemes et Reseaux'),
(4,	'Intelligence Artificielle'),
(5,	'Technologies Mobiles 2'),
(6,	'Technologies Internet 4');

DROP TABLE IF EXISTS `course_grades`;
CREATE TABLE `course_grades` (
  `course_id` int(11) NOT NULL,
  `note` double DEFAULT NULL,
  `grades_key` int(11) NOT NULL,
  PRIMARY KEY (`course_id`,`grades_key`),
  CONSTRAINT `FKqdqtyrrykp1o85it98op74plb` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

INSERT INTO `course_grades` (`course_id`, `note`, `grades_key`) VALUES
(1,	10.5,	1),
(1,	10,	2),
(3,	9,	1),
(3,	9.5,	2),
(3,	5,	3),
(3,	7,	5);

DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(255) DEFAULT NULL,
  `matricule` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

INSERT INTO `student` (`id`, `lastname`, `matricule`, `name`) VALUES
(1,	'Ozudogru',	'la226628',	'Huseyin'),
(2,	'Sirjacques',	'la226264',	'Celestin'),
(3,	'Ochana',	'la237911',	'Ochana'),
(5,	'Ozcan',	'la237346',	'Hasan');

-- 2025-01-03 18:29:07