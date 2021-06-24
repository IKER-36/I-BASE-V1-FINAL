USE `es_extended`;

CREATE TABLE `licenses` (
	`type` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`type`)
);

CREATE TABLE `user_licenses` (
	`id` int NOT NULL AUTO_INCREMENT,
	`type` varchar(60) NOT NULL,
	`owner` varchar(40) NOT NULL,

	PRIMARY KEY (`id`)
);
