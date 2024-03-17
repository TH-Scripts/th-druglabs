CREATE TABLE IF NOT EXISTS `druglabs` (
  `pinkode` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext DEFAULT NULL,
  `lvl` varchar(50) DEFAULT NULL,
  `shell` varchar(50) DEFAULT NULL,
  `exp` float DEFAULT NULL,
  `cooldown` int(11) DEFAULT 0,
  `owner` varchar(70) DEFAULT NULL,
  `stash` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `druglabs-members` (
  `lab-id` int(11) DEFAULT 0,
  `license` varchar(50) DEFAULT NULL,
  `gang` varchar(20) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `isBoss` tinyint DEFAULT 0,
  PRIMARY KEY (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;