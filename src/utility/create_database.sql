/*======== CREATING THE USER AND ADDING THE PRIVILEGES ========*/

/*
Log into the root user in mysql and create the admin user
mysql -u root -p
*/
CREATE USER IF NOT EXISTS 'market_admin'@'localhost' IDENTIFIED BY 'marketadminpassword';

GRANT ALL PRIVILEGES ON *.* TO 'market_admin'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

/*
Log out of the root user and login using the admin credentials
mysql -u parking_admin -p
*/

/*======== CREATING THE DATABASE ========*/
CREATE DATABASE full_market_db;
USE full_market_db;

/*======== CREATING THE TABLES  ========*/

/*==== user profile ====*/
CREATE TABLE IF NOT EXISTS user_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL,
	email_addr VARCHAR(100) NOT NULL,
	address VARCHAR(200) NOT NULL,
	username VARCHAR(100) NOT NULL,
	password VARCHAR(100) NOT NULL,
	PRIMARY KEY(id)
) ENGINE=INNODB;

/*==== item ====*/
CREATE TABLE IF NOT EXISTS item_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL,
	photo_name VARCHAR(100) NOT NULL,
	price float NOT NULL,
	shipping ENUM('no_shipping', 'post', 'people', 'seller', 'customer'),
	seller_id INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(seller_id) REFERENCES user_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;

/* Test Data */


INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Ali', 'ali@ymail.com', 'Khiabane Ordibehesht pelake 2', 'aliuser', 'aliuser');
INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Maryam', 'mary@ymail.com', 'Khiabane Ordibehesht pelake 10', 'maryuser', 'maryuser');
INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Sepehr', 'sepehr@ymail.com', 'Khiabane Farvardin pelake 3', 'sepehruser', 'sepehruser');

