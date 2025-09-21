-- ==================================================================================
-- Hospital Management System (HMS) Database Schema
-- Author: [Your Name]
-- Description: A comprehensive, normalized database for managing patients, doctors,
--              appointments, prescriptions, and inventory. Designed for data integrity
--              and performance.
-- ==================================================================================

-- Create the database. Drop it first if it exists for a clean slate.
DROP DATABASE IF EXISTS hospital_management_db;
CREATE DATABASE hospital_management_db;
USE hospital_management_db;

-- 1. Table `patients`
-- Core entity for storing patient demographic information.
CREATE TABLE patients (
    patient_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Surrogate key for efficiency and stability
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL, -- Constrained values for consistency
    primary_phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE, -- Email must be unique if provided
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Index on last_name and first_name for faster search in patient lookups
    INDEX idx_patient_name (last_name, first_name),
    -- Index on email as it's likely used for login/lookups
    INDEX idx_email (email)
) COMMENT='Stores core patient information';

-- 2. Table `patient_phones`
-- Purpose: To handle multiple phone numbers for a single patient (1-to-Many relationship).
-- This is a normalization best practice for multi-valued attributes.
CREATE TABLE patient_phones (
    phone_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id INT UNSIGNED NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    phone_type ENUM('Home', 'Mobile', 'Work', 'Emergency') NOT NULL DEFAULT 'Mobile',
    
    -- A patient can't have the same phone number listed twice
    UNIQUE KEY unique_patient_phone (patient_id, phone_number),
    
    -- Foreign key constraint with ON DELETE CASCADE: if a patient is deleted, their phones are too.
    CONSTRAINT fk_patient_phones FOREIGN KEY (patient_id)
        REFERENCES patients (patient_id) ON DELETE CASCADE,
        
    INDEX idx_phone_number (phone_number) -- For searching by phone number
) COMMENT='Stores multiple phone numbers for a single patient';

-- 3. Table `specializations`
-- Lookup table for doctor specializations (e.g., Cardiology, Neurology).
-- Helps maintain data consistency and avoids free-text entry errors.
CREATE TABLE specializations (
    specialization_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    specialization_name VARCHAR(100) NOT NULL UNIQUE
) COMMENT='Lookup table for medical specializations';

-- 4. Table `doctors`
-- Core entity for storing healthcare provider information.
CREATE TABLE doctors (
    doctor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE, -- Natural key, must be unique
    hire_date DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    primary_phone VARCHAR(15) NOT NULL,
    -- Assuming a doctor has one primary specialization. For multiple, see the junction table.
    primary_specialization_id SMALLINT UNSIGNED, 
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_doctor_specialization FOREIGN KEY (primary_specialization_id)
        REFERENCES specializations (specialization_id) ON DELETE SET NULL, -- If a specialization is deleted, set this to NULL instead of cascading.
        
    INDEX idx_doctor_name (last_name, first_name)
) COMMENT='Stores core doctor information';

-- 5. Table `doctor_specialization`
-- Junction table to handle the Many-to-Many relationship between Doctors and Specializations.
-- A doctor can have many specializations, and a specialization can have many doctors.
CREATE TABLE doctor_specialization (
    doctor_id INT UNSIGNED NOT NULL,
    specialization_id SMALLINT UNSIGNED NOT NULL,
    
    -- The combination of doctor_id and specialization_id must be unique.
    PRIMARY KEY (doctor_id, specialization_id),
    
    CONSTRAINT fk_docspec_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctors (doctor_id) ON DELETE CASCADE,
    CONSTRAINT fk_docspec_specialization FOREIGN KEY (specialization_id)
        REFERENCES specializations (specialization_id) ON DELETE CASCADE
) COMMENT='Junction table managing the many-to-many relationship between doctors and specializations';

-- 6. Table `appointments`
-- The heart of the scheduling system. Links patients to doctors.
CREATE TABLE appointments (
    appointment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id INT UNSIGNED NOT NULL,
    doctor_id INT UNSIGNED NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    -- ENUM ensures only valid statuses can be entered.
    status ENUM('Scheduled', 'Completed', 'Cancelled by Patient', 'Cancelled by Hospital', 'No-Show') NOT NULL DEFAULT 'Scheduled',
    reason_for_visit TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
        REFERENCES patients (patient_id) ON DELETE CASCADE,
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctors (doctor_id) ON DELETE CASCADE,
        
    -- Composite index for quickly finding all appointments for a doctor on a given day.
    INDEX idx_doctor_date (doctor_id, appointment_date),
    -- Composite index for quickly finding all appointments for a patient.
    INDEX idx_patient_date (patient_id, appointment_date)
) COMMENT='Manages all patient-doctor appointments';

-- 7. Table `medications`
-- Master list of all medications the hospital pharmacy stocks.
-- Acts as a lookup table to ensure consistency in prescription names.
CREATE TABLE medications (
    medication_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(255) NOT NULL UNIQUE, -- e.g., "Amoxicillin 500mg Tablet"
    description TEXT,
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0), -- Prevent negative stock
    last_restocked_date DATE
) COMMENT='Master inventory list of medications';

