-- People {{{
CREATE TABLE profiles
(
	-- id {{{
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	-- }}}

	-- Identity {{{
	email TINYTEXT NOT NULL,
	UNIQUE (email(255)),
	username TINYTEXT,
	UNIQUE (username(255)),
	name TINYTEXT,
	password TINYTEXT NOT NULL,
	created DATETIME NOT NULL,
	--- }}}

	-- Info {{{
	phone TINYTEXT,
	fax TINYTEXT,

	gender ENUM('Other', 'Male', 'Female'),
	profile_visibility ENUM('All', 'Members', 'None') NOT NULL DEFAULT 'Members',
	email_visible BIT NOT NULL DEFAULT 0,
	uses_gravatar BIT NOT NULL DEFAULT 1,
	country TINYTEXT,
	profile_text TEXT,
	sanitize_profile BIT NOT NULL DEFAULT 1
	--- }}}
);

CREATE TABLE profile_addresses
(
	-- id, profile_id {{{
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	profile_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (profile_id) REFERENCES profiles(id),
	-- }}}

	-- Identity {{{
	location ENUM('Other', 'Home', 'Work'),
	created DATETIME NOT NULL,
	removed DATETIME,
	-- }}}

	-- Info {{{
	name TINYTEXT NOT NULL,
	company TINYTEXT,
	address TINYTEXT NOT NULL,
	suite TINYTEXT,
	city TINYTEXT NOT NULL,
	state TINYTEXT NOT NULL,
	zipcode TINYTEXT NOT NULL,
	country TINYTEXT NOT NULL,
	UNIQUE(name, company, address, suite, city, state, zipcode, country)
	-- }}}
);

CREATE TABLE ip_addresses
(
	-- id {{{
	address TINYINT UNSIGNED NOT NULL,
	PRIMARY KEY (address),
	-- }}}

	-- Info {{{
	first_occurence DATETIME NOT NULL,
	last_occurence DATETIME NOT NULL,
	banned BIT NOT NULL DEFAULT 0
	-- }}}
);

CREATE TABLE login_instances
(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),

	profile_id SMALLINT UNSIGNED NOT NULL,
	ip_address TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (profile_id) REFERENCES profiles(id),
	FOREIGN KEY (ip_address) REFERENCES ip_addresses(address),

	instance_datetime DATETIME NOT NULL
);

CREATE TABLE employment
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	profile_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (profile_id) REFERENCES profiles(id),

	start_date DATE NOT NULL,
	end_date DATE,
	position TINYTEXT NOT NULL,
	work_email TINYTEXT,
	working_status ENUM('Other', 'Working', 'Working remote', 'Vacation') NOT NULL
);
-- }}}

-- Components / Boards
CREATE TABLE documents
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	company_id SMALLINT UNSIGNED,
	FOREIGN KEY (company_id) REFERENCES companies(id),

	created DATETIME NOT NULL,
	remote_url TINYTEXT,
	local_url TINYTEXT,
	torrent_magnet TINYTEXT,
	title TINYTEXT NOT NULL,
	description TEXT
);

CREATE TABLE companies
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	logo_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (logo_id) REFERENCES pictures(id),

	name TINYTEXT NOT NULL,
	abbreviation TINYTEXT,
	description TINYTEXT,

	services ENUM('Other', 'PCB fab', 'Board assembly',
				  'PCB fab / Board Assembly', 'Shipping'),
	sells ENUM('Other', 'Tools', 'Boards', 'Components',
			   'Boards / Components')
);

CREATE TABLE company_urls
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	company_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (company_id) REFERENCES companies(id),

	date_added DATE NOT NULL,
	url TINYTEXT NOT NULL,
	UNIQUE (url(255)),
	description TINYTEXT,
	is_site_root BIT NOT NULL DEFAULT 1
);

CREATE TABLE company_emails
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	company_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (company_id) REFERENCES companies(id),

	date_added DATE NOT NULL,
	address TINYTEXT NOT NULL,
	UNIQUE (address(255)),
	email_type ENUM('Other', 'Customer service', 'Tech support', 'Orders', 'Sales', 'Distribution'),
	description TINYTEXT
);

