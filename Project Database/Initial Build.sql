-- People
-- Note that passwords are currently unencrypted on the database side
CREATE TABLE profiles
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    email TINYTEXT NOT NULL,
    UNIQUE (email(255)),
    username TINYTEXT,
    UNIQUE (username(255)),
    PASSWORD TINYTEXT NOT NULL,

    first_name TINYTEXT,
    last_name TINYTEXT,
    profile_visibility ENUM('All', 'Members', 'None'),
    gender ENUM('Male', 'Female', 'Hidden', 'Other'),
    home_phone_number TINYTEXT,
    cell_phone_number TINYTEXT,
    fax_number TINYTEXT,

    bio TEXT,
    organizations TEXT,
    spoken_languages TEXT,
    programming_languages TEXT,
    associations TEXT,
    universities TEXT,
    expertise TEXT,
    interests TEXT,
    websites TEXT,
    publications TEXT
);

CREATE TABLE profile_addresses
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    profile_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (profile_id) REFERENCES profiles(id),

    TYPE ENUM('Shipping', 'Billing', 'Other'),
    location ENUM('Home', 'Work', 'Other', 'Unknown'),
    date_added DATETIME NOT NULL,
    date_removed DATETIME,

    first_name TINYTEXT NOT NULL,
    last_name TINYTEXT NOT NULL,
    company TINYTEXT,
    address TINYTEXT NOT NULL,
    suite TINYTEXT,
    city TINYTEXT NOT NULL,
    state TINYTEXT NOT NULL,
    zipcode TINYTEXT NOT NULL,
    country TINYTEXT NOT NULL
);

CREATE TABLE employment
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    profile_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (profile_id) REFERENCES profiles(id),

    position TINYTEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    current_status ENUM('Working', 'Working remote', 'Vacation')
);

-- Components / Boards
CREATE TABLE documents
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),

    url TINYTEXT NOT NULL,
    description TINYTEXT NOT NULL
);

CREATE TABLE vendors
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),

    name TINYTEXT NOT NULL,
    description TINYTEXT,
    url TINYTEXT,
    email TINYTEXT,
    UNIQUE (email(255))
);

CREATE TABLE vendor_addresses
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    vendor_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id),

    location ENUM('Offices', 'Warehouse', 'Storefront', 'Other'),
    department TINYTEXT,
    address TINYTEXT NOT NULL,
    suite TINYTEXT,
    city TINYTEXT NOT NULL,
    state TINYTEXT NOT NULL,
    zipcode TINYTEXT NOT NULL,
    country TINYTEXT NOT NULL
);

-- Components
CREATE TABLE component_libraries
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    name TINYTEXT NOT NULL,
    UNIQUE (name(255)),

    description TEXT
);

CREATE TABLE components
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    library_id TINYINT UNSIGNED,
    FOREIGN KEY (library_id) REFERENCES component_libraries(id),
    description TINYTEXT,

    TYPE ENUM('Connector', 'Cable', 'Switch', 'Resistor', 'Protective',
    'Capacitor', 'Inductive', 'Network', 'Piezoelectric', 'Power source',
    'Sensor', 'Diode', 'Transistor', 'Integrated circuit', 'Optoelectronic',
    'Display', 'Valve', 'Discharge', 'Antenna', 'Module', 'Other') NOT NULL,
    -- I plan on eventually changing the component value to a format better
    --   suited for sorting and filtering
    VALUE TINYTEXT,
    tolerance DECIMAL(5, 3) UNSIGNED,
    current_draw INT UNSIGNED,
    heat_max SMALLINT,
    heat_min SMALLINT,
    reflow_max SMALLINT UNSIGNED
);

CREATE TABLE component_doc_usages
(
    document_id SMALLINT UNSIGNED,
    component_id SMALLINT UNSIGNED,
    FOREIGN KEY (document_id) REFERENCES documents(id),
    FOREIGN KEY (component_id) REFERENCES components(id),
    PRIMARY KEY (document_id, component_id)
);

CREATE TABLE component_packages
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    package_name TINYTEXT,
    UNIQUE (package_name(255)),

    mount_type ENUM('Surface mount', 'Through hole', 'Hybrid', 'Connector', 'Other'),
    number_pins SMALLINT,
    weight_grams DECIMAL(8, 3) UNSIGNED,
    height_mm DECIMAL(5, 2) UNSIGNED,
    width_mm DECIMAL(5, 2) UNSIGNED,
    depth_mm DECIMAL(5, 2) UNSIGNED,
    description TINYTEXT,
    url TINYTEXT
);

