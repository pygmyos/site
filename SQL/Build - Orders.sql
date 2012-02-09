CREATE TABLE carrier
(
Carrier_Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,Short_Name tinytext,
PRIMARY KEY(Carrier_Id)
);

CREATE TABLE carrier_rate
(
Carrier_Rate_Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext,
Delivery_Days_Min tinyint,
Delivery_Days_Max tinyint,
Visible bit NOT NULL,
PRIMARY KEY(Carrier_Rate_Id)
);

CREATE TABLE order
(
Order_Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status tinyint UNSIGNED NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NO NULL,
Delivery_Estimate date NO NULL,
Tax mediumint NO NULL,
PRIMARY KEY(order)
);

CREATE TABLE order
(
Order_Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status tinyint UNSIGNED NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NO NULL,
Delivery_Estimate date NO NULL,
Tax mediumint NO NULL,
PRIMARY KEY(order)
);

--- Sub Types ---