CREATE TABLE company_addresses
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	company_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (company_id) REFERENCES companies(id),

	date_added DATE NOT NULL,
	date_removed DATE,
	location ENUM('Other', 'Offices', 'Warehouse', 'Storefront', 'Factory'),

	department TINYTEXT,
	address TINYTEXT NOT NULL,
	suite TINYTEXT,
	city TINYTEXT NOT NULL,
	state TINYTEXT NOT NULL,
	zipcode TINYTEXT NOT NULL,
	country TINYTEXT NOT NULL
);

CREATE TABLE programs
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	company_id SMALLINT UNSIGNED NOT NULL,
	icon_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (company_id) REFERENCES companies(id),
	FOREIGN KEY (icon_id) REFERENCES pictures(id),

	program_name TINYTEXT,
	abbreviation TINYTEXT,
	software_type ENUM('Other', 'Utility', 'ECAD', 'CAD', 'IDE'),
	source_location TINYTEXT,

	on_site BIT NOT NULL DEFAULT 1
);

CREATE TABLE program_doc_usages
(
	document_id SMALLINT UNSIGNED,
	program_id TINYINT UNSIGNED,
	FOREIGN KEY (document_id) REFERENCES documents(id),
	FOREIGN KEY (program_id) REFERENCES programs(id),
	PRIMARY KEY (document_id, board_id),

	on_page BIT NOT NULL DEFAULT 1
);

-- Components
CREATE TABLE components
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	library_id TINYINT UNSIGNED,
	FOREIGN KEY (library_id) REFERENCES component_libraries(id),
	description TEXT,
	description_summary TINYTEXT,

	created DATETIME NOT NULL,
	datetime_lastupdated DATETIME NOT NULL,
	category ENUM('Other', 'Connector', 'Cable', 'Switch', 'Resistor', 'Protective',
	'Capacitor', 'Inductive', 'Network', 'Piezoelectric', 'Power source',
	'Sensor', 'Diode', 'Transistor', 'Integrated circuit', 'Optoelectronic',
	'Display', 'Valve', 'Discharge', 'Antenna', 'Module') NOT NULL,
	-- I plan on eventually changing the component value to a format better
	--   suited for sorting and filtering
	valueness TINYTEXT,
	tolerance DECIMAL(5, 3) UNSIGNED,
	efficiency DECIMAL(5, 3) UNSIGNED,
	current_draw_ma DECIMAL(8, 3) UNSIGNED,
	current_output_ma DECIMAL(8, 3) UNSIGNED,
	power_watts DECIMAL(6, 3) UNSIGNED,
	heat_max_c DECIMAL(7, 3),
	heat_min_c DECIMAL(7, 3),
	reflow_max_c DECIMAL(7, 3) UNSIGNED,
	material TINYTEXT,
	is_uncommon BIT NOT NULL DEFAULT 0,

	on_site BIT NOT NULL DEFAULT 1
);

CREATE TABLE component_doc_usages
(
	document_id SMALLINT UNSIGNED,
	component_id SMALLINT UNSIGNED,
	FOREIGN KEY (document_id) REFERENCES documents(id),
	FOREIGN KEY (component_id) REFERENCES components(id),
	PRIMARY KEY (document_id, component_id),

	on_page BIT NOT NULL DEFAULT 1
);

CREATE TABLE component_packages
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	package_name TINYTEXT,
	UNIQUE (package_name(255)),

	created DATETIME NOT NULL,
	mount_type ENUM('Surface mount', 'Through hole', 'Hybrid', 'Connector', 'Other'),
	number_pins SMALLINT,
	color TINYTEXT,
	weight_grams DECIMAL(8, 3) UNSIGNED,
	height_mm DECIMAL(5, 2) UNSIGNED,
	width_mm DECIMAL(5, 2) UNSIGNED,
	depth_mm DECIMAL(5, 2) UNSIGNED,
	pitch_mm DECIMAL(5, 3) UNSIGNED,
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

	description TEXT
);

