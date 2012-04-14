-- People
-- Note that passwords are currently unencrypted on the database side
CREATE TABLE employees
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    First_Name tinytext NOT NULL,
    Last_Name tinytext NOT NULL,
    Email tinytext NOT NULL,
    UNIQUE (Email),
    Gender enum('Male', 'Female') NOT NULL,
    Position tinytext NOT NULL,
    Hire_Date date NOT NULL,
    Username tinytext NOT NULL,
    UNIQUE (Username),
    Password tinytext NOT NULL,
    Site tinytext,
    Phone_Number tinytext,
    Fax_Number tinytext,
    Address tinytext NOT NULL,
    City tinytext NOT NULL,
    State tinytext NOT NULL,
    Zipcode tinytext NOT NULL
);

CREATE TABLE customers
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Email tinytext NOT NULL,
    UNIQUE (Email),
    First_Name tinytext NOT NULL,
    Last_Name tinytext NOT NULL,
    Gender enum('Male', 'Female'),
    Username tinytext,
    UNIQUE (Username),
    Password tinytext,
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
    Billing_Zipcode tinytext
);

-- Components / Boards
CREATE TABLE documents
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Url tinytext NOT NULL,
    Description tinytext NOT NULL
);

CREATE TABLE vendors
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    Description tinytext,
    Url tinytext,
    Email tinytext,
    Address tinytext,
    City tinytext,
    State tinytext,
    Zipcode tinytext
);

-- Components
CREATE TABLE libraries
(
    Id tinyint NOT NULL,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    Description text,
    UNIQUE (Name)
);

CREATE TABLE components
(
    Id smallint UNSIGNED NOT NULL,
    PRIMARY KEY (Id),
    Description text,
    Type enum('Connector', 'Cable', 'Switch', 'Resistor', 'Protective', 
    'Capacitor', 'Inductive', 'Network', 'Piezoelectric', 'Power source', 
    'Sensor', 'Diode', 'Transistor', 'Integrated circuit', 'Optoelectronic', 
    'Display', 'Valve', 'Discharge', 'Antenna', 'Module', 'Other') NOT NULL,
    -- I plan on eventually changing the component value to a format better suited for sorting and filtering
    Value tinytext UNSIGNED,
    Tolerance decimal(2,3) UNSIGNED,
    Current_Draw int UNSIGNED,
    Heat_Max smallint,
    Heat_Min smallint,
    Reflow_Max smallint UNSIGNED,
    Library_Id tinyint,
    FOREIGN KEY (Library_Id) REFERENCES Libraries(Id)
);

CREATE TABLE component_packages
(
    Id smallint NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Package_Name tinytext,
    UNIQUE (Package_Name),
    Mount_Type enum('Surface mount', 'Through hole', 'Hybrid', 'Connector', 'Other'),
    Number_pins smallint,
    Weight_Grams decimal(5,3) UNSIGNED,
    Height_mm decimal(3,2) UNSIGNED,
    Width_mm decimal(3,2) UNSIGNED,
    Depth_mm decimal(3,2) UNSIGNED,
    Description text,
    Url tinytext
);

CREATE TABLE component_variants
(
    Id smallint UNSIGNED NOT NULL,
    PRIMARY KEY (Id),
    Component_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    Package_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Package_Id) REFERENCES Component_Packages(Id),
    Description tinytext
);

CREATE TABLE component_variant_pins
(
    Number tinyint UNSIGNED NOT NULL,
    Name tinytext NOT NULL,
    Type enum('In', 'Out', 'IO', 'Power', 'Passive', 'NC', 'Other') NOT NULL DEFAULT 'IO',
    Voltage_Max tinyint,
    Voltage_Nom tinyint,
    Voltage_Min tinyint,
    Current_mA decimal(5,3) UNSIGNED,
    Variant_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    PRIMARY KEY (Variant_Id, Number)
);

CREATE TABLE component_variant_listings
(
    Url tinytext,
    UNIQUE (Url),
    Variant_Id smallint UNSIGNED NOT NULL,
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
    PRIMARY KEY (Variant_Id, Vendor_Id)
);

CREATE TABLE component_variant_listing_prices
(
    Start_Date datetime NOT NULL,
    End_Date datetime,
    Listing_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Listing_Id) REFERENCES component_variant_listings(Id),
    PRIMARY KEY (Listing_Id, Start_Date)
    Price decimal(3,2) NOT NULL
);

