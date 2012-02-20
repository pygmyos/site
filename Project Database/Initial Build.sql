-- People
CREATE TABLE employees
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
First_Name tinytext NOT NULL,
Last_Name tinytext NOT NULL,
Email tinytext NOT NULL,
Gender enum('male', 'female') NOT NULL,
Position tinytext NOT NULL,
Hire_Date date NOT NULL,
Username tinytext,
Site tinytext,
Phone_Number tinytext,
Fax_Number tinytext,
Address tinytext,
City tinytext,
State tinytext,
Zipcode tinytext,
PRIMARY KEY (Id)
);

CREATE TABLE customers
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Email tinytext NOT NULL,
First_Name tinytext NOT NULL,
Last_Name tinytext NOT NULL,
Gender enum('male', 'female'),
Username tinytext,
Company tinytext,
Site tinytext,
Phone_Number tinytext,
Fax_Number tinytext,
Shipping_Address tinytext,
Shipping_City tinytext,
Shipping_State tinytext,
Shipping_Zipcode tinytext,
Billing_Address tinytext,
Billing_City tinytext,
Billing_State tinytext,
Billing_Zipcode tinytext,
PRIMARY KEY (Id)
);

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

CREATE TABLE incoming_part_orders
(
Quantity mediumint UNSIGNED NOT NULL,
Order_Id int UNSIGNED NOT NULL,
Part_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Order_Id, Part_Id)
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

CREATE TABLE outgoing_part_orders
(
Quantity mediumint UNSIGNED NOT NULL,
Order_Id int UNSIGNED NOT NULL,
Part_Id smallint UNSIGNED NOT NULL,
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
Carrier_Id tinyint UNSIGNED,
FOREIGN KEY (Carrier_Id) REFERENCES Carriers(Id),
PRIMARY KEY (Id, Carrier_Id)
);

-- Parts
CREATE TABLE parts
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Part_Type tinytext NOT NULL,
CHECK(Part_Type IN ('component', 'board', 'stencil')),
Description text,
Weight smallint,
PRIMARY KEY (Id)
);

-- Part subtypes
CREATE TABLE components
(
Id smallint UNSIGNED NOT NULL,
Part_Type tinytext NOT NULL,
Description text,
Weight smallint,
CHECK(Part_Type='component'),
FOREIGN KEY (Id, Part_Type(10))
REFERENCES Parts(Id, Part_Type) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Description(900)) REFERENCES Parts (Description) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Weight) REFERENCES Parts (Weight) ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (Id),
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
FOREIGN KEY (Library_Name(255)) REFERENCES Libraries(Name)
);

CREATE TABLE boards
(
Id smallint UNSIGNED NOT NULL,
Part_Type tinytext NOT NULL,
Description text,
Weight smallint,
CHECK(Part_Type='board'),
FOREIGN KEY (Id, Part_Type(10))
REFERENCES Parts(Id, Part_Type) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Description(900)) REFERENCES Parts (Description) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Weight) REFERENCES Parts (Weight) ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (Id),
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
FOREIGN KEY (Pcb_Id) REFERENCES Components(Id)
);

CREATE TABLE stencils
(
Id smallint UNSIGNED NOT NULL,
Part_Type tinytext NOT NULL,
Description text,
Weight smallint,
CHECK(Part_Type='stencil'),
FOREIGN KEY (Id, Part_Type(10))
REFERENCES Parts(Id, Part_Type) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Description(900)) REFERENCES Parts (Description) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Weight) REFERENCES Parts (Weight) ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (Id),
Material enum('Kapton', 'Mylar'),
Margin tinyint UNSIGNED
);

-- Part related
CREATE TABLE part_prices
(

Start_Date date NOT NULL,
End_Date date,
Value decimal(19,2) NOT NULL,
Part_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
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
Part_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
PRIMARY KEY (Part_Id, Number)
);

CREATE TABLE libraries
(
LibraryName tinytext NOT NULL,
Description text,
PRIMARY KEY (LibraryName(50))
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

CREATE TABLE manufacturer_components
(
Number tinytext NOT NULL,
Url tinytext,
Component_Id smallint UNSIGNED NOT NULL,
Manufacturer_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Component_Id) REFERENCES Components(Id),
FOREIGN KEY (Manufacturer_Id) REFERENCES Manufacturers(Id),
PRIMARY KEY (Component_Id, Manufacturer_Id)
);

CREATE TABLE manufacturers
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,
Email tinytext,
Url tinytext,
PRIMARY KEY (Id)
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

CREATE TABLE vendors
(
Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,
Url tinytext,
Email tinytext,
Address tinytext,
City tinytext,
State tinytext,
Zipcode tinytext,
PRIMARY KEY (Id)
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
SetContent mediumtext NOT NULL,
Archived bit NOT NULL DEFAULT 0,
Url_Part tinytext NOT NULL,
Part_Id smallint UNSIGNED,
Code_Ref_Id smallint UNSIGNED,
FOREIGN KEY (Part_Id) REFERENCES Parts(Id),
FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Ref(Id),
PRIMARY KEY (Id(255))
);

CREATE TABLE code_refs
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,
Description text NOT NULL,
Syntax tinytext NOT NULL,
Type enum('Structural'),
Returns tinytext,
Applications tinytext NOT NULL,
PRIMARY KEY (Id)
)

CREATE TABLE code_ref_examples
(
Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Code text,
Output text,
Code_Ref_Id smallint UNSIGNED,
Picture_Id smallint UNSIGNED,
FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),
FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
PRIMARY KEY (Code_Ref_Id, Number)
)

CREATE TABLE code_ref_parameters
(
Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Name tinytext NOT NULL,
Type tinytext NOT NULL,
Description tinytext NOT NULL,
Code_Ref_Id smallint,
FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
PRIMARY KEY (Code_Ref_Id, Number)
)

CREATE TABLE page_relations
(
Visible bit NOT NULL DEFAULT 1,
Page1_Id tinytext NOT NULL,
Page2_Id tinytext NOT NULL,
FOREIGN KEY (Page1_Id(255)) REFERENCES Pages(Id),
FOREIGN KEY (Page2_Id(255)) REFERENCES Pages(Id),
PRIMARY KEY (Page1_Id(100), Page2_Id(100))
);

CREATE TABLE alternative_nav_links
(
Text tinytext,
Page1_Id tinytext NOT NULL,
Page2_Id tinytext NOT NULL,
FOREIGN KEY (Page1_Id(255)) REFERENCES Pages(Id),
FOREIGN KEY (Page2_Id(255)) REFERENCES Pages(Id),
PRIMARY KEY (Page1_Id(100), Page2_Id(100))
);

CREATE TABLE comments
(
Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
Page_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Page_Id) REFERENCES Pages(Id),
PRIMARY KEY (Page_Id, Id)
);

CREATE TABLE comment_texts
(
Edit_Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
Comment_Id smallint UNSIGNED NOT NULL,
FOREIGN KEY (Comment_Id) REFERENCES Comments(Id),
PRIMARY KEY (Comment_Id, Edit_Number)
);