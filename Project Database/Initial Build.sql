-- People
-- Note that passwords are currently unencrypted on the database side
CREATE TABLE profiles
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Email tinytext NOT NULL,
    UNIQUE (Email(255)),
    Username tinytext,
    UNIQUE (Username(255)),
    Password tinytext NOT NULL,

    First_Name tinytext,
    Last_Name tinytext,
    Profile_Visibility enum('All', 'Members', 'None'),
    Gender enum('Male', 'Female', 'Hidden', 'Other'),
    Home_Phone_Number tinytext,
    Cell_Phone_Number tinytext,
    Fax_Number tinytext,

    Bio text,
    Organizations text,
    Spoken_Languages text,
    Programming_Languages text,
    Associations text,
    Universities text,
    Expertise text,
    Interests text,
    Websites text,
    Publications text
);

CREATE TABLE profile_addresses
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Profile_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Profile_Id) REFERENCES Profiles(Id),

    Type enum('Shipping', 'Billing', 'Other'),
    Location enum('Home', 'Work', 'Other', 'Unknown'),
    Date_Added datetime NOT NULL,
    Date_Removed datetime,

    First_Name tinytext NOT NULL,
    Last_Name tinytext NOT NULL,
    Company tinytext,
    Address tinytext NOT NULL,
    Suite tinytext,
    City tinytext NOT NULL,
    State tinytext NOT NULL,
    Zipcode tinytext NOT NULL,
    Country tinytext NOT NULL
);

CREATE TABLE employment
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Profile_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Profile_Id) REFERENCES Profiles(Id),

    Position tinytext NOT NULL,
    Start_Date date NOT NULL,
    End_Date date,
    Current_Status enum('Working', 'Working remote', 'Vacation')
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
    UNIQUE (Email(255))
);

CREATE TABLE vendor_addresses
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),

    Location enum('Offices', 'Warehouse', 'Storefront', 'Other'),
    Department tinytext,
    Address tinytext NOT NULL,
    Suite tinytext,
    City tinytext NOT NULL,
    State tinytext NOT NULL,
    Zipcode tinytext NOT NULL,
    Country tinytext NOT NULL
);

-- Components
CREATE TABLE component_libraries
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    UNIQUE (Name(255)),

    Description text
);

CREATE TABLE components
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Library_Id tinyint UNSIGNED,
    FOREIGN KEY (Library_Id) REFERENCES Component_Libraries(Id),
    Description tinytext,

    Type enum('Connector', 'Cable', 'Switch', 'Resistor', 'Protective',
    'Capacitor', 'Inductive', 'Network', 'Piezoelectric', 'Power source',
    'Sensor', 'Diode', 'Transistor', 'Integrated circuit', 'Optoelectronic',
    'Display', 'Valve', 'Discharge', 'Antenna', 'Module', 'Other') NOT NULL,
    -- I plan on eventually changing the component value to a format better
    --   suited for sorting and filtering
    Value tinytext,
    Tolerance decimal(5, 3) UNSIGNED,
    Current_Draw int UNSIGNED,
    Heat_Max smallint,
    Heat_Min smallint,
    Reflow_Max smallint UNSIGNED
);

CREATE TABLE component_doc_usages
(
    Document_Id smallint UNSIGNED,
    Component_Id smallint UNSIGNED,
    FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    PRIMARY KEY (Document_Id, Component_Id)
);

CREATE TABLE component_packages
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Package_Name tinytext,
    UNIQUE (Package_Name(255)),

    Mount_Type enum('Surface mount', 'Through hole', 'Hybrid', 'Connector', 'Other'),
    Number_pins smallint,
    Weight_Grams decimal(8, 3) UNSIGNED,
    Height_mm decimal(5, 2) UNSIGNED,
    Width_mm decimal(5, 2) UNSIGNED,
    Depth_mm decimal(5, 2) UNSIGNED,
    Description tinytext,
    Url tinytext
);

CREATE TABLE component_variants
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Component_Id smallint UNSIGNED NOT NULL,
    Package_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    FOREIGN KEY (Package_Id) REFERENCES Component_Packages(Id),

    Description tinytext
);

