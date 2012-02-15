-- People
CREATE TABLE employees
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
first_name tinytext NOT NULL,
last_name tinytext NOT NULL,
email tinytext NOT NULL,
gender enum('male', 'female') NOT NULL,
position tinytext NOT NULL,
hire_date date NOT NULL,
username tinytext,
site tinytext,
phone_number tinytext,
fax_number tinytext,
address tinytext,
city tinytext,
state tinytext,
zipcode tinytext,
PRIMARY KEY (Id)
);

CREATE TABLE customers
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
email tinytext NOT NULL,
first_name tinytext,
last_name tinytext,
gender enum('male', 'female'),
username tinytext,
company tinytext,
site tinytext,
phone_number tinytext,
fax_number tinytext,
shipping_address tinytext,
shipping_city tinytext,
shipping_state tinytext,
shipping_zipcode tinytext,
billing_address tinytext,
billing_city tinytext,
billing_state tinytext,
billing_zipcode tinytext,
PRIMARY KEY (Id)
);

-- Orders
CREATE TABLE incoming_orders
(
Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
Status enum('ship error', 'new order', 'shipped', 'received', 'cancelled') NOT NULL,
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
Status enum('exception', 'new order', 'packed', 'label printed', 'ready to ship', 'shipped', 'cancelled') NOT NULL,
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

-- Part subtypes
CREATE TABLE components
(
);

CREATE TABLE boards
(
);

CREATE TABLE pcbs
(
);

CREATE TABLE stencils
(
);

CREATE TABLE other_parts
(
);

-- Part related
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
Description text NOT NULL,
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
LibraryName tinytext NOT NULL,
Description text,
PRIMARY KEY (LibraryName)
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

-- Board (subtype) related
CREATE TABLE part_usages
(
);

CREATE TABLE pins
(
);

-- Component (subtype) related
CREATE TABLE variants
(
Part_Id smallint NOT NULL,
Package_Id smallint NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Package_Id) REFERENCES Packages(Id),
PRIMARY KEY (Part_Id, Package_Id)
);

CREATE TABLE packages
(
Package_Name tinytext NOT NULL,
Mount_Type enum('surface mount', 'through hole', 'connector', 'other'),
Number_Pins tinyint,
Description text,
Url tinytext,
PRIMARY KEY (Package_Name)
);

-- Pictures
CREATE TABLE pictures
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Url tinytext NOT NULL,
Caption tinytext NOT NULL,
Flickr_Url tinytext,
Page_Id tinytext,
FOREIGN KEY (Page_Id) REFERENCES Pages(Id)
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
Part_Id smallint,
Picture_Id smallint NOT NULL,
FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id)
FOREIGN KEY (Part_Id) REFERENCES Parts(Id)
PRIMARY KEY (Picture_Id, Number)
);

-- Pages
CREATE TABLE pages
(
Id tinytext NOT NULL,
Name tinytext NOT NULL,
Title tinytext NOT NULL,
Has_Header bit NOT NULL DEFAULT 1,
Has_Navbar bit NOT NULL DEFAULT 1,
Has_Socbar bit NOT NULL DEFAULT 1,
Has_Footer bit NOT NULL DEFAULT 1,
Content mediumtext NOT NULL DEFAULT 'No content',
Archived bit NOT NULL DEFAULT 0,
Custom_Url tinytext,
Page_Type enum('other', 'part', 'board', 'tutorial'),
Part_Id smallint,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Id)
);

CREATE TABLE page_relations
(
Visible bit NOT NULL DEFAULT 1,
Page1_Id tinytext NOT NULL,
Page1_Id tinytext NOT NULL,
FOREIGN KEY (Page1_Id) REFERENCES Pages(Id),
FOREIGN KEY (Page2_Id) REFERENCES Pages(Id),
PRIMARY KEY (Page1_Id, Page2_Id)
);

CREATE TABLE alternative_nav_links
(
Text tinytext,
Page1_Id tinytext NOT NULL,
Page1_Id tinytext NOT NULL,
FOREIGN KEY (Page1_Id) REFERENCES Pages(Id),
FOREIGN KEY (Page2_Id) REFERENCES Pages(Id),
PRIMARY KEY (Page1_Id, Page2_Id)
);

CREATE TABLE comments
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Page_Id smallint NOT NULL,
FOREIGN KEY (Page_Id) REFERENCES Pages(Id)
PRIMARY ID (Page_Id, Id)
);

CREATE TABLE comment_texts
(
Edit_Number UNSIGNED NOT NULL AUTO_INCREMENT,
Comment_Id smallint NOT NULL,
FOREIGN KEY (Comment_Id) REFERENCES Comments(Id),
PRIMARY KEY (Comment_Id, Edit_Number)
);