CREATE TABLE component_doc_usages
(
    Document_Id smallint UNSIGNED,
    FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
    Component_Id smallint UNSIGNED,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    PRIMARY KEY (Document_Id, Component_Id)
);

CREATE TABLE component_variant_ownerships
(
    Quantity mediumint UNSIGNED NOT NULL,
    Quantity_Needed mediumint UNSIGNED NOT NULL DEFAULT 0,
    Variant_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    Employee_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Employee_Id) REFERENCES Employees(Id),
    PRIMARY KEY (Variant_Id, Employee_Id)
);

CREATE TABLE component_manufacturers
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    Email tinytext,
    Url tinytext,
    UNIQUE (Url)
);

CREATE TABLE component_manufacturer_listings
(
    Manufacturer_Part_Number tinytext NOT NULL,
    Url tinytext,
    Component_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    Manufacturer_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Manufacturer_Id) REFERENCES Component_Manufacturers(Id),
    UNIQUE (Manufacturer_Id, Manufacturer_Part_Number),
    PRIMARY KEY (Component_Id, Manufacturer_Id)
);

-- Boards
CREATE TABLE boards
(
    Id smallint UNSIGNED NOT NULL,
    Revision_Number tinyint NOT NULL,
    PRIMARY KEY (Id, Revision_Number),
    Name tinytext NOT NULL,
    UNIQUE (Name, Revision_Number),
    Master_Id tinyint UNSIGNED,
    FOREIGN KEY (Master_Id) REFERENCES Boards(Id),
    Description text,
    Weight_Grams decimal(5,3) UNSIGNED,
    Type enum('Development', 'Logic', 'Test', 'External', 'Other') NOT NULL,
    Repo_Location tinytext,
    First_Commit_Hash tinytext,
    Width_mm decimal(5,2) UNSIGNED,
    Depth_mm decimal(5,2) UNSIGNED,
    Min_Trace tinyint UNSIGNED NOT NULL,
    Min_Via tinyint UNSIGNED NOT NULL,
    Copper_Thickness tinyint UNSIGNED,
    Color tinytext,
    On_Site bit NOT NULL DEFAULT 1
);

CREATE TABLE board_doc_usages
(
    On_Page bit NOT NULL DEFAULT 1,
    Document_Id smallint UNSIGNED,
    FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
    Board_Id smallint UNSIGNED,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Document_Id, Board_Id)
);

CREATE TABLE board_features
(
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    Number smallint UNSIGNED NOT NULL,
    PRIMARY KEY (Board_Id, Number)
    Feature_Text tinytext NOT NULL,
    On_Page bit NOT NULL DEFAULT 1
);

CREATE TABLE board_ownerships
(
    Quantity_Assembled smallint UNSIGNED NOT NULL,
    Quantity_Unassembled smallint UNSIGNED NOT NULL,
    Quantity_Needed smallint UNSIGNED NOT NULL,
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    Employee_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Employee_Id) REFERENCES Employees(Id),
    PRIMARY KEY (Board_Id, Employee_Id)
);

CREATE TABLE board_listings
(
    Url tinytext,
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
    PRIMARY KEY (Board_Id, Vendor_Id)
);

CREATE TABLE board_listing_prices
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Start_Date datetime NOT NULL,
    End_Date datetime,
    Price decimal(3,2) NOT NULL,
    Listing_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Listing_Id) REFERENCES board_listings(Id)
);

CREATE TABLE board_component_variant_usages
(
    Quantity tinyint UNSIGNED NOT NULL,
    Variant_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Board_Id, Variant_Id)
);

CREATE TABLE board_pins
(
    Number tinyint UNSIGNED NOT NULL,
    Name tinytext NOT NULL,
    Description tinytext,
    Type enum('In', 'Out', 'IO', 'Power', 'Passive', 'NC', 'Other') NOT NULL DEFAULT 'IO',
    Voltage_Max tinyint,
    Voltage_Nom tinyint,
    Voltage_Min tinyint,
    Current smallint UNSIGNED,
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Board_Id, Number)
);

CREATE TABLE board_relations
(
    On_Page bit NOT NULL DEFAULT 1,
    Board1_Id smallint NOT NULL,
    Board2_Id smallint NOT NULL,
    FOREIGN KEY (Board1_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Board2_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Board1_Id, Board2_Id)
);

-- Orders
CREATE TABLE carriers
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    Abbreviation tinytext,
);

