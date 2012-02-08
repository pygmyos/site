CREATE TABLE carrier
(
Carrier_Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,
Short_Name tinytext,
PRIMARY KEY(Carrier_Id)
);

CREATE TABLE carrier_rate
(
Carrier_Rate_Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext,
PRIMARY KEY(Carrier_Rate_Id)
);

CREATE TABLE order
(
Order_Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status tinyint UNSIGNED,
PRIMARY KEY(order)
);
