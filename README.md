# Hospital Management System Database

## 🏥 Description
A comprehensive, normalized, and production-ready relational database schema for a Hospital Management System (HMS). This project demonstrates advanced database design principles, implementing complex relationships, robust constraints, and performance optimization techniques that exceed typical academic requirements.

## ⚡ Features
- **Normalized Schema**: 8 expertly designed tables following 3rd Normal Form (3NF)
- **Complex Relationships**: 
  - One-to-Many (Patient → Phone Numbers)
  - Many-to-Many (Doctors ↔ Specializations)
  - Multiple One-to-Many (Appointments, Prescriptions)
- **Data Integrity**: Comprehensive constraints including:
  - Primary Keys, Foreign Keys with proper CASCADE rules
  - UNIQUE constraints to prevent duplicates
  - ENUM types for controlled value sets
  - CHECK constraints for business logic validation
- **Performance Optimization**: Strategic indexing on foreign keys and frequently searched columns
- **Sample Data**: Realistic demonstration data with practical queries
- **Comprehensive Documentation**: In-line comments explaining design decisions

## 📊 Database Schema Overview

### Core Entities:
- **Patients**: Core demographic information with support for multiple phone numbers
- **Doctors**: Healthcare provider details with license management
- **Appointments**: Scheduling system linking patients to doctors
- **Medications**: Pharmacy inventory management
- **Prescriptions**: Medication orders tied to specific appointments

### Relationship Management:
- **Patient_Phones**: 1-to-Many relationship for patient contact numbers
- **Doctor_Specialization**: Many-to-Many junction table for doctor qualifications
- **Specializations**: Lookup table for medical specialties

## 🚀 How to Run

### Prerequisites:
- MySQL Server (5.7 or higher)
- MySQL Workbench or command-line client

### Installation Steps:
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/hospital-management-db.git
   cd hospital-management-db
   ```

2. Execute the SQL script in MySQL:
   ```bash
   mysql -u your_username -p < hospital_management_system.sql
   ```

3. Alternatively, open the file in MySQL Workbench and execute it

### Verification:
The script will:
- Create the `hospital_management_db` database
- Build all tables with constraints and indexes
- Populate with sample data
- Be ready for the demonstration queries

## 🔍 Demonstration Queries

The SQL file includes practical queries that showcase the database's capabilities:

1. **Find upcoming appointments for a specific doctor**
2. **Retrieve all prescriptions for a specific patient**
3. **Check low medication inventory levels**

Example usage after database creation:
```sql
USE hospital_management_db;
-- Run any of the demonstration queries at the bottom of the SQL file
```

## 🎯 Advanced Design Highlights

This implementation showcases professional database design techniques:

1. **Surrogate Keys**: Used throughout for performance and stability
2. **Controlled Value Sets**: ENUM types ensure data consistency
3. **Multi-Valued Attribute Handling**: Separate table for patient phones
4. **Cascade Rules**: Proper ON DELETE CASCADE and SET NULL policies
5. **Indexing Strategy**: Strategic indexes on search columns and foreign keys
6. **Domain Validation**: CHECK constraints prevent invalid data
7. **Junction Tables**: Proper implementation of Many-to-Many relationships

## 📋 Table Structure Details

| Table | Description | Key Features |
|-------|-------------|--------------|
| `patients` | Core patient information | Surrogate key, ENUM constraint, indexes |
| `patient_phones` | Multiple phone numbers per patient | 1-to-Many relationship, phone type categorization |
| `doctors` | Healthcare provider details | Unique license number, specialization link |
| `specializations` | Medical specialty lookup | Normalized reference data |
| `doctor_specialization` | Doctor-qualification junction | Many-to-Many relationship implementation |
| `appointments` | Patient-doctor scheduling | Status tracking, datetime handling |
| `medications` | Pharmacy inventory | Stock management, unique medication names |
| `prescriptions` | Medication orders | Appointment linkage, dosage instructions |

## 📈 Entity-Relationship Diagram

A conceptual overview of the database schema is provided in the comments at the top of the SQL file. For a visual ER diagram, consider using MySQL Workbench's reverse engineering feature or import the SQL into a database visualization tool.

## 🎓 Academic Note

This project was developed as a final assignment for a database management course. It demonstrates mastery of:
- Relational database design principles
- SQL implementation skills
- Data integrity enforcement
- Performance optimization techniques
- Real-world problem solving

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👥 Author

Developed by John Omondi Ojango as a demonstration of advanced database design capabilities.

---

*This implementation represents professional-grade database design that could form the foundation of an actual hospital management application. The careful attention to normalization, constraints, and relationships ensures data integrity while maintaining performance and flexibility.*