CREATE TABLE carrier_rates
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    Carrier_Id tinyint UNSIGNED,
    FOREIGN KEY (Carrier_Id) REFERENCES Carriers(Id),
    PRIMARY KEY (Id, Carrier_Id),
    Description tinytext,
    Delivery_Days_Min tinyint,
    Delivery_Days_Max tinyint,
    On_Site bit NOT NULL DEFAULT 1
);

CREATE TABLE incoming_orders
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Employee_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Employee_Id) REFERENCES Employees(Id),
    Vendor_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
    Carrier_Rate_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Carrier_Rate_Id) REFERENCES Carrier_Rates(Id),
    Status enum('shipping error', 'new order', 'shipped', 'received', 'cancelled') NOT NULL,
    Tracking_Number tinytext,
    Date_Created datetime NOT NULL,
    Date_Received date,
    Tax decimal(5,2) NOT NULL,
    Shipping_Cost decimal(3,2) NOT NULL,
);

CREATE TABLE incoming_component_variant_orders
(
    Quantity mediumint UNSIGNED NOT NULL,
    Order_Id int UNSIGNED NOT NULL,
    FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
    Variant_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    PRIMARY KEY (Order_Id, Variant_Id)
);

CREATE TABLE outgoing_orders
(
    Id mediumint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Customer_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Customer_Id) REFERENCES Customers(Id),
    Packing_Employee_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Packing_Employee_Id) REFERENCES Employees(Id),
    Carrier_Rate_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Carrier_Rate_Id) REFERENCES Carrier_Rates(Id),
    Status enum('exception', 'new order', 'packed', 'label printed', 'ready to ship', 'shipped', 'cancelled') NOT NULL,
    Tracking_Number tinytext,
    Date_Created datetime NOT NULL,
    Tax decimal(5,2) NOT NULL,
    Shipping_Cost decimal(5,2) NOT NULL
);

CREATE TABLE outgoing_board_orders
(
    Quantity smallint UNSIGNED NOT NULL,
    Order_Id mediumint UNSIGNED NOT NULL,
    FOREIGN KEY (Order_Id) REFERENCES Outgoing_Orders(Id),
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Order_Id, Board_Id)
);

-- Pictures
CREATE TABLE pictures
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id)
    Url tinytext NOT NULL,
    Alt_Text tinytext NOT NULL,
    Caption tinytext,
    Flickr_Url tinytext,
);

CREATE TABLE picture_tags
(
    Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    Variant_Id smallint UNSIGNED,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    Picture_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),
    PRIMARY KEY (Picture_Id, Number)
    Left_Corner_X smallint UNSIGNED,
    Left_Corner_Y smallint UNSIGNED,
    Right_Corner_X smallint UNSIGNED,
    Right_Corner_Y smallint UNSIGNED,
    Alternative_Text tinytext,
);

-- Code refs
CREATE TABLE code_refs
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    Description text NOT NULL,
    Syntax tinytext NOT NULL,
    Category enum('Structural'),
    Returns tinytext,
    Applications tinytext NOT NULL,
    On_Site bit NOT NULL DEFAULT 1
)

CREATE TABLE code_ref_examples
(
    Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    Code_Ref_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
    Picture_Id smallint UNSIGNED,
    FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),
    PRIMARY KEY (Code_Ref_Id, Number),
    Code text,
    Output text,
    Difficulty_Level enum('beginner', 'moderate', 'advanced', 'super advanced')
)

CREATE TABLE code_ref_parameters
(
    Number tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    Code_Ref_Id smallint,
    FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
    PRIMARY KEY (Code_Ref_Id, Number),
    Name tinytext NOT NULL,
    Data_Type tinytext NOT NULL,
    Description tinytext NOT NULL
)

CREATE TABLE code_ref_relations
(
    Code_Ref1_Id smallint NOT NULL,
    FOREIGN KEY (Code_Ref1_Id) REFERENCES Code_Refs(Id),
    Code_Ref2_Id smallint NOT NULL,
    FOREIGN KEY (Code_Ref2_Id) REFERENCES Code_Refs(Id),
    PRIMARY KEY (Code_Ref1_Id, Code_Ref2_Id),
    On_Page bit NOT NULL DEFAULT 1
);

-- Comments
CREATE TABLE comments
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Page tinytext UNSIGNED NOT NULL,
    Visible bit NOT NULL DEFAULT 1
);

CREATE TABLE comment_edits
(
    Start_Date datetime NOT NULL,
    End_Date datetime,
    Comment_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Comment_Id) REFERENCES Comments(Id),
    PRIMARY KEY (Comment_Id, Start_Date),
);