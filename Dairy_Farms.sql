create database Dairy_Farms;
use Dairy_Farms;


-- ============================================
-- CORE TABLES (No Foreign Dependencies)
-- ============================================

-- Staff table (already correct, included for completeness)
CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    role VARCHAR(50), -- Vet / Technician / Worker
    phone VARCHAR(20),
    experience_years INT,
    manager_id INT NULL,
    CONSTRAINT FK_Staff_Manager FOREIGN KEY (manager_id) REFERENCES Staff(staff_id)
);
-- Customer table (already correct)
CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_type VARCHAR(30), -- Individual / Business / Cooperative
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(200),
    gst_number VARCHAR(50),
    credit_limit DECIMAL(10,2),
    payment_terms VARCHAR(50),
    created_date DATE,
    is_active BIT DEFAULT 1
);

-- Vendor table (already correct)
CREATE TABLE Vendor (
    vendor_id INT IDENTITY(1,1) PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    vendor_type VARCHAR(30), -- Feed / Medicine / Equipment / Semen / Livestock
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(200),
    gst_number VARCHAR(50),
    payment_terms VARCHAR(50),
    rating INT,
    contract_start_date DATE,
    contract_end_date DATE
);

-- Pen table (already correct)
CREATE TABLE Pen (
    pen_id INT IDENTITY(1,1) PRIMARY KEY,
    pen_name VARCHAR(50) NOT NULL,
    pen_type VARCHAR(30), -- Milking / Dry / Calves
    capacity INT,
    location VARCHAR(100)
);

-- Feed table (was missing IDENTITY)
CREATE TABLE feed (
    feed_id INT IDENTITY(1,1) PRIMARY KEY,
    feed_name VARCHAR(50),
    feed_type VARCHAR(50),
    cost_per_kg DECIMAL(10,2)
);

-- Medicine table (was missing IDENTITY)
CREATE TABLE Medicine (
    medicine_id INT IDENTITY(1,1) PRIMARY KEY,
    medicine_name VARCHAR(100),
    medicine_type VARCHAR(50),
    dosage_form VARCHAR(50),
    purpose VARCHAR(150),
    manufacturer VARCHAR(100)
);

-- Disease table (was missing IDENTITY)
CREATE TABLE Disease (
    disease_id INT IDENTITY(1,1) PRIMARY KEY,
    disease_name VARCHAR(100) NOT NULL,
    contagious_status VARCHAR(10) CHECK (contagious_status IN ('Yes','No'))
);

-- Bull table (was missing IDENTITY)
CREATE TABLE Bull (
    Bull_id INT IDENTITY(1,1) PRIMARY KEY,
    Bull_tag VARCHAR(50),
    Bull_name VARCHAR(50),
    Breed VARCHAR(50),
    Source VARCHAR(50)
);

-- Semen table (was missing IDENTITY)
CREATE TABLE Semen (
    Semen_id INT IDENTITY(1,1) PRIMARY KEY,
    Bull_name VARCHAR(50),
    Breed VARCHAR(50),
    Company VARCHAR(50),
    BatchNo VARCHAR(50)
);

-- ============================================
-- TABLES DEPENDING ON CORE TABLES
-- ============================================

-- Cow table (already correct)
CREATE TABLE Cow (
    cow_id INT IDENTITY(1,1) PRIMARY KEY,
    tag_id VARCHAR(20) UNIQUE NOT NULL,
    electronic_id VARCHAR(20) UNIQUE,
    cow_name VARCHAR(50),
    cow_type VARCHAR(20), -- Cow / Buffalo
    breed VARCHAR(50),
    gender VARCHAR(10),
    purchased_from VARCHAR(50),
    country VARCHAR(50),
    date_of_birth DATE,
    arrival_date DATE,
    purchase_price DECIMAL(10,2),
    cow_weight DECIMAL(10,2),
    weight_date DATE,
    status VARCHAR(20), -- Active / Sold / Dead
    pen_id INT NULL,
    CONSTRAINT FK_Cow_Pen FOREIGN KEY (pen_id) REFERENCES Pen(pen_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Calf table (was missing IDENTITY)
CREATE TABLE Calf (
    Calf_id INT IDENTITY(1,1) PRIMARY KEY,
    CalfTag VARCHAR(50) UNIQUE,
    MotherCowID INT NOT NULL,
    FatherSource VARCHAR(20), -- Bull / Semen
    FatherID INT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10),
    BirthWeight DECIMAL(5,2),
    Status VARCHAR(20), -- Alive / Sold / Dead
    DeathDate DATE NULL,
    SaleDate DATE NULL,
    SaleAmount DECIMAL(10,2),
    Remarks VARCHAR(200),
    FOREIGN KEY (MotherCowID) REFERENCES Cow(Cow_id)
);

-- Equipment table (already correct)
CREATE TABLE Equipment (
    equipment_id INT IDENTITY(1,1) PRIMARY KEY,
    equipment_name VARCHAR(100),
    equipment_type VARCHAR(50),
    purchase_date DATE,
    purchase_price DECIMAL(10,2),
    current_value DECIMAL(10,2),
    maintenance_schedule VARCHAR(100),
    last_maintenance DATE,
    next_maintenance DATE,
    status VARCHAR(20)
);

-- ============================================
-- TRANSACTION TABLES
-- ============================================

-- Breeding table (was missing IDENTITY)
CREATE TABLE Breeding (
    Breeding_id INT IDENTITY(1,1) PRIMARY KEY,
    cow_id INT,
    Breeding_date DATE,
    Breeding_type VARCHAR(20), -- AI / Natural
    Bull_id INT NULL,
    Semen_id INT NULL,
    Technician_name VARCHAR(50),
    Result VARCHAR(20), -- Successful / Failed / Pending
    Remarks VARCHAR(200),
    FOREIGN KEY (Cow_id) REFERENCES Cow(Cow_id),
    FOREIGN KEY (Bull_id) REFERENCES Bull(Bull_id),
    FOREIGN KEY (Semen_id) REFERENCES Semen(Semen_id)
);
-- Pregnancy table (was missing IDENTITY)
CREATE TABLE Pregnancy (
    Pregnancy_id INT IDENTITY(1,1) PRIMARY KEY,
    cow_id INT,
    Breeding_id INT,
    PregnancyCheckDate DATE,
    ExpectedCalvingDate DATE,
    ActualCalvingDate DATE,
    Status VARCHAR(20),
    Remarks VARCHAR(200),
    FOREIGN KEY (Cow_id) REFERENCES Cow(Cow_id),
    FOREIGN KEY (Breeding_id) REFERENCES Breeding(Breeding_id)
);

-- Milk Production table (was missing IDENTITY)
CREATE TABLE milk_production (
    milk_id INT IDENTITY(1,1) PRIMARY KEY,
    cow_id INT,
    record_date DATE,
    record_time VARCHAR(50), -- Morning / Afternoon / Evening
    milk_liters INT,
    FOREIGN KEY (Cow_id) REFERENCES Cow(Cow_id)
);

-- Milk Quality Test table (already correct)
CREATE TABLE Milk_Quality_Test (
    test_id INT IDENTITY(1,1) PRIMARY KEY,
    milk_id INT,
    test_date DATE,
    fat_percentage DECIMAL(5,2),
    protein_percentage DECIMAL(5,2),
    snf_percentage DECIMAL(5,2),
    somatic_cell_count INT,
    temperature DECIMAL(5,2),
    tester_name VARCHAR(100),
    grade VARCHAR(10),
    FOREIGN KEY (milk_id) REFERENCES milk_production(milk_id)
);

-- Feed Consumption table (was missing IDENTITY)
CREATE TABLE feed_consumption (
    feed_consume_id INT IDENTITY(1,1) PRIMARY KEY,
    cow_id INT,
    feed_id INT,
    feed_date DATE,
    quantity_kg DECIMAL(5,2),
    FOREIGN KEY (Cow_id) REFERENCES Cow(Cow_id),
    FOREIGN KEY (feed_id) REFERENCES feed(feed_id)
);

-- Health Record table (was missing IDENTITY)
CREATE TABLE health_record (
    health_id INT IDENTITY(1,1) PRIMARY KEY,
    cow_id INT,
    disease_name VARCHAR(100),
    treatment VARCHAR(100),
    medicine_cost DECIMAL(10,2),
    visit_date DATE,
    recovery_status VARCHAR(30),
    FOREIGN KEY (Cow_id) REFERENCES Cow(Cow_id)
);

-- Vaccination table (was missing IDENTITY)
CREATE TABLE Vaccination (
    vaccination_id INT IDENTITY(1,1) PRIMARY KEY,
    cow_id INT,
    bull_id INT,
    vaccine_name VARCHAR(100),
    vaccination_date DATE,
    next_due_date DATE,
    administered_by INT,
    remarks VARCHAR(200),
    FOREIGN KEY (cow_id) REFERENCES Cow(cow_id),
    FOREIGN KEY (bull_id) REFERENCES Bull(bull_id),
    FOREIGN KEY (administered_by) REFERENCES Staff(staff_id)
);

-- Medicine Stock table (was missing IDENTITY)
CREATE TABLE Medicine_Stock (
    stock_id INT IDENTITY(1,1) PRIMARY KEY,
    medicine_id INT,
    batch_number VARCHAR(50),
    bottle_size_ml INT,
    quantity_in_stock INT,
    unit_price DECIMAL(10,2),
    expiry_date DATE,
    received_date DATE,
    storage_condition VARCHAR(100),
    remarks VARCHAR(200),
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id)
);

-- Milk Sale table (was missing IDENTITY)
CREATE TABLE Milk_Sale (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    sale_date DATE,
    buyer_name VARCHAR(100),
    total_liters DECIMAL(8,2),
    fat DECIMAL(8,2),
    L_R DECIMAL(8,2),
    rate_per_liter DECIMAL(6,2),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20) -- Paid / Pending
);

-- Animal Sale table (was missing IDENTITY)
CREATE TABLE Animal_Sale (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    animal_type VARCHAR(10) NOT NULL, -- 'Cow' / 'Bull' / 'Calf'
    animal_id INT NOT NULL,
    sale_date DATE,
    sale_price DECIMAL(10,2),
    buyer_name VARCHAR(100)
);

-- Weight History table (was missing IDENTITY)
CREATE TABLE Weight_History (
    weight_id INT IDENTITY(1,1) PRIMARY KEY,
    animal_type VARCHAR(10) NOT NULL, -- 'Cow', 'Bull', 'Calf'
    animal_id INT NOT NULL,
    weight DECIMAL(6,2) NOT NULL,
    recorded_date DATE NOT NULL,       -- Defined only once
    recorded_by INT NULL,
    notes VARCHAR(200) NULL,
    -- Add check constraint to ensure valid animal types
    CONSTRAINT CHK_Animal_Type CHECK (animal_type IN ('Cow', 'Bull', 'Calf'))
    -- Removed the duplicate recorded_date line
);

-- Add indexes for performance
CREATE INDEX IX_Weight_History_Animal ON Weight_History(animal_type, animal_id);
CREATE INDEX IX_Weight_History_Date ON Weight_History(recorded_date);

-- Expense table (was missing IDENTITY)
CREATE TABLE Expense (
    expense_id INT IDENTITY(1,1) PRIMARY KEY,
    expense_date DATE,
    expense_type VARCHAR(50), -- Feed / Medicine / Labor / Electricity
    amount DECIMAL(10,2),
    remarks VARCHAR(200)
);

-- Income table (was missing IDENTITY)
CREATE TABLE Income (
    income_id INT IDENTITY(1,1) PRIMARY KEY,
    income_date DATE,
    source VARCHAR(50), -- Milk / Cow Sale
    amount DECIMAL(10,2),
    reference_id INT
);

-- Alerts table (was missing IDENTITY)
CREATE TABLE Alerts (
    alert_id INT IDENTITY(1,1) PRIMARY KEY,
    Cow_id INT,
    bull_id INT,
    calf_id INT,
    alert_type VARCHAR(50),
    alert_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (Cow_id) REFERENCES Cow(Cow_id),
    FOREIGN KEY (bull_id) REFERENCES Bull(bull_id),
    FOREIGN KEY (calf_id) REFERENCES Calf(Calf_id)
);

-- ============================================
-- EMPLOYEE MANAGEMENT TABLES
-- ============================================

-- Employee Payroll table (already correct)
CREATE TABLE Employee_Payroll (
    payroll_id INT IDENTITY(1,1) PRIMARY KEY,
    staff_id INT,
    pay_period_start DATE,
    pay_period_end DATE,
    basic_salary DECIMAL(10,2),
    overtime_hours DECIMAL(5,2),
    overtime_rate DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    net_salary DECIMAL(10,2),
    payment_date DATE,
    payment_status VARCHAR(20),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Employee Attendance table (already correct)
CREATE TABLE Employee_Attendance (
    attendance_id INT IDENTITY(1,1) PRIMARY KEY,
    staff_id INT,
    work_date DATE,
    hours_worked DECIMAL(4,2),
    overtime_hours DECIMAL(4,2),
    shift VARCHAR(20),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Maintenance Log table (already correct)
CREATE TABLE Maintenance_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    equipment_id INT,
    maintenance_date DATE,
    description VARCHAR(200),
    cost DECIMAL(10,2),
    performed_by VARCHAR(100),
    next_due_date DATE,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);

-- ============================================
-- INVENTORY & FEED MANAGEMENT TABLES
-- ============================================

-- Genetics table (already correct)
CREATE TABLE Genetics (
    genetics_id INT IDENTITY(1,1) PRIMARY KEY,
    animal_id INT,
    animal_type VARCHAR(10), -- Cow / Bull / Calf
    sire_id INT,
    dam_id INT,
    genetic_merit_score DECIMAL(5,2),
    genetic_test_date DATE,
    test_results VARCHAR(200)
);

-- Inventory table (already correct)
CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    item_type VARCHAR(30), -- Feed / Medicine / Semen / Equipment
    item_id INT,
    quantity_on_hand DECIMAL(10,2),
    unit VARCHAR(20),
    reorder_level DECIMAL(10,2),
    reorder_quantity DECIMAL(10,2),
    location VARCHAR(50),
    last_stock_take DATE
    -- Note: Foreign keys would need to be handled application-side due to polymorphic nature
);

-- Feed Inventory table (already correct)
-- Feed Inventory table with remarks column
CREATE TABLE Feed_Inventory (
    feed_inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    feed_id INT,
    batch_number VARCHAR(50),
    quantity_kg DECIMAL(10,2),
    purchase_date DATE,
    expiry_date DATE,
    purchase_price DECIMAL(10,2),
    supplier_id INT,
    location VARCHAR(50),
    remarks VARCHAR(200),  -- Added remarks column
    FOREIGN KEY (feed_id) REFERENCES feed(feed_id),
    FOREIGN KEY (supplier_id) REFERENCES Vendor(vendor_id)
);
-- Feed Formula table (already correct)
CREATE TABLE Feed_Formula (
    formula_id INT IDENTITY(1,1) PRIMARY KEY,
    formula_name VARCHAR(100),
    pen_type VARCHAR(30), -- Milking / Dry / Calves
    production_stage VARCHAR(50), -- Lactation / Dry period
    total_kg_per_animal DECIMAL(6,2),
    cost_per_kg DECIMAL(10,2),
    is_active BIT DEFAULT 1
);
select * from feed_formula_detail;
-- Feed Formula Detail table (already correct)
CREATE TABLE Feed_Formula_Detail (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    formula_id INT,
    feed_id INT,
    percentage DECIMAL(5,2),
    kg_per_animal DECIMAL(6,2),
    FOREIGN KEY (formula_id) REFERENCES Feed_Formula(formula_id),
    FOREIGN KEY (feed_id) REFERENCES feed(feed_id)
);



INSERT INTO Staff (staff_name, role, phone, experience_years, manager_id) VALUES
('John Smith', 'Farm Manager', '555-0101', 15, NULL),
('Sarah Johnson', 'Vet', '555-0102', 8, 1),
('Mike Wilson', 'Senior Technician', '555-0103', 10, 1),
('Emily Brown', 'Technician', '555-0104', 3, 3),
('David Miller', 'Worker', '555-0105', 2, 3),
('Lisa Davis', 'Vet', '555-0106', 5, 1),
('Tom Harris', 'Worker', '555-0107', 1, 3),
('Anna Martinez', 'Technician', '555-0108', 4, 3),
('Robert Taylor', 'Worker', '555-0109', 6, 3),
('Jennifer White', 'Accountant', '555-0110', 7, 1);

-- Insert Customer
INSERT INTO Customer (customer_name, customer_type, phone, email, address, gst_number, credit_limit, payment_terms, created_date, is_active) VALUES
('Fresh Milk Dairy', 'Business', '555-1001', 'orders@freshmilk.com', '123 Industrial Ave', 'GST12345', 50000.00, 'Net 30', '2025-01-15', 1),
('City Creamery', 'Business', '555-1002', 'purchase@citycreamery.com', '456 Commerce St', 'GST67890', 75000.00, 'Net 15', '2025-01-20', 1),
('Green Valley School', 'Cooperative', '555-1003', 'kitchen@greenvalley.edu', '789 Education Rd', NULL, 15000.00, 'Net 7', '2025-02-01', 1),
('Sunrise Cafe', 'Individual', '555-1004', 'owner@sunrisecafe.com', '321 Main St', NULL, 5000.00, 'COD', '2025-02-10', 1),
('Daily Needs Store', 'Business', '555-1005', 'contact@dailyneeds.com', '654 Market St', 'GST54321', 25000.00, 'Net 30', '2025-02-15', 1);

-- Insert Vendor
INSERT INTO Vendor (vendor_name, vendor_type, contact_person, phone, email, address, gst_number, payment_terms, rating, contract_start_date, contract_end_date) VALUES
('AgriFeed Corp', 'Feed', 'John Anderson', '555-2001', 'sales@agrifeed.com', '111 Feed Mill Rd', 'GST11111', 'Net 45', 5, '2025-01-01', '2025-12-31'),
('VetMed Supply', 'Medicine', 'Dr. Peter Chen', '555-2002', 'orders@vetmed.com', '222 Pharma Blvd', 'GST22222', 'Net 30', 4, '2025-01-01', '2025-12-31'),
('DairyTech Industries', 'Equipment', 'Mary Johnson', '555-2003', 'sales@dairytech.com', '333 Equipment Ave', 'GST33333', 'Net 60', 5, '2025-02-01', '2026-01-31'),
('Genex Genetics', 'Semen', 'Dr. Robert Lee', '555-2004', 'orders@genexgen.com', '444 Genetics Way', 'GST44444', 'Net 30', 5, '2025-01-15', '2025-12-31'),
('Livestock Traders', 'Livestock', 'William Brown', '555-2005', 'info@livestocktraders.com', '555 Auction St', 'GST55555', 'Net 15', 3, '2025-03-01', '2025-12-31');

-- Insert Pen
INSERT INTO Pen (pen_name, pen_type, capacity, location) VALUES
('Milking Parlor A', 'Milking', 50, 'Barn 1 - East'),
('Milking Parlor B', 'Milking', 50, 'Barn 1 - West'),
('Dry Cow Section', 'Dry', 30, 'Barn 2'),
('Calves Nursery', 'Calves', 40, 'Barn 3 - Heated'),
('Young Stock', 'Calves', 35, 'Barn 3 - South'),
('Hospital Pen', 'Dry', 10, 'Barn 4'),
('Close-up Pen', 'Dry', 20, 'Barn 2 - North');


-- Insert Feed
INSERT INTO feed (feed_name, feed_type, cost_per_kg) VALUES
('Corn Silage - 2025 Harvest', 'Roughage', 0.42),
('Alfalfa Hay - Premium Grade', 'Roughage', 0.62),
('Dairy Pellet 20% Protein', 'Concentrate', 0.92),
('Soybean Meal - Solvent Extracted', 'Protein', 1.28),
('Whole Cottonseed', 'Protein/Fiber', 0.74),
('Barley Grain - Rolled', 'Energy', 0.48),
('Wheat Bran', 'Fiber', 0.35),
('Distillers Grains', 'Protein', 0.58),
('Calf Starter Medicated', 'Concentrate', 1.15),
('Dairy Mineral Premium', 'Mineral', 2.85);