CREATE TABLE component_variants
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    component_id SMALLINT UNSIGNED NOT NULL,
    package_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (component_id) REFERENCES components(id),
    FOREIGN KEY (package_id) REFERENCES component_packages(id),

    description TINYTEXT
);

CREATE TABLE component_variant_pins
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    variant_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (variant_id) REFERENCES component_variants(id),
    number TINYINT UNSIGNED NOT NULL,
    UNIQUE (variant_id, number),

    name TINYTEXT NOT NULL,
    TYPE ENUM('In', 'Out', 'IO', 'Power', 'Passive', 'NC',
              'Other') NOT NULL DEFAULT 'IO',

    voltage_max DECIMAL(4, 2),
    voltage_nom DECIMAL(4, 2),
    voltage_min DECIMAL(4, 2),
    output_current_ma DECIMAL(8, 3) UNSIGNED,
    input_current_ma DECIMAL(8, 3) UNSIGNED
);

CREATE TABLE component_variant_listings
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    variant_id SMALLINT UNSIGNED NOT NULL,
    vendor_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (variant_id) REFERENCES component_variants(id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(id),

    url TINYTEXT,
    UNIQUE (url(255))
);

CREATE TABLE component_variant_listing_prices
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    listing_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (listing_id) REFERENCES component_variant_listings(id),

    start_date DATETIME NOT NULL,
    end_date DATETIME,
    price DECIMAL(5, 2) NOT NULL
);

CREATE TABLE component_variant_ownerships
(
    variant_id SMALLINT UNSIGNED NOT NULL,
    employee_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (variant_id) REFERENCES component_variants(id),
    FOREIGN KEY (employee_id) REFERENCES profiles(id),
    PRIMARY KEY (variant_id, employee_id),

    quantity MEDIUMINT UNSIGNED NOT NULL,
    quantity_needed MEDIUMINT UNSIGNED NOT NULL DEFAULT 0
);

CREATE TABLE component_manufacturers
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),

    name TINYTEXT NOT NULL,
    email TINYTEXT,
    url TINYTEXT,
    UNIQUE (url(255))
);

CREATE TABLE component_manufacturer_addresses
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    manufacturer_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES component_manufacturers(id),

    location ENUM('Other', 'Offices', 'Warehouse', 'Storefront', 'Factory'),
    department TINYTEXT,
    address TINYTEXT NOT NULL,
    suite TINYTEXT,
    city TINYTEXT NOT NULL,
    state TINYTEXT NOT NULL,
    zipcode TINYTEXT NOT NULL,
    country TINYTEXT NOT NULL
);

CREATE TABLE component_manufacturer_listings
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    component_id SMALLINT UNSIGNED NOT NULL,
    manufacturer_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (component_id) REFERENCES components(id),
    FOREIGN KEY (manufacturer_id) REFERENCES component_manufacturers(id),
    UNIQUE (manufacturer_id, component_id),

    manufacturer_part_number TINYTEXT NOT NULL,
    UNIQUE (manufacturer_id, manufacturer_part_number(255)),
    url TINYTEXT
);

-- Boards
CREATE TABLE boards
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    shield_master_id TINYINT UNSIGNED,
    FOREIGN KEY (shield_master_id) REFERENCES boards(id),

    name TINYTEXT NOT NULL,
    revision_number TINYINT NOT NULL,
    UNIQUE (name(255), revision_number),

    TYPE ENUM('Development', 'Logic', 'Test', 'External', 'Other') NOT NULL,
    description TEXT,
    repo_location TINYTEXT,
    first_commit_hash TINYTEXT,
    on_site BIT NOT NULL DEFAULT 1,

    height_mm DECIMAL(7, 2) UNSIGNED,
    width_mm DECIMAL(7, 2) UNSIGNED,
    depth_mm DECIMAL(7, 2) UNSIGNED,
    pcb_thickness_mil TINYINT UNSIGNED,
    copper_thickness_mil TINYINT UNSIGNED,
    min_trace_mil TINYINT UNSIGNED NOT NULL,
    min_via_mil TINYINT UNSIGNED NOT NULL,
    shape ENUM('Other', 'Rectangle', 'Rounded rectangle', 'Circle'),
    color TINYTEXT,
    weight_grams DECIMAL(8, 3) UNSIGNED
);

CREATE TABLE board_doc_usages
(
    document_id SMALLINT UNSIGNED,
    board_id TINYINT UNSIGNED,
    FOREIGN KEY (document_id) REFERENCES documents(id),
    FOREIGN KEY (board_id) REFERENCES boards(id),
    PRIMARY KEY (document_id, board_id),

    on_page BIT NOT NULL DEFAULT 1
);

