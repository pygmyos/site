-- People
-- Note that passwords are currently unencrypted on the database side
CREATE TABLE employees
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    First_Name tinytext NOT NULL,
    Last_Name tinytext NOT NULL,
    Email tinytext NOT NULL,
    Gender enum('male', 'female') NOT NULL,
    Position tinytext NOT NULL,
    Hire_Date date NOT NULL,
    Username tinytext NOT NULL,
    Password tinytext NOT NULL,
    Site tinytext,
    Phone_Number tinytext,
    Fax_Number tinytext,
    Address tinytext NOT NULL,
    City tinytext NOT NULL,
    State tinytext NOT NULL,
    Zipcode tinytext NOT NULL,
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
    Billing_Zipcode tinytext,
    PRIMARY KEY (Id)
);

-- Components / Boards
CREATE TABLE documents
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    Url tinytext NOT NULL,
    Description text NOT NULL,
    PRIMARY KEY (Id)
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

-- Components
CREATE TABLE libraries
(
    Name tinytext NOT NULL,
    Description text,
    PRIMARY KEY (Name(255))
);

CREATE TABLE components
(
    Id smallint UNSIGNED NOT NULL,
    PRIMARY KEY (Id),
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
    FOREIGN KEY (Library_Name(255)) REFERENCES Libraries(Name)
);

CREATE TABLE component_listings
(
    Url tinytext,
    Component_Id smallint UNSIGNED NOT NULL,
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
    PRIMARY KEY (Component_Id, Vendor_Id)
);

CREATE TABLE component_prices
(
    Start_Date date NOT NULL,
    End_Date date,
    Value decimal(19,2) NOT NULL,
    Listing_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Listing_Id) REFERENCES component_listings(Id),
    PRIMARY KEY (Listing_Id, Start_Date)
);

CREATE TABLE component_doc_usages
(
    On_Page bit NOT NULL DEFAULT 1,
    Document_Id smallint UNSIGNED,
    Component_Id smallint UNSIGNED,
    FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    PRIMARY KEY (Document_Id, Component_Id)
);

CREATE TABLE component_features
(
    Number smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    Feature_Text tinytext NOT NULL,
    Component_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    UNIQUE (Component_Id),
    PRIMARY KEY (Number)
);

CREATE TABLE component_ownerships
(
    Quantity mediumint UNSIGNED NOT NULL,
    Component_Id smallint UNSIGNED NOT NULL,
    Employee_Id mediumint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    FOREIGN KEY (Employee_Id) REFERENCES Employees(Id),
    PRIMARY KEY (Component_Id, Employee_Id)
);

CREATE TABLE manufacturers
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    Name tinytext NOT NULL,
    Email tinytext,
    Url tinytext,
    PRIMARY KEY (Id)
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

CREATE TABLE packages
(
    Package_Name tinytext NOT NULL,
    Mount_Type enum('Surface mount', 'Through hole', 'Hybrid', 'Connector', 'Other'),
    Number_pins smallint,
    Description text,
    Url tinytext,
    PRIMARY KEY (Package_Name(255))
);

CREATE TABLE variants
(
    Component_Id smallint UNSIGNED NOT NULL,
    Package_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    FOREIGN KEY (Package_Id) REFERENCES Packages(Id),
    PRIMARY KEY (Component_Id, Package_Id)
);

-- Boards
CREATE TABLE boards
(
    Id smallint UNSIGNED NOT NULL,
    PRIMARY KEY (Id),
    Description text,
    Weight smallint,
    Name tinytext NOT NULL,
    Type enum('Development', 'Logic', 'Test', 'External', 'Other') NOT NULL,
    Repo_Subdir tinytext,
    First_Commit_Hash tinytext,
    Min_Trace tinyint UNSIGNED NOT NULL,
    Min_Via tinyint UNSIGNED NOT NULL,
    Copper_Thickness tinyint UNSIGNED,
    Color tinytext,
    Master_Id tinyint UNSIGNED,
    Pcb_Id tinyint UNSIGNED,
    FOREIGN KEY (Master_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Pcb_Id) REFERENCES Components(Id)
    -- Maybe Mysql will support check constraints within subqueries one day
    -- CHECK ((SELECT type FROM components WHERE id=pcb_id)='Pcb')
);

