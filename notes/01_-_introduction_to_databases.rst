Data Sources Online
-------------------
1. data.gov provides USG data sets.
2. kaggle.com allows user to find and publish data sets.
3. data.nasa.gov provides aerospace and astronomical data sets.


1.2 Database Systems
--------------------

File systems and database sysetms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Design considerations of large databases:

* Performance
* Authorization
* Security
* Rules
* Recovery

Transactions
^^^^^^^^^^^^
A transaction is a group of queries that must be either completed or jected as a whole.

* Ensure transactiosn are processed completely or not at all.
* Prevent conflicts between concurrent transactions.
* Ensure transaction results are never lost.

Architecture
^^^^^^^^^^^^
A database system is composed of a query processor, storage manager, transaction manager, log, and catalog.

* **Query processor**

  The query processor interprets queries, creates a plan to modify the database or retrieve data,
  and returns query results to the application. The query processor performs query optimization 
  to ensure the most efficient instructions are executed on the data.

* **Storage manager**

  The storage manager translates the query processor instruction into low-level filesystem commands
  that modify or retrieve data. Database sizes range from megabytes to many terabytes, so the storage
  manager uses indexes to quickly locate data.

* **Transaction manager**

  The transaction manager ensures tranactions are p

* **Logs**

  The log is a file containing a complete record of all inserts, updates, and deletes processed by
  the database. The transaction manager writes log records before applying changes to the database.
  In the event of a failure, the transaction manager uses log records to restore the database.

* **Catalog (AKA data directory)**

  The catalog is a directory of tables, columns, indexes, and other database objects.
  Other components use catalog information to process and execute queries.


1.3 Query languages
-------------------
A query is a command for a database that typically inserts new data,
retrieves data, updates data, or deletes data from a database.
A query language is a PL for writing database queries.

There are many query types, but the most commonly used ones are:

* **insert**
* **update**
* **select**
* **delete**

Thes four common queries are sometimes referred to as CRUD (Create Read Update
Delete) operations.

Creating tables with SQL
^^^^^^^^^^^^^^^^^^^^^^^^
::

  create table $table_name ( $colname $type, $colname $type, ... );

  create table Employee (
    ID int,
    Name varchar(60),
    BirthDate date,
    Salary decimal(7,2)
  );

Common SQL data types example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

  -- Numeric Types
  CREATE TABLE numeric_example (
      id INTEGER,               -- Standard integer
      price DECIMAL(10, 2),     -- Exact decimal (10 digits, 2 after decimal)
      weight FLOAT              -- Approximate floating-point
  );

  -- String Types
  CREATE TABLE string_example (
      name CHAR(50),            -- Fixed-length string (50 characters)
      description VARCHAR(255), -- Variable-length string (up to 255 characters)
      notes TEXT                -- Unbounded text
  );

  -- Date and Time Types
  -- https://dev.mysql.com/doc/refman/8.4/en/datetime.html
  CREATE TABLE datetime_example (
      event_date DATE,          -- Stores date (YYYY-MM-DD)
      event_time TIME,          -- Stores time (HH:MM:SS)
      event_timestamp TIMESTAMP -- Date and time (YYYY-MM-DD HH:MM:SS) stored as 32 bit unix epoch time
      event_timestamp2 DATETIME -- Contains both date and time (YYYY-MM-DD hh:mm:ss) up to '9999-12-31 23:59:59'

  );

  -- Boolean Type
  CREATE TABLE boolean_example (
      is_active BOOLEAN         -- TRUE or FALSE
  );

  -- Binary Type
  CREATE TABLE binary_example (
      file_data BLOB            -- Binary Large Object
  );


1.4 Database design and programming
-----------------------------------
For large complex databases, the **database design** process has three phases:

1. Analysis
2. Logical design
3. Physical design

**Database design is a broad term for the process that generates database
specifications in SQL. The term covers three phases: analysis, logical
design, and physical design.**

Analysis
^^^^^^^^
The analysis phase specifies database requirements without regard to a specific DB system.
Requirements are represented as entities, relationships, and attributes.
An entity is a person, place, or thing.
A relationship is a link between entities.
An attribute is a descriptive property of an entity.

(Analysis is sometime known as conceptual design, or entity-relationship modeling, or requirements definition.)

Entities, relatiphsips, and attributes are depecited in entity-relationship diagrams.

* Rectangles represent entities.
* Lines between rectangles represent relationships.
* Text inside rectangles and below entity names represent attributes.

**Analysis is the process of gathering and documenting database requirements.
The requirements are not dependent on any specific database system.
Analysis goes by other names, such as conceptual design.**

Logical Design
^^^^^^^^^^^^^^
Logical design converts entities, relationships, and attributes into tables, keys, and columns.
A key is a column used to identify individual rows of a table.
These are specified in SQL with CREATE TABLE statements.

The logical design is depicted in a **table diagram**.
Table diagrams are similar to ER diagrams but more detailed.

* Rectangles represent tables. Table names appear at the top of rectangles.
* Text within rectangles and below table names represent columns.
* Solid bullets indicate key columns.
* Empty bullets and arrows indicate columns that refer to keys.

The logical design as specified in SQL and depicted in a table diagram is called a database schema.

**Logical design results in SQL specifications for tables, columns, and keys in
a specific database system.**

Physical Design
^^^^^^^^^^^^^^^
The physical design phase adds indexes and specifies how tables are organized on storage media.
Physical design is specified with SQL statements such as CREATE INDEX, and, like logical design
is specific toa database system.

Physical design can be depicted in diagrams, but they're not commonly used.
Physical design affects query processing speed but never affects the query result.
The principle that physical design never affects query results is called **data independence**.
Prior to relational databases, most DB systems did not support data independence.
In other words, the retrieval was dependendant on the datastructures traversal pattern.

**Physical design results in SQL specificatiosn for index and table structures.
In a relational database, index and table structures affect query performance
but not query results. This principle is called data independence.**


1.5 MySQL
---------
MySQL is a leading RDBMS sponsored by Oracle (AKA Satan).
It's available in two editions:

* MySQL Community, commonly called MySQL Server.
* MySQL Enterprise is a paid edition that includes 
  additional administrative applications.

This book is based on MySQL Server 8.0.

MySQL CLI Client
^^^^^^^^^^^^^^^^
On fedora linux you generally want to use MariaDB instead
of MySQL. It's a fork of MySQL from the original developers
that has better performance and more features.
It's also not associated with Oracle.

::

  sudo dnf install -y mariadb