CREATE TABLE component_variant_pins
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Variant_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    Number tinyint UNSIGNED NOT NULL,
    UNIQUE (Variant_Id, Number),

    Name tinytext NOT NULL,
    Type enum('In', 'Out', 'IO', 'Power', 'Passive', 'NC',
              'Other') NOT NULL DEFAULT 'IO',

    Voltage_Max decimal(4, 2),
    Voltage_Nom decimal(4, 2),
    Voltage_Min decimal(4, 2),
    Output_Current_mA decimal(8, 3) UNSIGNED,
    Input_Current_mA decimal(8, 3) UNSIGNED
);

CREATE TABLE component_variant_listings
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Variant_Id smallint UNSIGNED NOT NULL,
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),

    Url tinytext,
    UNIQUE (Url(255))
);

CREATE TABLE component_variant_listing_prices
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Listing_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Listing_Id) REFERENCES component_variant_listings(Id),

    Start_Date datetime NOT NULL,
    End_Date datetime,
    Price decimal(5, 2) NOT NULL
);

CREATE TABLE component_variant_ownerships
(
    Variant_Id smallint UNSIGNED NOT NULL,
    Employee_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    FOREIGN KEY (Employee_Id) REFERENCES Profiles(Id),
    PRIMARY KEY (Variant_Id, Employee_Id),

    Quantity mediumint UNSIGNED NOT NULL,
    Quantity_Needed mediumint UNSIGNED NOT NULL DEFAULT 0
);

CREATE TABLE component_manufacturers
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),

    Name tinytext NOT NULL,
    Email tinytext,
    Url tinytext,
    UNIQUE (Url(255))
);

CREATE TABLE component_manufacturer_addresses
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Manufacturer_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Manufacturer_Id) REFERENCES Component_Manufacturers(Id),

    Location enum('Other', 'Offices', 'Warehouse', 'Storefront', 'Factory'),
    Department tinytext,
    Address tinytext NOT NULL,
    Suite tinytext,
    City tinytext NOT NULL,
    State tinytext NOT NULL,
    Zipcode tinytext NOT NULL,
    Country tinytext NOT NULL
);

CREATE TABLE component_manufacturer_listings
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Component_Id smallint UNSIGNED NOT NULL,
    Manufacturer_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Component_Id) REFERENCES Components(Id),
    FOREIGN KEY (Manufacturer_Id) REFERENCES Component_Manufacturers(Id),
    UNIQUE (Manufacturer_Id, Component_Id),

    Manufacturer_Part_Number tinytext NOT NULL,
    UNIQUE (Manufacturer_Id, Manufacturer_Part_Number(255)),
    Url tinytext
);

-- Boards
CREATE TABLE boards
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Shield_Master_Id tinyint UNSIGNED,
    FOREIGN KEY (Shield_Master_Id) REFERENCES Boards(Id),

    Name tinytext NOT NULL,
    Revision_Number tinyint NOT NULL,
    UNIQUE (Name(255), Revision_Number),

    Type enum('Development', 'Logic', 'Test', 'External', 'Other') NOT NULL,
    Description text,
    Repo_Location tinytext,
    First_Commit_Hash tinytext,
    On_Site bit NOT NULL DEFAULT 1,

    Height_mm decimal(7, 2) UNSIGNED,
    Width_mm decimal(7, 2) UNSIGNED,
    Depth_mm decimal(7, 2) UNSIGNED,
    Pcb_Thickness_mil tinyint UNSIGNED,
    Copper_Thickness_mil tinyint UNSIGNED,
    Min_Trace_mil tinyint UNSIGNED NOT NULL,
    Min_Via_mil tinyint UNSIGNED NOT NULL,
    Shape enum('Other', 'Rectangle', 'Rounded rectangle', 'Circle'),
    Color tinytext,
    Weight_Grams decimal(8, 3) UNSIGNED
);

CREATE TABLE board_doc_usages
(
    Document_Id smallint UNSIGNED,
    Board_Id tinyint UNSIGNED,
    FOREIGN KEY (Document_Id) REFERENCES Documents(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Document_Id, Board_Id),

    On_Page bit NOT NULL DEFAULT 1
);

CREATE TABLE board_features
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Board_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    Number tinyint UNSIGNED NOT NULL,
    UNIQUE (Board_Id, Number),

    Feature_Text tinytext NOT NULL,
    On_Page bit NOT NULL DEFAULT 1
);

CREATE TABLE board_ownerships
(
    Board_Id tinyint UNSIGNED NOT NULL,
    Employee_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Employee_Id) REFERENCES Profiles(Id),
    PRIMARY KEY (Board_Id, Employee_Id),

    Quantity_Assembled smallint UNSIGNED NOT NULL,
    Quantity_Unassembled smallint UNSIGNED NOT NULL,
    Quantity_Needed smallint UNSIGNED NOT NULL
);

CREATE TABLE board_listings
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Board_Id tinyint UNSIGNED NOT NULL,
    Vendor_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),

    Url tinytext
);

CREATE TABLE board_listing_prices
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Listing_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Listing_Id) REFERENCES board_listings(Id),

    Start_Date datetime NOT NULL,
    End_Date datetime,
    Price decimal(5, 2) NOT NULL
);

CREATE TABLE board_component_variant_usages
(
    Variant_Id smallint UNSIGNED NOT NULL,
    Board_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Board_Id, Variant_Id),

    Quantity tinyint UNSIGNED NOT NULL,
    Optional bit NOT NULL DEFAULT 0
);

CREATE TABLE board_pins
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Board_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    Number tinyint UNSIGNED NOT NULL,
    UNIQUE (Board_Id, Number),

    Type enum('In', 'Out', 'IO', 'Power', 'Passive',
              'NC', 'Other') NOT NULL DEFAULT 'IO',
    Name tinytext NOT NULL,
    Description tinytext,
    Voltage_Max decimal(4, 2),
    Voltage_Nom decimal(4, 2),
    Voltage_Min decimal(4, 2),
    Output_Current_mA decimal(7, 2) UNSIGNED,
    Input_Current_mA decimal(7, 2) UNSIGNED
);

CREATE TABLE board_relations
(
    Board1_Id tinyint UNSIGNED NOT NULL,
    Board2_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Board1_Id) REFERENCES Boards(Id),
    FOREIGN KEY (Board2_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Board1_Id, Board2_Id),

    On_Page bit NOT NULL DEFAULT 1
);

-- Orders
CREATE TABLE carriers
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Name tinytext NOT NULL,
    UNIQUE (Name(255)),

    Abbreviation tinytext,
    Url tinytext NOT NULL,
    UNIQUE (Url(255))
);

CREATE TABLE carrier_rates
(
    Id tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Carrier_Id tinyint UNSIGNED,
    FOREIGN KEY (Carrier_Id) REFERENCES Carriers(Id),
    Number tinyint UNSIGNED NOT NULL,
    UNIQUE (Carrier_Id, Number),

    Description tinytext,
    Delivery_Days_Min tinyint,
    Delivery_Days_Max tinyint,
    On_Site bit NOT NULL DEFAULT 1
);

CREATE TABLE orders_incoming
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Employee_Id smallint UNSIGNED NOT NULL,
    Vendor_Id tinyint UNSIGNED NOT NULL,
    Carrier_Rate_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Employee_Id) REFERENCES Profiles(Id),
    FOREIGN KEY (Vendor_Id) REFERENCES Vendors(Id),
    FOREIGN KEY (Carrier_Rate_Id) REFERENCES Carrier_Rates(Id),

    Status enum('Other', 'Shipping error', 'New order', 'Shipped', 'Received',
                'Cancelled') NOT NULL,
    Tracking_Number tinytext,
    Date_Created datetime NOT NULL,
    Date_Received date,
    Tax decimal(7, 2) NOT NULL,
    Shipping_Cost decimal(5, 2) NOT NULL
);

CREATE TABLE orders_incoming_components
(
    Order_Id smallint UNSIGNED NOT NULL,
    Variant_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Order_Id) REFERENCES Orders_Incoming(Id),
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    PRIMARY KEY (Order_Id, Variant_Id),

    Quantity mediumint UNSIGNED NOT NULL
);

CREATE TABLE orders_outgoing
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Customer_Id smallint UNSIGNED NOT NULL,
    Packing_Employee_Id smallint UNSIGNED NOT NULL,
    Carrier_Rate_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Customer_Id) REFERENCES Profiles(Id),
    FOREIGN KEY (Packing_Employee_Id) REFERENCES Profiles(Id),
    FOREIGN KEY (Carrier_Rate_Id) REFERENCES Carrier_Rates(Id),

    Status enum('Exception', 'New order', 'Packed', 'Label printed',
                'Ready to ship', 'Shipped', 'Cancelled') NOT NULL,
    Tracking_Number tinytext,
    Date_Created datetime NOT NULL,
    Date_Packed date,
    Date_Shipped date,
    Tax decimal(7, 2) NOT NULL,
    Shipping_Cost decimal(7, 2) NOT NULL
);