CREATE TABLE board_doc_usages
(
    On_Page bit NOT NULL DEFAULT 1,
    Document_Id smallint UNSIGNED,
    Board_Id smallint UNSIGNED,
    FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Document_Id, Board_Id)
);

CREATE TABLE board_features
(
    Number smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    Text tinytext NOT NULL,
    On_Page bit NOT NULL DEFAULT 1,
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    UNIQUE (Board_Id),
    PRIMARY KEY (Number)
);

CREATE TABLE board_ownerships
(
    Quantity mediumint UNSIGNED NOT NULL,
    Board_Id smallint UNSIGNED NOT NULL,
    Employee_Id mediumint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Employee_Id) REFERENCES Employees(Id),
    PRIMARY KEY (Board_Id, Employee_Id)
);

CREATE TABLE board_listings
(
    Url tinytext,
    Board_Id smallint UNSIGNED NOT NULL,
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
    PRIMARY KEY (Board_Id, Vendor_Id)
);

CREATE TABLE board_prices
(
    Start_Date date NOT NULL,
    End_Date date,
    Value decimal(19,2) NOT NULL,
    Listing_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Listing_Id) REFERENCES board_listings(Id),
    PRIMARY KEY (Listing_Id, Start_Date)
);

CREATE TABLE board_component_usages
(
    Quantity smallint UNSIGNED NOT NULL,
    Component_Id smallint UNSIGNED NOT NULL,
    Board_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Board_Id, Component_Id)
);

CREATE TABLE board_pins
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

CREATE TABLE board_relations
(
    Visible bit NOT NULL DEFAULT 1,
    Board1_Id tinytext NOT NULL,
    Board2_Id tinytext NOT NULL,
    FOREIGN KEY (Board1_Id(255)) REFERENCES Boards(Id),
    FOREIGN KEY (Board2_Id(255)) REFERENCES Boards(Id),
    PRIMARY KEY (Board1_Id(100), Board2_Id(100))
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

CREATE TABLE incoming_component_orders
(
    Quantity mediumint UNSIGNED NOT NULL,
    Order_Id int UNSIGNED NOT NULL,
    Component_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Order_Id) REFERENCES Incoming_Orders(Id),
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    PRIMARY KEY (Order_Id, Component_Id)
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

-- Pictures
CREATE TABLE pictures
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    Url tinytext NOT NULL,
    Caption tinytext NOT NULL,
    Flickr_Url tinytext,
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
    Component_Id smallint UNSIGNED,
    Picture_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    PRIMARY KEY (Picture_Id, Number)
);

-- Code refs
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

CREATE TABLE code_ref_relations
(
    Visible bit NOT NULL DEFAULT 1,
    Code_Ref1_Id tinytext NOT NULL,
    Code_Ref2_Id tinytext NOT NULL,
    FOREIGN KEY (Code_Ref1_Id(255)) REFERENCES Code_Refs(Id),
    FOREIGN KEY (Code_Ref2_Id(255)) REFERENCES Code_Refs(Id),
    PRIMARY KEY (Code_Ref1_Id(100), Code_Ref2_Id(100))
);

-- Comments
CREATE TABLE comments
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    Page tinytext UNSIGNED NOT NULL,
    PRIMARY KEY (Id)
);

CREATE TABLE comment_edits
(
    Comment_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Comment_Id) REFERENCES Comments(Id),
    Start_Date datetime NOT NULL,
    End_Date datetime,
    PRIMARY KEY (Comment_Id, Start_Date),
);