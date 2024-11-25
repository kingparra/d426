2.1 Relational model
--------------------

Database models
^^^^^^^^^^^^^^^
A database model is a conceptual framework for database systems, with three parts:

* Datastructures that prescribe how data is organized.
* Operations that manipulate datastructures.
* Rules that govern valid data.

The **relational model** is a database model based on a tabluar datastructure.
The model was published in 1970 by Edgar Frank Codd in a paper called "A
Relational Model of Data for Large Shared Data Banks" in Communications of the ACM.

Relational datastructure
^^^^^^^^^^^^^^^^^^^^^^^^
* A **table** has a name, a fixed tuple of columns, and a varying set of rows.
* A **column** has a name and a data type.
* A **row** is an unnamed tuple of values.
  Each value corresponds to a column and belongs to the column's data type.
* A **datatype** is a named set of values, from which column values are drwan.

Since a table is a set of rows, the rows have no inherent order.

Relational operations
^^^^^^^^^^^^^^^^^^^^^
Like the relational datastructure, relational operations are based on set theory.
Each operation generates a result table from one or two input tables.

* **select** selects a subset of rows in a table.

* **project** eliminates one or more columns of a table.

* **product** lists all combinations of rows of two tables.

* **join** combines two tables by comparing related columns.

* **union** selects all rows of two tables.

* **intersect** selects rows common to two tables.

* **difference** selects rows that appear in one table but not another.

* **rename** changes a tables name.

* **aggregate** computes functions over multiple table rows, such as sum and count.

The operations are collectively called **relational algebra** and are the
theoretical foundation of the SQL language.
Since the result of relational operations is always a table, the result of
a SQL query is also a table.

Relational rules
^^^^^^^^^^^^^^^^
Rules are logical constraints that ensure data is valid.

**Relational rules** are part of the relational model and govern data in every relational database.

* **Unique primary key**. All tables have a primary key column, or group of
  columns, in which values may not repeat.
* **Unique column names**. Different columns of the same table have different names.
* **No duplicate rows**. No two rows of the same table have identical values in all columns.

**Business rules** are based on business policy and are specific to a particular database.
Ex: All rows of the Employee table must have a valid entry in the DepartCode column.

Relational rules are implemented as SQL **constraints** and enforced by the database system.

::

  create table Task (
    ...
    foreign key (EmployeeID) references Employee (ID)
      on delete cascade
    ...
  );


2.2 Structured Query Language
-----------------------------
SQL is a set-based declarative programming language specialized for working with databases.

Literals
^^^^^^^^
::

  -- Numeric
  127
  12345.67
  3.14E1
  B'1010'
  X'48656C6C6F'

  -- Strings
  'Hello'

  -- Dates
  '2024-11-16'
  '2024-11-16 14:30:00'
  '14:30:00'
  2024 -- YEAR: Year (4 digits)

  -- JSON
  '{ "name": "Alice", "age": 30 }'

  -- Boolean
  TRUE
  FALSE

  -- ENUM and SET Types
  'medium'  -- ENUM('small', 'medium', 'large'): Chosen value
  'a,b,d'   -- SET('a', 'b', 'c', 'd'): Multiple values

SQL Sublanguages
^^^^^^^^^^^^^^^^
SQL is divided into file sublanguages:

* **DDL (Data Definition Language)** defines the structure of the database.
* **DQL (Data Query Language)** retrieves data from the database.
* **DML (Data Manipulation Language)** manipulates data stored in a database.
* **DCL (Data Control Language)** controls database user access.
* **DTL (Data Transaction Language)** manages database transactions.


2.3 Managing databases
----------------------

Create and delete databases
^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

  create database pet_store;
  drop database pet_store;