CREATE TABLE orders_outgoing_boards
(
    Order_Id smallint UNSIGNED NOT NULL,
    Board_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Order_Id) REFERENCES Orders_Outgoing(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Order_Id, Board_Id),

    Quantity smallint UNSIGNED NOT NULL
);

-- Pictures
CREATE TABLE pictures
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),

    Url tinytext NOT NULL,
    UNIQUE (Url(255)),
    Flickr_Url tinytext,
    Alt_Text tinytext NOT NULL,
    Caption tinytext
);

CREATE TABLE picture_tags
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Picture_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),

    Item_Name tinytext,
    Variant_Id smallint UNSIGNED,
    Profile_Id smallint UNSIGNED,
    Board_Id tinyint UNSIGNED,
    FOREIGN KEY (Variant_Id) REFERENCES Component_Variants(Id),
    FOREIGN KEY (Profile_Id) REFERENCES Profiles(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),

    Left_Corner_X smallint UNSIGNED,
    Left_Corner_Y smallint UNSIGNED,
    Right_Corner_X smallint UNSIGNED,
    Right_Corner_Y smallint UNSIGNED,
    Visible bit NOT NULL DEFAULT 1
);

-- Code refs
CREATE TABLE code_refs
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),

    Category enum('Other', 'Structural') NOT NULL,
    Difficulty_Level enum('Beginner', 'Moderate', 'Advanced', 'Super advanced'),
    Name tinytext NOT NULL,

    Description text NOT NULL,
    Syntax tinytext NOT NULL,
    Returns tinytext,
    Applications tinytext NOT NULL,
    On_Site bit NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_relations
(
    Code_Ref1_Id smallint UNSIGNED NOT NULL,
    Code_Ref2_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Code_Ref1_Id) REFERENCES Code_Refs(Id),
    FOREIGN KEY (Code_Ref2_Id) REFERENCES Code_Refs(Id),
    PRIMARY KEY (Code_Ref1_Id, Code_Ref2_Id),

    On_Page bit NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_support
(
    Code_Ref_Id smallint UNSIGNED NOT NULL,
    Board_Id tinyint UNSIGNED NOT NULL,
    FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
    FOREIGN KEY (Board_Id) REFERENCES Boards(Id),
    PRIMARY KEY (Code_Ref_Id, Board_Id),

    On_Page bit NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_examples
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Code_Ref_Id smallint UNSIGNED NOT NULL,
    Picture_Id smallint UNSIGNED,
    FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
    FOREIGN KEY (Picture_Id) REFERENCES Pictures(Id),
    Number tinyint UNSIGNED NOT NULL,
    UNIQUE (Code_Ref_Id, Number),

    Setup text,
    Code text,
    Output text,
    On_Page bit NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_parameters
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Code_Ref_Id smallint UNSIGNED,
    FOREIGN KEY (Code_Ref_Id) REFERENCES Code_Refs(Id),
    Number tinyint UNSIGNED NOT NULL,
    UNIQUE (Code_Ref_Id, Number),

    Name tinytext NOT NULL,
    Data_Type tinytext NOT NULL,
    Description tinytext NOT NULL,
    On_Page bit NOT NULL DEFAULT 1
);

-- Comments
CREATE TABLE comments
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Reply_To_Id smallint UNSIGNED,
    FOREIGN KEY (Reply_To_Id) REFERENCES Comments(Id),

    Page tinytext NOT NULL,
    Visible bit NOT NULL DEFAULT 1
);

CREATE TABLE comment_edits
(
    Id smallint UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    Comment_Id smallint UNSIGNED NOT NULL,
    Writer_Profile_Id smallint UNSIGNED NOT NULL,
    FOREIGN KEY (Comment_Id) REFERENCES Comments(Id),
    FOREIGN KEY (Writer_Profile_Id) REFERENCES Profiles(Id),

    Contents text NOT NULL,
    Start_Date datetime NOT NULL,
    End_Date datetime,
    Sanitize bit NOT NULL DEFAULT 1
);