CREATE TABLE component_pins
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	variant_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	number TINYINT UNSIGNED NOT NULL,
	UNIQUE (variant_id, number),

	name TINYTEXT NOT NULL,
	direction ENUM('Other', 'In', 'Out', 'IO', 'Power',
				   'Passive', 'NC') NOT NULL DEFAULT 'IO',

	voltage_max DECIMAL(4, 2),
	voltage_nom DECIMAL(4, 2),
	voltage_min DECIMAL(4, 2),
	output_current_ma DECIMAL(8, 3) UNSIGNED,
	input_current_ma DECIMAL(8, 3) UNSIGNED
);

CREATE TABLE component_vendor_listings
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	variant_id SMALLINT UNSIGNED NOT NULL,
	vendor_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	FOREIGN KEY (vendor_id) REFERENCES companies(id),

	url TINYTEXT,
	minimum_quantity SMALLINT UNSIGNED NOT NULL DEFAULT 0,
	vendor_part_number TINYTEXT,
	UNIQUE (vendor_id, vendor_part_number(255))
);

CREATE TABLE component_vendor_listing_prices
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	listing_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (listing_id) REFERENCES component_listings(id),

	start_datetime DATETIME NOT NULL,
	end_datetime DATETIME,
	price DECIMAL(6, 3) NOT NULL,
	discount_per_ten DECIMAL (7, 4) NOT NULL
);

CREATE TABLE component_ownerships
(
	variant_id SMALLINT UNSIGNED NOT NULL,
	employee_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	FOREIGN KEY (employee_id) REFERENCES profiles(id),
	PRIMARY KEY (variant_id, employee_id),

	start_datetime DATETIME NOT NULL,
	end_datetime DATETIME,
	quantity MEDIUMINT UNSIGNED NOT NULL,
	quantity_needed MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
	is_estimated BIT NOT NULL DEFAULT 0
);

CREATE TABLE component_libraries
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	program_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (program_id) REFERENCES programs(id),

	file_name TINYTEXT NOT NULL,
	UNIQUE (name(255)),
	description TEXT
);

CREATE TABLE component_library_instances
(
	variant_id SMALLINT UNSIGNED NOT NULL,
	library_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	FOREIGN KEY (library_id) REFERENCES component_libraries(id),
	PRIMARY KEY (variant_id, library_id),

	created DATETIME,
	needs_fixes BIT NOT NULL DEFAULT 0,
	proven BIT NOT NULL DEFAULT 0,
	preferred BIT NOT NULL DEFAULT 0,
	UNIQUE (variant_id, preferred)
);

CREATE TABLE component_manufacturer_listings
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	component_id SMALLINT UNSIGNED NOT NULL,
	manufacturer_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (component_id) REFERENCES components(id),
	FOREIGN KEY (manufacturer_id) REFERENCES companies(id),
	UNIQUE (manufacturer_id, component_id),

	date_added DATE NOT NULL,
	date_removed DATE,
	manufacturer_part_number TINYTEXT,
	UNIQUE (manufacturer_id, manufacturer_part_number(255)),
	url TINYTEXT,
	deprecated BIT NOT NULL DEFAULT 0
);

-- Boards
CREATE TABLE boards
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	shield_master_id TINYINT UNSIGNED,
	manufacturer_id SMALLINT UNSIGNED,
	program_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (shield_master_id) REFERENCES boards(id),
	FOREIGN KEY (manufacturer_id) REFERENCES companies(id),
	FOREIGN KEY (program_id) REFERENCES programs(id),

	name TINYTEXT NOT NULL,
	revision_number TINYINT NOT NULL,
	variation TINYTEXT,
	UNIQUE (name(255), revision_number, variation(255)),

	category ENUM('Other', 'Development', 'Logic', 'Test') NOT NULL,
	description TEXT,
	source_location TINYTEXT,
	start_datetime DATETIME,
	end_datetime DATETIME,
	first_commit_hash TINYTEXT,
	on_site BIT NOT NULL DEFAULT 0,
	for_sale BIT NOT NULL DEFAULT 0,

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

