-- 1. Plants (Strong Entity)
CREATE TABLE Plants (
    plant_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    max_capacity INT
);

-- 2. Suppliers (Strong Entity)
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quality_rating INT,
    /* CONSTRAINT 1: Ensure rating is between 1 and 5 */
    CONSTRAINT chk_quality_rating CHECK (quality_rating BETWEEN 1 AND 5)
);

-- 3. Customers (Strong Entity)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

-- 4. Parts (Strong Entity, dependent on Supplier)
CREATE TABLE Parts (
    part_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- 5. Inventory (Associative Entity between Plants and Parts)
CREATE TABLE Inventory (
    plant_id INT,
    part_id INT,
    quantity INT DEFAULT 0,
    min_threshold INT DEFAULT 10,
    PRIMARY KEY (plant_id, part_id),
    FOREIGN KEY (plant_id) REFERENCES Plants(plant_id),
    FOREIGN KEY (part_id) REFERENCES Parts(part_id),
    /* CONSTRAINT 2: Inventory cannot be negative */
    CONSTRAINT chk_inventory_quantity CHECK (quantity >= 0)
);

-- 6. Vehicles (Strong Entity, linked to Plant)
CREATE TABLE Vehicles (
    vin VARCHAR(17) PRIMARY KEY,
    model_name VARCHAR(50),
    manufacture_date DATE,
    status VARCHAR(20),
    plant_id INT,
    FOREIGN KEY (plant_id) REFERENCES Plants(plant_id),
    /* CONSTRAINT 3: Status must be a valid business state */
    CONSTRAINT chk_vehicle_status CHECK (status IN ('Planned', 'In Production', 'Quality Check', 'Ready', 'Sold'))
);

-- 7. SalesOrders (Link between Customer and Vehicle)
CREATE TABLE SalesOrders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    vin VARCHAR(17),
    sale_date DATE,
    sale_price DECIMAL(12, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (vin) REFERENCES Vehicles(vin),
    /* CONSTRAINT 4: Sale price must be positive */
    CONSTRAINT chk_sale_price CHECK (sale_price > 0)
);

-- 8. ServiceRecords (Weak Entity, dependent on Vehicle)
CREATE TABLE ServiceRecords (
    service_id INT PRIMARY KEY,
    vin VARCHAR(17),
    service_date DATE,
    description VARCHAR(255),
    cost DECIMAL(10, 2),
    FOREIGN KEY (vin) REFERENCES Vehicles(vin)
);
