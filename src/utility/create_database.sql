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

/*==== business profile ====*/
CREATE TABLE IF NOT EXISTS business_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL,
	address VARCHAR(200) NOT NULL,
	seller_id INT NOT NULL,
	default_shipping ENUM('no_shipping', 'post', 'people', 'seller', 'customer'),
	PRIMARY KEY(id),
	FOREIGN KEY(seller_id) REFERENCES user_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;

/*==== shipper profile ====*/
CREATE TABLE IF NOT EXISTS shipper_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	user_id INT NOT NULL,
	vehicle_description VARCHAR(200) NOT NULL,
	vehicle_plate VARCHAR(200) NOT NULL,
	verification_status ENUM('verified', 'unverified'),
	PRIMARY KEY(id),
	FOREIGN KEY(user_id) REFERENCES user_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;

/*==== item profile ====*/
CREATE TABLE IF NOT EXISTS item_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(200) NOT NULL,
	photo_name VARCHAR(100) NOT NULL,
	seller_id INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(seller_id) REFERENCES user_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;


/*==== ad profile ====*/
CREATE TABLE IF NOT EXISTS ad_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	item_id INT NOT NULL,
	price_per float NOT NULL,
	shipping ENUM('no_shipping', 'post', 'people', 'seller', 'customer'),
	PRIMARY KEY(id),
	FOREIGN KEY(item_id) REFERENCES item_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;

/*==== menu item profile ====*/
CREATE TABLE IF NOT EXISTS menu_item_profile
(
	id INT NOT NULL AUTO_INCREMENT,
	business_id INT NOT NULL,
	ad_id INT NOT NULL,
	max_number INT NOT NULL DEFAULT 1,
	PRIMARY KEY(id),
	FOREIGN KEY(business_id) REFERENCES business_profile(id) ON DELETE CASCADE,
	FOREIGN KEY(ad_id) REFERENCES ad_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;

/*==== minicart ====*/
CREATE TABLE IF NOT EXISTS minicart
(
	id INT NOT NULL AUTO_INCREMENT,
	customer_id INT NOT NULL,
	seller_id INT NOT NULL,
	shipping ENUM('no_shipping', 'post', 'people', 'seller', 'customer'),
	contents LONGTEXT NOT NULL,/*[{"ad_id":id, "number":count}, {...}, ...] // contents in JSON format*/
	PRIMARY KEY(id),
	FOREIGN KEY(customer_id) REFERENCES user_profile(id) ON DELETE CASCADE,
	FOREIGN KEY(seller_id) REFERENCES user_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;

/*==== purchased minicart ====*/
CREATE TABLE IF NOT EXISTS purchased_minicart
(
	id INT NOT NULL AUTO_INCREMENT,
	cart_id INT NOT NULL,
	ownership_code INT NOT NULL,
	transaction_status ENUM('purchased', 'shipped', 'arrived', 'accepted', 
	'rejected', 'returned_shipped', 'returned_arrived'),
	PRIMARY KEY(id),
	FOREIGN KEY(cart_id) REFERENCES minicart(id) ON DELETE CASCADE
) ENGINE=INNODB;

/*==== purchased minicart ====*/
CREATE TABLE IF NOT EXISTS shipped_item
(
	id INT NOT NULL AUTO_INCREMENT,
	purchased_cart_id INT NOT NULL,
	package_number INT NOT NULL,
	shipper_id INT,/*If shipper_id is not null, tmp_ownership_code should also have a value.*/
	tmp_ownership_code INT,
	postIN INT,/*post identification number which has value if package is sent via post.*/
	PRIMARY KEY(id),
	FOREIGN KEY(purchased_cart_id) REFERENCES purchased_minicart(id) ON DELETE CASCADE,
	FOREIGN KEY(shipper_id) REFERENCES shipper_profile(id) ON DELETE CASCADE
) ENGINE=INNODB;
/* Test Data */


INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Ali', 'ali@ymail.com', 'Khiabane Ordibehesht pelake 2', 'aliuser', 'aliuser');
INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Maryam', 'mary@ymail.com', 'Khiabane Ordibehesht pelake 10', 'maryuser', 'maryuser');
INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Sepehr', 'sepehr@ymail.com', 'Khiabane Farvardin pelake 3', 'sepehruser', 'sepehruser');
INSERT INTO user_profile (name, email_addr, address, username, password) 
VALUE ('Nila', 'nila@ymail.com', 'Khiabane Farvardin pelake 4', 'nilauser', 'nilauser');

INSERT INTO item_profile (name, photo_name, seller_id)
VALUE ('Saat', 'saat.png', 1);
INSERT INTO item_profile (name, photo_name, seller_id)
VALUE ('ketab', 'ketab.png', 2);
INSERT INTO item_profile (name, photo_name, seller_id)
VALUE ('Dast band', 'dastband.png', 1);
INSERT INTO item_profile (name, photo_name, seller_id)
VALUE ('Couch', 'couch.png', 2);
INSERT INTO item_profile (name, photo_name, seller_id)
VALUE ('Shaal', 'shaal.png', 1);
INSERT INTO item_profile (name, photo_name, seller_id)
VALUE ('USB Cable', 'usbcable.png', 2);

INSERT INTO ad_profile (item_id, price_per, shipping)
VALUE (1, 120000, 'post');
INSERT INTO ad_profile (item_id, price_per, shipping)
VALUE (2, 30000, 'seller');
INSERT INTO ad_profile (item_id, price_per, shipping)
VALUE (3, 30000, 'people');
INSERT INTO ad_profile (item_id, price_per, shipping)
VALUE (4, 200000, 'customer');
INSERT INTO ad_profile (item_id, price_per, shipping)
VALUE (5, 30000, 'people');
INSERT INTO ad_profile (item_id, price_per, shipping)
VALUE (6, 84000, 'people');