CREATE TABLE board_features
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    board_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (board_id) REFERENCES boards(id),
    number TINYINT UNSIGNED NOT NULL,
    UNIQUE (board_id, number),

    feature_text TINYTEXT NOT NULL,
    on_page BIT NOT NULL DEFAULT 1
);

CREATE TABLE board_ownerships
(
    board_id TINYINT UNSIGNED NOT NULL,
    employee_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (board_id) REFERENCES boards(id),
    FOREIGN KEY (employee_id) REFERENCES profiles(id),
    PRIMARY KEY (board_id, employee_id),

    quantity_assembled SMALLINT UNSIGNED NOT NULL,
    quantity_unassembled SMALLINT UNSIGNED NOT NULL,
    quantity_needed SMALLINT UNSIGNED NOT NULL
);

CREATE TABLE board_listings
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    board_id TINYINT UNSIGNED NOT NULL,
    vendor_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (board_id) REFERENCES boards(id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(id),

    url TINYTEXT
);

CREATE TABLE board_listing_prices
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    listing_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (listing_id) REFERENCES board_listings(id),

    start_date DATETIME NOT NULL,
    end_date DATETIME,
    price DECIMAL(5, 2) NOT NULL
);

CREATE TABLE board_component_variant_usages
(
    variant_id SMALLINT UNSIGNED NOT NULL,
    board_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (variant_id) REFERENCES component_variants(id),
    FOREIGN KEY (board_id) REFERENCES boards(id),
    PRIMARY KEY (board_id, variant_id),

    quantity TINYINT UNSIGNED NOT NULL,
    optional BIT NOT NULL DEFAULT 0
);

CREATE TABLE board_pins
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    board_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (board_id) REFERENCES boards(id),
    number TINYINT UNSIGNED NOT NULL,
    UNIQUE (board_id, number),

    TYPE ENUM('In', 'Out', 'IO', 'Power', 'Passive',
              'NC', 'Other') NOT NULL DEFAULT 'IO',
    name TINYTEXT NOT NULL,
    description TINYTEXT,
    voltage_max DECIMAL(4, 2),
    voltage_nom DECIMAL(4, 2),
    voltage_min DECIMAL(4, 2),
    output_current_ma DECIMAL(7, 2) UNSIGNED,
    input_current_ma DECIMAL(7, 2) UNSIGNED
);

CREATE TABLE board_relations
(
    board1_id TINYINT UNSIGNED NOT NULL,
    board2_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (board1_id) REFERENCES boards(id),
    FOREIGN KEY (board2_id) REFERENCES boards(id),
    PRIMARY KEY (board1_id, board2_id),

    on_page BIT NOT NULL DEFAULT 1
);

-- Orders
CREATE TABLE carriers
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    name TINYTEXT NOT NULL,
    UNIQUE (name(255)),

    abbreviation TINYTEXT,
    url TINYTEXT NOT NULL,
    UNIQUE (url(255))
);

CREATE TABLE carrier_rates
(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    carrier_id TINYINT UNSIGNED,
    FOREIGN KEY (carrier_id) REFERENCES carriers(id),
    number TINYINT UNSIGNED NOT NULL,
    UNIQUE (carrier_id, number),

    description TINYTEXT,
    delivery_days_min TINYINT,
    delivery_days_max TINYINT,
    on_site BIT NOT NULL DEFAULT 1
);

CREATE TABLE orders_incoming
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    employee_id SMALLINT UNSIGNED NOT NULL,
    vendor_id TINYINT UNSIGNED NOT NULL,
    carrier_rate_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES profiles(id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(id),
    FOREIGN KEY (carrier_rate_id) REFERENCES carrier_rates(id),

    status ENUM('Other', 'Shipping error', 'New order', 'Shipped', 'Received',
                'Cancelled') NOT NULL,
    tracking_number TINYTEXT,
    date_created DATETIME NOT NULL,
    date_received DATE,
    tax DECIMAL(7, 2) NOT NULL,
    shipping_cost DECIMAL(5, 2) NOT NULL
);

CREATE TABLE orders_incoming_components
(
    order_id SMALLINT UNSIGNED NOT NULL,
    variant_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_incoming(id),
    FOREIGN KEY (variant_id) REFERENCES component_variants(id),
    PRIMARY KEY (order_id, variant_id),

    quantity MEDIUMINT UNSIGNED NOT NULL
);

