
-- customers status = 3 -> connected customers
-- customers deleted = 0 -> not deleted
-- nodes access = 1

-- networks for MACAUTH: 10

CREATE VIEW `macauth_radcheck` AS 
    select 
        `macs`.`id` AS `id`,
        `macs`.`mac` AS `username`,
        'Cleartext-Password' AS `attribute`,
        ':=' AS `op`,
        `macs`.`mac` AS `value` 
    from 
        `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id` and `nodes`.`netid` = 10 and `nodes`.`access` = 1) 
        left join `customers` on (`customers`.`id` = `nodes`.`ownerid` and `customers`.`deleted` = 0 and `customers`.`status` = 3)
    where 
        `macs`.`mac` <> '00:00:00:00:00:00' 
        and `customers`.`id` is not null;

CREATE VIEW `macauth_radreply` AS 
    select 
        `macs`.`id` AS `id`,
        `macs`.`mac` AS `username`,
        'Tunnel-Private-Group-ID' AS `attribute`,
        '=' AS `op`,
        `networks`.`vlanid` AS `value` 
    from 
        `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id` and `nodes`.`netid` = 10 and `nodes`.`access` = 1)
        left join `customers` on (`customers`.`id` = `nodes`.`ownerid` and `customers`.`deleted` = 0 and `customers`.`status` = 3)
        left join `networks` on (`nodes`.`netid` = `networks`.`id`)
    where 
        `macs`.`mac` <> '00:00:00:00:00:00' 
        and `customers`.`id` is not null 
    union 
    select 
        `macs`.`id` AS `id`,
        `macs`.`mac` AS `username`,
        'Tunnel-Medium-Type' AS `attribute`,
        '=' AS `op`,
        'IEEE-802' AS `value` 
    from 
        `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id` and `nodes`.`netid` = 10 and `nodes`.`access` = 1)
        left join `customers` on (`customers`.`id` = `nodes`.`ownerid` and `customers`.`deleted` = 0 and `customers`.`status` = 3)
        left join `networks` on (`nodes`.`netid` = `networks`.`id`)
    where 
        `macs`.`mac` <> '00:00:00:00:00:00' 
        and `customers`.`id` is not null 
    union 
    select 
        `macs`.`id` AS `id`,
        `macs`.`mac` AS `username`,
        'Tunnel-Type' AS `attribute`,
        '=' AS `op`,
        'VLAN' AS `value` 
    from 
        `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id` and `nodes`.`netid` = 10 and `nodes`.`access` = 1)
        left join `customers` on (`customers`.`id` = `nodes`.`ownerid` and `customers`.`deleted` = 0 and `customers`.`status` = 3)
        left join `networks` on (`nodes`.`netid` = `networks`.`id`)
    where 
        `macs`.`mac` <> '00:00:00:00:00:00' 
        and `customers`.`id` is not null;


CREATE TABLE `macauth_radacct` (
  `radacctid` bigint(21) NOT NULL AUTO_INCREMENT,
  `acctsessionid` varchar(64) NOT NULL DEFAULT '',
  `acctuniqueid` varchar(32) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasportid` varchar(15) DEFAULT NULL,
  `nasporttype` varchar(32) DEFAULT NULL,
  `acctstarttime` datetime DEFAULT NULL,
  `acctupdatetime` datetime DEFAULT NULL,
  `acctstoptime` datetime DEFAULT NULL,
  `acctinterval` int(12) DEFAULT NULL,
  `acctsessiontime` int(12) unsigned DEFAULT NULL,
  `acctauthentic` varchar(32) DEFAULT NULL,
  `connectinfo_start` varchar(50) DEFAULT NULL,
  `connectinfo_stop` varchar(50) DEFAULT NULL,
  `acctinputoctets` bigint(20) DEFAULT NULL,
  `acctoutputoctets` bigint(20) DEFAULT NULL,
  `calledstationid` varchar(50) NOT NULL DEFAULT '',
  `callingstationid` varchar(50) NOT NULL DEFAULT '',
  `acctterminatecause` varchar(32) NOT NULL DEFAULT '',
  `servicetype` varchar(32) DEFAULT NULL,
  `framedprotocol` varchar(32) DEFAULT NULL,
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`radacctid`),
  UNIQUE KEY `acctuniqueid` (`acctuniqueid`),
  KEY `username` (`username`),
  KEY `framedipaddress` (`framedipaddress`),
  KEY `acctsessionid` (`acctsessionid`),
  KEY `acctsessiontime` (`acctsessiontime`),
  KEY `acctstarttime` (`acctstarttime`),
  KEY `acctinterval` (`acctinterval`),
  KEY `acctstoptime` (`acctstoptime`),
  KEY `nasipaddress` (`nasipaddress`)
);

CREATE TABLE `macauth_radgroupcheck` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
);

CREATE TABLE `macauth_radgroupreply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
);

CREATE TABLE `macauth_radpostauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `pass` varchar(64) NOT NULL DEFAULT '',
  `reply` varchar(32) NOT NULL DEFAULT '',
  `authdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
);

CREATE TABLE `macauth_radusergroup` (
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1,
  KEY `username` (`username`(32))
);

