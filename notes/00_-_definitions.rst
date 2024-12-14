Basic Definitions
-----------------
Data

  Output from a sensing device or organ that includes both useful and
  irrelevant or redundant information and must be processed to be turned
  into meaningful information.

  Raw, unprocessed facts or values that lack context or meaning.

  Data can very in several important ways.

  * Scope: The amount of data, or the area of concern.
  * Format: Text, image, audio, video, binary, etc.
  * Access: Private vs public, etc.

DB (Database)

  Data stored in a structured format.

DBMS (Database Management System)

  Software that reads from, write to, and manages databases.

Query

  A request to retrieve or change data in a database.

Query Language

  A specialized programming language designed specifically for database systems.

SQL (Structured Query Language)

  A domain specific language for working with relational databases.

  SQL is divided into five sublanguages.

  * **DDL (Data Definition Language)** defines the structure of the database.

    CREATE, ALTER, DROP, TRUNCATE

  * **DQL (Data Query Language)** retrieves data from the database.

    SELECT

  * **DML (Data Manipulation Language)** manipulates data stored in a database.

    INSERT, UPDATE, DELETE

  * **DCL (Data Control Language)** controls database user access.

    GRANT, REVOKE

  * **DTL (Data Transaction Language)** manages database transactions.

    BEGIN, COMMIT, ROLLBACK

Database Application

  Software that helps business users interact with database systems.

Information Management System

  An application that manages data for a specific business function.

Entity

  Anything we store data about.

Attribute

  Data about an entity.

Entity Integrity

  Ensures that each fow in a table is uniquely identifiable.
  This is achieved by enforcing a constraint on the primary key of the table.

  1. Every table must have a primary key.
  2. The primary key must have unique values.
  3. The primary key cannot contain NULL values.

Referential Integrity

  Referential integrity refers to the accuracy and consistency of 
  data within a relationship.

  Referential integrity requires that whenever a foreign key value
  is used it must reference a valid, existing primary key in the
  parent table.

  Referential integrity will prevent users from:

  * Adding rows to a related table if there is no associated row in the primary
    table.

  * Changing values in a primary table that result in orphaned records in a
    related table.

  * Deleting rows from a primary table if there are matching related rows.

Domain Integrity

  Domain integrity is a concept in database management that ensures the values
  stored in a column are valid, consistent, and within a predefined set of rules.
  It is one of the fundamental principles of data integrity and is enforced
  through constraints and data types.

  Constraints include things such as UNIQUE, NOT NULL, CHECK, UNIQUE, or DEFAULT.

  ::

    -- Create a table with various constraints

    CREATE TABLE employees (
        id SERIAL PRIMARY KEY,       -- PRIMARY KEY: Ensures unique ID for each row
        email VARCHAR(255) UNIQUE,   -- UNIQUE: Ensures email addresses are not duplicated
        name VARCHAR(100) NOT NULL,  -- NOT NULL: Ensures name cannot be null
        age INT CHECK (age > 18),    -- CHECK: Ensures age is greater than 18
        department_id INT DEFAULT 1, -- DEFAULT: Provides a default value if none is specified
        hire_date DATE NOT NULL,     -- NOT NULL: Ensures hire_date cannot be null
        FOREIGN KEY (department_id) REFERENCES departments(id) -- FOREIGN KEY: Links to departments table
    );

Database Models

  A conceptual framework for database systems, with three parts:

  * Datastructures the prescribe how data is organized.
  * Operations that manipulate datastructures.
  * Rules that govern valid data.

View

  A view is a virtual table based on teh result of
  a SELECT query. It doesn't store data itself but
  presents data dynamically from underlying tables
  whenever accessed.

  ::

    CREATE VIEW employee_view AS
    SELECT id, name, age
    FROM employees
    WHERE age > 30;

Types of Relationships

  * One-to-one
  * One-to-many
  * Many-to-many

Key

  * Never NULL
  * Unique
  * Never changes

Superkey

  A set of attributes that can uniquely identify a row in a table
  when considered together.
  It's a broader concept than a primary key, as it may contain extra
  attributes beyond what is strictly neccessary for uniqueness.

Primary Key

  A column or set of columns in a database that uniquely identifies each row in the table.
  Primary keys must be unique, non-null, and immutable (it never changes).
  Primary keys can be composed from a single column, in which case it's called a single
  primary key, or from many columns, in which case it's called a composite primary key.

  Here's an example of creating a single primary key::

    create table employees (
      employee_id serial primary key,
      uname varchar(100),
      age int
    );

  Here's an example of creating a composite primary key::

    create table project_assignments (
      employee_id int,
      project_id int,
      primary key (employee_id, project_id)
    );

Foriegn Key

  A reference to a primary key from another table.

  ::

    CREATE TABLE order_items (
        id SERIAL PRIMARY KEY,
        order_id INT REFERENCES orders(order_id)
    );

Reflexive Relationship

  A reflexive relationship relates an entity to itself.

Entity Type

  An entity type is a set of things.

Relationship type

  A relationship type is a set of related things.

Attribute Type

  An attribute type is a set of related values.

Entity Instance

  An entity instance is an individual thing.