-- Insert Medicine
INSERT INTO Medicine ( medicine_name, medicine_type, dosage_form, purpose, manufacturer) VALUES
('Oxytetracycline', 'Antibiotic', 'Injection', 'Bacterial infections', 'VetMed'),
('Ivermectin', 'Antiparasitic', 'Pour-on', 'Internal/external parasites', 'VetMed'),
('Lactation Booster', 'Hormone', 'Injection', 'Milk production', 'DairyHealth'),
('Calcium Borogluconate', 'Supplement', 'Solution', 'Milk fever', 'VetSolutions'),
('Penicillin G', 'Antibiotic', 'Injection', 'Mastitis', 'PharmaVet'),
('Multivitamin', 'Supplement', 'Injection', 'General health', 'VetMed'),
('Cloxacillin', 'Antibiotic', 'Intramammary', 'Mastitis', 'PharmaVet'),
('Vitamin E/Selenium', 'Supplement', 'Injection', 'White muscle disease', 'VetSolutions');

-- Step 1: See what medicine_ids currently exist
SELECT MIN(medicine_id) as MinID, MAX(medicine_id) as MaxID, COUNT(*) as TotalMedicines FROM Medicine;

-- Step 2: Insert missing medicines with specific IDs if needed
-- (Only if your table doesn't use IDENTITY or you have IDENTITY_INSERT ON)
SET IDENTITY_INSERT Medicine ON;

INSERT INTO Medicine (medicine_id, medicine_name, medicine_type, dosage_form, purpose, manufacturer) VALUES
(9, 'Flunixin Meglumine', 'NSAID', 'Injection', 'Pain relief, anti-inflammatory', 'VetMed'),
(10, 'Dexamethasone', 'Steroid', 'Injection', 'Anti-inflammatory, shock', 'PharmaVet'),
(11, 'Ketoprofen', 'NSAID', 'Injection', 'Pain relief, fever reduction', 'VetSolutions'),
(12, 'Tetracycline', 'Antibiotic', 'Injection', 'Broad-spectrum antibiotic', 'AgriPharma'),
(13, 'Sulfadimidine', 'Antibiotic', 'Injection', 'Bacterial infections', 'VetMed'),
(14, 'Propylene Glycol', 'Supplement', 'Oral', 'Ketosis treatment', 'DairyHealth'),
(15, 'Calcium Gel', 'Supplement', 'Oral', 'Milk fever prevention', 'VetSolutions');

-- Step 1: See what medicine_ids currently exist
SELECT MIN(medicine_id) as MinID, MAX(medicine_id) as MaxID, COUNT(*) as TotalMedicines FROM Medicine;

-- Step 2: Insert missing medicines with specific IDs if needed
-- (Only if your table doesn't use IDENTITY or you have IDENTITY_INSERT ON)
SET IDENTITY_INSERT Medicine ON;

INSERT INTO Medicine (medicine_id, medicine_name, medicine_type, dosage_form, purpose, manufacturer) VALUES
(9, 'Flunixin Meglumine', 'NSAID', 'Injection', 'Pain relief, anti-inflammatory', 'VetMed'),
(10, 'Dexamethasone', 'Steroid', 'Injection', 'Anti-inflammatory, shock', 'PharmaVet'),
(11, 'Ketoprofen', 'NSAID', 'Injection', 'Pain relief, fever reduction', 'VetSolutions'),
(12, 'Tetracycline', 'Antibiotic', 'Injection', 'Broad-spectrum antibiotic', 'AgriPharma'),
(13, 'Sulfadimidine', 'Antibiotic', 'Injection', 'Bacterial infections', 'VetMed'),
(14, 'Propylene Glycol', 'Supplement', 'Oral', 'Ketosis treatment', 'DairyHealth'),
(15, 'Calcium Gel', 'Supplement', 'Oral', 'Milk fever prevention', 'VetSolutions');

SET IDENTITY_INSERT Medicine OFF;

-- Step 3: Now run your medicine stock insert
-- (Your original insert will now work)


-- Step 3: Now run your medicine stock insert
-- (Your original insert will now work)

-- Insert Disease
INSERT INTO Disease ( disease_name, contagious_status) VALUES
( 'Mastitis', 'No'),
( 'Foot and Mouth Disease', 'Yes'),
( 'Bovine Tuberculosis', 'Yes'),
( 'Brucellosis', 'Yes'),
( 'Milk Fever', 'No'),
( 'Ketosis', 'No'),
( 'Lameness', 'No'),
('Pneumonia', 'Yes'),
( 'Metritis', 'No'),
( 'Parasites', 'Yes');


-- Insert Bull
INSERT INTO Bull ( Bull_tag, Bull_name, Breed, Source) VALUES
( 'BULL001', 'Thunder', 'Holstein', 'Genex Genetics'),
( 'BULL002', 'Lightning', 'Jersey', 'Genex Genetics'),
( 'BULL003', 'Ace', 'Holstein', 'ABS Global'),
( 'BULL004', 'King', 'Brown Swiss', 'Select Sires'),
( 'BULL005', 'Major', 'Ayrshire', 'Genex Genetics');

-- Insert Semen
INSERT INTO Semen ( Bull_name, Breed, Company, BatchNo) VALUES
('Thunder', 'Holstein', 'Genex Genetics', 'GEN2025-001'),
( 'Lightning', 'Jersey', 'Genex Genetics', 'GEN2025-002'),
( 'Ace', 'Holstein', 'ABS Global', 'ABS2025-101'),
( 'King', 'Brown Swiss', 'Select Sires', 'SEL2025-201'),
( 'Major', 'Ayrshire', 'Genex Genetics', 'GEN2025-003'),
( 'Thunder', 'Holstein', 'Genex Genetics', 'GEN2025-004');


-- Insert Cows
INSERT INTO Cow (tag_id, electronic_id, cow_name, cow_type, breed, gender, purchased_from, country, date_of_birth, arrival_date, purchase_price, cow_weight, weight_date, status, pen_id) VALUES
('COW001', 'ELEC001', 'Bella', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2021-03-15', '2022-01-10', 1800.00, 650.50, '2026-01-15', 'Active', 1),
('COW002', 'ELEC002', 'Daisy', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2020-06-20', '2021-02-15', 1750.00, 680.00, '2026-01-14', 'Active', 1),
('COW003', 'ELEC003', 'Molly', 'Cow', 'Jersey', 'Female', 'Local Farmer', 'Canada', '2022-01-10', '2023-03-01', 1500.00, 520.50, '2026-01-15', 'Active', 2),
('COW004', 'ELEC004', 'Lily', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2019-11-05', '2020-01-20', 1900.00, 710.25, '2026-01-13', 'Active', 2),
('COW005', 'ELEC005', 'Rosie', 'Cow', 'Ayrshire', 'Female', 'Local Farmer', 'Canada', '2021-08-12', '2022-05-10', 1600.00, 590.75, '2026-01-15', 'Active', 1),
('COW006', 'ELEC006', 'Bessie', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2020-02-28', '2020-09-15', 1850.00, 695.00, '2026-01-14', 'Active', 3),
('COW007', 'ELEC007', 'Clover', 'Cow', 'Jersey', 'Female', 'Local Farmer', 'Canada', '2022-05-15', '2023-07-01', 1550.00, 510.00, '2026-01-15', 'Active', 3),
('COW008', 'ELEC008', 'Maple', 'Cow', 'Brown Swiss', 'Female', 'Livestock Traders', 'Switzerland', '2021-11-30', '2022-08-20', 2000.00, 625.50, '2026-01-15', 'Active', 2),
('COW009', 'ELEC009', 'Buttercup', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2022-07-04', '2023-02-28', 1700.00, 540.00, '2026-01-14', 'Active', 4),
('COW010', 'ELEC010', 'Stella', 'Buffalo', 'Murrah', 'Female', 'Local Farmer', 'India', '2021-12-10', '2022-06-15', 2200.00, 580.00, '2026-01-15', 'Active', 5),
('COW011', 'ELEC011', 'Penny', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2018-09-18', '2019-01-15', 1650.00, 720.00, '2026-01-13', 'Active', 6),
('COW012', 'ELEC012', 'Hazel', 'Cow', 'Guernsey', 'Female', 'Local Farmer', 'Canada', '2022-10-22', '2023-04-10', 1450.00, 495.00, '2026-01-15', 'Active', 7),
('COW013', 'ELEC013', 'Ruby', 'Cow', 'Holstein', 'Female', 'Livestock Traders', 'USA', '2023-01-05', '2023-08-20', 1600.00, 480.00, '2026-01-14', 'Active', 4),
('COW014', 'ELEC014', 'Pearl', 'Cow', 'Jersey', 'Female', 'Local Farmer', 'Canada', '2023-03-12', '2023-09-25', 1400.00, 450.00, '2026-01-15', 'Active', 5),
('COW015', 'ELEC015', 'Misty', 'Cow', 'Ayrshire', 'Female', 'Livestock Traders', 'USA', '2022-12-01', '2023-06-05', 1550.00, 520.50, '2026-01-15', 'Active', 7),
('COW016', 'ELEC016', 'Bella 2', 'Cow', 'Holstein', 'Female', 'Internal', 'USA', '2024-01-15', '2024-01-15', 0.00, 40.50, '2024-01-15', 'Active', 4),
('COW017', 'ELEC017', 'Daisy Jr', 'Cow', 'Holstein', 'Female', 'Internal', 'USA', '2024-02-20', '2024-02-20', 0.00, 42.00, '2024-02-20', 'Active', 4),
('COW018', 'ELEC018', 'Molly Jr', 'Cow', 'Jersey', 'Female', 'Internal', 'Canada', '2024-03-10', '2024-03-10', 0.00, 38.50, '2024-03-10', 'Active', 4);


-- Insert Calf (calves born in last 6 months)
-- Insert 20 calf records
INSERT INTO Calf (CalfTag, MotherCowID, FatherSource, FatherID, DateOfBirth, Gender, BirthWeight, Status, DeathDate, SaleDate, SaleAmount, Remarks) VALUES
-- Recent births (last 3 months)
('CLF2401', 1, 'Semen', 1, '2025-12-05', 'Female', 42.5, 'Alive', NULL, NULL, NULL, 'Healthy, strong'),
('CLF2402', 2, 'Semen', 3, '2025-12-08', 'Male', 45.0, 'Alive', NULL, NULL, NULL, 'Large birth weight'),
('CLF2403', 4, 'Bull', 2, '2025-12-12', 'Female', 40.0, 'Alive', NULL, NULL, NULL, 'Good conformation'),
('CLF2404', 5, 'Semen', 1, '2025-12-15', 'Female', 41.5, 'Alive', NULL, NULL, NULL, 'Dam is good producer'),
('CLF2405', 7, 'Semen', 4, '2025-12-18', 'Male', 44.0, 'Sold', NULL, '2026-01-20', 850.00, 'Sold to Johnson Farms'),
('CLF2406', 8, 'Semen', 6, '2025-12-22', 'Female', 43.0, 'Alive', NULL, NULL, NULL, 'Potential replacement'),
('CLF2407', 10, 'Bull', 1, '2025-12-25', 'Female', 40.5, 'Alive', NULL, NULL, NULL, 'Christmas calf'),
('CLF2408', 11, 'Semen', 3, '2025-12-28', 'Male', 46.0, 'Alive', NULL, NULL, NULL, 'Very strong bull calf'),
('CLF2409', 3, 'Bull', 2, '2026-01-02', 'Female', 38.5, 'Alive', NULL, NULL, NULL, 'Small but healthy'),
('CLF2410', 6, 'Semen', 1, '2026-01-05', 'Female', 42.0, 'Alive', NULL, NULL, NULL, 'Good markings'),
('CLF2411', 9, 'Semen', 2, '2026-01-08', 'Male', 43.5, 'Sold', NULL, '2026-02-01', 900.00, 'Sold to Miller Dairy'),
('CLF2412', 12, 'Semen', 5, '2026-01-10', 'Female', 41.0, 'Alive', NULL, NULL, NULL, 'Good pedigree'),
('CLF2413', 14, 'Bull', 3, '2026-01-12', 'Male', 44.5, 'Alive', NULL, NULL, NULL, 'Strong growth potential'),
('CLF2414', 15, 'Semen', 1, '2026-01-15', 'Female', 40.0, 'Alive', NULL, NULL, NULL, 'Well formed'),

-- Births with complications/mortality
('CLF2315', 13, 'Semen', 4, '2025-11-10', 'Male', 47.0, 'Dead', '2025-11-10', NULL, NULL, 'Dystocia - stillborn'),
('CLF2316', 16, 'Bull', 2, '2025-11-15', 'Female', 35.0, 'Dead', '2025-11-20', NULL, NULL, 'Weak calf, died at 5 days'),

-- Older calves (weaned)
('CLF2317', 1, 'Semen', 1, '2025-09-20', 'Female', 41.0, 'Alive', NULL, NULL, NULL, 'Weaned, growing well'),
('CLF2318', 2, 'Semen', 3, '2025-09-25', 'Male', 44.0, 'Sold', NULL, '2025-12-15', 800.00, 'Sold at auction'),
('CLF2319', 4, 'Bull', 2, '2025-10-01', 'Female', 42.0, 'Alive', NULL, NULL, NULL, 'Excellent growth rate'),
('CLF2320', 5, 'Semen', 1, '2025-10-08', 'Female', 40.5, 'Alive', NULL, NULL, NULL, 'Good replacement heifer');


-- Insert Equipment
INSERT INTO Equipment ( equipment_name, equipment_type, purchase_date, purchase_price, current_value, maintenance_schedule, last_maintenance, next_maintenance, status) VALUES
( 'Delaval Milking Machine', 'Milking machine', '2023-05-15', 45000.00, 35000.00, 'Quarterly', '2026-01-10', '2026-04-10', 'Operational'),
( 'John Deere Tractor', 'Tractor', '2022-03-20', 65000.00, 52000.00, 'Bi-annual', '2025-12-05', '2026-06-05', 'Operational'),
( 'Bulk Milk Cooler', 'Cooler', '2024-01-10', 28000.00, 24000.00, 'Monthly', '2026-02-01', '2026-03-01', 'Operational'),
( 'Feed Mixer', 'Equipment', '2023-11-15', 18500.00, 15000.00, 'Quarterly', '2026-01-20', '2026-04-20', 'Under Repair'),
( 'Manure Scraper', 'Equipment', '2024-06-01', 12000.00, 10500.00, 'Monthly', '2026-02-05', '2026-03-05', 'Operational'),
( 'Generator', 'Equipment', '2022-09-10', 15000.00, 9500.00, 'Bi-annual', '2025-12-15', '2026-06-15', 'Operational');

-- Insert Breeding
INSERT INTO Breeding ( cow_id, Breeding_date, Breeding_type, Bull_id, Semen_id, Technician_name, Result, Remarks) VALUES
( 1, '2025-07-10', 'AI', NULL, 1, 'Emily Brown', 'Successful', NULL),
( 2, '2025-08-15', 'AI', NULL, 3, 'Emily Brown', 'Successful', NULL),
( 3, '2025-09-05', 'Natural', 2, NULL, 'Mike Wilson', 'Successful', NULL),
( 4, '2025-09-20', 'AI', NULL, 1, 'Anna Martinez', 'Failed', 'Repeat breeding'),
( 4, '2025-10-05', 'AI', NULL, 1, 'Anna Martinez', 'Successful', NULL),
( 5, '2025-10-12', 'AI', NULL, 1, 'Emily Brown', 'Successful', NULL),
( 6, '2025-10-28', 'AI', NULL, 4, 'Anna Martinez', 'Successful', NULL),
( 7, '2025-11-15', 'Natural', 2, NULL, 'Mike Wilson', 'Pending', NULL),
( 8, '2025-11-20', 'AI', NULL, 6, 'Emily Brown', 'Successful', NULL),
( 9, '2025-12-01', 'AI', NULL, 3, 'Anna Martinez', 'Failed', NULL),
( 9, '2025-12-15', 'AI', NULL, 3, 'Anna Martinez', 'Successful', NULL),
( 10, '2026-01-05', 'Natural', 1, NULL, 'Mike Wilson', 'Pending', NULL),
( 11, '2026-01-10', 'AI', NULL, 1, 'Emily Brown', 'Pending', NULL),
( 12, '2026-01-15', 'AI', NULL, 2, 'Anna Martinez', 'Successful', NULL);



-- Insert Pregnancy
INSERT INTO Pregnancy ( cow_id, Breeding_id, PregnancyCheckDate, ExpectedCalvingDate, ActualCalvingDate, Status, Remarks) VALUES
( 1, 1, '2025-08-10', '2026-04-15', NULL, 'Confirmed', 'Ultrasound positive'),
( 2, 2, '2025-09-15', '2026-05-20', NULL, 'Confirmed', NULL),
( 3, 3, '2025-10-05', '2026-06-10', NULL, 'Confirmed', NULL),
( 4, 5, '2025-11-05', '2026-07-12', NULL, 'Confirmed', NULL),
( 5, 6, '2025-11-15', '2026-07-20', NULL, 'Confirmed', NULL),
( 6, 7, '2025-12-01', '2026-08-05', NULL, 'Confirmed', NULL),
( 7, 8, '2025-12-15', NULL, NULL, 'Pending', 'Check scheduled'),
( 8, 9, '2025-12-20', '2026-08-28', NULL, 'Confirmed', NULL),
( 9, 11, '2026-01-15', '2026-09-22', NULL, 'Confirmed', NULL),
( 12, 14, '2026-02-12', '2026-10-20', NULL, 'Confirmed', NULL);


-- Insert 50 milk production records
INSERT INTO milk_production (cow_id, record_date, record_time, milk_liters) VALUES
-- Cow #1 - Bella (High producer)
(1, '2026-02-01', 'Morning', 14),
(1, '2026-02-01', 'Afternoon', 12),
(1, '2026-02-01', 'Evening', 10),
(1, '2026-02-02', 'Morning', 15),
(1, '2026-02-02', 'Afternoon', 12),
(1, '2026-02-02', 'Evening', 11),
(1, '2026-02-03', 'Morning', 14),
(1, '2026-02-03', 'Afternoon', 13),
(1, '2026-02-03', 'Evening', 10),
(1, '2026-02-04', 'Morning', 15),
(1, '2026-02-04', 'Afternoon', 12),
(1, '2026-02-04', 'Evening', 11),
(1, '2026-02-05', 'Morning', 14),
(1, '2026-02-05', 'Afternoon', 13),
(1, '2026-02-05', 'Evening', 11),

-- Cow #2 - Daisy (High producer)
(2, '2026-02-01', 'Morning', 16),
(2, '2026-02-01', 'Afternoon', 14),
(2, '2026-02-01', 'Evening', 12),
(2, '2026-02-02', 'Morning', 17),
(2, '2026-02-02', 'Afternoon', 14),
(2, '2026-02-02', 'Evening', 13),
(2, '2026-02-03', 'Morning', 16),
(2, '2026-02-03', 'Afternoon', 15),
(2, '2026-02-03', 'Evening', 12),
(2, '2026-02-04', 'Morning', 17),
(2, '2026-02-04', 'Afternoon', 14),
(2, '2026-02-04', 'Evening', 13),
(2, '2026-02-05', 'Morning', 16),
(2, '2026-02-05', 'Afternoon', 15),
(2, '2026-02-05', 'Evening', 13),

-- Cow #3 - Molly (Medium producer)
(3, '2026-02-01', 'Morning', 11),
(3, '2026-02-01', 'Afternoon', 9),
(3, '2026-02-01', 'Evening', 8),
(3, '2026-02-02', 'Morning', 12),
(3, '2026-02-02', 'Afternoon', 10),
(3, '2026-02-02', 'Evening', 8),
(3, '2026-02-03', 'Morning', 11),
(3, '2026-02-03', 'Afternoon', 10),
(3, '2026-02-03', 'Evening', 9),
(3, '2026-02-04', 'Morning', 12),
(3, '2026-02-04', 'Afternoon', 10),
(3, '2026-02-04', 'Evening', 8),
(3, '2026-02-05', 'Morning', 11),
(3, '2026-02-05', 'Afternoon', 9),
(3, '2026-02-05', 'Evening', 8),

-- Cow #4 - Lily (High producer)
(4, '2026-02-01', 'Morning', 17),
(4, '2026-02-01', 'Afternoon', 15),
(4, '2026-02-01', 'Evening', 13),
(4, '2026-02-02', 'Morning', 18),
(4, '2026-02-02', 'Afternoon', 15),
(4, '2026-02-02', 'Evening', 14),
(4, '2026-02-03', 'Morning', 17),
(4, '2026-02-03', 'Afternoon', 16),
(4, '2026-02-03', 'Evening', 13),
(4, '2026-02-04', 'Morning', 18),
(4, '2026-02-04', 'Afternoon', 15),
(4, '2026-02-04', 'Evening', 14),
(4, '2026-02-05', 'Morning', 17),
(4, '2026-02-05', 'Afternoon', 16),
(4, '2026-02-05', 'Evening', 14),

-- Cow #5 - Rosie (Medium producer)
(5, '2026-02-01', 'Morning', 12),
(5, '2026-02-01', 'Afternoon', 10),
(5, '2026-02-01', 'Evening', 9),
(5, '2026-02-02', 'Morning', 13),
(5, '2026-02-02', 'Afternoon', 11),
(5, '2026-02-02', 'Evening', 9),
(5, '2026-02-03', 'Morning', 12),
(5, '2026-02-03', 'Afternoon', 11),
(5, '2026-02-03', 'Evening', 10),
(5, '2026-02-04', 'Morning', 13),
(5, '2026-02-04', 'Afternoon', 11),
(5, '2026-02-04', 'Evening', 9),
(5, '2026-02-05', 'Morning', 12),
(5, '2026-02-05', 'Afternoon', 10),
(5, '2026-02-05', 'Evening', 9),

-- Cow #6 - Bessie (Dry period - low production)
(6, '2026-02-01', 'Morning', 6),
(6, '2026-02-01', 'Afternoon', 5),
(6, '2026-02-01', 'Evening', 4),
(6, '2026-02-02', 'Morning', 6),
(6, '2026-02-02', 'Afternoon', 5),
(6, '2026-02-02', 'Evening', 4),
(6, '2026-02-03', 'Morning', 5),
(6, '2026-02-03', 'Afternoon', 5),
(6, '2026-02-03', 'Evening', 4),
(6, '2026-02-04', 'Morning', 6),
(6, '2026-02-04', 'Afternoon', 5),
(6, '2026-02-04', 'Evening', 4),
(6, '2026-02-05', 'Morning', 6),
(6, '2026-02-05', 'Afternoon', 5),
(6, '2026-02-05', 'Evening', 4),

-- Cow #7 - Clover (Medium producer)
(7, '2026-02-01', 'Morning', 11),
(7, '2026-02-01', 'Afternoon', 9),
(7, '2026-02-01', 'Evening', 8),
(7, '2026-02-02', 'Morning', 12),
(7, '2026-02-02', 'Afternoon', 10),
(7, '2026-02-02', 'Evening', 8),
(7, '2026-02-03', 'Morning', 11),
(7, '2026-02-03', 'Afternoon', 9),
(7, '2026-02-03', 'Evening', 8),
(7, '2026-02-04', 'Morning', 12),
(7, '2026-02-04', 'Afternoon', 10),
(7, '2026-02-04', 'Evening', 8),
(7, '2026-02-05', 'Morning', 11),
(7, '2026-02-05', 'Afternoon', 10),
(7, '2026-02-05', 'Evening', 9),

-- Cow #8 - Maple (High producer)
(8, '2026-02-01', 'Morning', 15),
(8, '2026-02-01', 'Afternoon', 13),
(8, '2026-02-01', 'Evening', 11),
(8, '2026-02-02', 'Morning', 16),
(8, '2026-02-02', 'Afternoon', 13),
(8, '2026-02-02', 'Evening', 12),
(8, '2026-02-03', 'Morning', 15),
(8, '2026-02-03', 'Afternoon', 14),
(8, '2026-02-03', 'Evening', 11),
(8, '2026-02-04', 'Morning', 16),
(8, '2026-02-04', 'Afternoon', 13),
(8, '2026-02-04', 'Evening', 12),
(8, '2026-02-05', 'Morning', 15),
(8, '2026-02-05', 'Afternoon', 14),
(8, '2026-02-05', 'Evening', 12),

-- Cow #9 - Buttercup (First calf heifer - lower production)
(9, '2026-02-01', 'Morning', 8),
(9, '2026-02-01', 'Afternoon', 7),
(9, '2026-02-01', 'Evening', 6),
(9, '2026-02-02', 'Morning', 9),
(9, '2026-02-02', 'Afternoon', 7),
(9, '2026-02-02', 'Evening', 6),
(9, '2026-02-03', 'Morning', 8),
(9, '2026-02-03', 'Afternoon', 8),
(9, '2026-02-03', 'Evening', 6),
(9, '2026-02-04', 'Morning', 9),
(9, '2026-02-04', 'Afternoon', 7),
(9, '2026-02-04', 'Evening', 6),
(9, '2026-02-05', 'Morning', 8),
(9, '2026-02-05', 'Afternoon', 7),
(9, '2026-02-05', 'Evening', 7),

-- Cow #10 - Stella (Buffalo - different production pattern)
(10, '2026-02-01', 'Morning', 7),
(10, '2026-02-01', 'Afternoon', 6),
(10, '2026-02-01', 'Evening', 5),
(10, '2026-02-02', 'Morning', 8),
(10, '2026-02-02', 'Afternoon', 6),
(10, '2026-02-02', 'Evening', 5),
(10, '2026-02-03', 'Morning', 7),
(10, '2026-02-03', 'Afternoon', 7),
(10, '2026-02-03', 'Evening', 5),
(10, '2026-02-04', 'Morning', 8),
(10, '2026-02-04', 'Afternoon', 6),
(10, '2026-02-04', 'Evening', 5),
(10, '2026-02-05', 'Morning', 7),
(10, '2026-02-05', 'Afternoon', 6),
(10, '2026-02-05', 'Evening', 6);



-- Insert 50 milk quality test records
INSERT INTO Milk_Quality_Test (milk_id, test_date, fat_percentage, protein_percentage, snf_percentage, somatic_cell_count, temperature, tester_name, grade) VALUES
-- Cow #1 - Bella (Holstein) - Feb 1-5
(1, '2026-02-01', 3.8, 3.2, 8.5, 125000, 3.9, 'Emily Brown', 'A'),
(2, '2026-02-01', 3.7, 3.1, 8.4, 118000, 4.0, 'Emily Brown', 'A'),
(3, '2026-02-01', 3.9, 3.2, 8.6, 132000, 3.8, 'Emily Brown', 'A'),
(4, '2026-02-02', 3.8, 3.2, 8.5, 115000, 3.9, 'Anna Martinez', 'A'),
(5, '2026-02-02', 3.8, 3.1, 8.5, 122000, 4.0, 'Anna Martinez', 'A'),
(6, '2026-02-02', 3.9, 3.3, 8.7, 128000, 3.9, 'Anna Martinez', 'A'),
(7, '2026-02-03', 3.8, 3.2, 8.5, 135000, 4.0, 'Emily Brown', 'A'),
(8, '2026-02-03', 3.9, 3.3, 8.6, 142000, 3.9, 'Emily Brown', 'A'),
(9, '2026-02-03', 3.8, 3.2, 8.5, 138000, 4.0, 'Emily Brown', 'A'),
(10, '2026-02-04', 3.8, 3.2, 8.5, 121000, 3.9, 'Anna Martinez', 'A'),
(11, '2026-02-04', 3.9, 3.3, 8.7, 119000, 4.0, 'Anna Martinez', 'A'),
(12, '2026-02-04', 3.8, 3.2, 8.5, 126000, 3.9, 'Anna Martinez', 'A'),
(13, '2026-02-05', 3.9, 3.3, 8.6, 129000, 3.9, 'Emily Brown', 'A'),
(14, '2026-02-05', 3.8, 3.2, 8.5, 124000, 4.0, 'Emily Brown', 'A'),
(15, '2026-02-05', 3.9, 3.3, 8.7, 131000, 3.9, 'Emily Brown', 'A'),

-- Cow #2 - Daisy (Holstein) - Higher fat %
(16, '2026-02-01', 4.1, 3.4, 8.9, 95000, 3.9, 'Emily Brown', 'A+'),
(17, '2026-02-01', 4.0, 3.3, 8.8, 88000, 4.0, 'Emily Brown', 'A+'),
(18, '2026-02-01', 4.2, 3.4, 9.0, 92000, 3.9, 'Emily Brown', 'A+'),
(19, '2026-02-02', 4.1, 3.4, 8.9, 89000, 4.0, 'Anna Martinez', 'A+'),
(20, '2026-02-02', 4.1, 3.3, 8.9, 91000, 4.0, 'Anna Martinez', 'A+'),
(21, '2026-02-02', 4.2, 3.5, 9.1, 86000, 3.9, 'Anna Martinez', 'A+'),
(22, '2026-02-03', 4.1, 3.4, 8.9, 93000, 4.0, 'Emily Brown', 'A+'),
(23, '2026-02-03', 4.2, 3.5, 9.0, 94000, 3.9, 'Emily Brown', 'A+'),
(24, '2026-02-03', 4.1, 3.4, 8.9, 90000, 4.0, 'Emily Brown', 'A+'),
(25, '2026-02-04', 4.1, 3.4, 8.9, 87000, 3.9, 'Anna Martinez', 'A+'),
(26, '2026-02-04', 4.2, 3.5, 9.1, 89000, 4.0, 'Anna Martinez', 'A+'),
(27, '2026-02-04', 4.1, 3.4, 8.9, 91000, 3.9, 'Anna Martinez', 'A+'),
(28, '2026-02-05', 4.2, 3.5, 9.0, 85000, 4.0, 'Emily Brown', 'A+'),
(29, '2026-02-05', 4.1, 3.4, 8.9, 88000, 3.9, 'Emily Brown', 'A+'),
(30, '2026-02-05', 4.2, 3.5, 9.1, 92000, 4.0, 'Emily Brown', 'A+'),

-- Cow #3 - Molly (Jersey) - High fat %
(31, '2026-02-01', 5.2, 3.9, 9.4, 145000, 3.9, 'Emily Brown', 'A'),
(32, '2026-02-01', 5.1, 3.8, 9.3, 152000, 4.0, 'Emily Brown', 'A'),
(33, '2026-02-01', 5.3, 3.9, 9.5, 148000, 3.9, 'Emily Brown', 'A'),
(34, '2026-02-02', 5.2, 3.9, 9.4, 138000, 4.0, 'Anna Martinez', 'A'),
(35, '2026-02-02', 5.2, 3.8, 9.4, 142000, 3.9, 'Anna Martinez', 'A'),
(36, '2026-02-02', 5.3, 4.0, 9.6, 135000, 4.0, 'Anna Martinez', 'A'),
(37, '2026-02-03', 5.2, 3.9, 9.4, 149000, 3.9, 'Emily Brown', 'A'),
(38, '2026-02-03', 5.3, 4.0, 9.5, 155000, 4.0, 'Emily Brown', 'A'),
(39, '2026-02-03', 5.2, 3.9, 9.4, 151000, 3.9, 'Emily Brown', 'A'),
(40, '2026-02-04', 5.2, 3.9, 9.4, 141000, 4.0, 'Anna Martinez', 'A'),
(41, '2026-02-04', 5.3, 4.0, 9.6, 144000, 3.9, 'Anna Martinez', 'A'),
(42, '2026-02-04', 5.2, 3.9, 9.4, 147000, 4.0, 'Anna Martinez', 'A'),
(43, '2026-02-05', 5.3, 4.0, 9.5, 139000, 3.9, 'Emily Brown', 'A'),
(44, '2026-02-05', 5.2, 3.9, 9.4, 143000, 4.0, 'Emily Brown', 'A'),
(45, '2026-02-05', 5.3, 4.0, 9.6, 146000, 3.9, 'Emily Brown', 'A'),

-- Cow #4 - Lily (Holstein) - Some elevated SCC (mild infection)
(46, '2026-02-01', 3.9, 3.3, 8.7, 210000, 4.0, 'Emily Brown', 'B'),
(47, '2026-02-01', 3.8, 3.2, 8.6, 198000, 4.0, 'Emily Brown', 'B'),
(48, '2026-02-01', 3.9, 3.3, 8.7, 225000, 3.9, 'Emily Brown', 'B'),
(49, '2026-02-02', 3.9, 3.3, 8.7, 205000, 4.0, 'Anna Martinez', 'B'),
(50, '2026-02-02', 3.8, 3.2, 8.6, 215000, 3.9, 'Anna Martinez', 'B');


-- Insert 50 feed consumption records
INSERT INTO feed_consumption (cow_id, feed_id, feed_date, quantity_kg) VALUES
-- Cow #1 - Bella (High producer - Milking cow) - Feb 1-5
-- Using High Production Lactation formula: Corn Silage, Alfalfa Hay, Concentrate, Minerals
(1, 1, '2026-02-01', 10.0), -- Corn Silage
(1, 2, '2026-02-01', 5.0),  -- Alfalfa Hay
(1, 3, '2026-02-01', 7.5),  -- Dairy Concentrate
(1, 8, '2026-02-01', 0.5),  -- Mineral Mixture
(1, 1, '2026-02-02', 10.5), -- Corn Silage (slightly more)
(1, 2, '2026-02-02', 5.0),  -- Alfalfa Hay
(1, 3, '2026-02-02', 7.5),  -- Dairy Concentrate
(1, 8, '2026-02-02', 0.5),  -- Mineral Mixture
(1, 1, '2026-02-03', 10.0), -- Corn Silage
(1, 2, '2026-02-03', 5.5),  -- Alfalfa Hay (slightly more)
(1, 3, '2026-02-03', 8.0),  -- Dairy Concentrate (more for production)
(1, 8, '2026-02-03', 0.5),  -- Mineral Mixture
(1, 1, '2026-02-04', 10.0), -- Corn Silage
(1, 2, '2026-02-04', 5.0),  -- Alfalfa Hay
(1, 3, '2026-02-04', 7.5),  -- Dairy Concentrate
(1, 8, '2026-02-04', 0.5),  -- Mineral Mixture
(1, 1, '2026-02-05', 10.5), -- Corn Silage
(1, 2, '2026-02-05', 5.0),  -- Alfalfa Hay
(1, 3, '2026-02-05', 8.0),  -- Dairy Concentrate
(1, 8, '2026-02-05', 0.5),  -- Mineral Mixture

-- Cow #2 - Daisy (High producer) - Feb 1-5
(2, 1, '2026-02-01', 11.0), -- Corn Silage (eats more)
(2, 2, '2026-02-01', 5.5),  -- Alfalfa Hay
(2, 3, '2026-02-01', 8.0),  -- Dairy Concentrate
(2, 8, '2026-02-01', 0.5),  -- Mineral Mixture
(2, 1, '2026-02-02', 11.0), -- Corn Silage
(2, 2, '2026-02-02', 5.5),  -- Alfalfa Hay
(2, 3, '2026-02-02', 8.5),  -- Dairy Concentrate
(2, 8, '2026-02-02', 0.5),  -- Mineral Mixture
(2, 1, '2026-02-03', 11.5), -- Corn Silage
(2, 2, '2026-02-03', 5.5),  -- Alfalfa Hay
(2, 3, '2026-02-03', 8.5),  -- Dairy Concentrate
(2, 8, '2026-02-03', 0.5),  -- Mineral Mixture
(2, 1, '2026-02-04', 11.0), -- Corn Silage
(2, 2, '2026-02-04', 5.0),  -- Alfalfa Hay
(2, 3, '2026-02-04', 8.0),  -- Dairy Concentrate
(2, 8, '2026-02-04', 0.5),  -- Mineral Mixture
(2, 1, '2026-02-05', 11.0), -- Corn Silage
(2, 2, '2026-02-05', 5.5),  -- Alfalfa Hay
(2, 3, '2026-02-05', 8.5),  -- Dairy Concentrate
(2, 8, '2026-02-05', 0.5),  -- Mineral Mixture

-- Cow #3 - Molly (Jersey - Medium producer) - Feb 1-5
-- Jerseys eat less but need quality feed
(3, 1, '2026-02-01', 8.0),  -- Corn Silage
(3, 2, '2026-02-01', 4.0),  -- Alfalfa Hay
(3, 3, '2026-02-01', 5.0),  -- Dairy Concentrate
(3, 8, '2026-02-01', 0.4),  -- Mineral Mixture
(3, 1, '2026-02-02', 8.5),  -- Corn Silage
(3, 2, '2026-02-02', 4.0),  -- Alfalfa Hay
(3, 3, '2026-02-02', 5.0),  -- Dairy Concentrate
(3, 8, '2026-02-02', 0.4),  -- Mineral Mixture
(3, 1, '2026-02-03', 8.0),  -- Corn Silage
(3, 2, '2026-02-03', 4.5),  -- Alfalfa Hay
(3, 3, '2026-02-03', 5.5),  -- Dairy Concentrate
(3, 8, '2026-02-03', 0.4),  -- Mineral Mixture
(3, 1, '2026-02-04', 8.0),  -- Corn Silage
(3, 2, '2026-02-04', 4.0),  -- Alfalfa Hay
(3, 3, '2026-02-04', 5.0),  -- Dairy Concentrate
(3, 8, '2026-02-04', 0.4),  -- Mineral Mixture
(3, 1, '2026-02-05', 8.5),  -- Corn Silage
(3, 2, '2026-02-05', 4.0),  -- Alfalfa Hay
(3, 3, '2026-02-05', 5.0),  -- Dairy Concentrate
(3, 8, '2026-02-05', 0.4),  -- Mineral Mixture

-- Cow #4 - Lily (High producer) - Feb 1-5
(4, 1, '2026-02-01', 12.0), -- Corn Silage (very high intake)
(4, 2, '2026-02-01', 6.0),  -- Alfalfa Hay
(4, 3, '2026-02-01', 9.0),  -- Dairy Concentrate
(4, 8, '2026-02-01', 0.6),  -- Mineral Mixture
(4, 1, '2026-02-02', 12.0), -- Corn Silage
(4, 2, '2026-02-02', 6.0),  -- Alfalfa Hay
(4, 3, '2026-02-02', 9.5),  -- Dairy Concentrate
(4, 8, '2026-02-02', 0.6),  -- Mineral Mixture
(4, 1, '2026-02-03', 12.5), -- Corn Silage
(4, 2, '2026-02-03', 6.0),  -- Alfalfa Hay
(4, 3, '2026-02-03', 9.5),  -- Dairy Concentrate
(4, 8, '2026-02-03', 0.6),  -- Mineral Mixture
(4, 1, '2026-02-04', 12.0), -- Corn Silage
(4, 2, '2026-02-04', 6.5),  -- Alfalfa Hay
(4, 3, '2026-02-04', 9.0),  -- Dairy Concentrate
(4, 8, '2026-02-04', 0.6),  -- Mineral Mixture
(4, 1, '2026-02-05', 12.0), -- Corn Silage
(4, 2, '2026-02-05', 6.0),  -- Alfalfa Hay
(4, 3, '2026-02-05', 9.5),  -- Dairy Concentrate
(4, 8, '2026-02-05', 0.6),  -- Mineral Mixture

-- Cow #5 - Rosie (Ayrshire - Medium producer) - Feb 1-5
(5, 1, '2026-02-01', 9.0),  -- Corn Silage
(5, 2, '2026-02-01', 4.5),  -- Alfalfa Hay
(5, 3, '2026-02-01', 6.0),  -- Dairy Concentrate
(5, 8, '2026-02-01', 0.4),  -- Mineral Mixture
(5, 1, '2026-02-02', 9.5),  -- Corn Silage
(5, 2, '2026-02-02', 4.5),  -- Alfalfa Hay
(5, 3, '2026-02-02', 6.0),  -- Dairy Concentrate
(5, 8, '2026-02-02', 0.4),  -- Mineral Mixture
(5, 1, '2026-02-03', 9.0),  -- Corn Silage
(5, 2, '2026-02-03', 5.0),  -- Alfalfa Hay
(5, 3, '2026-02-03', 6.5),  -- Dairy Concentrate
(5, 8, '2026-02-03', 0.4),  -- Mineral Mixture
(5, 1, '2026-02-04', 9.0),  -- Corn Silage
(5, 2, '2026-02-04', 4.5),  -- Alfalfa Hay
(5, 3, '2026-02-04', 6.0),  -- Dairy Concentrate
(5, 8, '2026-02-04', 0.4),  -- Mineral Mixture
(5, 1, '2026-02-05', 9.5),  -- Corn Silage
(5, 2, '2026-02-05', 4.5),  -- Alfalfa Hay
(5, 3, '2026-02-05', 6.0),  -- Dairy Concentrate
(5, 8, '2026-02-05', 0.4),  -- Mineral Mixture

-- Cow #6 - Bessie (Dry cow) - Different feed formula
-- Dry cows get more roughage, less concentrate
(6, 1, '2026-02-01', 8.0),  -- Corn Silage
(6, 6, '2026-02-01', 3.0),  -- Wheat Straw
(6, 2, '2026-02-01', 2.0),  -- Alfalfa Hay
(6, 8, '2026-02-01', 0.2),  -- Mineral Mixture
(6, 1, '2026-02-02', 8.0),  -- Corn Silage
(6, 6, '2026-02-02', 3.0),  -- Wheat Straw
(6, 2, '2026-02-02', 2.0),  -- Alfalfa Hay
(6, 8, '2026-02-02', 0.2),  -- Mineral Mixture
(6, 1, '2026-02-03', 8.5),  -- Corn Silage
(6, 6, '2026-02-03', 3.0),  -- Wheat Straw
(6, 2, '2026-02-03', 2.0),  -- Alfalfa Hay
(6, 8, '2026-02-03', 0.2),  -- Mineral Mixture
(6, 1, '2026-02-04', 8.0),  -- Corn Silage
(6, 6, '2026-02-04', 3.5),  -- Wheat Straw (more fiber)
(6, 2, '2026-02-04', 1.5),  -- Alfalfa Hay
(6, 8, '2026-02-04', 0.2),  -- Mineral Mixture
(6, 1, '2026-02-05', 8.0),  -- Corn Silage
(6, 6, '2026-02-05', 3.0),  -- Wheat Straw
(6, 2, '2026-02-05', 2.0),  -- Alfalfa Hay
(6, 8, '2026-02-05', 0.2),  -- Mineral Mixture

-- Cow #7 - Clover (Jersey - Medium) - Feb 1-5
(7, 1, '2026-02-01', 8.5),  -- Corn Silage
(7, 2, '2026-02-01', 4.0),  -- Alfalfa Hay
(7, 3, '2026-02-01', 5.5),  -- Dairy Concentrate
(7, 8, '2026-02-01', 0.4),  -- Mineral Mixture
(7, 1, '2026-02-02', 8.5),  -- Corn Silage
(7, 2, '2026-02-02', 4.0),  -- Alfalfa Hay
(7, 3, '2026-02-02', 5.5),  -- Dairy Concentrate
(7, 8, '2026-02-02', 0.4),  -- Mineral Mixture
(7, 1, '2026-02-03', 8.0),  -- Corn Silage
(7, 2, '2026-02-03', 4.5),  -- Alfalfa Hay
(7, 3, '2026-02-03', 5.5),  -- Dairy Concentrate
(7, 8, '2026-02-03', 0.4),  -- Mineral Mixture
(7, 1, '2026-02-04', 8.5),  -- Corn Silage
(7, 2, '2026-02-04', 4.0),  -- Alfalfa Hay
(7, 3, '2026-02-04', 5.0),  -- Dairy Concentrate
(7, 8, '2026-02-04', 0.4),  -- Mineral Mixture
(7, 1, '2026-02-05', 9.0),  -- Corn Silage
(7, 2, '2026-02-05', 4.0),  -- Alfalfa Hay
(7, 3, '2026-02-05', 5.5),  -- Dairy Concentrate
(7, 8, '2026-02-05', 0.4),  -- Mineral Mixture

-- Cow #8 - Maple (Brown Swiss - High producer) - Feb 1-5
(8, 1, '2026-02-01', 11.0), -- Corn Silage
(8, 2, '2026-02-01', 5.5),  -- Alfalfa Hay
(8, 3, '2026-02-01', 8.0),  -- Dairy Concentrate
(8, 8, '2026-02-01', 0.5),  -- Mineral Mixture
(8, 1, '2026-02-02', 11.5), -- Corn Silage
(8, 2, '2026-02-02', 5.5),  -- Alfalfa Hay
(8, 3, '2026-02-02', 8.0),  -- Dairy Concentrate
(8, 8, '2026-02-02', 0.5),  -- Mineral Mixture
(8, 1, '2026-02-03', 11.0), -- Corn Silage
(8, 2, '2026-02-03', 6.0),  -- Alfalfa Hay
(8, 3, '2026-02-03', 8.5),  -- Dairy Concentrate
(8, 8, '2026-02-03', 0.5),  -- Mineral Mixture
(8, 1, '2026-02-04', 11.0), -- Corn Silage
(8, 2, '2026-02-04', 5.5),  -- Alfalfa Hay
(8, 3, '2026-02-04', 8.0),  -- Dairy Concentrate
(8, 8, '2026-02-04', 0.5),  -- Mineral Mixture
(8, 1, '2026-02-05', 11.5), -- Corn Silage
(8, 2, '2026-02-05', 5.5),  -- Alfalfa Hay
(8, 3, '2026-02-05', 8.0),  -- Dairy Concentrate
(8, 8, '2026-02-05', 0.5),  -- Mineral Mixture

-- Cow #9 - Buttercup (First calf heifer) - Feb 1-5
(9, 1, '2026-02-01', 7.0),  -- Corn Silage
(9, 2, '2026-02-01', 3.5),  -- Alfalfa Hay
(9, 3, '2026-02-01', 5.0),  -- Dairy Concentrate
(9, 8, '2026-02-01', 0.3),  -- Mineral Mixture
(9, 1, '2026-02-02', 7.5),  -- Corn Silage
(9, 2, '2026-02-02', 3.5),  -- Alfalfa Hay
(9, 3, '2026-02-02', 5.0),  -- Dairy Concentrate
(9, 8, '2026-02-02', 0.3),  -- Mineral Mixture
(9, 1, '2026-02-03', 7.0),  -- Corn Silage
(9, 2, '2026-02-03', 4.0),  -- Alfalfa Hay
(9, 3, '2026-02-03', 5.0),  -- Dairy Concentrate
(9, 8, '2026-02-03', 0.3),  -- Mineral Mixture
(9, 1, '2026-02-04', 7.0),  -- Corn Silage
(9, 2, '2026-02-04', 3.5),  -- Alfalfa Hay
(9, 3, '2026-02-04', 5.5),  -- Dairy Concentrate
(9, 8, '2026-02-04', 0.3),  -- Mineral Mixture
(9, 1, '2026-02-05', 7.5),  -- Corn Silage
(9, 2, '2026-02-05', 3.5),  -- Alfalfa Hay
(9, 3, '2026-02-05', 5.0),  -- Dairy Concentrate
(9, 8, '2026-02-05', 0.3),  -- Mineral Mixture

-- Cow #10 - Stella (Buffalo) - Different feeding pattern
(10, 1, '2026-02-01', 9.0),  -- Corn Silage
(10, 2, '2026-02-01', 4.0),  -- Alfalfa Hay
(10, 4, '2026-02-01', 2.0),  -- Soybean Meal (extra protein for buffalo)
(10, 8, '2026-02-01', 0.4),  -- Mineral Mixture
(10, 1, '2026-02-02', 9.0),  -- Corn Silage
(10, 2, '2026-02-02', 4.0),  -- Alfalfa Hay
(10, 4, '2026-02-02', 2.0),  -- Soybean Meal
(10, 8, '2026-02-02', 0.4),  -- Mineral Mixture
(10, 1, '2026-02-03', 9.5),  -- Corn Silage
(10, 2, '2026-02-03', 4.0),  -- Alfalfa Hay
(10, 4, '2026-02-03', 2.0),  -- Soybean Meal
(10, 8, '2026-02-03', 0.4),  -- Mineral Mixture
(10, 1, '2026-02-04', 9.0),  -- Corn Silage
(10, 2, '2026-02-04', 4.5),  -- Alfalfa Hay
(10, 4, '2026-02-04', 2.0),  -- Soybean Meal
(10, 8, '2026-02-04', 0.4),  -- Mineral Mixture
(10, 1, '2026-02-05', 9.0),  -- Corn Silage
(10, 2, '2026-02-05', 4.0),  -- Alfalfa Hay
(10, 4, '2026-02-05', 2.5),  -- Soybean Meal (extra)
(10, 8, '2026-02-05', 0.4);  -- Mineral Mixture


-- Insert 50 health record entries
INSERT INTO health_record (cow_id, disease_name, treatment, medicine_cost, visit_date, recovery_status) VALUES
-- Mastitis cases (most common)
(1, 'Clinical Mastitis', 'Cloxacillin intramammary 3 doses', 45.50, '2025-09-10', 'Recovered'),
(2, 'Subclinical Mastitis', 'Cephalexin treatment + supportive therapy', 38.75, '2025-09-15', 'Recovered'),
(4, 'Clinical Mastitis', 'Penicillin G + anti-inflammatory', 52.30, '2025-09-22', 'Recovered'),
(7, 'Mastitis - E. coli', 'Antibiotics + fluid therapy', 65.00, '2025-10-05', 'Recovered'),
(11, 'Chronic Mastitis', 'Extended antibiotic therapy + culling decision', 120.50, '2025-10-12', 'Chronic'),
(3, 'Mastitis - Staph', 'Cloxacillin + supportive care', 48.20, '2025-10-18', 'Recovered'),
(8, 'Clinical Mastitis', 'Intramammary antibiotics 3 days', 42.80, '2025-10-25', 'Recovered'),
(5, 'Mastitis', 'Ceftiofur treatment', 55.00, '2025-11-02', 'Recovered'),
(12, 'Subclinical Mastitis', 'Dry cow therapy', 36.50, '2025-11-08', 'Recovered'),
(15, 'Clinical Mastitis', 'Cloxacillin + supportive', 47.90, '2025-11-15', 'Recovered'),
(2, 'Mastitis - Recurrent', 'Extended therapy + culture', 78.30, '2025-12-01', 'Recovered'),
(6, 'Clinical Mastitis', 'Antibiotic therapy', 44.50, '2025-12-10', 'Recovered'),

-- Lameness/Foot problems
(3, 'Foot Rot', 'Hoof trimming + topical antibiotic + bandage', 35.00, '2025-08-20', 'Recovered'),
(9, 'Sole Ulcer', 'Hoof block + antibiotics + pain relief', 58.50, '2025-09-05', 'Recovered'),
(14, 'Digital Dermatitis', 'Topical treatment + footbath', 28.75, '2025-09-18', 'Recovered'),
(5, 'Foot Rot', 'Systemic antibiotics + hoof care', 42.30, '2025-10-08', 'Recovered'),
(10, 'Laminitis', 'Anti-inflammatories + dietary change', 65.00, '2025-10-22', 'Recovered'),
(13, 'Heel Horn Erosion', 'Hoof trimming + topical treatment', 32.50, '2025-11-12', 'Recovered'),
(1, 'Foot Abscess', 'Drainage + antibiotics + bandage', 48.00, '2025-11-28', 'Recovered'),
(7, 'Digital Dermatitis', 'Footbath + topical oxytetracycline', 25.80, '2025-12-15', 'Recovered'),
(16, 'Foot Rot', 'Antibiotics + hoof block', 38.50, '2026-01-05', 'Recovered'),

-- Metabolic disorders
(4, 'Milk Fever (Hypocalcemia)', 'Calcium borogluconate IV + oral calcium', 85.00, '2025-08-12', 'Recovered'),
(11, 'Ketosis', 'Propylene glycol drench + IV dextrose', 72.50, '2025-09-08', 'Recovered'),
(2, 'Milk Fever', 'Calcium IV + supportive care', 78.00, '2025-09-25', 'Recovered'),
(8, 'Ketosis', 'Propylene glycol + B vitamins', 65.30, '2025-10-15', 'Recovered'),
(15, 'Hypomagnesemia', 'Magnesium IV + oral supplementation', 58.00, '2025-11-03', 'Recovered'),
(5, 'Milk Fever', 'Calcium treatment', 82.50, '2025-11-20', 'Recovered'),
(12, 'Ketosis', 'Energy supplements + dietary adjustment', 55.00, '2025-12-05', 'Recovered'),
(3, 'Fatty Liver', 'Supportive therapy + nutritional management', 95.00, '2025-12-18', 'Recovered'),

-- Respiratory issues
(6, 'Pneumonia', 'Oxytetracycline + anti-inflammatory', 62.00, '2025-08-25', 'Recovered'),
(9, 'BRD (Bovine Respiratory)', 'Tulathromycin + supportive care', 88.50, '2025-09-14', 'Recovered'),
(13, 'Pneumonia', 'Antibiotics + nebulization', 70.00, '2025-10-10', 'Recovered'),
(17, 'Respiratory Infection', 'Florfenicol treatment', 68.00, '2025-10-28', 'Recovered'),
(2, 'Pneumonia', 'Enrofloxacin + supportive', 75.50, '2025-11-15', 'Recovered'),
(8, 'BRD', 'Antibiotic therapy + vitamins', 82.00, '2025-12-08', 'Recovered'),
(14, 'Respiratory Infection', 'Treatment with tulathromycin', 72.80, '2026-01-12', 'Recovered'),

-- Reproductive issues
(4, 'Metritis', 'Intrauterine antibiotics + prostaglandin', 95.00, '2025-08-30', 'Recovered'),
(7, 'Retained Placenta', 'Manual removal + antibiotics', 68.50, '2025-09-20', 'Recovered'),
(11, 'Pyometra', 'Prostaglandin + antibiotic therapy', 105.00, '2025-10-08', 'Recovered'),
(1, 'Metritis', 'Antibiotics + supportive care', 82.00, '2025-10-25', 'Recovered'),
(5, 'Cystic Ovaries', 'GnRH + PGF2α protocol', 120.00, '2025-11-12', 'Recovered'),
(9, 'Metritis', 'Intrauterine treatment', 78.50, '2025-11-30', 'Recovered'),
(15, 'Retained Placenta', 'Manual removal + antibiotics', 72.00, '2025-12-15', 'Recovered'),
(3, 'Repeat Breeder', 'Hormonal therapy + breeding management', 150.00, '2026-01-08', 'Under Treatment'),

-- Digestive issues
(10, 'Indigestion/Atony', 'Rumen tonics + probiotics', 35.00, '2025-09-12', 'Recovered'),
(12, 'Bloat', 'Rumenotomy + antifoaming agents', 210.00, '2025-10-18', 'Recovered'),
(6, 'Diarrhea', 'Fluids + antibiotics + probiotics', 48.50, '2025-11-05', 'Recovered'),
(16, 'Acidosis', 'Rumen buffer + dietary adjustment', 62.00, '2025-11-22', 'Recovered'),
(8, 'Indigestion', 'Rumen transfauination + supportive', 45.00, '2025-12-12', 'Recovered'),
(13, 'Bloat - Chronic', 'Management changes + anti-bloat', 85.00, '2026-01-15', 'Recovered'),

-- Injuries/Trauma
(2, 'Traumatic Reticulitis', 'Magnet administration + antibiotics', 95.50, '2025-08-18', 'Recovered'),
(7, 'Leg Injury', 'Wound care + antibiotics + rest', 52.00, '2025-09-28', 'Recovered'),
(14, 'Eye Injury', 'Topical antibiotics + atropine', 38.00, '2025-10-20', 'Recovered'),
(4, 'Horn Injury', 'Debridement + antibiotics', 42.50, '2025-11-18', 'Recovered'),
(9, 'Skin Laceration', 'Suturing + antibiotics', 65.00, '2025-12-22', 'Recovered'),
(11, 'Udder Injury', 'Cold therapy + anti-inflammatories', 48.00, '2026-01-20', 'Recovered'),

-- Parasitic issues
(5, 'External Parasites (Lice)', 'Ivermectin pour-on', 28.00, '2025-08-05', 'Recovered'),
(8, 'Internal Parasites', 'Fenbendazole treatment', 32.50, '2025-09-08', 'Recovered'),
(13, 'Mange', 'Amitraz treatment + environmental spray', 45.00, '2025-10-15', 'Recovered'),
(1, 'Coccidiosis', 'Amprolium treatment', 36.00, '2025-11-10', 'Recovered'),
(17, 'Internal Parasites', 'Ivermectin + albendazole', 42.00, '2025-12-05', 'Recovered'),
(6, 'External Parasites', 'Pour-on treatment', 28.50, '2026-01-18', 'Recovered'),

-- Other conditions
(3, 'Eye Cancer (SCC)', 'Surgical removal', 350.00, '2025-08-22', 'Recovered'),
(10, 'Actinomycosis (Lumpy Jaw)', 'Sodium iodide IV + antibiotics', 185.00, '2025-09-25', 'Recovered'),
(15, 'Ringworm', 'Topical antifungal treatment', 25.00, '2025-10-28', 'Recovered'),
(12, 'Vitamin Deficiency', 'Vitamin ADE injection', 22.50, '2025-11-15', 'Recovered'),
(7, 'Allergic Reaction', 'Antihistamines + steroids', 38.00, '2025-12-20', 'Recovered'),
(4, 'Dehydration', 'IV fluids + electrolytes', 45.00, '2026-01-25', 'Recovered');


-- Insert 20 vaccination records
INSERT INTO Vaccination (cow_id, bull_id, vaccine_name, vaccination_date, next_due_date, administered_by, remarks) VALUES
-- Adult Cow Vaccinations (Core vaccines)
(1, NULL, 'BVD (Bovine Viral Diarrhea) - Modified Live', '2025-06-15', '2026-06-15', 2, 'Annual booster - Holstein cow #1'),
(2, NULL, 'IBR (Infectious Bovine Rhinotracheitis)', '2025-06-15', '2026-06-15', 2, 'Annual - part of respiratory protocol'),
(3, NULL, 'PI3 (Parainfluenza-3)', '2025-06-20', '2026-06-20', 6, 'Combination vaccine'),
(4, NULL, 'BRSV (Bovine Respiratory Syncytial Virus)', '2025-06-20', '2026-06-20', 6, 'Fall booster schedule'),
(5, NULL, 'Leptospirosis 5-way', '2025-07-01', '2026-07-01', 2, 'Pre-breeding vaccination'),
(6, NULL, 'Clostridial 7-way (CD&T)', '2025-07-05', '2026-07-05', 2, 'Routine annual'),
(7, NULL, 'BVD/IBR/PI3/BRSV Combo', '2025-07-10', '2026-07-10', 6, 'Modified live vaccine'),
(8, NULL, 'Leptospirosis 5-way', '2025-07-15', '2026-07-15', 2, 'Pre-breeding - important for reproduction'),
(9, NULL, 'Clostridial 7-way', '2025-07-20', '2026-07-20', 6, 'Booster'),
(10, NULL, 'IBR/BVD Combo', '2025-08-01', '2026-08-01', 2, 'Annual vaccination'),

-- Calf Vaccinations (series)
(11, NULL, 'Clostridial 7-way - Calf', '2025-09-10', '2025-10-10', 6, 'First dose - calf #11'),
(11, NULL, 'Clostridial 7-way - Booster', '2025-10-10', '2026-10-10', 6, 'Second dose - booster'),
(12, NULL, 'IBR/PI3 Intranasal', '2025-09-15', '2025-10-15', 2, 'Calf respiratory protection'),
(12, NULL, 'IBR/PI3 Booster', '2025-10-15', '2026-10-15', 2, 'Follow-up dose'),
(13, NULL, 'BVD Modified Live - Calf', '2025-10-05', '2026-04-05', 6, 'First BVD vaccination'),
(14, NULL, 'Leptospirosis - Heifer', '2025-10-20', '2026-04-20', 2, 'Pre-breeding preparation'),
(15, NULL, 'Clostridial 7-way - Calf', '2025-11-01', '2025-12-01', 6, 'First dose'),
(15, NULL, 'Clostridial 7-way - Booster', '2025-12-01', '2026-12-01', 6, 'Booster completed'),
(16, NULL, 'IBR/PI3 Intranasal', '2025-11-10', '2025-12-10', 2, 'Calf #16 - new born'),
(16, NULL, 'IBR/PI3 Booster', '2025-12-10', '2026-12-10', 2, 'Booster completed'),

-- Bull Vaccinations
(NULL, 1, 'BVD/IBR/PI3/BRSV Combo', '2025-05-10', '2026-05-10', 2, 'Bull #1 - Thunder'),
(NULL, 1, 'Leptospirosis 5-way', '2025-05-10', '2026-05-10', 2, 'Bull #1 - important for fertility'),
(NULL, 2, 'Clostridial 7-way', '2025-06-01', '2026-06-01', 6, 'Bull #2 - Lightning'),
(NULL, 3, 'BVD/IBR Combo', '2025-06-15', '2026-06-15', 2, 'Bull #3 - Ace'),

-- Additional Cow Vaccinations (boosters and special vaccines)
(1, NULL, 'Leptospirosis 5-way', '2025-12-01', '2026-12-01', 2, 'Fall booster for cow #1'),
(3, NULL, 'E. coli Mastitis Vaccine', '2025-08-15', '2025-09-15', 6, 'Mastitis prevention - dose 1'),
(3, NULL, 'E. coli Mastitis Vaccine', '2025-09-15', '2026-03-15', 6, 'Mastitis prevention - dose 2'),
(5, NULL, 'Rotavirus/Coronavirus - Calf scours', '2025-10-01', '2025-11-01', 2, 'Pre-calving - dose 1'),
(5, NULL, 'Rotavirus/Coronavirus - Calf scours', '2025-11-01', '2026-05-01', 2, 'Pre-calving - dose 2'),
(7, NULL, 'Staph aureus Mastitis Vaccine', '2025-09-20', '2025-10-20', 6, 'Mastitis control program'),
(7, NULL, 'Staph aureus Mastitis Vaccine', '2025-10-20', '2026-04-20', 6, 'Booster'),
(8, NULL, 'Rabies', '2025-07-15', '2026-07-15', 2, 'Required for show animals'),
(9, NULL, 'Anthrax', '2025-08-01', '2026-08-01', 6, 'Endemic area precaution'),

-- Recent vaccinations (2026)
(2, NULL, 'BVD/IBR Booster', '2026-01-10', '2027-01-10', 2, 'Early 2026 booster'),
(4, NULL, 'Leptospirosis', '2026-01-15', '2027-01-15', 6, 'Pre-breeding'),
(6, NULL, 'Clostridial 7-way', '2026-01-20', '2027-01-20', 2, 'Annual'),
(10, NULL, 'IBR/PI3/BRSV', '2026-01-25', '2027-01-25', 6, 'Respiratory protection'),
(11, NULL, 'BVD Booster', '2026-02-01', '2027-02-01', 2, 'Annual for cow #11'),
(13, NULL, 'Leptospirosis', '2026-02-05', '2027-02-05', 6, 'Pre-breeding'),
(15, NULL, 'Clostridial Booster', '2026-02-10', '2027-02-10', 2, 'Annual'),
(17, NULL, 'IBR/PI3 Intranasal', '2026-02-12', '2026-03-12', 6, 'New calf'),
(17, NULL, 'IBR/PI3 Booster', '2026-03-12', '2027-03-12', 6, 'Follow-up'),
(NULL, 4, 'BVD/IBR Combo', '2026-01-05', '2027-01-05', 2, 'Bull #4 - King'),
(NULL, 5, 'Leptospirosis', '2026-01-08', '2027-01-08', 6, 'Bull #5 - Major');




-- Insert 30 medicine stock records
INSERT INTO Medicine_Stock (medicine_id, batch_number, bottle_size_ml, quantity_in_stock, unit_price, expiry_date, received_date, storage_condition, remarks) VALUES
-- Antibiotics
(1, 'OXY-2425-01', 100, 15, 24.50, '2026-06-15', '2025-12-10', 'Room Temperature', 'First-line antibiotic'),
(1, 'OXY-2425-02', 100, 8, 24.50, '2026-08-20', '2026-01-15', 'Room Temperature', 'New batch'),
(1, 'OXY-2425-03', 250, 10, 52.00, '2026-09-10', '2026-02-01', 'Room Temperature', 'Bulk size'),
(2, 'IVM-2501-A', 500, 5, 45.00, '2026-12-01', '2026-01-05', 'Room Temperature', 'Pour-on dewormer'),
(2, 'IVM-2502-B', 1000, 3, 82.50, '2027-01-15', '2026-01-20', 'Room Temperature', 'Bulk pack - livestock'),
(3, 'LAC-2401', 50, 12, 65.00, '2025-12-15', '2025-10-01', 'Refrigerated', 'EXPIRING SOON - use by Dec 2025'),
(3, 'LAC-2402', 50, 20, 65.00, '2026-05-20', '2025-11-15', 'Refrigerated', 'Lactation booster'),
(4, 'CAL-2501', 500, 25, 18.50, '2027-02-28', '2026-01-10', 'Room Temperature', 'Calcium for milk fever'),
(4, 'CAL-2502', 500, 18, 18.75, '2027-03-15', '2026-02-05', 'Room Temperature', 'New stock'),
(4, 'CAL-2503', 1000, 10, 32.00, '2027-04-01', '2026-02-15', 'Room Temperature', 'Bulk IV solution'),
(5, 'PEN-2501', 100, 12, 22.00, '2026-07-30', '2025-12-05', 'Refrigerated', 'Penicillin G'),
(5, 'PEN-2502', 100, 8, 22.50, '2026-09-15', '2026-01-12', 'Refrigerated', 'Fresh batch'),
(5, 'PEN-2503', 250, 6, 48.00, '2026-10-20', '2026-02-08', 'Refrigerated', 'Multi-dose vial'),
(6, 'VIT-2405', 250, 20, 14.50, '2026-04-10', '2025-10-20', 'Room Temperature', 'Multivitamin - ADE'),
(6, 'VIT-2406', 250, 15, 15.00, '2026-05-15', '2025-11-25', 'Room Temperature', 'B-complex'),
(6, 'VIT-2501', 500, 12, 26.00, '2026-08-01', '2026-01-18', 'Room Temperature', 'Injectable vitamins'),
(7, 'CLO-2403', 50, 4, 35.00, '2026-02-28', '2025-10-15', 'Refrigerated', 'LOW STOCK - mastitis treatment'),
(7, 'CLO-2501', 50, 15, 36.50, '2026-06-30', '2026-01-22', 'Refrigerated', 'New batch - cloxacillin'),
(7, 'CLO-2502', 100, 8, 62.00, '2026-07-15', '2026-02-10', 'Refrigerated', 'Economy size'),
(8, 'VSE-2402', 100, 18, 27.50, '2026-03-20', '2025-11-08', 'Refrigerated', 'Vitamin E/Selenium'),
(8, 'VSE-2501', 100, 22, 28.50, '2026-09-10', '2026-01-25', 'Refrigerated', 'White muscle disease prevention'),
(8, 'VSE-2502', 250, 10, 58.00, '2026-10-05', '2026-02-12', 'Refrigerated', 'Bulk pack'),

-- Additional medicines (assuming medicine_id 9-15 exist)
(9, 'FLU-2404', 100, 8, 32.00, '2026-01-15', '2025-09-15', 'Room Temperature', 'Flunixin - EXPIRED'),
(9, 'FLU-2501', 100, 20, 34.50, '2026-08-20', '2026-01-05', 'Room Temperature', 'Anti-inflammatory'),
(10, 'DEX-2501', 50, 15, 22.00, '2026-11-10', '2026-01-30', 'Room Temperature', 'Dexamethasone'),
(11, 'KET-2501', 100, 12, 42.00, '2026-09-25', '2026-02-01', 'Room Temperature', 'Ketoprofen'),
(12, 'TET-2420', 250, 6, 38.50, '2026-03-01', '2025-10-25', 'Room Temperature', 'Tetracycline - expiring'),
(12, 'TET-2501', 250, 18, 40.00, '2026-12-15', '2026-01-28', 'Room Temperature', 'Fresh tetracycline'),
(13, 'SUL-2501', 500, 10, 65.00, '2027-01-20', '2026-02-05', 'Room Temperature', 'Sulfa antibiotics'),
(14, 'PRO-2406', 1000, 5, 120.00, '2026-05-30', '2025-11-20', 'Room Temperature', 'Propylene glycol - bulk'),
(15, 'CALG-2501', 100, 30, 8.50, '2027-02-10', '2026-02-14', 'Room Temperature', 'Calcium gel - oral');




-- Insert 30 milk sale records
INSERT INTO Milk_Sale (sale_date, buyer_name, total_liters, fat, L_R, rate_per_liter, total_amount, payment_status) VALUES
-- January 2026 sales
('2026-01-05', 'Fresh Milk Dairy', 450, 4.2, 1.2, 45.00, 20250.00, 'Paid'),
('2026-01-07', 'City Creamery', 520, 4.4, 1.3, 46.00, 23920.00, 'Paid'),
('2026-01-10', 'Daily Needs Store', 180, 4.1, 1.1, 44.00, 7920.00, 'Paid'),
('2026-01-12', 'Green Valley School', 120, 4.0, 1.0, 43.50, 5220.00, 'Paid'),
('2026-01-15', 'Sunrise Cafe', 85, 4.3, 1.2, 45.00, 3825.00, 'Paid'),
('2026-01-18', 'Fresh Milk Dairy', 465, 4.3, 1.2, 45.50, 21157.50, 'Paid'),
('2026-01-20', 'City Creamery', 535, 4.5, 1.3, 47.00, 25145.00, 'Paid'),
('2026-01-22', 'Daily Needs Store', 165, 4.2, 1.2, 44.50, 7342.50, 'Paid'),
('2026-01-25', 'Green Valley School', 130, 4.1, 1.1, 44.00, 5720.00, 'Paid'),
('2026-01-28', 'Sunrise Cafe', 90, 4.2, 1.2, 45.00, 4050.00, 'Paid'),
('2026-01-30', 'Fresh Milk Dairy', 480, 4.3, 1.2, 46.00, 22080.00, 'Paid'),

-- February 2026 sales
('2026-02-01', 'Fresh Milk Dairy', 450, 4.2, 1.2, 45.00, 20250.00, 'Paid'),
('2026-02-02', 'City Creamery', 520, 4.4, 1.3, 46.00, 23920.00, 'Paid'),
('2026-02-03', 'Fresh Milk Dairy', 485, 4.2, 1.2, 45.00, 21825.00, 'Paid'),
('2026-02-04', 'Green Valley School', 120, 4.0, 1.0, 44.00, 5280.00, 'Paid'),
('2026-02-05', 'Sunrise Cafe', 80, 4.1, 1.1, 45.00, 3600.00, 'Paid'),
('2026-02-06', 'Daily Needs Store', 200, 4.3, 1.2, 45.00, 9000.00, 'Paid'),
('2026-02-07', 'City Creamery', 500, 4.5, 1.3, 47.00, 23500.00, 'Paid'),
('2026-02-08', 'Fresh Milk Dairy', 440, 4.2, 1.2, 45.00, 19800.00, 'Pending'),
('2026-02-09', 'Fresh Milk Dairy', 460, 4.3, 1.2, 45.00, 20700.00, 'Paid'),
('2026-02-10', 'City Creamery', 530, 4.4, 1.3, 46.00, 24380.00, 'Paid'),
('2026-02-11', 'Daily Needs Store', 210, 4.2, 1.1, 45.00, 9450.00, 'Pending'),
('2026-02-12', 'Green Valley School', 130, 4.1, 1.0, 44.00, 5720.00, 'Paid'),
('2026-02-13', 'Sunrise Cafe', 95, 4.2, 1.2, 45.50, 4322.50, 'Paid'),
('2026-02-14', 'City Creamery', 515, 4.4, 1.3, 46.50, 23947.50, 'Paid'),
('2026-02-15', 'Fresh Milk Dairy', 475, 4.3, 1.2, 45.00, 21375.00, 'Paid'),
('2026-02-16', 'Daily Needs Store', 195, 4.2, 1.1, 44.50, 8677.50, 'Pending'),
('2026-02-17', 'Green Valley School', 125, 4.0, 1.0, 43.50, 5437.50, 'Paid'),
('2026-02-18', 'Sunrise Cafe', 88, 4.1, 1.1, 45.00, 3960.00, 'Paid'),
('2026-02-19', 'Fresh Milk Dairy', 455, 4.3, 1.2, 45.50, 20702.50, 'Paid'),
('2026-02-20', 'City Creamery', 525, 4.5, 1.3, 47.00, 24675.00, 'Paid');



-- Insert 15 animal sale records
INSERT INTO Animal_Sale (animal_type, animal_id, sale_date, sale_price, buyer_name) VALUES
-- Calf sales (most common)
('Calf', 5, '2025-06-10', 750.00, 'Johnson Farms'),
('Calf', 2, '2025-07-15', 825.00, 'Miller Dairy'),
('Calf', 8, '2025-08-22', 950.00, 'Elite Genetics'),
('Calf', 11, '2025-09-05', 700.00, 'Local 4-H Member'),
('Calf', 3, '2025-10-12', 890.00, 'Wilson Brothers'),
('Calf', 14, '2025-11-18', 1020.00, 'Green Valley Ranch'),
('Calf', 7, '2026-01-15', 925.00, 'Thompson Livestock'),
('Calf', 9, '2026-02-20', 880.00, 'Smith Family Farm'),

-- Cow sales (culled or surplus cows)
('Cow', 12, '2025-05-15', 1200.00, 'Beef Buyer - Packing Plant'),
('Cow', 9, '2025-08-08', 1450.00, 'Dairy Trader'),
('Cow', 5, '2025-11-25', 1650.00, 'Another Dairy Farm'),
('Cow', 14, '2026-01-22', 1325.00, 'Local Farmer - Williams'),

-- Bull sales
('Bull', 4, '2025-04-20', 2500.00, 'Another Dairy Farm'),
('Bull', 2, '2025-07-12', 3200.00, 'Elite Genetics'),
('Bull', 1, '2025-09-30', 4200.00, 'Breeding Stock Supplier');



-- Insert weight records for 5 Bulls, 18 Cows, and 14 Calves
INSERT INTO Weight_History (animal_type, animal_id, weight, recorded_date, recorded_by, notes) VALUES
-- ============================================
-- BULLS (5 bulls - 4 records each = 20 entries)
-- ============================================
-- Bull #1 - Thunder
('Bull', 1, 820.0, '2025-03-15', 2, 'Spring weigh-in'),
('Bull', 1, 855.0, '2025-06-20', 2, 'Pre-breeding season'),
('Bull', 1, 885.0, '2025-09-25', 3, 'End of breeding season'),
('Bull', 1, 910.0, '2026-01-15', 2, 'Winter weight'),

-- Bull #2 - Lightning
('Bull', 2, 695.0, '2025-04-10', 3, 'Purchased weight'),
('Bull', 2, 730.0, '2025-07-15', 2, 'Summer weigh-in'),
('Bull', 2, 765.0, '2025-10-20', 2, 'Fall weight'),
('Bull', 2, 795.0, '2026-02-10', 3, 'Current weight'),

-- Bull #3 - Ace
('Bull', 3, 780.0, '2025-05-05', 2, 'Spring'),
('Bull', 3, 815.0, '2025-08-10', 6, 'Summer'),
('Bull', 3, 850.0, '2025-11-15', 2, 'Fall'),
('Bull', 3, 880.0, '2026-02-20', 2, 'Late winter'),

-- Bull #4 - King
('Bull', 4, 650.0, '2025-06-15', 3, 'Young bull'),
('Bull', 4, 685.0, '2025-09-18', 2, 'Growing well'),
('Bull', 4, 715.0, '2025-12-22', 6, 'Winter'),
('Bull', 4, 740.0, '2026-03-05', 2, 'Spring approaching'),

-- Bull #5 - Major
('Bull', 5, 720.0, '2025-07-20', 2, 'Mid-summer'),
('Bull', 5, 755.0, '2025-10-25', 3, 'Fall'),
('Bull', 5, 785.0, '2026-01-28', 2, 'Winter'),
('Bull', 5, 810.0, '2026-03-10', 2, 'Pre-breeding'),

-- ============================================
-- COWS (18 cows - 3 records each = 54 entries)
-- ============================================
-- Cow #1 - Bella
('Cow', 1, 650.5, '2025-08-15', 2, 'Late lactation'),
('Cow', 1, 658.0, '2025-11-20', 3, 'Drying off'),
('Cow', 1, 665.5, '2026-02-18', 2, 'Close-up dry cow'),

-- Cow #2 - Daisy
('Cow', 2, 680.0, '2025-08-10', 2, 'Mid-lactation'),
('Cow', 2, 688.5, '2025-11-15', 6, 'Late lactation'),
('Cow', 2, 695.0, '2026-02-20', 2, 'Pre-calving'),

-- Cow #3 - Molly
('Cow', 3, 520.5, '2025-08-05', 3, 'Jersey - milking'),
('Cow', 3, 528.0, '2025-11-10', 2, 'Holding weight'),
('Cow', 3, 533.5, '2026-02-15', 3, 'Pregnant'),

-- Cow #4 - Lily
('Cow', 4, 710.3, '2025-08-12', 2, 'Heavy producer'),
('Cow', 4, 718.5, '2025-11-18', 2, 'Maintaining'),
('Cow', 4, 726.0, '2026-02-22', 6, 'Late pregnancy'),

-- Cow #5 - Rosie
('Cow', 5, 590.8, '2025-08-08', 3, 'Ayrshire'),
('Cow', 5, 598.0, '2025-11-12', 2, 'Good condition'),
('Cow', 5, 605.5, '2026-02-16', 2, 'Expected calving soon'),

-- Cow #6 - Bessie
('Cow', 6, 695.0, '2025-08-20', 2, 'Dry period start'),
('Cow', 6, 705.5, '2025-11-25', 3, 'Mid dry period'),
('Cow', 6, 715.0, '2026-02-25', 2, 'Close-up'),

-- Cow #7 - Clover
('Cow', 7, 510.0, '2025-08-18', 2, 'Jersey'),
('Cow', 7, 518.5, '2025-11-22', 6, 'Holding'),
('Cow', 7, 525.0, '2026-02-24', 2, 'Pregnant'),

-- Cow #8 - Maple
('Cow', 8, 625.5, '2025-08-22', 3, 'Brown Swiss'),
('Cow', 8, 635.0, '2025-11-26', 2, 'Gaining'),
('Cow', 8, 644.5, '2026-02-26', 2, 'Good weight'),

-- Cow #9 - Buttercup
('Cow', 9, 540.0, '2025-08-25', 2, 'First calf heifer'),
('Cow', 9, 550.5, '2025-11-28', 3, 'Growing'),
('Cow', 9, 560.0, '2026-02-28', 2, 'Milking well'),

-- Cow #10 - Stella (Buffalo)
('Cow', 10, 580.0, '2025-08-15', 2, 'Buffalo'),
('Cow', 10, 588.5, '2025-11-20', 6, 'Good condition'),
('Cow', 10, 597.0, '2026-02-22', 2, 'Healthy'),

-- Cow #11 - Penny
('Cow', 11, 720.0, '2025-08-10', 2, 'Senior cow'),
('Cow', 11, 728.5, '2025-11-15', 2, 'Holding weight'),
('Cow', 11, 736.0, '2026-02-18', 3, 'Excellent condition'),

-- Cow #12 - Hazel
('Cow', 12, 495.0, '2025-08-05', 2, 'Young cow'),
('Cow', 12, 505.5, '2025-11-10', 3, 'Growing'),
('Cow', 12, 515.0, '2026-02-15', 2, 'Filling out'),

-- Cow #13 - Ruby
('Cow', 13, 480.0, '2025-08-12', 6, 'First lactation'),
('Cow', 13, 490.5, '2025-11-18', 2, 'Gaining'),
('Cow', 13, 500.0, '2026-02-20', 2, 'Good progress'),

-- Cow #14 - Pearl
('Cow', 14, 450.0, '2025-08-08', 3, 'Young heifer'),
('Cow', 14, 462.5, '2025-11-12', 2, 'Growing well'),
('Cow', 14, 475.0, '2026-02-16', 2, 'Ready for breeding'),

-- Cow #15 - Misty
('Cow', 15, 520.5, '2025-08-18', 2, 'Ayrshire'),
('Cow', 15, 530.0, '2025-11-22', 3, 'Holding'),
('Cow', 15, 540.5, '2026-02-24', 2, 'Pregnant'),

-- Cow #16 - Bella 2
('Cow', 16, 380.0, '2025-08-20', 2, 'Heifer'),
('Cow', 16, 405.0, '2025-11-25', 6, 'Growing fast'),
('Cow', 16, 430.0, '2026-02-26', 2, 'Almost breeding weight'),

-- Cow #17 - Daisy Jr
('Cow', 17, 360.0, '2025-08-22', 3, 'Yearling'),
('Cow', 17, 385.0, '2025-11-26', 2, 'Good growth'),
('Cow', 17, 410.0, '2026-02-28', 2, 'Developing well'),

-- Cow #18 - Molly Jr
('Cow', 18, 340.0, '2025-08-25', 2, 'Young stock'),
('Cow', 18, 365.0, '2025-11-28', 3, 'On track'),
('Cow', 18, 390.0, '2026-03-02', 2, 'Growing steadily'),

-- ============================================
-- CALVES (14 calves - progressive weights)
-- ============================================
-- Calf #1
('Calf', 1, 42.5, '2025-12-05', 3, 'Birth weight - female'),
('Calf', 1, 58.0, '2026-01-05', 2, '1 month - doing well'),
('Calf', 1, 72.5, '2026-02-05', 3, '2 months - healthy'),
('Calf', 1, 86.0, '2026-03-05', 2, '3 months - good gain'),

-- Calf #2
('Calf', 2, 45.0, '2025-12-08', 2, 'Birth weight - male'),
('Calf', 2, 61.5, '2026-01-08', 3, '1 month - strong'),
('Calf', 2, 77.0, '2026-02-08', 2, '2 months - excellent'),
('Calf', 2, 92.0, '2026-03-08', 3, '3 months - top of group'),

-- Calf #3
('Calf', 3, 38.0, '2025-12-12', 2, 'Birth weight - female'),
('Calf', 3, 53.5, '2026-01-12', 6, '1 month - small but healthy'),
('Calf', 3, 68.5, '2026-02-12', 2, '2 months - catching up'),
('Calf', 3, 83.0, '2026-03-12', 3, '3 months - good progress'),

-- Calf #4
('Calf', 4, 41.5, '2025-12-15', 3, 'Birth weight - female'),
('Calf', 4, 57.0, '2026-01-15', 2, '1 month - healthy'),
('Calf', 4, 72.5, '2026-02-15', 2, '2 months - good'),
('Calf', 4, 87.5, '2026-03-15', 3, '3 months - on target'),

-- Calf #5
('Calf', 5, 44.0, '2025-11-18', 2, 'Birth weight - male - SOLD'),
('Calf', 5, 60.5, '2025-12-18', 3, '1 month - strong'),
('Calf', 5, 76.5, '2026-01-18', 2, '2 months - excellent'),
('Calf', 5, 92.0, '2026-02-18', 2, '3 months - sold at this weight'),

-- Calf #6
('Calf', 6, 43.0, '2025-12-01', 3, 'Birth weight - female'),
('Calf', 6, 59.0, '2026-01-01', 2, '1 month - healthy'),
('Calf', 6, 74.5, '2026-02-01', 6, '2 months - good gain'),
('Calf', 6, 89.5, '2026-03-01', 2, '3 months - potential replacement'),

-- Calf #7
('Calf', 7, 40.5, '2025-12-15', 2, 'Birth weight - female'),
('Calf', 7, 56.0, '2026-01-15', 3, '1 month - doing well'),
('Calf', 7, 71.5, '2026-02-15', 2, '2 months - healthy'),
('Calf', 7, 86.5, '2026-03-15', 2, '3 months - good confirmation'),

-- Calf #8
('Calf', 8, 46.0, '2026-01-05', 3, 'Birth weight - male'),
('Calf', 8, 62.5, '2026-02-05', 2, '1 month - big calf'),
('Calf', 8, 78.5, '2026-03-05', 2, '2 months - excellent growth'),

-- Calf #9
('Calf', 9, 42.0, '2026-01-20', 2, 'Birth weight - female'),
('Calf', 9, 58.5, '2026-02-20', 3, '1 month - healthy'),
('Calf', 9, 74.0, '2026-03-20', 2, '2 months - doing well'),

-- Calf #10
('Calf', 10, 39.5, '2026-02-01', 2, 'Birth weight - female'),
('Calf', 10, 55.0, '2026-03-01', 3, '1 month - gaining well'),

-- Calf #11
('Calf', 11, 44.5, '2025-10-15', 2, 'Birth weight - male'),
('Calf', 11, 62.0, '2025-11-15', 3, '1 month - strong'),
('Calf', 11, 79.5, '2025-12-15', 2, '2 months - excellent'),
('Calf', 11, 96.0, '2026-01-15', 6, '3 months - top calf'),
('Calf', 11, 112.0, '2026-02-15', 2, '4 months - bull potential'),

-- Calf #12
('Calf', 12, 41.0, '2025-11-10', 3, 'Birth weight - female'),
('Calf', 12, 58.5, '2025-12-10', 2, '1 month - healthy'),
('Calf', 12, 75.5, '2026-01-10', 2, '2 months - good'),
('Calf', 12, 92.0, '2026-02-10', 3, '3 months - replacement quality'),

-- Calf #13
('Calf', 13, 43.5, '2025-12-20', 2, 'Birth weight - female'),
('Calf', 13, 60.0, '2026-01-20', 3, '1 month - healthy'),
('Calf', 13, 76.5, '2026-02-20', 2, '2 months - good gain'),
('Calf', 13, 92.5, '2026-03-20', 2, '3 months - excellent'),

-- Calf #14
('Calf', 14, 40.0, '2026-01-25', 3, 'Birth weight - female'),
('Calf', 14, 56.5, '2026-02-25', 2, '1 month - healthy'),
('Calf', 14, 72.5, '2026-03-25', 2, '2 months - on track');



-- Insert 50 expense records
INSERT INTO Expense (expense_date, expense_type, amount, remarks) VALUES
-- ============================================
-- FEED EXPENSES (15 entries)
-- ============================================
('2025-06-05', 'Feed', 12500.00, 'Monthly feed purchase - Corn silage, hay, concentrate'),
('2025-06-20', 'Feed', 8750.50, 'Supplemental feed - protein mix and minerals'),
('2025-07-03', 'Feed', 13200.00, 'July bulk feed order'),
('2025-07-18', 'Feed', 5600.00, 'Calf starter and milk replacer'),
('2025-08-07', 'Feed', 14100.00, 'August feed - pre-harvest stocking'),
('2025-08-22', 'Feed', 3200.00, 'Mineral blocks and supplements'),
('2025-09-05', 'Feed', 12800.00, 'September feed purchase'),
('2025-09-19', 'Feed', 4850.00, 'Specialty feed for high producers'),
('2025-10-08', 'Feed', 13500.00, 'October feed - winter preparation'),
('2025-10-25', 'Feed', 6200.00, 'Hay purchase - 10 tons'),
('2025-11-10', 'Feed', 14200.00, 'November bulk feed order'),
('2025-11-28', 'Feed', 3800.00, 'Vitamin and mineral premix'),
('2025-12-12', 'Feed', 15100.00, 'December feed - winter stock'),
('2026-01-08', 'Feed', 14800.00, 'January feed purchase'),
('2026-02-05', 'Feed', 13600.00, 'February feed order'),

-- ============================================
-- MEDICINE & VET EXPENSES (12 entries)
-- ============================================
('2025-06-10', 'Medicine', 850.50, 'Vaccines - IBR, BVD, Lepto'),
('2025-06-25', 'Medicine', 1250.00, 'Mastitis treatment supplies'),
('2025-07-12', 'Medicine', 560.00, 'Dewormer - Ivermectin'),
('2025-08-05', 'Medicine', 2100.00, 'Emergency vet call - calving difficulty'),
('2025-08-28', 'Medicine', 750.00, 'Antibiotics and anti-inflammatories'),
('2025-09-15', 'Medicine', 980.00, 'Vaccination supplies'),
('2025-10-10', 'Medicine', 1650.00, 'Hoof trimming and treatment'),
('2025-11-05', 'Medicine', 720.00, 'Vitamin injections'),
('2025-11-30', 'Medicine', 1850.00, 'Pregnancy checks and ultrasound'),
('2025-12-18', 'Medicine', 2300.00, 'Winter health program'),
('2026-01-20', 'Medicine', 950.00, 'Mastitis prevention supplies'),
('2026-02-15', 'Medicine', 1200.00, 'Routine vaccinations'),

-- ============================================
-- LABOR & SALARIES (8 entries)
-- ============================================
('2025-06-30', 'Labor', 8500.00, 'June staff salaries'),
('2025-07-31', 'Labor', 8500.00, 'July staff salaries'),
('2025-08-31', 'Labor', 8750.00, 'August staff salaries + overtime'),
('2025-09-30', 'Labor', 8500.00, 'September staff salaries'),
('2025-10-31', 'Labor', 8900.00, 'October staff salaries + bonus'),
('2025-11-30', 'Labor', 8500.00, 'November staff salaries'),
('2025-12-31', 'Labor', 9200.00, 'December staff salaries + holiday bonus'),
('2026-01-31', 'Labor', 8500.00, 'January staff salaries'),

-- ============================================
-- ELECTRICITY & UTILITIES (8 entries)
-- ============================================
('2025-06-15', 'Electricity', 2850.00, 'June electricity - milking parlor'),
('2025-07-15', 'Electricity', 3200.00, 'July electricity - cooling fans'),
('2025-08-15', 'Electricity', 3550.00, 'August electricity - peak cooling'),
('2025-09-15', 'Electricity', 2950.00, 'September electricity'),
('2025-10-15', 'Electricity', 2450.00, 'October electricity'),
('2025-11-15', 'Electricity', 2100.00, 'November electricity'),
('2025-12-15', 'Electricity', 2650.00, 'December electricity - lighting and heating'),
('2026-01-15', 'Electricity', 2800.00, 'January electricity'),

-- ============================================
-- EQUIPMENT & MAINTENANCE (7 entries)
-- ============================================
('2025-06-18', 'Equipment', 1250.00, 'Milking machine replacement parts'),
('2025-07-22', 'Equipment', 3500.00, 'Tractor maintenance and oil change'),
('2025-08-30', 'Equipment', 850.00, 'Fence repairs'),
('2025-09-25', 'Equipment', 2200.00, 'Bulk tank cleaning and inspection'),
('2025-10-28', 'Equipment', 1750.00, 'Water pump repair'),
('2025-11-20', 'Equipment', 4200.00, 'New milking claw sets'),
('2026-02-10', 'Equipment', 950.00, 'Generator maintenance'),

-- ============================================
-- BEDDING & SUPPLIES (5 entries)
-- ============================================
('2025-07-05', 'Supplies', 850.00, 'Straw bedding for calving pens'),
('2025-09-10', 'Supplies', 1100.00, 'Sawdust bedding - 2 truckloads'),
('2025-11-15', 'Supplies', 950.00, 'Winter bedding - straw'),
('2026-01-10', 'Supplies', 1250.00, 'Extra bedding for cold weather'),
('2026-02-20', 'Supplies', 800.00, 'Bedding materials'),

-- ============================================
-- BREEDING & SEMEN (5 entries)
-- ============================================
('2025-06-08', 'Breeding', 1850.00, 'Semen purchase - Holstein genetics'),
('2025-08-12', 'Breeding', 950.00, 'AI supplies and equipment'),
('2025-10-05', 'Breeding', 2100.00, 'Semen - Jersey and Ayrshire'),
('2025-12-03', 'Breeding', 750.00, 'Pregnancy testing supplies'),
('2026-02-18', 'Breeding', 1650.00, 'Semen order - spring breeding'),
('2026-02-18', 'Breeding', 1650.00, 'Semen order - spring breeding'),

-- ============================================
-- MISCELLANEOUS (5 entries)
-- ============================================
('2025-07-28', 'Miscellaneous', 450.00, 'Farm registration and permits'),
('2025-09-18', 'Miscellaneous', 600.00, 'Water testing and quality analysis'),
('2025-11-08', 'Miscellaneous', 350.00, 'Office supplies'),
('2026-01-25', 'Miscellaneous', 1200.00, 'Consultant fees - nutritionist'),
('2026-03-01', 'Miscellaneous', 550.00, 'Record keeping software subscription');



-- Insert 40 income records
INSERT INTO Income (income_date, source, amount, reference_id) VALUES
-- ============================================
-- MILK SALES (25 entries) - reference_id links to Milk_Sale table
-- ============================================
('2025-06-05', 'Milk', 12500.00, 1),
('2025-06-12', 'Milk', 14200.00, 2),
('2025-06-19', 'Milk', 13800.00, 3),
('2025-06-26', 'Milk', 15100.00, 4),
('2025-07-03', 'Milk', 14800.00, 5),
('2025-07-10', 'Milk', 16200.00, 6),
('2025-07-17', 'Milk', 15800.00, 7),
('2025-07-24', 'Milk', 17100.00, 8),
('2025-07-31', 'Milk', 16500.00, 9),
('2025-08-07', 'Milk', 16800.00, 10),
('2025-08-14', 'Milk', 17200.00, 11),
('2025-08-21', 'Milk', 16900.00, 12),
('2025-08-28', 'Milk', 17500.00, 13),
('2025-09-04', 'Milk', 15800.00, 14),
('2025-09-11', 'Milk', 16200.00, 15),
('2025-09-18', 'Milk', 15500.00, 16),
('2025-09-25', 'Milk', 16100.00, 17),
('2025-10-02', 'Milk', 15200.00, 18),
('2025-10-09', 'Milk', 14800.00, 19),
('2025-10-16', 'Milk', 15500.00, 20),
('2025-10-23', 'Milk', 15100.00, 21),
('2025-10-30', 'Milk', 15800.00, 22),
('2025-11-06', 'Milk', 14200.00, 23),
('2025-11-13', 'Milk', 13800.00, 24),
('2025-11-20', 'Milk', 14500.00, 25),
('2025-11-27', 'Milk', 14100.00, 26),
('2025-12-04', 'Milk', 13200.00, 27),
('2025-12-11', 'Milk', 12800.00, 28),
('2025-12-18', 'Milk', 13500.00, 29),
('2025-12-25', 'Milk', 14100.00, 30),
('2026-01-01', 'Milk', 14800.00, 31),
('2026-01-08', 'Milk', 15200.00, 32),
('2026-01-15', 'Milk', 15800.00, 33),
('2026-01-22', 'Milk', 15500.00, 34),
('2026-01-29', 'Milk', 16200.00, 35),
('2026-02-05', 'Milk', 16800.00, 36),
('2026-02-12', 'Milk', 17200.00, 37),
('2026-02-19', 'Milk', 17500.00, 38),
('2026-02-26', 'Milk', 17100.00, 39),

-- ============================================
-- COW SALES (8 entries) - reference_id links to Animal_Sale table
-- ============================================
('2025-06-15', 'Cow Sale', 1200.00, 101),
('2025-07-22', 'Cow Sale', 1450.00, 102),
('2025-08-18', 'Cow Sale', 1100.00, 103),
('2025-09-25', 'Cow Sale', 1650.00, 104),
('2025-10-12', 'Cow Sale', 1325.00, 105),
('2025-11-08', 'Cow Sale', 1520.00, 106),
('2025-12-05', 'Cow Sale', 1400.00, 107),
('2026-01-20', 'Cow Sale', 1750.00, 108),

-- ============================================
-- CALF SALES (5 entries) - reference_id links to Animal_Sale table
-- ============================================
('2025-07-10', 'Calf Sale', 750.00, 201),
('2025-08-15', 'Calf Sale', 825.00, 202),
('2025-09-20', 'Calf Sale', 950.00, 203),
('2025-10-25', 'Calf Sale', 1020.00, 204),
('2025-11-30', 'Calf Sale', 890.00, 205),

-- ============================================
-- BULL SALES (2 entries) - reference_id links to Animal_Sale table
-- ============================================
('2025-07-25', 'Bull Sale', 2500.00, 301),
('2025-09-30', 'Bull Sale', 4200.00, 302);


-- Insert 15 alert records
INSERT INTO Alerts (Cow_id, bull_id, calf_id, alert_type, alert_date, status) VALUES
-- ============================================
-- COW ALERTS (8 entries)
-- ============================================
(1, NULL, NULL, 'Heat Detection', '2026-03-15', 'Active'),
(4, NULL, NULL, 'Heat Detection', '2026-03-18', 'Active'),
(2, NULL, NULL, 'Due for Vaccination', '2026-03-20', 'Active'),
(6, NULL, NULL, 'Dry Off', '2026-03-25', 'Pending'),
(11, NULL, NULL, 'Expected Calving', '2026-04-10', 'Active'),
(5, NULL, NULL, 'Pregnancy Check', '2026-03-22', 'Pending'),
(8, NULL, NULL, 'Mastitis Check', '2026-03-16', 'Active'),
(3, NULL, NULL, 'Hoof Trimming Due', '2026-03-28', 'Active'),

-- ============================================
-- CALF ALERTS (4 entries)
-- ============================================
(NULL, NULL, 1, 'Weaning Due', '2026-03-30', 'Pending'),
(NULL, NULL, 3, 'Vaccination - 1st Round', '2026-03-19', 'Active'),
(NULL, NULL, 6, 'Dehorning Scheduled', '2026-03-25', 'Pending'),
(NULL, NULL, 8, 'Health Check', '2026-03-17', 'Completed'),

-- ============================================
-- BULL ALERTS (3 entries)
-- ============================================
(NULL, 1, NULL, 'Semen Collection', '2026-03-21', 'Active'),
(NULL, 2, NULL, 'Breeding Soundness Exam', '2026-04-05', 'Pending'),
(NULL, 3, NULL, 'Vaccination Due', '2026-03-23', 'Active');



-- Insert 20 payroll records
INSERT INTO Employee_Payroll (staff_id, pay_period_start, pay_period_end, basic_salary, overtime_hours, overtime_rate, bonus, deductions, net_salary, payment_date, payment_status) VALUES
-- ============================================
-- Q3 2025 PAYROLL (June - August)
-- ============================================
-- Staff #1 - John Smith (Farm Manager)
(1, '2025-06-01', '2025-06-30', 4500.00, 5.0, 45.00, 500.00, 350.00, 4875.00, '2025-07-05', 'Paid'),
(1, '2025-07-01', '2025-07-31', 4500.00, 8.0, 45.00, 500.00, 350.00, 5010.00, '2025-08-05', 'Paid'),
(1, '2025-08-01', '2025-08-31', 4500.00, 6.0, 45.00, 500.00, 350.00, 4920.00, '2025-09-05', 'Paid'),

-- Staff #2 - Sarah Johnson (Vet)
(2, '2025-06-01', '2025-06-30', 3800.00, 3.0, 40.00, 300.00, 320.00, 3900.00, '2025-07-05', 'Paid'),
(2, '2025-07-01', '2025-07-31', 3800.00, 5.0, 40.00, 300.00, 320.00, 3980.00, '2025-08-05', 'Paid'),
(2, '2025-08-01', '2025-08-31', 3800.00, 4.0, 40.00, 300.00, 320.00, 3940.00, '2025-09-05', 'Paid'),

-- Staff #3 - Mike Wilson (Senior Technician)
(3, '2025-06-01', '2025-06-30', 3500.00, 8.0, 38.00, 250.00, 300.00, 3754.00, '2025-07-05', 'Paid'),
(3, '2025-07-01', '2025-07-31', 3500.00, 12.0, 38.00, 250.00, 300.00, 3906.00, '2025-08-05', 'Paid'),
(3, '2025-08-01', '2025-08-31', 3500.00, 10.0, 38.00, 250.00, 300.00, 3830.00, '2025-09-05', 'Paid'),

-- ============================================
-- Q4 2025 PAYROLL (September - November)
-- ============================================
-- Staff #4 - Emily Brown (Technician)
(4, '2025-09-01', '2025-09-30', 2800.00, 4.0, 32.00, 150.00, 250.00, 2828.00, '2025-10-05', 'Paid'),
(4, '2025-10-01', '2025-10-31', 2800.00, 6.0, 32.00, 150.00, 250.00, 2892.00, '2025-11-05', 'Paid'),
(4, '2025-11-01', '2025-11-30', 2800.00, 5.0, 32.00, 150.00, 250.00, 2860.00, '2025-12-05', 'Paid'),

-- Staff #5 - David Miller (Worker)
(5, '2025-09-01', '2025-09-30', 2500.00, 6.0, 30.00, 100.00, 220.00, 2560.00, '2025-10-05', 'Paid'),
(5, '2025-10-01', '2025-10-31', 2500.00, 8.0, 30.00, 100.00, 220.00, 2620.00, '2025-11-05', 'Paid'),
(5, '2025-11-01', '2025-11-30', 2500.00, 7.0, 30.00, 100.00, 220.00, 2590.00, '2025-12-05', 'Paid'),

-- ============================================
-- Q1 2026 PAYROLL (January - February)
-- ============================================
-- Staff #6 - Lisa Davis (Vet)
(6, '2026-01-01', '2026-01-31', 3800.00, 2.0, 40.00, 300.00, 320.00, 3860.00, '2026-02-05', 'Paid'),
(6, '2026-02-01', '2026-02-28', 3800.00, 4.0, 40.00, 300.00, 320.00, 3940.00, '2026-03-05', 'Paid'),

-- Staff #7 - Tom Harris (Worker)
(7, '2026-01-01', '2026-01-31', 2400.00, 5.0, 28.00, 50.00, 200.00, 2390.00, '2026-02-05', 'Paid'),
(7, '2026-02-01', '2026-02-28', 2400.00, 8.0, 28.00, 50.00, 200.00, 2474.00, '2026-03-05', 'Paid'),

-- Staff #8 - Anna Martinez (Technician)
(8, '2026-01-01', '2026-01-31', 2800.00, 3.0, 32.00, 150.00, 250.00, 2796.00, '2026-02-05', 'Paid'),
(8, '2026-02-01', '2026-02-28', 2800.00, 5.0, 32.00, 150.00, 250.00, 2860.00, '2026-03-05', 'Paid'),

-- Staff #9 - Robert Taylor (Worker)
(9, '2026-01-01', '2026-01-31', 2600.00, 7.0, 30.00, 100.00, 230.00, 2680.00, '2026-02-05', 'Paid'),
(9, '2026-02-01', '2026-02-28', 2600.00, 6.0, 30.00, 100.00, 230.00, 2650.00, '2026-03-05', 'Paid'),

-- Staff #10 - Jennifer White (Accountant)
(10, '2026-01-01', '2026-01-31', 3200.00, 0.0, 0.00, 400.00, 280.00, 3320.00, '2026-02-05', 'Paid'),
(10, '2026-02-01', '2026-02-28', 3200.00, 2.0, 35.00, 400.00, 280.00, 3390.00, '2026-03-05', 'Paid');


-- Insert 50 employee attendance records
INSERT INTO Employee_Attendance (staff_id, work_date, hours_worked, overtime_hours, shift) VALUES
-- ============================================
-- STAFF #1 - John Smith (Farm Manager)
-- ============================================
(1, '2026-02-01', 8.5, 0.5, 'Morning'),
(1, '2026-02-02', 8.0, 0.0, 'Morning'),
(1, '2026-02-03', 9.0, 1.0, 'Morning'),
(1, '2026-02-04', 8.0, 0.0, 'Morning'),
(1, '2026-02-05', 8.5, 0.5, 'Morning'),
(1, '2026-02-06', 8.0, 0.0, 'Morning'),

-- ============================================
-- STAFF #2 - Sarah Johnson (Vet)
-- ============================================
(2, '2026-02-01', 8.0, 0.0, 'Morning'),
(2, '2026-02-02', 8.5, 0.5, 'Morning'),
(2, '2026-02-03', 8.0, 0.0, 'Morning'),
(2, '2026-02-04', 9.0, 1.0, 'Morning'),
(2, '2026-02-05', 8.0, 0.0, 'Morning'),
(2, '2026-02-06', 8.0, 0.0, 'Morning'),

-- ============================================
-- STAFF #3 - Mike Wilson (Senior Technician)
-- ============================================
(3, '2026-02-01', 9.0, 1.0, 'Morning'),
(3, '2026-02-02', 8.5, 0.5, 'Morning'),
(3, '2026-02-03', 9.5, 1.5, 'Morning'),
(3, '2026-02-04', 8.0, 0.0, 'Morning'),
(3, '2026-02-05', 9.0, 1.0, 'Morning'),
(3, '2026-02-06', 8.5, 0.5, 'Morning'),

-- ============================================
-- STAFF #4 - Emily Brown (Technician)
-- ============================================
(4, '2026-02-01', 8.0, 0.0, 'Morning'),
(4, '2026-02-02', 8.5, 0.5, 'Morning'),
(4, '2026-02-03', 8.0, 0.0, 'Morning'),
(4, '2026-02-04', 8.5, 0.5, 'Afternoon'),
(4, '2026-02-05', 8.0, 0.0, 'Afternoon'),
(4, '2026-02-06', 8.0, 0.0, 'Afternoon'),

-- ============================================
-- STAFF #5 - David Miller (Worker)
-- ============================================
(5, '2026-02-01', 8.0, 0.0, 'Morning'),
(5, '2026-02-02', 8.0, 0.0, 'Morning'),
(5, '2026-02-03', 8.5, 0.5, 'Morning'),
(5, '2026-02-04', 8.0, 0.0, 'Afternoon'),
(5, '2026-02-05', 8.5, 0.5, 'Afternoon'),
(5, '2026-02-06', 8.0, 0.0, 'Afternoon'),

-- ============================================
-- STAFF #6 - Lisa Davis (Vet)
-- ============================================
(6, '2026-02-01', 8.0, 0.0, 'Afternoon'),
(6, '2026-02-02', 8.5, 0.5, 'Afternoon'),
(6, '2026-02-03', 8.0, 0.0, 'Afternoon'),
(6, '2026-02-04', 9.0, 1.0, 'Afternoon'),
(6, '2026-02-05', 8.0, 0.0, 'Afternoon'),
(6, '2026-02-06', 8.0, 0.0, 'Afternoon'),

-- ============================================
-- STAFF #7 - Tom Harris (Worker)
-- ============================================
(7, '2026-02-01', 8.0, 0.0, 'Afternoon'),
(7, '2026-02-02', 8.5, 0.5, 'Afternoon'),
(7, '2026-02-03', 9.0, 1.0, 'Afternoon'),
(7, '2026-02-04', 8.0, 0.0, 'Evening'),
(7, '2026-02-05', 8.5, 0.5, 'Evening'),
(7, '2026-02-06', 8.0, 0.0, 'Evening'),

-- ============================================
-- STAFF #8 - Anna Martinez (Technician)
-- ============================================
(8, '2026-02-01', 8.5, 0.5, 'Afternoon'),
(8, '2026-02-02', 8.0, 0.0, 'Afternoon'),
(8, '2026-02-03', 8.5, 0.5, 'Evening'),
(8, '2026-02-04', 8.0, 0.0, 'Evening'),
(8, '2026-02-05', 8.5, 0.5, 'Evening'),
(8, '2026-02-06', 8.0, 0.0, 'Evening'),

-- ============================================
-- STAFF #9 - Robert Taylor (Worker)
-- ============================================
(9, '2026-02-01', 8.0, 0.0, 'Evening'),
(9, '2026-02-02', 8.5, 0.5, 'Evening'),
(9, '2026-02-03', 8.0, 0.0, 'Evening'),
(9, '2026-02-04', 8.5, 0.5, 'Evening'),
(9, '2026-02-05', 8.0, 0.0, 'Evening'),
(9, '2026-02-06', 8.5, 0.5, 'Evening'),

-- ============================================
-- STAFF #10 - Jennifer White (Accountant)
-- ============================================
(10, '2026-02-01', 8.0, 0.0, 'Morning'),
(10, '2026-02-02', 8.0, 0.0, 'Morning'),
(10, '2026-02-03', 8.0, 0.0, 'Morning'),
(10, '2026-02-04', 8.0, 0.0, 'Morning'),
(10, '2026-02-05', 8.0, 0.0, 'Morning'),
(10, '2026-02-06', 8.0, 0.0, 'Morning');

-- Insert 25 maintenance log records
INSERT INTO Maintenance_Log (equipment_id, maintenance_date, description, cost, performed_by, next_due_date) VALUES
-- ============================================
-- MILKING EQUIPMENT
-- ============================================
-- Equipment #1 - Delaval Milking Machine
(1, '2025-06-10', 'Routine service - cleaned and calibrated', 350.00, 'Mike Wilson', '2025-07-10'),
(1, '2025-07-15', 'Replaced rubber liners and filters', 275.00, 'Mike Wilson', '2025-08-15'),
(1, '2025-08-20', 'Vacuum pump inspection and belt replacement', 420.00, 'DairyTech Industries', '2025-09-20'),
(1, '2025-09-25', 'Pulsator cleaning and adjustment', 180.00, 'Anna Martinez', '2025-10-25'),
(1, '2025-11-05', 'Major service - replaced claws and hoses', 850.00, 'DairyTech Industries', '2026-02-05'),
(1, '2026-01-10', 'Routine maintenance and calibration', 320.00, 'Mike Wilson', '2026-04-10'),

-- Equipment #3 - Bulk Milk Cooler
(3, '2025-06-05', 'Cleaning cycle and temperature check', 120.00, 'Emily Brown', '2025-07-05'),
(3, '2025-07-08', 'Compressor inspection and filter cleaning', 250.00, 'HVAC Services', '2025-08-08'),
(3, '2025-08-12', 'Temperature sensor calibration', 95.00, 'Emily Brown', '2025-09-12'),
(3, '2025-09-18', 'Deep cleaning and sanitation', 180.00, 'Mike Wilson', '2025-10-18'),
(3, '2025-10-25', 'Refrigerant level check and top-up', 350.00, 'HVAC Services', '2025-11-25'),
(3, '2025-12-02', 'Pre-winter maintenance', 220.00, 'Mike Wilson', '2026-01-02'),
(3, '2026-01-15', 'Emergency repair - thermostat replacement', 185.00, 'HVAC Services', '2026-02-15'),
(3, '2026-02-20', 'Routine cleaning and inspection', 110.00, 'Emily Brown', '2026-03-20'),

-- ============================================
-- TRACTORS & VEHICLES
-- ============================================
-- Equipment #2 - John Deere Tractor
(2, '2025-06-18', 'Oil change and filter replacement', 220.00, 'David Miller', '2025-08-18'),
(2, '2025-08-25', 'Hydraulic system check and fluid top-up', 180.00, 'John Deere Service', '2025-10-25'),
(2, '2025-10-30', 'Tire pressure check and rotation', 150.00, 'Tom Harris', '2025-12-30'),
(2, '2026-01-05', 'Winterization and battery check', 130.00, 'David Miller', '2026-03-05'),
(2, '2026-02-15', 'Pre-spring service and inspection', 350.00, 'John Deere Service', '2026-05-15'),

-- ============================================
-- FEED EQUIPMENT
-- ============================================
-- Equipment #4 - Feed Mixer
(4, '2025-06-22', 'Blade sharpening and bearing lubrication', 280.00, 'Mike Wilson', '2025-08-22'),
(4, '2025-08-28', 'Motor inspection and belt replacement', 420.00, 'Agri Repair Services', '2025-10-28'),
(4, '2025-11-05', 'Gearbox oil change', 190.00, 'Tom Harris', '2026-01-05'),
(4, '2026-01-20', 'Full service and calibration', 550.00, 'DairyTech Industries', '2026-04-20'),

-- ============================================
-- MANURE HANDLING
-- ============================================
-- Equipment #5 - Manure Scraper
(5, '2025-07-05', 'Blade replacement and chain tensioning', 320.00, 'Robert Taylor', '2025-09-05'),
(5, '2025-09-10', 'Hydraulic cylinder repair', 450.00, 'Hydraulic Services', '2025-11-10'),
(5, '2025-11-15', 'Routine maintenance and lubrication', 150.00, 'Robert Taylor', '2026-01-15'),
(5, '2026-01-25', 'Motor inspection and cleaning', 180.00, 'Mike Wilson', '2026-03-25'),

-- ============================================
-- GENERATOR
-- ============================================
-- Equipment #6 - Generator
(6, '2025-06-30', 'Oil change and filter replacement', 210.00, 'PowerGen Services', '2025-08-30'),
(6, '2025-08-25', 'Load bank testing', 380.00, 'PowerGen Services', '2025-10-25'),
(6, '2025-10-20', 'Battery replacement and terminal cleaning', 175.00, 'Tom Harris', '2025-12-20'),
(6, '2025-12-15', 'Full annual service', 520.00, 'PowerGen Services', '2026-03-15'),
(6, '2026-02-10', 'Fuel system check and additive', 95.00, 'Tom Harris', '2026-04-10');

-- Insert 25 genetics records
INSERT INTO Genetics (animal_id, animal_type, sire_id, dam_id, genetic_merit_score, genetic_test_date, test_results) VALUES
-- ============================================
-- COW GENETICS (10 entries)
-- ============================================
(1, 'Cow', 1, NULL, 85.5, '2025-03-10', 'High production potential - Excellent lineage'),
(2, 'Cow', 3, NULL, 82.0, '2025-03-15', 'Good type traits - Strong frame'),
(3, 'Cow', 2, NULL, 79.5, '2025-04-05', 'High butterfat genetics - Jersey lineage'),
(4, 'Cow', 1, NULL, 88.0, '2025-04-12', 'Excellent production - Top 10% of herd'),
(5, 'Cow', 1, NULL, 81.5, '2025-05-08', 'Good conformation - Moderate production'),
(6, 'Cow', 4, NULL, 76.0, '2025-05-20', 'Average genetics - Good maternal traits'),
(7, 'Cow', 2, NULL, 83.5, '2025-06-15', 'Excellent butterfat - Jersey bloodline'),
(8, 'Cow', 6, NULL, 84.0, '2025-06-22', 'Brown Swiss - Strong frame, good longevity'),
(9, 'Cow', 3, 2, 86.5, '2025-07-08', 'Young cow - Promising genetics from top dam'),
(10, 'Cow', 1, 4, 89.0, '2025-07-18', 'Elite genetics - Daughter of top cow and bull'),

-- ============================================
-- BULL GENETICS (8 entries)
-- ============================================
(1, 'Bull', NULL, NULL, 92.0, '2025-02-10', 'Elite sire - Top 5% for production and type'),
(1, 'Bull', NULL, NULL, 93.5, '2025-08-15', 'Updated genomics - Excellent calving ease'),
(2, 'Bull', NULL, NULL, 87.5, '2025-02-18', 'Good all-around genetics - Moderate frame'),
(2, 'Bull', NULL, NULL, 88.0, '2025-08-22', 'Confirmed high fertility scores'),
(3, 'Bull', 1, NULL, 90.0, '2025-03-05', 'Son of Thunder - Excellent production'),
(3, 'Bull', 1, NULL, 91.0, '2025-09-10', 'Proven sire - Daughters milk well'),
(4, 'Bull', NULL, NULL, 81.0, '2025-04-15', 'Young bull - Average genetics'),
(5, 'Bull', 2, NULL, 86.5, '2025-05-20', 'Jersey bull - High butterfat transmission'),
(5, 'Bull', 2, NULL, 87.5, '2025-11-05', 'Confirmed - Daughters have excellent components'),

-- ============================================
-- CALF GENETICS (7 entries)
-- ============================================
(1, 'Calf', 1, 1, 86.5, '2026-01-10', 'Promising heifer - Daughter of Bella and Thunder'),
(1, 'Calf', 1, 1, 87.0, '2026-02-15', 'Growing well - Excellent confirmation'),
(2, 'Calf', 3, 2, 84.0, '2026-01-18', 'Good potential - Balanced genetics'),
(3, 'Calf', 2, 3, 88.5, '2026-01-22', 'Jersey heifer - High butterfat potential'),
(4, 'Calf', 1, 4, 89.5, '2026-02-05', 'Elite heifer - Best genetics in herd'),
(5, 'Calf', 1, 5, 83.0, '2026-02-12', 'Bull calf - Good growth rates'),
(6, 'Calf', 4, 6, 81.5, '2026-02-18', 'Average heifer - Suitable for replacement'),
(7, 'Calf', 2, 7, 86.0, '2026-02-25', 'Jersey heifer - Excellent components'),
(8, 'Calf', 3, 8, 85.5, '2026-03-01', 'Brown Swiss cross - Good frame');



-- Insert 30 inventory records
INSERT INTO Inventory (item_type, item_id, quantity_on_hand, unit, reorder_level, reorder_quantity, location, last_stock_take) VALUES
-- ============================================
-- FEED INVENTORY (10 entries)
-- ============================================
('Feed', 1, 25000, 'kg', 8000, 15000, 'Silo A - East', '2026-02-28'),
('Feed', 1, 18500, 'kg', 8000, 15000, 'Silo B - West', '2026-02-28'),
('Feed', 2, 12000, 'kg', 5000, 10000, 'Hay Barn - Section 1', '2026-02-27'),
('Feed', 2, 8500, 'kg', 5000, 10000, 'Hay Barn - Section 2', '2026-02-27'),
('Feed', 3, 7500, 'kg', 3000, 6000, 'Feed Shed - Bins 1-3', '2026-03-01'),
('Feed', 4, 4200, 'kg', 2000, 4000, 'Feed Shed - Bins 4-5', '2026-03-01'),
('Feed', 5, 3800, 'kg', 1500, 3000, 'Feed Shed - Bin 6', '2026-02-28'),
('Feed', 6, 1200, 'kg', 500, 1000, 'Mineral Storage', '2026-02-26'),
('Feed', 7, 2800, 'kg', 1000, 2000, 'Feed Shed - Bin 7', '2026-02-28'),
('Feed', 8, 950, 'kg', 300, 600, 'Calf Barn - Starter Area', '2026-03-01'),

-- ============================================
-- MEDICINE INVENTORY (8 entries)
-- ============================================
('Medicine', 1, 18, 'bottles', 10, 20, 'Pharmacy - Shelf A1', '2026-02-25'),
('Medicine', 2, 7, 'bottles', 5, 10, 'Pharmacy - Shelf A2', '2026-02-25'),
('Medicine', 3, 12, 'bottles', 8, 15, 'Refrigerator - Top Shelf', '2026-02-26'),
('Medicine', 4, 22, 'bottles', 10, 20, 'Pharmacy - Shelf B1', '2026-02-27'),
('Medicine', 5, 9, 'bottles', 5, 10, 'Refrigerator - Middle Shelf', '2026-02-26'),
('Medicine', 6, 28, 'bottles', 15, 30, 'Pharmacy - Shelf B2', '2026-02-28'),
('Medicine', 7, 4, 'bottles', 8, 15, 'Refrigerator - Bottom Shelf', '2026-02-27'),
('Medicine', 8, 15, 'bottles', 10, 20, 'Pharmacy - Shelf C1', '2026-02-28'),

-- ============================================
-- SEMEN INVENTORY (6 entries)
-- ============================================
('Semen', 1, 42, 'doses', 20, 40, 'LN2 Tank #1 - Canister A', '2026-02-20'),
('Semen', 2, 28, 'doses', 15, 30, 'LN2 Tank #1 - Canister B', '2026-02-20'),
('Semen', 3, 55, 'doses', 25, 50, 'LN2 Tank #2 - Canister A', '2026-02-21'),
('Semen', 4, 18, 'doses', 10, 20, 'LN2 Tank #2 - Canister B', '2026-02-21'),
('Semen', 5, 35, 'doses', 15, 30, 'LN2 Tank #3 - Canister A', '2026-02-22'),
('Semen', 6, 12, 'doses', 8, 15, 'LN2 Tank #3 - Canister B', '2026-02-22'),

-- ============================================
-- EQUIPMENT SPARE PARTS (6 entries)
-- ============================================
('Equipment', 101, 8, 'units', 4, 8, 'Workshop - Cabinet 1', '2026-02-15'),
('Equipment', 102, 15, 'units', 6, 12, 'Workshop - Cabinet 2', '2026-02-15'),
('Equipment', 103, 3, 'units', 5, 10, 'Workshop - Shelf A', '2026-02-18'),
('Equipment', 104, 22, 'units', 10, 20, 'Workshop - Cabinet 3', '2026-02-18'),
('Equipment', 105, 6, 'units', 4, 8, 'Workshop - Shelf B', '2026-02-20'),
('Equipment', 106, 9, 'units', 5, 10, 'Workshop - Cabinet 4', '2026-02-20');


-- Insert 25 feed inventory records
INSERT INTO Feed_Inventory (feed_id, batch_number, quantity_kg, purchase_date, expiry_date, purchase_price, supplier_id, location, remarks) VALUES
-- ============================================
-- CORN SILAGE (Feed ID: 1)
-- ============================================
(1, 'CS-2025-01', 25000, '2025-05-15', '2026-05-15', 0.38, 1, 'Silo A - East', '2025 harvest - good quality'),
(1, 'CS-2025-02', 22000, '2025-06-20', '2026-06-20', 0.39, 1, 'Silo A - West', 'Summer batch'),
(1, 'CS-2025-03', 28000, '2025-08-10', '2026-08-10', 0.37, 1, 'Silo B - East', 'Main harvest - best quality'),
(1, 'CS-2025-04', 18000, '2025-09-25', '2026-09-25', 0.40, 1, 'Silo B - West', 'Late harvest'),
(1, 'CS-2026-01', 15000, '2026-01-15', '2027-01-15', 0.42, 1, 'Silo C - East', 'Winter order'),

-- ============================================
-- ALFALFA HAY (Feed ID: 2)
-- ============================================
(2, 'AH-2025-01', 12000, '2025-06-05', '2026-06-05', 0.55, 1, 'Hay Barn - Section A', 'First cutting'),
(2, 'AH-2025-02', 10000, '2025-07-18', '2026-07-18', 0.58, 1, 'Hay Barn - Section B', 'Second cutting - premium'),
(2, 'AH-2025-03', 8000, '2025-09-10', '2026-09-10', 0.56, 3, 'Hay Barn - Section C', 'Third cutting'),
(2, 'AH-2026-01', 5000, '2026-02-20', '2027-02-20', 0.60, 1, 'Hay Barn - Section D', 'Winter order'),

-- ============================================
-- DAIRY CONCENTRATE 18% (Feed ID: 3)
-- ============================================
(3, 'DC-2025-01', 8000, '2025-05-10', '2025-11-10', 0.82, 1, 'Feed Shed - Bin 1', 'Spring batch'),
(3, 'DC-2025-02', 7500, '2025-07-15', '2026-01-15', 0.84, 1, 'Feed Shed - Bin 2', 'Summer formula'),
(3, 'DC-2025-03', 9000, '2025-09-20', '2026-03-20', 0.83, 3, 'Feed Shed - Bin 3', 'Fall batch'),
(3, 'DC-2026-01', 6000, '2026-01-25', '2026-07-25', 0.86, 1, 'Feed Shed - Bin 4', 'Winter blend'),

-- ============================================
-- SOYBEAN MEAL (Feed ID: 4)
-- ============================================
(4, 'SBM-2025-01', 5000, '2025-06-12', '2026-06-12', 1.18, 2, 'Feed Shed - Bin 5', 'High protein'),
(4, 'SBM-2025-02', 4500, '2025-08-25', '2026-08-25', 1.22, 2, 'Feed Shed - Bin 5', 'Premium grade'),
(4, 'SBM-2026-01', 3000, '2026-02-05', '2027-02-05', 1.25, 2, 'Feed Shed - Bin 6', 'Recent purchase'),

-- ============================================
-- COTTONSEED (Feed ID: 5)
-- ============================================
(5, 'COT-2025-01', 4000, '2025-07-08', '2026-07-08', 0.70, 3, 'Feed Shed - Bin 7', 'Whole cottonseed'),
(5, 'COT-2025-02', 3500, '2025-09-15', '2026-09-15', 0.72, 3, 'Feed Shed - Bin 7', 'Good quality'),
(5, 'COT-2026-01', 2000, '2026-01-30', '2027-01-30', 0.74, 1, 'Feed Shed - Bin 8', 'New batch'),

-- ============================================
-- MINERAL MIXTURE (Feed ID: 6)
-- ============================================
(6, 'MIN-2025-01', 1200, '2025-05-20', '2026-05-20', 2.35, 2, 'Mineral Storage - Rack A', 'Dairy minerals'),
(6, 'MIN-2025-02', 1000, '2025-08-18', '2026-08-18', 2.40, 2, 'Mineral Storage - Rack B', 'With trace elements'),
(6, 'MIN-2026-01', 800, '2026-02-10', '2027-02-10', 2.45, 2, 'Mineral Storage - Rack A', 'Fresh stock'),

-- ============================================
-- BEET PULP (Feed ID: 7)
-- ============================================
(7, 'BP-2025-01', 3000, '2025-06-25', '2026-06-25', 0.52, 1, 'Feed Shed - Bin 9', 'Shredded beet pulp'),
(7, 'BP-2025-02', 2500, '2025-10-10', '2026-10-10', 0.54, 3, 'Feed Shed - Bin 9', 'Pellets'),
(7, 'BP-2026-01', 1500, '2026-01-20', '2027-01-20', 0.55, 1, 'Feed Shed - Bin 10', 'New stock'),

-- ============================================
-- CALF STARTER (Feed ID: 8)
-- ============================================
(8, 'CS-2025-01', 800, '2025-07-05', '2026-01-05', 1.05, 1, 'Calf Barn - Bin A', 'Medicated starter'),
(8, 'CS-2025-02', 600, '2025-09-12', '2026-03-12', 1.08, 1, 'Calf Barn - Bin B', 'Regular starter'),
(8, 'CS-2026-01', 400, '2026-02-18', '2026-08-18', 1.10, 1, 'Calf Barn - Bin A', 'Fresh batch');

-- Insert 15 feed formula records
INSERT INTO Feed_Formula (formula_name, pen_type, production_stage, total_kg_per_animal, cost_per_kg, is_active) VALUES
-- ============================================
-- MILKING COW FORMULAS
-- ============================================
('High Production Lactation - Holstein', 'Milking', 'Lactation', 25.5, 0.82, 1),
('Medium Production Lactation', 'Milking', 'Lactation', 22.0, 0.76, 1),
('Low Production Lactation', 'Milking', 'Lactation', 18.5, 0.71, 1),
('Jersey Lactation Formula', 'Milking', 'Lactation', 20.0, 0.79, 1),
('Fresh Cow Transition', 'Milking', 'Fresh', 16.0, 0.88, 1),
('Peak Lactation Booster', 'Milking', 'Lactation', 26.0, 0.85, 1),

-- ============================================
-- DRY COW FORMULAS
-- ============================================
('Far-Off Dry Cow', 'Dry', 'Dry period', 12.5, 0.54, 1),
('Close-Up Dry Cow', 'Dry', 'Close-up', 14.0, 0.68, 1),
('Springing Heifer Formula', 'Dry', 'Close-up', 13.0, 0.65, 1),

-- ============================================
-- CALF & HEIFER FORMULAS
-- ============================================
('Calf Starter - 0-3 months', 'Calves', 'Growing', 2.5, 1.12, 1),
('Calf Grower - 3-6 months', 'Calves', 'Growing', 4.5, 0.98, 1),
('Heifer Developer - 6-12 months', 'Calves', 'Growing', 8.0, 0.82, 1),
('Breeding Age Heifer', 'Calves', 'Growing', 11.0, 0.75, 1),

-- ============================================
-- SPECIALTY FORMULAS
-- ============================================
('Hospital Pen Recovery', 'Dry', 'Special Needs', 15.0, 0.91, 1),
('Bull Maintenance', 'Dry', 'Maintenance', 14.5, 0.62, 1),
('Show Animal Premium', 'Milking', 'Special', 22.0, 0.95, 1);

-- Insert feed formula detail records for 15 formulas
INSERT INTO Feed_Formula_Detail (formula_id, feed_id, percentage, kg_per_animal) VALUES
-- ============================================
-- FORMULA 1: High Production Lactation - Holstein
-- ============================================
(1, 1, 40.0, 10.20),  -- Corn Silage
(1, 2, 20.0, 5.10),   -- Alfalfa Hay
(1, 3, 30.0, 7.65),   -- Dairy Concentrate
(1, 4, 5.0, 1.28),    -- Soybean Meal
(1, 6, 2.0, 0.51),    -- Mineral Mixture
(1, 7, 3.0, 0.77),    -- Beet Pulp

-- ============================================
-- FORMULA 2: Medium Production Lactation
-- ============================================
(2, 1, 45.0, 9.90),   -- Corn Silage
(2, 2, 20.0, 4.40),   -- Alfalfa Hay
(2, 3, 25.0, 5.50),   -- Dairy Concentrate
(2, 5, 5.0, 1.10),    -- Cottonseed
(2, 6, 2.0, 0.44),    -- Mineral Mixture
(2, 7, 3.0, 0.66),    -- Beet Pulp

-- ============================================
-- FORMULA 3: Low Production Lactation
-- ============================================
(3, 1, 50.0, 9.25),   -- Corn Silage
(3, 2, 20.0, 3.70),   -- Alfalfa Hay
(3, 3, 20.0, 3.70),   -- Dairy Concentrate
(3, 5, 5.0, 0.93),    -- Cottonseed
(3, 6, 2.0, 0.37),    -- Mineral Mixture
(3, 9, 3.0, 0.56),    -- Wheat Straw

-- ============================================
-- FORMULA 4: Jersey Lactation Formula
-- ============================================
(4, 1, 35.0, 7.00),   -- Corn Silage
(4, 2, 25.0, 5.00),   -- Alfalfa Hay
(4, 3, 25.0, 5.00),   -- Dairy Concentrate
(4, 5, 8.0, 1.60),    -- Cottonseed
(4, 6, 2.5, 0.50),    -- Mineral Mixture
(4, 7, 4.5, 0.90),    -- Beet Pulp

-- ============================================
-- FORMULA 5: Fresh Cow Transition
-- ============================================
(5, 1, 35.0, 5.60),   -- Corn Silage
(5, 2, 20.0, 3.20),   -- Alfalfa Hay
(5, 3, 25.0, 4.00),   -- Dairy Concentrate
(5, 4, 8.0, 1.28),    -- Soybean Meal
(5, 6, 3.0, 0.48),    -- Mineral Mixture
(5, 10, 5.0, 0.80),   -- Molasses
(5, 8, 4.0, 0.64),    -- Calf Starter

-- ============================================
-- FORMULA 6: Peak Lactation Booster
-- ============================================
(6, 1, 35.0, 9.10),   -- Corn Silage
(6, 2, 15.0, 3.90),   -- Alfalfa Hay
(6, 3, 35.0, 9.10),   -- Dairy Concentrate
(6, 4, 8.0, 2.08),    -- Soybean Meal
(6, 5, 4.0, 1.04),    -- Cottonseed
(6, 6, 2.0, 0.52),    -- Mineral Mixture
(6, 10, 1.0, 0.26),   -- Molasses

-- ============================================
-- FORMULA 7: Far-Off Dry Cow
-- ============================================
(7, 1, 50.0, 6.25),   -- Corn Silage
(7, 9, 30.0, 3.75),   -- Wheat Straw
(7, 2, 15.0, 1.88),   -- Alfalfa Hay
(7, 6, 2.0, 0.25),    -- Mineral Mixture
(7, 5, 3.0, 0.38),    -- Cottonseed

-- ============================================
-- FORMULA 8: Close-Up Dry Cow
-- ============================================
(8, 1, 40.0, 5.60),   -- Corn Silage
(8, 9, 25.0, 3.50),   -- Wheat Straw
(8, 2, 15.0, 2.10),   -- Alfalfa Hay
(8, 3, 10.0, 1.40),   -- Dairy Concentrate
(8, 6, 3.0, 0.42),    -- Mineral Mixture
(8, 4, 5.0, 0.70),    -- Soybean Meal
(8, 10, 2.0, 0.28),   -- Molasses

-- ============================================
-- FORMULA 9: Springing Heifer Formula
-- ============================================
(9, 1, 45.0, 5.85),   -- Corn Silage
(9, 2, 20.0, 2.60),   -- Alfalfa Hay
(9, 3, 15.0, 1.95),   -- Dairy Concentrate
(9, 6, 3.0, 0.39),    -- Mineral Mixture
(9, 4, 7.0, 0.91),    -- Soybean Meal
(9, 7, 10.0, 1.30),   -- Beet Pulp

-- ============================================
-- FORMULA 10: Calf Starter - 0-3 months
-- ============================================
(10, 8, 70.0, 1.75),  -- Calf Starter
(10, 2, 15.0, 0.38),  -- Alfalfa Hay (chopped)
(10, 4, 10.0, 0.25),  -- Soybean Meal
(10, 6, 3.0, 0.08),   -- Mineral Mixture
(10, 10, 2.0, 0.05),  -- Molasses

-- ============================================
-- FORMULA 11: Calf Grower - 3-6 months
-- ============================================
(11, 8, 60.0, 2.70),  -- Calf Starter
(11, 2, 20.0, 0.90),  -- Alfalfa Hay
(11, 1, 10.0, 0.45),  -- Corn Silage
(11, 4, 5.0, 0.23),   -- Soybean Meal
(11, 6, 3.0, 0.14),   -- Mineral Mixture
(11, 10, 2.0, 0.09),  -- Molasses

-- ============================================
-- FORMULA 12: Heifer Developer - 6-12 months
-- ============================================
(12, 1, 50.0, 4.00),  -- Corn Silage
(12, 2, 25.0, 2.00),  -- Alfalfa Hay
(12, 3, 15.0, 1.20),  -- Dairy Concentrate
(12, 5, 5.0, 0.40),   -- Cottonseed
(12, 6, 2.5, 0.20),   -- Mineral Mixture
(12, 7, 2.5, 0.20),   -- Beet Pulp

-- ============================================
-- FORMULA 13: Breeding Age Heifer
-- ============================================
(13, 1, 45.0, 4.95),  -- Corn Silage
(13, 2, 25.0, 2.75),  -- Alfalfa Hay
(13, 3, 15.0, 1.65),  -- Dairy Concentrate
(13, 5, 8.0, 0.88),   -- Cottonseed
(13, 6, 2.5, 0.28),   -- Mineral Mixture
(13, 7, 4.5, 0.50),   -- Beet Pulp

-- ============================================
-- FORMULA 14: Hospital Pen Recovery
-- ============================================
(14, 1, 30.0, 4.50),  -- Corn Silage
(14, 2, 20.0, 3.00),  -- Alfalfa Hay
(14, 3, 25.0, 3.75),  -- Dairy Concentrate
(14, 4, 10.0, 1.50),  -- Soybean Meal
(14, 6, 3.0, 0.45),   -- Mineral Mixture
(14, 8, 5.0, 0.75),   -- Calf Starter
(14, 10, 7.0, 1.05),  -- Molasses

-- ============================================
-- FORMULA 15: Bull Maintenance
-- ============================================
(15, 1, 55.0, 7.98),  -- Corn Silage
(15, 9, 25.0, 3.63),  -- Wheat Straw
(15, 2, 10.0, 1.45),  -- Alfalfa Hay
(15, 3, 5.0, 0.73),   -- Dairy Concentrate
(15, 6, 2.0, 0.29),   -- Mineral Mixture
(15, 5, 3.0, 0.44);   -- Cottonseed












WITH MonthlyIncome AS (
    SELECT 
        YEAR(income_date) as Year,
        MONTH(income_date) as Month,
        SUM(CASE WHEN source = 'Milk' THEN amount ELSE 0 END) as milk_income,
        SUM(CASE WHEN source LIKE '%Sale%' THEN amount ELSE 0 END) as animal_sales,
        SUM(amount) as total_income
    FROM Income
    GROUP BY YEAR(income_date), MONTH(income_date)
),
MonthlyExpense AS (
    SELECT 
        YEAR(expense_date) as Year,
        MONTH(expense_date) as Month,
        SUM(CASE WHEN expense_type = 'Feed' THEN amount ELSE 0 END) as feed_cost,
        SUM(CASE WHEN expense_type = 'Medicine' THEN amount ELSE 0 END) as medicine_cost,
        SUM(CASE WHEN expense_type = 'Labor' THEN amount ELSE 0 END) as labor_cost,
        SUM(CASE WHEN expense_type = 'Electricity' THEN amount ELSE 0 END) as electricity_cost,
        SUM(amount) as total_expense
    FROM Expense
    GROUP BY YEAR(expense_date), MONTH(expense_date)
)
SELECT 
    COALESCE(i.Year, e.Year) as Year,
    COALESCE(i.Month, e.Month) as Month,
    ISNULL(i.milk_income, 0) as milk_income,
    ISNULL(i.animal_sales, 0) as animal_sales,
    ISNULL(i.total_income, 0) as total_income,
    ISNULL(e.feed_cost, 0) as feed_cost,
    ISNULL(e.medicine_cost, 0) as medicine_cost,
    ISNULL(e.labor_cost, 0) as labor_cost,
    ISNULL(e.electricity_cost, 0) as electricity_cost,
    ISNULL(e.total_expense, 0) as total_expense,
    ISNULL(i.total_income, 0) - ISNULL(e.total_expense, 0) as profit,
    CASE 
        WHEN ISNULL(i.total_income, 0) > 0 
        THEN (ISNULL(i.total_income, 0) - ISNULL(e.total_expense, 0)) / ISNULL(i.total_income, 0) * 100 
        ELSE 0 
    END as profit_margin_percent
FROM MonthlyIncome i
FULL OUTER JOIN MonthlyExpense e ON i.Year = e.Year AND i.Month = e.Month
WHERE COALESCE(i.Year, e.Year) = 2026
ORDER BY Year, Month;