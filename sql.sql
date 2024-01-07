-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for esxlegacy_973b5e
CREATE DATABASE IF NOT EXISTS `esxlegacy_973b5e` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `esxlegacy_973b5e`;

-- Dumping structure for table esxlegacy_973b5e.druglabs
CREATE TABLE IF NOT EXISTS `druglabs` (
  `pinkode` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext DEFAULT NULL,
  `lvl` varchar(50) DEFAULT NULL,
  `shell` varchar(50) DEFAULT NULL,
  `exp` int(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table esxlegacy_973b5e.druglabs: ~2 rows (approximately)
INSERT INTO `druglabs` (`pinkode`, `id`, `coords`, `lvl`, `shell`, `exp`) VALUES
	(1111, 26, '{"x":838.6549682617188,"y":-3105.019775390625,"z":5.892333984375}', '4', 'coke', 20),
	(1212, 27, '{"x":852.5406494140625,"y":-3107.578125,"z":5.892333984375}', '2', 'coke', 50);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
