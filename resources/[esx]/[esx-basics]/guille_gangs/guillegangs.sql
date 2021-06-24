USE `es_extended`;

INSERT INTO `jobs` (name, label, whitelisted) VALUES
	('vagos', 'Vagos', 1), 
	('ballas', 'Ballas', 1), 
	('thelost', 'The Lost', 1), 
	('families', 'Families', 1),
	('mafia', 'Mafia', 1)
;


INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_families', 'families', 1),
	('society_vagos', 'Vagos', 1), 
	('society_ballas', 'Ballas', 1), 
	('society_thelost', 'The Lost', 1), 
	('society_mafia', 'Mafia', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_families', 'families', 1),
	('society_vagos', 'Vagos', 1), 
	('society_ballas', 'Ballas', 1), 
	('society_thelost', 'The Lost', 1), 
	('society_mafia', 'Mafia', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_families', 'families', 1),
	('society_vagos', 'Vagos', 1), 
	('society_ballas', 'Ballas', 1), 
	('society_thelost', 'The Lost', 1), 
	('society_mafia', 'Mafia', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('families',0,'homie','Homie',0,'{}','{}'),
	('families',1,'boss','B',0,'{}','{}'),
	('ballas',0,'homie','Reclute',0,'{}','{}'),
	('ballas',1,'boss','GangBoss',0,'{}','{}'),
	('vagos',0,'homie','Reclute',0,'{}','{}'),
	('vagos',1,'boss','GangBoss',0,'{}','{}'),
	('mafia',0,'homie','Reclute',0,'{}','{}'),
	('mafia',1,'boss','GangBoss',0,'{}','{}'),
	('thelost',0,'biker','Reclute',0,'{}','{}'),
	('thelost',1,'boss','GangBoss',0,'{}','{}')
;

CREATE TABLE `gangmissions` (
	`keyid` int(11) NOT NULL DEFAULT "0",
	`gang` LONGTEXT NOT NULL DEFAULT '{}',
	`mission` varchar(700) DEFAULT NULL
);
