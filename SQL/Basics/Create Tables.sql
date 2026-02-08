--Column name verification
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'StagingAppointments';
GO

--Create Statements (6 tables)
USE CounsellingManagement;
GO

-- Table 1: Therapists
CREATE TABLE Therapists (
    therapist_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    years_experience INT CHECK (years_experience >= 0),
    hourly_rate DECIMAL(10,2),
    availability_status VARCHAR(20) DEFAULT 'Available'
);
GO

-- Table 2: Clients
CREATE TABLE Clients (
    client_id BIGINT PRIMARY KEY,
    age INT CHECK (age >= 0),
    gender VARCHAR(10),
    neighbourhood VARCHAR(100),
    insurance_provider VARCHAR(50),
    registration_date DATE,
    assigned_therapist_id INT,
    FOREIGN KEY (assigned_therapist_id) REFERENCES Therapists(therapist_id)
);
GO

-- Index for foreign key
CREATE INDEX idx_clients_therapist ON Clients(assigned_therapist_id);
GO

-- Table 3: Appointments
CREATE TABLE Appointments (
    appointment_id BIGINT PRIMARY KEY,
    client_id BIGINT NOT NULL,
    therapist_id INT NOT NULL,
    appointment_date DATETIME,
    duration_minutes INT CHECK (duration_minutes > 0),
    session_type VARCHAR(20),
    status VARCHAR(20),
    cancellation_reason VARCHAR(200),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (therapist_id) REFERENCES Therapists(therapist_id)
);
GO

-- Indexes for foreign keys
CREATE INDEX idx_appointments_client ON Appointments(client_id);
CREATE INDEX idx_appointments_therapist ON Appointments(therapist_id);
CREATE INDEX idx_appointments_date ON Appointments(appointment_date);
GO

-- Table 4: Treatment Plans
CREATE TABLE TreatmentPlans (
    plan_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id BIGINT NOT NULL,
    therapist_id INT NOT NULL,
    diagnosis VARCHAR(200),
    treatment_goals VARCHAR(500),
    start_date DATE,
    end_date DATE,
    plan_status VARCHAR(20),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (therapist_id) REFERENCES Therapists(therapist_id)
);
GO

CREATE INDEX idx_treatment_client ON TreatmentPlans(client_id);
GO

-- Table 5: Session Notes
CREATE TABLE SessionNotes (
    note_id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id BIGINT NOT NULL,
    session_summary VARCHAR(1000),
    progress_rating INT CHECK (progress_rating BETWEEN 1 AND 10),
    next_steps VARCHAR(500),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

CREATE INDEX idx_notes_appointment ON SessionNotes(appointment_id);
GO

-- Table 6: Billing
CREATE TABLE Billing (
    billing_id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id BIGINT NOT NULL,
    amount_charged DECIMAL(10,2),
    insurance_coverage DECIMAL(10,2),
    patient_responsibility DECIMAL(10,2),
    payment_status VARCHAR(20),
    payment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
GO

CREATE INDEX idx_billing_appointment ON Billing(appointment_id);
GO

--Confirm tables exist
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;