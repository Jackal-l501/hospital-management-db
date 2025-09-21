# Hospital Management System Database

## Description
A comprehensive, normalized, and production-ready relational database schema for a Hospital Management System (HMS). Designed with data integrity, performance, and real-world complexity in mind.

## Features
- **8 Normalized Tables:** Eliminates data redundancy.
- **Advanced Relationships:** Implements One-to-Many (Patient -> Phones) and Many-to-Many (Doctors <-> Specializations) relationships correctly.
- **Robust Constraints:** Uses `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `ENUM`, and `CHECK` constraints to ensure data validity.
- **Performance Optimized:** Includes strategic indexing on foreign keys and search columns.
- **Sample Data & Queries:** Pre-populated with sample data and practical demonstration queries.

## How to Run
1.  Open MySQL Command Line, Workbench, or your preferred SQL client.
2.  Execute the entire SQL script (`hospital_management_system.sql`).
3.  The script will automatically:
    - Drop the existing database (if any).
    - Create a new `hospital_management_db` database.
    - Build all tables, constraints, and indexes.
    - Populate the database with sample data.
4.  Run the demonstration queries at the bottom of the script to see it in action.

## Entity-Relationship Diagram (ERD)
A conceptual overview of the database schema is provided in the comments at the top of the SQL file.
