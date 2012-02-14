CREATE TABLE carriers
(
Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,
Abbreviation tinytext,
PRIMARY KEY (Id)
);

CREATE TABLE carrier_rates
(
Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext,
Delivery_Days_Min tinyint,
Delivery_Days_Max tinyint,
Visible bit NOT NULL,
Carrier_Id tinyint,
FOREIGN KEY (Carrier_Id) REFERENCES Carriers(Id),
PRIMARY KEY (Id, Carrier_Id)
);

CREATE TABLE customer_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status tinyint UNSIGNED NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NO NULL,
Delivery_Estimate date NO NULL,
Tax mediumint NO NULL,
PRIMARY KEY (Id)
);

CREATE TABLE company_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status tinyint UNSIGNED NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NO NULL,
Delivery_Estimate date NO NULL,
Tax mediumint NO NULL,
PRIMARY KEY (Id)
);

CREATE TABLE part_orders
(
Quantity mediumint UNSIGNED NO NULL
);

CREATE TABLE

--- Sub Types ---