CREATE TABLE board_manufacturer_rates
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	manufacturer_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (manufacturer_id) REFERENCES companies(id),

	price_setup DECIMAL(5, 2),
	price_sqin DECIMAL(4, 2),
	price_assembly_approxperpad DECIMAL(4, 3),
	minimum_quantity SMALLINT UNSIGNED,
	maximum_quantity SMALLINT UNSIGNED,
	days_min TINYINT UNSIGNED,
	days_max TINYINT UNSIGNED
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

	created DATETIME NOT NULL,
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

	start_datetime DATETIME NOT NULL,
	end_datetime DATETIME,
	quantity_sellable SMALLINT UNSIGNED NOT NULL,
	quantity_personal SMALLINT UNSIGNED NOT NULL,
	quantity_unassembled SMALLINT UNSIGNED NOT NULL,
	quantity_needed SMALLINT UNSIGNED NOT NULL
);

CREATE TABLE board_vendor_listings
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	board_id TINYINT UNSIGNED NOT NULL,
	vendor_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (board_id) REFERENCES boards(id),
	FOREIGN KEY (vendor_id) REFERENCES companies(id),

	url TINYTEXT
);

CREATE TABLE board_vendor_listing_prices
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	listing_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (listing_id) REFERENCES board_listings(id),

	start_datetime DATETIME NOT NULL,
	end_datetime DATETIME,
	price DECIMAL(5, 2) NOT NULL
);

CREATE TABLE board_component_usages
(
	variant_id SMALLINT UNSIGNED NOT NULL,
	board_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	FOREIGN KEY (board_id) REFERENCES boards(id),
	PRIMARY KEY (board_id, variant_id),

	quantity TINYINT UNSIGNED NOT NULL
);

CREATE TABLE board_pins
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	board_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (board_id) REFERENCES boards(id),
	number TINYINT UNSIGNED NOT NULL,
	UNIQUE (board_id, number),

	pad_type ENUM('Other', 'PTH', 'Surface'),
	direction ENUM('Other', 'In', 'Out', 'IO', 'Power', 'Passive',
			  'NC') NOT NULL DEFAULT 'IO',
	name TINYTEXT NOT NULL,
	description TINYTEXT,
	voltage_max DECIMAL(4, 2),
	voltage_nom DECIMAL(4, 2),
	voltage_min DECIMAL(4, 2),
	output_current_ma DECIMAL(8, 2) UNSIGNED,
	input_current_ma DECIMAL(8, 2) UNSIGNED
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
CREATE TABLE carrier_rates
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	carrier_id TINYINT UNSIGNED,
	FOREIGN KEY (carrier_id) REFERENCES companies(id),
	number TINYINT UNSIGNED NOT NULL,
	UNIQUE (carrier_id, number),

	date_added DATE NOT NULL,
	description TINYTEXT,
	delivery_days_min TINYINT,
	delivery_days_max TINYINT,
	on_site BIT NOT NULL DEFAULT 1
);

CREATE TABLE orders_incoming
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	employee_address_id SMALLINT UNSIGNED NOT NULL,
	vendor_id SMALLINT UNSIGNED NOT NULL,
	carrier_rate_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (employee_address_id) REFERENCES profile_addresses(id),
	FOREIGN KEY (vendor_id) REFERENCES companies(id),
	FOREIGN KEY (carrier_rate_id) REFERENCES carrier_rates(id),

	status ENUM('Other', 'Shipping error', 'New order', 'Shipped', 'Received',
				'Cancelled') NOT NULL,
	vendor_order_number TINYTEXT,
	tracking_number TINYTEXT,
	datetime_created DATETIME NOT NULL,
	date_received DATE,
	tax DECIMAL(7, 2) NOT NULL,
	shipping_cost DECIMAL(5, 2) NOT NULL,
	charged DECIMAL(10, 2) NOT NULL
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

CREATE TABLE orders_incoming_boards
(
	order_id SMALLINT UNSIGNED NOT NULL,
	board_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (order_id) REFERENCES orders_incoming(id),
	FOREIGN KEY (board_id) REFERENCES boards(id),
	PRIMARY KEY (order_id, board_id),

	quantity MEDIUMINT UNSIGNED NOT NULL
);

