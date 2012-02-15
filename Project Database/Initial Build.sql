-- People
CREATE TABLE employees
(
);

CREATE TABLE customers
(
);

-- Orders
CREATE TABLE incoming_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status enum('exception', 'packed', 'label printed', 'ready to ship', 'shipped', 'received', 'cancelled') NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NO NULL,
Delivery_Estimate date NO NULL,
Tax mediumint NO NULL,
Date_Received date,
PRIMARY KEY (Id)
);

CREATE TABLE incoming_part_orders
(
Quantity mediumint UNSIGNED NO NULL
Order_Id int NO NULL,
Part_Id smallint NO NULL,
FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Order_Id, Part_Id)
);

CREATE TABLE outgoing_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status enum('exception', 'packed', 'label printed', 'ready to ship', 'shipped', 'cancelled') NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NO NULL,
Delivery_Estimate date NO NULL,
Tax mediumint NO NULL,
PRIMARY KEY (Id)
);

CREATE TABLE outgoing_part_orders
(
Quantity mediumint UNSIGNED NO NULL
Order_Id int NO NULL,
Part_Id smallint NO NULL,
FOREIGN KEY (Order_Id) REFERENCES Outgoing_Orders(Id),
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Order_Id, Part_Id)
);

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

-- Parts
CREATE TABLE parts
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Description text,
Weight smallint,
PRIMARY KEY (Id)
);

CREATE TABLE part_prices
(
Start_Date date NOT NULL,
End_Date date,
Value smallint UNSIGNED NOT NULL,
Part_Id smallint NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Part_Id, Start_Date)
);

CREATE TABLE doc_usages
(
On_Page bit NOT NULL DEFAULT 1,
Document_Id smallint,
Part_Id smallint,
FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Document_Id, Part_Id)
);

CREATE TABLE documents
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Url tinytext NOT NULL,
Description mediumtext NOT NULL,
PRIMARY KEY (Id)
);

CREATE TABLE features
(
Number smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Text tinytext NOT NULL,
On_Page bit NOT NULL DEFAULT 1,
Part_Id smallint NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Part_Id, Number)
);

CREATE TABLE libraries
(

);

CREATE TABLE part_ownerships
(
Quantity mediumint UNSIGNED NO NULL,
Part_Id smallint NO NULL,
Employee_Id mediumint NO NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Person_Id) REFERENCES Employees(Id),
PRIMARY KEY (Part_Id, Person_Id)
);

CREATE TABLE manufacturer_parts
(
);

CREATE TABLE manufacturers
(
);

CREATE TABLE part_listings
(
);

CREATE TABLE vendors
(
);

-- Boards
CREATE TABLE boards
(
);

CREATE TABLE part_usages
(
);

CREATE TABLE pins
(
);

-- Components
CREATE TABLE variants
(
);

CREATE TABLE packages
(
);

-- Pictures
CREATE TABLE pictures
(
);

CREATE TABLE picture_tags
(
);

-- Pages
CREATE TABLE pages
(
);

CREATE TABLE page_relations
(
);

CREATE TABLE alt_nav_links
(
);

CREATE TABLE comments
(
);

CREATE TABLE comment_texts
(
);

CREATE TABLE 
(
);