CREATE TABLE orders_outgoing
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    customer_id SMALLINT UNSIGNED NOT NULL,
    packing_employee_id SMALLINT UNSIGNED NOT NULL,
    carrier_rate_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES profiles(id),
    FOREIGN KEY (packing_employee_id) REFERENCES profiles(id),
    FOREIGN KEY (carrier_rate_id) REFERENCES carrier_rates(id),

    status ENUM('Exception', 'New order', 'Packed', 'Label printed',
                'Ready to ship', 'Shipped', 'Cancelled') NOT NULL,
    tracking_number TINYTEXT,
    date_created DATETIME NOT NULL,
    date_packed DATE,
    date_shipped DATE,
    tax DECIMAL(7, 2) NOT NULL,
    shipping_cost DECIMAL(7, 2) NOT NULL
);

CREATE TABLE orders_outgoing_boards
(
    order_id SMALLINT UNSIGNED NOT NULL,
    board_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_outgoing(id),
    FOREIGN KEY (board_id) REFERENCES boards(id),
    PRIMARY KEY (order_id, board_id),

    quantity SMALLINT UNSIGNED NOT NULL
);

-- Pictures
CREATE TABLE pictures
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),

    url TINYTEXT NOT NULL,
    UNIQUE (url(255)),
    flickr_url TINYTEXT,
    alt_text TINYTEXT NOT NULL,
    caption TINYTEXT
);

CREATE TABLE picture_tags
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    picture_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (picture_id) REFERENCES pictures(id),

    item_name TINYTEXT,
    variant_id SMALLINT UNSIGNED,
    profile_id SMALLINT UNSIGNED,
    board_id TINYINT UNSIGNED,
    FOREIGN KEY (variant_id) REFERENCES component_variants(id),
    FOREIGN KEY (profile_id) REFERENCES profiles(id),
    FOREIGN KEY (board_id) REFERENCES boards(id),

    left_corner_x SMALLINT UNSIGNED,
    left_corner_y SMALLINT UNSIGNED,
    right_corner_x SMALLINT UNSIGNED,
    right_corner_y SMALLINT UNSIGNED,
    visible BIT NOT NULL DEFAULT 1
);

-- Code refs
CREATE TABLE code_refs
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),

    category ENUM('Other', 'Structural') NOT NULL,
    difficulty_level ENUM('Beginner', 'Moderate', 'Advanced', 'Super advanced'),
    name TINYTEXT NOT NULL,

    description TEXT NOT NULL,
    syntax TINYTEXT NOT NULL,
    RETURNS TINYTEXT,
    applications TINYTEXT NOT NULL,
    on_site BIT NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_relations
(
    code_ref1_id SMALLINT UNSIGNED NOT NULL,
    code_ref2_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (code_ref1_id) REFERENCES code_refs(id),
    FOREIGN KEY (code_ref2_id) REFERENCES code_refs(id),
    PRIMARY KEY (code_ref1_id, code_ref2_id),

    on_page BIT NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_support
(
    code_ref_id SMALLINT UNSIGNED NOT NULL,
    board_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (code_ref_id) REFERENCES code_refs(id),
    FOREIGN KEY (board_id) REFERENCES boards(id),
    PRIMARY KEY (code_ref_id, board_id),

    on_page BIT NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_examples
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    code_ref_id SMALLINT UNSIGNED NOT NULL,
    picture_id SMALLINT UNSIGNED,
    FOREIGN KEY (code_ref_id) REFERENCES code_refs(id),
    FOREIGN KEY (picture_id) REFERENCES pictures(id),
    number TINYINT UNSIGNED NOT NULL,
    UNIQUE (code_ref_id, number),

    setup TEXT,
    code TEXT,
    output TEXT,
    on_page BIT NOT NULL DEFAULT 1
);

CREATE TABLE code_ref_parameters
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    code_ref_id SMALLINT UNSIGNED,
    FOREIGN KEY (code_ref_id) REFERENCES code_refs(id),
    number TINYINT UNSIGNED NOT NULL,
    UNIQUE (code_ref_id, number),

    name TINYTEXT NOT NULL,
    data_type TINYTEXT NOT NULL,
    description TINYTEXT NOT NULL,
    on_page BIT NOT NULL DEFAULT 1
);

-- Comments
CREATE TABLE comments
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    reply_to_id SMALLINT UNSIGNED,
    FOREIGN KEY (reply_to_id) REFERENCES comments(id),

    page TINYTEXT NOT NULL,
    visible BIT NOT NULL DEFAULT 1
);

CREATE TABLE comment_edits
(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    comment_id SMALLINT UNSIGNED NOT NULL,
    writer_profile_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (comment_id) REFERENCES comments(id),
    FOREIGN KEY (writer_profile_id) REFERENCES profiles(id),

    contents TEXT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME,
    sanitize BIT NOT NULL DEFAULT 1
);