Showing things
^^^^^^^^^^^^^^
These commands seem to be specific to MySQL (they don't work in PostgreSQL).
::

  -- List all databases
  show databases;
  -- Use the world database for subesequent queries
  use world;

  show tables;
  show columns;
  show create table;


2.4 Tables
----------

Tables, columns, and rows
^^^^^^^^^^^^^^^^^^^^^^^^^
* A **table** has a name, a fixed sequence of columns, and a varying set of rows.
* A **column** has a name and a data type.
* A **row** is an unnamed sequence of values.
  Each value corresponds to a column and belongs to the column's datatype.
* A **cell** is a single column of a single row.

A table must have at least one column but can have any number of rows.
A table without rows is called an empty table.

Rules governing tables
^^^^^^^^^^^^^^^^^^^^^^
1. Exactly one value per cell.
2. No duplicate column names.
3. No duplicate rows.
4. No row order. (data independence)

Creating and deleting tables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
https://dev.mysql.com/doc/refman/8.0/en/create-table.html
https://dev.mysql.com/doc/refman/8.0/en/drop-table.html

::

  create table Employee (
    ID int,
    Name varchar(60),
    BirthDate date,
    Salary decimal(7,2)
  );
  
  drop table Employee;


Altering tables
^^^^^^^^^^^^^^^
You can use an ALTER statement to add, delete, or midify columns on an existing table.
https://dev.mysql.com/doc/refman/8.0/en/alter-table.html

::

  alter table TableName add ColName DataType;

  alter table TableName change CurrColName NewColName NewDataType;

  alter table TableName drop ColName;


2.5 Datatypes
-------------
* **Integer** types represent positive and negative whole numbers.
  INTEGER, SMALLINT.
* **Decimal** types represent numbers with fractional values.
  Decimal datatypes vary by number of digits after the decimal point and maximum size.
  FLOAT, DECIMAL.
* **Character** CHAR, VARCHAR.
* **Date and time** DATE, TIME, DATETIME, TIMESTAMP.
* **Binary** BLOB, BINARY, VARBINARY, IMAGE.
* **Spatial** store geometric information such as lines, polygons, and map coordinates.
  POLYGON, POINT, GEOMETRY.
* **Document** XML, JSON

.. topic:: Can you create user-defined types in SQL?

   Yes, here are a few examples::

     create type job_role as enum ('Manager', 'Developer', 'Tester');

     create type address as (
       street varchar(100),
       city   varchar(50),
       zip_code varchar(10)
     );


2.6 Selecting rows
------------------

Operators
^^^^^^^^^
::

  + - * / ^ = != <> < <= > >= and or not

Expressions
^^^^^^^^^^^
Expressions are strings of operators, operands, and parentheses that evaluate to a single value.
Operands may be column names or fixed values.

Selecting rows
^^^^^^^^^^^^^^
The select statement evaluates an expression and returns a set of rows called the result table.

::

  SELECT expression FROM tablename;

  select first_name as "First Name", last_name as "Last Name" from actor;

  select count(*) from inventory;

  select actor_id, first_name, last_name, last_update from actor;


2.7 Null values
---------------
Null is a special value that represents either unknown or inapplicable data.

Testing for null
^^^^^^^^^^^^^^^^
You cannot use arithmetic comparison operators such as =, <, or <> to test for NULL.

::

  mysql> SELECT 1 = NULL, 1 <> NULL, 1 < NULL, 1 > NULL;
  +----------+-----------+----------+----------+
  | 1 = NULL | 1 <> NULL | 1 < NULL | 1 > NULL |
  +----------+-----------+----------+----------+
  |     NULL |      NULL |     NULL |     NULL |
  +----------+-----------+----------+----------+

To test for NULL, use the IS NULL and IS NOT NULL operators.

::

  mysql> SELECT 1 IS NULL, 1 IS NOT NULL;
  +-----------+---------------+
  | 1 IS NULL | 1 IS NOT NULL |
  +-----------+---------------+
  |         0 |             1 |
  +-----------+---------------+

You can also use coalesce(). The coalesce() function takes a varying number of
arguments, checks each for null from left to right, and returns the first non-NULL
argument.

::

  mysql> select coalesce(NULL, NULL, 'First non-NULL');
  'First non-NULL'

  mysql> SELECT COALESCE(bonus, salary * 0.1, 0) AS effective_bonus FROM employees;
  -- Uses 'bonus', or falls back to 'salary * 0.1', or 0.

Here's an example of using a case expression to check for a NULL

::

  -- Example: Conditional result for bonuses
  SELECT
      name,
      salary,
      CASE
          WHEN bonus IS NOT NULL THEN salary + bonus
          ELSE salary
      END AS total_compensation
  FROM employees;

Null in arithmetic
^^^^^^^^^^^^^^^^^^
**The result of any arithmetic comparison with NULL is also NULL.**

::

  mysql> select 1 + NULL;
  NULL
  mysql> select NULL = NULL;
  NULL

Null is a falesy value
^^^^^^^^^^^^^^^^^^^^^^
In MySQL, 0 or NULL means false and enything else means true.

::

  NULL    AND   TRUE    =   NULL
  TRUE    AND   NULL    =   NULL
  NULL    OR    TRUE    =   TRUE
  TRUE    OR    NULL    =   TRUE
  FALSE   AND   NULL    =   FALSE
  NULL    AND   FALSE   =   FALSE
  NULL    AND   NULL    =   NULL
  NULL                  =   NULL
  NOT NULL              =   NULL

Behavior of null in aggregations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Two NULL values are regarded as equal in a GROUP BY.
When doing an ORDER BY, the NULL values are presented first 
if you do ORDER BY .. ASC and last if you do ORDER BY ... DESC.

Common errors when working with null values
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
**A common error when working with NULL is to assume that it's not possible to
insert a zero or an empty string into a column defined as NOT null, but this
is not the case.** these are in fact non-NULL values.

Creating columns that cannot be null
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

  create table Employee (
    ID smallint unsigned,
    Name varchar(60) not null,
    BirthDate date,
    Salary decimal(7,2)
  );


2.8 Inserting, updating, and deleting rows
------------------------------------------
Insert
::

  -- Basic INSERT syntax
  INSERT INTO table_name (col1, col2, ...)
  VALUES (val1, val2, ...);


Create
::

  -- Default values
  CREATE TABLE employee_with_defaults (
    id SMALLINT UNSIGNED,
    name VARCHAR(60),
    birth_date DATE DEFAULT '2000-01-01',
    salary DECIMAL(7,2) DEFAULT 0.00
  );

Update
https://dev.mysql.com/doc/refman/8.0/en/update.html
::

  -- Change a value
  UPDATE table_name
  SET col1 = val1, col2 = val2, col3 = val3, ...
  WHERE condition;

Alter
::

  -- Add a column
  ALTER TABLE table_name
  ADD COLUMN col_name CHAR(2);

  -- Rename a column
  ALTER TABLE table_name
  CHANGE username user_name VARCHAR(50);

  -- Change the column datatype
  ALTER TABLE table_name
  MODIFY COLUMN sex CHAR(1);

  -- Add a NOT NULL constraint to a column
  ALTER TABLE table_name
  MODIFY COLUMN sex CHAR(1) NOT NULL;

  -- Remove a column
  ALTER TABLE table_name
  DROP COLUMN col_name;

  -- Add primary key
  ALTER TABLE table_name
  ADD PRIMARY KEY (col_name);

  -- Drop primary key
  ALTER TABLE table_name
  DROP PRIMARY KEY;

  -- Add index
  ALTER TABLE table_name
  ADD INDEX index_name (col_name);

  -- Drop index
  ALTER TABLE table_name
  DROP INDEX index_name;

  -- Add unique key
  ALTER TABLE table_name
  ADD UNIQUE (col_name);

  -- Drop unique key
  ALTER TABLE table_name
  DROP INDEX unique_key_name;

  -- Add foreign key
  ALTER TABLE table_name
  ADD CONSTRAINT fk_name
  FOREIGN KEY (col_name)
  REFERENCES referenced_table (referenced_col);

  -- Drop foreign key
  ALTER TABLE table_name
  DROP FOREIGN KEY fk_name;

  -- Rename table
  ALTER TABLE old_table_name
  RENAME TO new_table_name;

  -- Add constraint
  ALTER TABLE table_name
  ADD CONSTRAINT constraint_name CHECK (condition);

  -- Drop constraint
  ALTER TABLE table_name
  DROP CONSTRAINT constraint_name;

  -- Set a default value
  ALTER TABLE table_name
  ALTER COLUMN col_name SET DEFAULT 'this string';

  -- Change column order
  ALTER TABLE table_name
  MODIFY COLUMN moved_col_name data_type AFTER unmoved_col_name;

Delete
::

  -- Drop a row
  DELETE FROM table_name where condition;

  -- Delete rows using a subquery
  DELETE FROM table_name
  WHERE column_name IN (SELECT column_name FROM another_table WHERE condition);

  -- Delete with LIMIT to restrict the number of rows affected
  DELETE FROM table_name
  WHERE condition
  LIMIT number_of_rows;

Truncate

::

  -- delete all rows from the table
  TRUNCATE TABLE table_name;


2.9 Primary Keys
----------------

Primary keys
^^^^^^^^^^^^

A primary keys is a column or set of columns in a database that uniquely
identifies each row in the table.

Primary keys can be composed from a single column, in which case it's called a single
primary key, or from many columns, in which case it's called a composite primary key.

**Primary keys must be unique, non-null, and immutable (it never changes).**

Composite primary keys must also be **minimal**, which means there should be no
columns in it that aren't needed to uniquely identify a row.

Here's an example of creating a single primary key (the short way)::

  create table employees (
    employee_id serial primary key,
    uname varchar(100),
    age int
  );

Or you can do it the long way::

  create table employees (
    employee_id serial,
    uname varchar(100),
    age int,
    primary key (employee_id)
  );

The ``serial`` above auto increments ints, but you can also auto increment explicitly::

  create table employees (
    employee_id int auto_increment
    uname varchar(100),
    age int,
    primary key (employee_id)
  );

Here's an example of creating a composite primary key::

  create table project_assignments (
    employee_id int,
    project_id int,
    primary key (employee_id, project_id)
  );

Common insert mistakes
^^^^^^^^^^^^^^^^^^^^^^
MySQL allows insertion of a specific value to an auto-increment column.
However, overriding auto-increment for a primary key is usally a mistake.

::

  -- mistake
  insert into Employee values (3, 'Maria', 92300);

  -- correct
  insert into Employee (Name, Salary)
  values ('Maria' 92300);

  -- if ID (column 1) is non auto-incrementing, you should provide the value.

Check out the CHECK constraint on this example::

  CREATE TABLE Movie (
    ID INT AUTO_INCREMENT,
    Title VARCHAR(100),
    Rating CHAR(5) CHECK (Rating IN ('G', 'PG', 'PG-13', 'R')),
    ReleaseDate DATE,
    PRIMARY KEY (ID)
  );


2.10 Foreign keys
-----------------
https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html

**A foreign key is a column or group of columns that refer to a primary key of a different table.**
The data types of the foreign and primary keys must be the same, but the names may be different.
In this course, an empty circle in table diagrams indicates a foreign key.

Foreign key values may be repeated and may be NULL, unlike primary keys.
**Foreign keys obey a relational rule called referential integrity.**
Referential integrity requires foreign key values must be either NULL or match some
value of the referenced primary key.


Creating a foriegn key results in a child-parent relationship
between tables, where the referenced table is the parent.


Here's how to create a foriegn key using SQL:

::

  CREATE TABLE Customers (
      CustomerID INT PRIMARY KEY,
      Name VARCHAR(50)
  );

  CREATE TABLE Orders (
      OrderID INT PRIMARY KEY,
      CustomerID INT,
      OrderDate DATE,
      FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
  );

When a foreign key constraint is specified, the database rejects
statements that violate referential integrity.

Constraints for cascade operations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ON DELETE CASCADE: If a parent row is deleted, the child rows are automatically deleted.
* ON UPDATE CASCADE: Updates in the parent table are propagated to the child table.

Special cases
^^^^^^^^^^^^^
Multiple foreign keys may refer to the same primary key.

A foreign key may refer to a primary key in the same table.

A foreign key that refers to a composite primary key must also be composite.
All columns of a composite foreign key must either be NULL or match
the corresponding primary key columns.


2.11 Referential integrity
--------------------------
**Referential integrity is a relational rule that requires foreign key values
are either fully NULL or match some primary key value.** A fully NULL foreign
key is a simple or composite foreign key in which all columns are NULL. 

In a relational database, foreign keys must obey referential integrity at all
times. Occasionally, data entry errors or incomplete data result in referential
integrity violations. Violations must be corrected before data is stored in the
database.

Referential integrity violations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Referential integrity can be violated in four ways:

* A primary key is updated.
* A foreign key is updated.
* A row containing a primary key is deleted.
* A row containing a foreign key is inserted.

Only these four operations can violate referential integrity.
Primary key inserts and foreign key deletes never violate referential integrity.

Referential integrity actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
DB automatically correct referential integrity violations with any of these
four actions, specified as SQL constraints.

* RESTRICT rejects an insert, update, or delete that violates referential integrity.
* SET NULL sets invalid foreign keys to NULL.
* SET DEFAULT sets invalid foreign keys to the foreign key default value.
* CASCADE propagates primary key changes to foreign keys.

ON UPDATE and ON DELETE clauses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
For foreign key inserts and updates, MySQL supports only RESTRICT. Foreign key
inserts and updates that violate referentil integrity are automatically
rejected.

For primary key updates and deletes, MySQL supports all four actions.
Actions are specified in the options ON UPDATE and ON DELETE
clauses ofr the FOREIGN KEY constraing.

**NOTE: Review this section, I don't feel that I understand the integrity actions.**


2.12 Constraints
----------------

Column and table constraints
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A constraint is a rule that governs allowable values in a database.
They are implemented with special keywords in a CREATE TABLE statement.
The database rejects insert, update, and delete statements that violate a constraint.

The following constraints are descrived elsewhere in this material.

* NOT NULL
* DEFAULT
* PRIMARY KEY
* FORIEGN KEY

A **column constraint** appears after the column name and datatype in a CREATE TABLE statement.
**Column constraints govern values in a single column.** NOT NULL is a column constraint.

A **table constraint** appears in a separate clause of a CREATE TABLE statement and governs
values in **one or more columns**. FOREIGN KEY is a table constraint.

Some constraint types can be defined as either column or table constraints.

UNIQUE constraint
^^^^^^^^^^^^^^^^^
The UNIQUE constraint ensures that values in a column, or group of columns, are unique.
Primary keys are automatically unique, so you don't have to use the constraint.
MySQL creates an index for each UNIQUE constraint, in sorted order, to quickly
determine whether the new value is part of the set of existing values.

::

  -- Make one column unique
  CREATE TABLE Employee (
    ID SMALLINT UNSIGNED,
    Name VARCHAR(60),
    Extension CHAR(4),
    Username VARCHAR(50) UNIQUE,
    PRIMARY KEY (ID)
    );

  -- Make the combination of two columns unique
  CREATE TABLE Department (
    Code TINYINT UNSIGNED,
    Name VARCHAR(20) UNIQUE,
    ManagerID SMALLINT,
    PRIMARY KEY(Code),
    UNIQUE (ManagerID, Appointment)
    );

CHECK constraint
^^^^^^^^^^^^^^^^
The CHECK constraint specifies an expression on one or more columns of a table.
The constraint is violated when the expression is FALSE, and satisfied when TRUE or NULL.
It may appear either in the column declaration or a separate clause.
When the expression contains multiple columns, CHECK is a table
constraint and must be a separate clause.

::

  CREATE TABLE Employee (
     ID        SMALLINT UNSIGNED,
     Name      VARCHAR(60),
     BirthDate DATE,
     HireDate  DATE CHECK (HireDate >= '2000-01-01' AND HireDate <= '2019-12-31'),
     CHECK (BirthDate < HireDate),
     PRIMARY KEY (ID)
  );

Be careful of unintentional NULL values in your expression, since they satisfy the constraint.

Constraint names
^^^^^^^^^^^^^^^^
Table constraints may be named using the optional CONSTRAINT keyword,
followed by the name and declaration.

::

  create table Employee (
    ID int,
    Name varchar(20) not null,
    DepartmentCode int default 999,
    constraint EmployeePK primary key (ID),
    constraint EmployeeDepartmentFK
      foreign key (DepartmentCode) references Department (Code)
  );

Constraint names appear in error messages when constraints are voilated.

If no name is provided, the database generates a default name.
This query displays all names of constraints on table_name, including default names.
::

  select Column_Name, Constraint_Name
  from Information_Schema.Key_Column_Usage
  where Table_Name = 'Tablename';

Most column constraints can't be named, but CHECK is an exception.

::

  create table Department (
    Code int,
    Name varchar(20),
    ManagerID int 
      constraint CheckManager
      check (ManagerID > 9999),
    primary key (Code)
  );


Adding and dropping constraints
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Constraints are added and dropped with the ALTER TABLE table_name 
followed by and ADD, DROP, or CHANGE clause.

Unnamed constraints such as NOT NULL and DEFAULT are added or dropped with a
CHANGE clause.
::

  -- Change to include a not null constraint
  ALTER TABLE Students CHANGE Email Email VARCHAR(255) NOT NULL;

  -- Change to include a default constraint
  ALTER TABLE Students CHANGE Age Age INT DEFAULT 18;

Named constraints are added with an ADD clause.
::

  -- Add a primary key constraint
  ALTER TABLE Students ADD CONSTRAINT PK_Student PRIMARY KEY (StudentID);

  -- Add a foreign key constraint
  ALTER TABLE Enrollments 
  ADD CONSTRAINT FK_Student 
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID);

  -- Add a unique constraint
  ALTER TABLE Students ADD CONSTRAINT UQ_Email UNIQUE (Email);

  -- Add a check constraint
  ALTER TABLE Students ADD CONSTRAINT CHK_Age CHECK (Age >= 18);

Adding a constraint fails when the table contains data that violates the
constraint.

Named constraints are dropped with a DROP clause.
::

  -- Drop a primary key constraint
  ALTER TABLE Students DROP PRIMARY KEY;

  -- Drop a foreign key constraint
  ALTER TABLE Enrollments DROP FOREIGN KEY FK_Student;

  -- Drop a unique constraint (MySQL treats unique constraints as indexes)
  ALTER TABLE Students DROP INDEX UQ_Email;

  -- Drop a check constraint
  ALTER TABLE Students DROP CHECK CHK_Age;

  -- Drop any named constraint
  ALTER TABLE Students DROP CONSTRAINT ConstraintName;