CREATE TABLE orders_outgoing
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	customer_address_id SMALLINT UNSIGNED NOT NULL,
	packing_employee_address_id SMALLINT UNSIGNED NOT NULL,
	carrier_rate_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (customer_address_id) REFERENCES profile_addresses(id),
	FOREIGN KEY (packing_employee_address_id) REFERENCES profile_addresses(id),
	FOREIGN KEY (carrier_rate_id) REFERENCES carrier_rates(id),

	tracking_number TINYTEXT,
	datetime_created DATETIME NOT NULL,
	date_label_printed DATE,
	date_packed DATE,
	date_shipped DATE,
	date_cancelled DATE,
	date_returned DATE,
	date_return_received DATE,

	tax DECIMAL(7, 2) NOT NULL,
	shipping_cost DECIMAL(7, 2) NOT NULL,
	charged DECIMAL(10, 2) NOT NULL
);

CREATE TABLE orders_outgoing_components
(
	order_id SMALLINT UNSIGNED NOT NULL,
	variant_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (order_id) REFERENCES orders_outgoing(id),
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	PRIMARY KEY (order_id, variant_id),

	quantity MEDIUMINT UNSIGNED NOT NULL
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

	created DATETIME NOT NULL,
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

	created DATETIME NOT NULL,
	item_name TINYTEXT,
	variant_id SMALLINT UNSIGNED,
	profile_id SMALLINT UNSIGNED,
	board_id TINYINT UNSIGNED,
	package_id TINYINT UNSIGNED,
	FOREIGN KEY (variant_id) REFERENCES component_variants(id),
	FOREIGN KEY (profile_id) REFERENCES profiles(id),
	FOREIGN KEY (board_id) REFERENCES boards(id),
	FOREIGN KEY (package_id) REFERENCES component_packages(id),

	left_corner_x SMALLINT UNSIGNED,
	left_corner_y SMALLINT UNSIGNED,
	right_corner_x SMALLINT UNSIGNED,
	right_corner_y SMALLINT UNSIGNED,
	visible BIT NOT NULL DEFAULT 1
);

-- Code refs
CREATE TABLE code_libraries
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	picture_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (picture_id) REFERENCES pictures(id),

	library_name TINYTEXT NOT NULL,
	location TINYTEXT NOT NULL,
	description TEXT,
	source_url TINYTEXT,
	download_url TINYTEXT
);

CREATE TABLE code_ref_categories
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	master_id TINYINT UNSIGNED,
	FOREIGN KEY (master_id) REFERENCES code_ref_categories(id),
	library_id TINYINT UNSIGNED,
	FOREIGN KEY (library_id) REFERENCES code_libraries(id),

	category_name TINYTEXT NOT NULL,
	description TEXT
);

CREATE TABLE code_refs
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	category_id TINYINT UNSIGNED,
	FOREIGN KEY (category_id) REFERENCES code_ref_categories(id),

	difficulty_level ENUM('Beginner', 'Moderate', 'Advanced', 'Super advanced'),
	name TINYTEXT NOT NULL,

	created DATETIME NOT NULL,
	last_updated DATETIME NOT NULL,
	description TEXT NOT NULL,
	syntax TINYTEXT NOT NULL,
	return_type TINYTEXT,
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

	variable_name TINYTEXT NOT NULL,
	data_type TINYTEXT NOT NULL,
	description TINYTEXT NOT NULL,
	on_page BIT NOT NULL DEFAULT 1
);

-- Content pages
CREATE TABLE content_pages
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),

	page_group ENUM('Tutorial', 'Project', 'Blog post'),
	difficulty_level ENUM('Beginner', 'Moderate', 'Advanced', 'Super advanced'),
	title TINYTEXT NOT NULL,
	description TEXT NOT NULL
);

CREATE TABLE content_page_edits
(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	page_id SMALLINT UNSIGNED NOT NULL,
	writer_profile_id SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (page_id) REFERENCES content_pages(id),
	FOREIGN KEY (writer_profile_id) REFERENCES profiles(id),

	started DATETIME NOT NULL,
	end_datetime DATETIME,
	contents TEXT NOT NULL,
	sanitize BIT NOT NULL DEFAULT 1
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

	start_datetime DATETIME NOT NULL,
	end_datetime DATETIME,
	contents TEXT NOT NULL,
	sanitize BIT NOT NULL DEFAULT 1
);
