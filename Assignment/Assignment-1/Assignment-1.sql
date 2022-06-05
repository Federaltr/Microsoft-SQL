--Assignment-1
--(Charlie's Chocolate Factory)

--Create Database

CREATE DATABASE Manufacturer;

Use Manufacturer;

--Create Table with constraints.

CREATE TABLE product (
		product_id INT IDENTITY (1, 1) PRIMARY KEY,
		product_name VARCHAR(50) NOT NULL,
		quantity INT NULL
);

CREATE TABLE component (
		component_id INT IDENTITY (1, 1) PRIMARY KEY,
		component_name VARCHAR(50) NOT NULL,
		[description] VARCHAR(50),
		quantity_comp INT
);

CREATE TABLE supplier (
		supplier_id INT IDENTITY (1, 1) PRIMARY KEY,
		supplier_name VARCHAR(50),
		supplier_loc VARCHAR(50),
		supp_country VARCHAR(50),
		is_active BIT
);

CREATE TABLE  prod_comp  (
		product_id INT,
		component_id INT,
		quantity_comp INT,
		PRIMARY KEY (product_id, component_id),
		FOREIGN KEY (product_id) REFERENCES product (product_id),
		FOREIGN KEY (component_id) REFERENCES component (component_id)
);

CREATE TABLE comp_supp  (
		component_id INT,
		supplier_id INT,
		order_date DATE NOT NULL,
		quantity INT,
		PRIMARY KEY (component_id, supplier_id),
		FOREIGN KEY (component_id) REFERENCES component (component_id),
		FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id)
);















































