
-- customers status = 3 -> connected customers
-- customers deleted = 0 -> not deleted
-- nodes access = 1
-- netdevices status = 0 -> existing

-- networks for DHCP managements: 1,4,10,11

CREATE VIEW `dhcp_radcheck` AS 
  select 
    `macs`.`id` AS `id`,
    `macs`.`mac` AS `username`,
    'Auth-Type' AS `attribute`,
    ':=' AS `op`,
    'Accept' AS `value` 
  from 
    `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id` and `nodes`.`netid` in (1,4,10,11) and `nodes`.`access` = 1)
    left join `customers` on (`customers`.`id` = `nodes`.`ownerid` and `customers`.`deleted` = 0 and `customers`.`status` = 3) 
    left join `netdevices` on (`netdevices`.`id` = `nodes`.`netdev` and `netdevices`.`status` = 0)
  where 
    `macs`.`mac` <> '00:00:00:00:00:00' 
    and ((`customers`.`id` is null and `netdevices`.`id` is not null) or (`customers`.`id` is not null and `netdevices`.`id` is null));


CREATE VIEW `dhcp_radreply` AS 
  select 
    `macs`.`id` AS `id`,
    `macs`.`mac` AS `username`,
    'Framed-IP-Address' AS `attribute`,
    '=' AS `op`,
    inet_ntoa(`nodes`.`ipaddr`) AS `value` 
  from 
    `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id` and `nodes`.`netid` in (1,4,10,11) and `nodes`.`access` = 1)
    left join `customers` on (`customers`.`id` = `nodes`.`ownerid` and `customers`.`deleted` = 0 and `customers`.`status` = 3)
    left join `netdevices` on (`netdevices`.`id` = `nodes`.`netdev` and `netdevices`.`status` = 0)
  where 
    `macs`.`mac` <> '00:00:00:00:00:00' 
    and ((`customers`.`id` is null and `netdevices`.`id` is not null) or (`customers`.`id` is not null and `netdevices`.`id` is null))


CREATE TABLE `dhcp_radacct` (
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

CREATE TABLE `dhcp_radgroupcheck` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
);

-- > select * from dhcp_radgroupcheck;
-- +----+------------+-----------+----+--------+
-- | id | groupname  | attribute | op | value  |
-- +----+------------+-----------+----+--------+
-- |  1 | unknownmac | Auth-Type | := | Accept |
-- +----+------------+-----------+----+--------+

CREATE TABLE `dhcp_radgroupreply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
);

-- > select * from dhcp_radgroupreply;
-- +----+------------+-----------+----+----------------+
-- | id | groupname  | attribute | op | value          |
-- +----+------------+-----------+----+----------------+
-- |  1 | unknownmac | Pool-Name | := | guests_pdc_net |
-- +----+------------+-----------+----+----------------+

CREATE TABLE `dhcp_radpostauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `pass` varchar(64) NOT NULL DEFAULT '',
  `reply` varchar(32) NOT NULL DEFAULT '',
  `authdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
);

CREATE TABLE `dhcp_radusergroup_tbl` (
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1,
  KEY `username` (`username`(32))
);

insert into dhcp_radusergroup_tbl values('unknownmac','unknownmac',1);

CREATE VIEW `dhcp_radusergroup` AS 
    select 
        `dhcp_radusergroup_tbl`.`username` AS `username`,
        `dhcp_radusergroup_tbl`.`groupname` AS `groupname`,
        `dhcp_radusergroup_tbl`.`priority` AS `priority` 
    from `dhcp_radusergroup_tbl` 
    union 
    select 
        `macs`.`mac` AS `username`,
        'LAN' AS `groupname`,
        1 AS `priority` 
    from 
        `macs` left join `nodes` on (`macs`.`nodeid` = `nodes`.`id`)
    where `nodes`.`access` = 1;
