# CentOS7安装mysql数据库

### 在Centos7中用MariaDB代替了mysql数据库。
  '' # yum install mariadb
	'' # yum install mysql-devel
	'' # yum install MySQL-python

### mariadb数据库的启动命令是：
  '' # systemctl start mariadb  #启动MariaDB
  '' # systemctl stop mariadb  #停止MariaDB
  '' # systemctl restart mariadb  #重启MariaDB
  '' # systemctl enable mariadb  #设置开机启动
  '' # mysql_secure_installation ==> 设置 root密码等相关

### 创建mysql用户
  '' $ mysql -u root -p @>密码 
  //创建用户
  '' MariaDB> insert into mysql.user(Host,User,Password) values(‘localhost’,’legend’, password(‘20170123’)); 
  //刷新系统权限表
  '' MariaDB>flush privileges; 
  这样就创建了一个名为：legend  密码为：20170123  的用户。
  //退出后登录一下
  ''  MariaDB>exit;
  '' $ mysql -u legend -p @>输入密码
  ''  MariaDB>登录成功

### 为用户授权
  //登录MYSQL（有ROOT权限）。我里我以ROOT身份登录. 
  '' $ mysql -u root -p @>密码 
  //首先为用户创建一个数据库(legend)
  ''  MariaDB>create database legend; 
  //授权legend用户拥有legend数据库的所有权限
   '' MariaDB>grant all privileges on legend.* to legend@localhost IDENTIFIED BY '20170123'; 
  //刷新系统权限表 
  '' MariaDB>flush privileges; 

### 创建表: 联盟

  '' $ mysql -u legend -p @>输入密码
  ''  MariaDB>use legend;
  '' MariaDB>show tables;

  CREATE TABLE 'league' (
    '_id' char(32) NOT NULL,
    '_name' varchar(255) DEFAULT NULL,
    'create_time' bigint(19) NOT NULL DEFAULT '0',
    '_status' int(8) NOT NULL DEFAULT '0',
    PRIMARY KEY ('_id')
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

  INSERT INTO league (_id, _name) VALUES ('f24794c7e1d511e68c0aa45e60efbf2d', 'legend-league');


### 创建表: 联盟管理员

  '' $ mysql -u legend -p @>输入密码
  ''  MariaDB>use legend;
  '' MariaDB>show tables;

  CREATE TABLE league_admin (
    league_id char(32) NOT NULL DEFAULT '0000000000000000000000000000000',
    account_id char(32) NOT NULL DEFAULT '0000000000000000000000000000000',
    create_time bigint(19) NOT NULL DEFAULT '0',
    _status int(8) NOT NULL DEFAULT '0',
    _rank int(8) NOT NULL DEFAULT '0',
    PRIMARY KEY (account_id, league_id)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

  // 创建超级管理员帐号到联盟中
  INSERT INTO league_admin (league_id, account_id, create_time, _rank)
  VALUES ('f24794c7e1d511e68c0aa45e60efbf2d', '128be5bee0a411e69c5200163e023e51', 1485245086, 999);

  CREATE TABLE `league_user` (
    `league_id` char(32) NOT NULL,
    `account_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    PRIMARY KEY (`league_id`,`account_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

  // 创建超级管理员帐号同时要添加普通用户帐号在这个联盟中
  INSERT INTO league_user (league_id, account_id, create_time)
  VALUES ('f24794c7e1d511e68c0aa45e60efbf2d', '128be5bee0a411e69c5200163e023e51', 1485245086);

  // 创建特许经营权许可证(club)
  CREATE TABLE `league_franchise` (
    `_id` char(32) NOT NULL, // as club_id
    `account_id` char(32) DEFAULT NULL,
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    `_status` int(8) NOT NULL DEFAULT '0',
    `league_id` char(32) DEFAULT NULL,
    PRIMARY KEY (`_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 俱乐部

  CREATE TABLE `club` (
    `_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    `_status` int(8) NOT NULL DEFAULT '0',
    `league_id` char(32) DEFAULT NULL,
    PRIMARY KEY (`_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 俱乐部管理员

  CREATE TABLE `club_ops` (
    `club_id` char(32) NOT NULL DEFAULT '00000000000000000000000000000000',
    `account_id` char(32) NOT NULL DEFAULT '00000000000000000000000000000000',
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    `_status` int(8) NOT NULL DEFAULT '0',
    `_rank` int(8) NOT NULL DEFAULT '0',
    PRIMARY KEY (`club_id`,`account_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 俱乐部成员

  CREATE TABLE `club_user` (
    `club_id` char(32) NOT NULL,
    `account_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    PRIMARY KEY (`club_id`,`account_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 联盟与俱乐部的关系

  CREATE TABLE `relation_league_club` (
    `league_id` char(32) NOT NULL,
    `club_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    PRIMARY KEY (`league_id`,`club_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 文章的索引表

  CREATE TABLE `article_index` (
    `_id` char(32) NOT NULL,
    `_status` int(8) NOT NULL DEFAULT '0' COMMENT '0: draft\n100: publish',
    `account_id` char(32) DEFAULT NULL,
    `league_id` char(32) DEFAULT NULL,
    `club_id` char(32) DEFAULT NULL,
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    `last_update_time` bigint(19) NOT NULL DEFAULT '0',
    `publish_time` bigint(19) NOT NULL DEFAULT '0',
    `view_num` int(11) NOT NULL DEFAULT '0',
    `like_num` int(11) NOT NULL DEFAULT '0',
    `comment_num` int(11) NOT NULL DEFAULT '0',
    `_type` int(8) DEFAULT '0' COMMENT '10: moment\n0: article',
    PRIMARY KEY (`_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 分类

  CREATE TABLE `category` (
    `_id` char(32) NOT NULL,
    `title` varchar(255) DEFAULT NULL,
    `img` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 文章分类

  CREATE TABLE `article_category` (
    `article_id` char(32) NOT NULL,
    `category_id` char(32) NOT NULL,
    PRIMARY KEY (`article_id`,`category_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 文章阅读

  CREATE TABLE `article_view` (
    `article_id` char(32) NOT NULL,
    `account_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL,
    `club_id` char(32) DEFAULT NULL,
    `league_id` char(32) DEFAULT NULL,
    PRIMARY KEY (`article_id`,`account_id`,`create_time`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 文章点赞

  CREATE TABLE `article_like` (
    `article_id` char(32) NOT NULL,
    `account_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL,
    `club_id` char(32) DEFAULT NULL,
    `league_id` char(32) DEFAULT NULL,
    PRIMARY KEY (`article_id`,`account_id`,`create_time`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 文章评论

  CREATE TABLE `article_comment` (
    `article_id` char(32) NOT NULL,
    `account_id` char(32) NOT NULL,
    `create_time` bigint(19) NOT NULL,
    `club_id` char(32) DEFAULT NULL,
    `league_id` char(32) DEFAULT NULL,
    `comment` varchar(2000) DEFAULT NULL,
    PRIMARY KEY (`article_id`,`account_id`,`create_time`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

### 创建表: 多媒体文件资源索引表

  CREATE TABLE `multimedia` (
    `_id` char(32) NOT NULL,
    `article_id` char(32) DEFAULT NULL,
    `account_id` char(32) DEFAULT NULL,
    `club_id` char(32) DEFAULT NULL,
    `league_id` char(32) DEFAULT NULL,
    `url` varchar(255) DEFAULT NULL,
    `_type` varchar(45) DEFAULT NULL COMMENT 'img\nvideo\naudio',
    `create_time` bigint(19) NOT NULL DEFAULT '0',
    `_status` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
