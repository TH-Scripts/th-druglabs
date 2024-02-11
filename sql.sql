CREATE TABLE IF NOT EXISTS `druglabs` (
  `pinkode` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext DEFAULT NULL,
  `lvl` varchar(50) DEFAULT NULL,
  `shell` varchar(50) DEFAULT NULL,
  `exp` int(100) DEFAULT NULL,
  `speed` tinyint() DEFAULT 0,
  `police` tinyint DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;