-- 8. Table `prescriptions`
-- Records medications prescribed during a specific appointment.
CREATE TABLE prescriptions (
    prescription_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    appointment_id BIGINT UNSIGNED NOT NULL, -- Ties the prescription to the specific visit
    medication_id INT UNSIGNED NOT NULL,     -- References the medication master list
    dosage VARCHAR(100) NOT NULL,            -- e.g., "500mg"
    quantity_prescribed INT UNSIGNED NOT NULL CHECK (quantity_prescribed > 0),
    instructions TEXT NOT NULL,              -- e.g., "Take twice daily for 7 days"
    prescribed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- A prescription is uniquely linked to an appointment and a specific medication.
    -- Prevents the same medication from being accidentally added twice for one appointment.
    UNIQUE KEY unique_appointment_medication (appointment_id, medication_id),
    
    CONSTRAINT fk_prescription_appointment FOREIGN KEY (appointment_id)
        REFERENCES appointments (appointment_id) ON DELETE CASCADE,
    CONSTRAINT fk_prescription_medication FOREIGN KEY (medication_id)
        REFERENCES medications (medication_id) ON DELETE CASCADE
) COMMENT='Records prescriptions issued during appointments';

-- ==================================================================================
-- SAMPLE DATA INSERTION
-- Populating the database with sample data to demonstrate functionality.
-- ==================================================================================

-- Insert specializations
INSERT INTO specializations (specialization_name) VALUES
('Cardiology'),
('Neurology'),
('Pediatrics'),
('Orthopedics'),
('Dermatology');

-- Insert sample patients
INSERT INTO patients (first_name, last_name, date_of_birth, gender, primary_phone, email, address) VALUES
('John', 'Doe', '1985-07-19', 'Male', '555-123-4567', 'john.doe@email.com', '123 Main St, Anytown, USA'),
('Jane', 'Smith', '1990-04-22', 'Female', '555-987-6543', 'jane.smith@email.com', '456 Oak Ave, Somewhere, USA');

-- Insert multiple phones for John Doe
INSERT INTO patient_phones (patient_id, phone_number, phone_type) VALUES
(1, '555-123-4567', 'Mobile'),
(1, '555-888-9999', 'Work');

-- Insert doctors
INSERT INTO doctors (first_name, last_name, license_number, hire_date, email, primary_phone, primary_specialization_id) VALUES
('Alice', 'Williams', 'MD123456', '2015-06-10', 'a.williams@hospital.com', '555-555-1001', 1), -- Cardiology
('Robert', 'Chen', 'MD654321', '2018-03-15', 'r.chen@hospital.com', '555-555-1002', 2);        -- Neurology

-- Assign multiple specializations to Dr. Chen (Many-to-Many)
INSERT INTO doctor_specialization (doctor_id, specialization_id) VALUES
(2, 2), -- Neurology
(2, 3); -- Pediatrics

-- Schedule appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason_for_visit) VALUES
(1, 1, '2023-10-26', '10:00:00', 'Completed', 'Routine heart checkup and occasional chest pain.'),
(2, 2, '2023-10-27', '14:30:00', 'Scheduled', 'Persistent headaches and dizziness.');

-- Add medications to inventory
INSERT INTO medications (medication_name, description, stock_quantity) VALUES
('Atorvastatin 20mg', 'Tablet, 30 count bottle', 50),
('Sumatriptan 50mg', 'Tablet, 9 count package', 25);

-- Record prescriptions from the completed appointment
INSERT INTO prescriptions (appointment_id, medication_id, dosage, quantity_prescribed, instructions) VALUES
(1, 1, '20mg', 1, 'Take one tablet by mouth daily.');

-- ==================================================================================
-- DEMONSTRATION QUERIES
-- Example queries to showcase the database's capabilities.
-- ==================================================================================

-- Query 1: Find all upcoming appointments for a specific doctor (Dr. Alice Williams) with patient details.
SELECT 
    a.appointment_date,
    a.appointment_time,
    a.status,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.primary_phone
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE d.doctor_id = 1
    AND a.appointment_date >= CURDATE()
    AND a.status = 'Scheduled'
ORDER BY a.appointment_date, a.appointment_time;

-- Query 2: Find all prescriptions for a specific patient (John Doe).
SELECT 
    pat.first_name,
    pat.last_name,
    med.medication_name,
    pres.dosage,
    pres.instructions,
    app.appointment_date,
    CONCAT(dr.first_name, ' ', dr.last_name) AS prescribed_by
FROM prescriptions pres
JOIN appointments app ON pres.appointment_id = app.appointment_id
JOIN patients pat ON app.patient_id = pat.patient_id
JOIN medications med ON pres.medication_id = med.medication_id
JOIN doctors dr ON app.doctor_id = dr.doctor_id
WHERE pat.patient_id = 1;

-- Query 3: Check medication inventory levels that are low (below 10 units).
SELECT medication_name, stock_quantity
FROM medications
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC;