DROP TABLE parts;
DROP TABLE incoming_orders;
DROP TABLE incoming_part_orders;
DROP TABLE outgoing_part_orders;
DROP TABLE outgoing_orders;
DROP TABLE part_prices;
DROP TABLE pages;


-- Orders
CREATE TABLE incoming_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status enum('ship error', 'new order', 'shipped', 'received', 'cancelled') NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NOT NULL,
Delivery_Estimate date NOT NULL,
Tax decimal(19,2) NOT NULL,
Shipping_Cost decimal(19,2) NOT NULL,
Date_Received date,
PRIMARY KEY (Id)
);

CREATE TABLE incoming_board_orders
(
Quantity mediumint UNSIGNED NOT NULL,
Order_Id int UNSIGNED NOT NULL,
Board_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
PRIMARY KEY (Order_Id, Board_Id)
);

CREATE TABLE incoming_component_orders
(
Quantity mediumint UNSIGNED NOT NULL,
Order_Id int UNSIGNED NOT NULL,
Component_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
FOREIGN KEY (Component_Id) REFERENCES Components(Id),
PRIMARY KEY (Order_Id, Component_Id)
);

CREATE TABLE incoming_stencil_orders
(
Quantity mediumint UNSIGNED NOT NULL,
Order_Id int UNSIGNED NOT NULL,
Stencil_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
FOREIGN KEY (Stencil_Id) REFERENCES Stencils(Id),
PRIMARY KEY (Order_Id, Stencil_Id)
);

CREATE TABLE outgoing_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status enum('exception', 'new order', 'packed', 'label printed', 'ready to ship', 'shipped', 'cancelled') NOT NULL,
Tracking_Nbr tinytext,
Date_Created datetime NOT NULL,
Delivery_Estimate date NOT NULL,
Tax decimal(19,2) NOT NULL,
Shipping_Cost decimal(19,2) NOT NULL,
PRIMARY KEY (Id)
);

CREATE TABLE outgoing_board_orders
(
Quantity mediumint UNSIGNED NOT NULL,
Order_Id int UNSIGNED NOT NULL,
Board_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Order_Id) REFERENCES Outgoing_Orders(Id),
FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
PRIMARY KEY (Order_Id, Board_Id)
);

-- Parts
CREATE TABLE components
(
Id smallint UNSIGNED NOT NULL,
Part_Type tinytext NOT NULL,
Description text,
Weight smallint,
Type enum('Connector', 'Cable', 'Switch', 'Resistor', 'Protective', 
'Capacitor', 'Inductive', 'Network', 'Piezoelectric', 'Power source', 
'Sensor', 'Diode', 'Transistor', 'Integrated circuit', 'Optoelectronic', 
'Display', 'Valve', 'Discharge', 'Antenna', 'Module', 'Pcb', 'Other') NOT NULL,
Value int UNSIGNED,
Tolerance tinyint UNSIGNED,
Current int UNSIGNED,
Volt_Max tinyint,
Volt_Min tinyint,
Heat_Max smallint,
Heat_Min smallint,
Reflow_Max smallint UNSIGNED,
Library_Name tinytext,
FOREIGN KEY (Library_Name(255)) REFERENCES Libraries(Name),
PRIMARY KEY (Id)
);

CREATE TABLE boards
(
Id smallint UNSIGNED NOT NULL,
Part_Type tinytext NOT NULL,
Description text,
Weight smallint,
Name tinytext NOT NULL,
Type enum('Selling', 'Dev', 'Bought', 'Test', 'Other') NOT NULL,
Repo_Subdir tinytext,
Min_Trace tinyint UNSIGNED NOT NULL,
Min_Via tinyint UNSIGNED NOT NULL,
Copper_Thickness tinyint UNSIGNED,
Color tinytext,
Master_Id tinyint UNSIGNED,
Pcb_Id tinyint UNSIGNED,
FOREIGN KEY (Master_Id) REFERENCES Boards(Id),
FOREIGN KEY (Pcb_Id) REFERENCES Components(Id),
PRIMARY KEY (Id)
);

-- Part related
CREATE TABLE part_prices
(
Start_Date date NOT NULL,
End_Date date,
Value decimal(19,2) NOT NULL,
Part_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
Listing_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Listing_Id) REFERENCES Part_Listings(Id),
PRIMARY KEY (Part_Id, Start_Date)
);

CREATE TABLE doc_usages
(
On_Page bit NOT NULL DEFAULT 1,
Document_Id smallint UNSIGNED,
Part_Id smallint UNSIGNED,
FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Document_Id, Part_Id)
);

CREATE TABLE part_ownerships
(
Quantity mediumint UNSIGNED NOT NULL,
Part_Id smallint UNSIGNED NOT NULL,
Employee_Id mediumint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Employee_Id) REFERENCES Employees(Id),
PRIMARY KEY (Part_Id, Employee_Id)
);

CREATE TABLE part_listings
(
Direction enum('Import', 'Export') NOT NULL DEFAULT 'Import',
Url tinytext,
Part_Id smallint UNSIGNED NOT NULL,
Vendor_Id tinyint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
PRIMARY KEY (Part_Id, Vendor_Id)
);

-- Board (subtype) related
CREATE TABLE part_usages
(
Quantity smallint UNSIGNED NOT NULL,
Part_Id smallint UNSIGNED NOT NULL,
Board_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
PRIMARY KEY (Board_Id, Part_Id)
);

CREATE TABLE pins
(
Number tinyint UNSIGNED NOT NULL,
Name tinytext NOT NULL,
Type enum('In', 'Out', 'IO', 'Power', 'Passive', 'NC', 'Other') DEFAULT 'IO',
Max_Voltage tinyint,
Min_Voltage tinyint,
Current smallint UNSIGNED,
Board_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
PRIMARY KEY (Board_Id, Number)
);

-- Component (subtype) related
CREATE TABLE variants
(
Part_Id smallint UNSIGNED NOT NULL,
Package_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Package_Id) REFERENCES Packages(Id),
PRIMARY KEY (Part_Id, Package_Id)
);

CREATE TABLE packages
(
Package_Name tinytext NOT NULL,
Mount_Type enum('Surface mount', 'Through hole', 'Hybrid', 'Connector', 'Other'),
Number_Pins smallint,
Description text,
Url tinytext,
PRIMARY KEY (Package_Name(255))
);

-- Pictures
CREATE TABLE pictures
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Url tinytext NOT NULL,
Caption tinytext NOT NULL,
Flickr_Url tinytext,
Page_Id tinytext,
FOREIGN KEY (Page_Id(255)) REFERENCES Pages(Id),
PRIMARY KEY (Id)
);

CREATE TABLE picture_tags
(
Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Left_Corner_X smallint UNSIGNED,
Left_Corner_Y smallint UNSIGNED,
Right_Corner_X smallint UNSIGNED,
Right_Corner_Y smallint UNSIGNED,
Alternative_Text tinytext,
Part_Id smallint UNSIGNED,
Picture_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Picture_Id, Number)
);