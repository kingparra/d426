Unit 4: Database Design
***********************


4.1 Entities, relationships, and attributes
-------------------------------------------
Database design begins with erbal or written requirements for the database.
Requirements are then formalized as an entity-relationship model and then impemented in SQL.

An **entity-relationship model** is a high-level representation of data requriements, ignoring implementation details.
It includes three types of objects:

* **entity**: a person, place, product, concept, or activity.
* **relationship**: a statement about two entities.
* **attribute**: a descriptive property of an entity.

A **reflexive relationship** relates an entity to itself.

Entity Relationship Dagram (ERD) and Glossary
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
An ERD is a diagram of entities, relationships, and attributes.
Entities are drawn as rectangles.
Relationships are drawn as lines connecting rectangles.
Attributes appear as additional text within an entity rectangle, under the entity name.

A **glossary**, also known as a data dictonary or repository, documents additional detail in text format.
A glossary includes names, synonyms, and descriptions of entities, relationships, and attributes.

Types and instances
^^^^^^^^^^^^^^^^^^^
In entity-relationship modeling types are viewd as sets and instances are viewed as elements.

Types:

* An **entity type** is a set of things.
* A **relationshp type** is a set of related things.
* An **attribute type** is a set of values.

Instances:

* An **entity instance** is an indivudual thing.
* A **relationship instance** is a statement about entity instances.
* An **attribute instance** is an individual value.

Database design
^^^^^^^^^^^^^^^
Complex databases are developed in three phases:

* **Analysis** develops an entity-relationship model, caputuring data requirements while ignoring implementation details.
* **Logical design** converts the entity-relationship model into tables, columns, and keys for a particular DB implementation.
* **Pyhsical design** adds indexes and specifies how tables are organized on storage media.


4.2 Discovery
-------------
Entities, relationships, and attributes are discovered in interviews with database users and managers.

* Entities usually appear as nouns, but not all nouns are entities.
  Designers should ignore nouns that denote specific data or are not relevant to the database.

* Relationships are often expressed as verbs.

* Attributes are usually nouns that denote specific data, such as names, dates, quantities, and monetary values.

Names
^^^^^
Entity names are a singular noun.
Relationship names have the form Entity-Verb-Entity. The verb should be active rather than passive.
Attribute names have the form EntityQualifierType, such as EmployeeFirstName.

Database design
^^^^^^^^^^^^^^^
* Identify entities, relationships, and attributes in interviews.
* Draw ER diagram.
* List standard attribute types in the glossary.
* Document names, synonyms, and descriptions in the glossary.


4.3 Cardinality
---------------
https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model

In entity-relationship modeling, cardinality refers to the number of times one
entity can (or must) be associated with each occurence of another entity.

Relationship maximum (maxima) and relationship minimum (minima)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Maxima (or relationship maximum) is the maximum number of relationships an entity can participate in.
Minima (or realationship manimum) is the minimum number of relationships an entity must participate in.

Relationship maximum is the greatest number of instances of one entity that can relate to a single instance of another entity.
A relationship has two maxima, one for each of the related entities.
Maxima are usually specified as one 1 or many M, but may be any number.
A related entity is singular when the maxima is one and plural when the maxima is many.


::

  +--------+                                             +---------+
  | Flight |--maxima(minama)------------ maxima(minima)--| Booking |
  +--------+                                             +---------+

Attribute maximum and minimum
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Attribute maximum and attribute minimum describe the greatest and least number
of attribute values that should be found in a row (or tuple).

::

  +------------------------------+
  |  Employee                    |
  +------------------------------+
  |  EmployeeNumber 1(1) <----------- singular, required
  |  PassportNumber 1(0) <----------- singular, optional
  |  FullName 1(1)   <--------------- singular, required
  |  SkillCode M(0)  <--------------- plural,   optional
  +------------------------------+

Unique attributes
^^^^^^^^^^^^^^^^^
::

  +------------------------------+
  |  Employee                    |
  +------------------------------+
  |  EmployeeNumber 1-1(1)       |
  |  PassportNumber 1-1(0)       |
  |  FullName M-1(1)             |
  |  SkillCode M-M(0)            |
  +------------------------------+

The format for these cardinality constraints are
::

  cardinality_constraint ::= minimum "-" maximum "(" required ")"

  minimum ::= M | number

  maximum ::= M | number

  required ::= 0 | 1

  number ::= 0 | number + 1

Steps to determine cardinality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Determine relationship maxima and minima.
* Determine attribute maxima and minama.
* Identify unique attributes.
* Document cardinality in glossary and, optionally, on the ERD.


4.4 Strong and weak entities
----------------------------

Strong entities
^^^^^^^^^^^^^^^
An **identifying attribute*** is an attribute that is unique, singular, and required.
Identifying attributes correspond with entity instances one-to-one.

A **strong entity** has one or more identifying attributes.
When a strong entity is implemented as a table, one of the indetifying attributes may beceome the primary key.

Weak entities
^^^^^^^^^^^^^
A **weak entity** does not have an identifying attriute (or primary key).
Instead, a weak entity usually has a relationship, called an **identifying
relationship**, to another entity, called an **identifying entity**.
Cardinality of the identifying entity is 1(1).
In ERDs, a diamond at the end of a line between entities indicates an identifying relationship.
The diamond goes on the end where the strong entity is.

Database design
^^^^^^^^^^^^^^^
Distinguish strong and weak entities

* Identify strong and weak entities.
* Determine the identifying relationship(s) for each weak entity.
* Document weak entities and identifying relationships in glossary and ER diagram.

Distinguising strong and weak entities is part of the analysis phase of design.


4.5 Supertype and subtype entities
----------------------------------

Supertype and subtype entities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
An **entity type** is a set of entity instances.
A subtype entity is a subset of another entity type, called the supertype entity.
On ERDs subtype entities are drawn within the supertype.

A supertype entity usually has several subtypes.
Attributes of the supertype apply to all subtypes.
Attributes of a subtype do not apply to other subtypes or the supertype.

A supertype entity identifies its subtype entities.
The identifying relationship is called an **IsA relationship**.
This is basic subtype/supertype vocabulary from OOP.

Similar entities and optional attributes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
**Similar entities** are entities that have many common attributes and relationships.
Sometimes the common attributes can be refactored into a supertype that they inherit from.

Partitions
^^^^^^^^^^
A **partition** of a supertype entity is a group of mutually exclusive subtype entities.
A supertype entity can have several partitions.
Subtype entities within each partition are disjoint and do not share instances.
Subtype entities in different partitions overlap and do share instances.

In diagrams, subtype entities within each partition are vertically aligned.
Subtype entities in different partitions are horizontally aligned.

Each partition corresponds to an optional partition attribute of the supertype entity.
The partition attriube indicates which subtype entity is associated with each supertype instances.

Database design
^^^^^^^^^^^^^^^
Create supertype and subtype entities

* Identify supertype and subtype entities.
* Replace similar entities and optional attributes with supertype and subtype entities.
* Identify partitions and partition attrbutes.
* Document supertypes, subtypes, and partitions in glossary and ER diagram.

Creating supertype and subtype entities is the last of four analysis steps:

1. Discover entites, relationships, and attributes.
2. Determine cardinality.
3. Distinguish strong and weak entities.
4. Create supertype and subtype entities.


4.6 Alternative modeling conventions
------------------------------------

Diagram conventions
^^^^^^^^^^^^^^^^^^^
Diagram conventions for ERDs vary widely. Some ERDs may:

* Depict relationship names inside a diamond.
* Depict weak entities and identifying relationships with double lines.
* Depict subtype entities with IsA relationships rather than inside of supertype entities.
* Use color, dashed lines, or double lines to convey additional information.

Crow's foot notation
::


                      
  +-----------+            Advises            +-----------+
  |  Faculty  |-------------------------------|  Student  |
  +-----------+ 1(1)                     M(0) +-----------+
                   

  +-----------+            Advises           /+-----------+
  |  Faculty  |--|-|----------------------o-<-|  Student  |
  +-----------+                              \+-----------+
                    

Model conventions
^^^^^^^^^^^^^^^^^
ER modeling concepts also vary. Some ER models may:

* Allow relationships between three or more entities.
* Decompose a complex model into a group of related entited called a subject area.
* Refer to strong entities as independent and weak entities as dependent.

Several model conventions are standardized and widely used. Leading conventions include:

* Unified Modeling Language (UML).
* IDEF1X, whatever that is...
* Chen notation


4.7 Implementing entities
-------------------------

Selecting primary keys
^^^^^^^^^^^^^^^^^^^^^^
Primary keys should be:

* Unique
* Not NULL
* Never changes (stable)
* Simple (easy to type and store)
* Meaningless (should not contain descriptive information)

Implementing strong entities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A strong entity becomes a strong table.

Implementing subtype entities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A subtype entity becomes a subtype table and is implemented as follows:

* The primary key is identical to the supertype primary key.
* The primary key is also a foreign key that references the supertype primary key.

(Can a primary key be a foreign key? Does that make sense? I'm not sure it makes sense...)

The foreign key implements the **IsA** identifying relationship.
Foreign keys that implement identifying relationshps usually have the following referential integrity actions:

* Cascade on primary key update and delete.
* Restrict on foreign key insert and update.

On table diagrams, open bullets denote foreign key columns.

Implementing weak entities
^^^^^^^^^^^^^^^^^^^^^^^^^^
A weak entity becomes a weak table.
The primary key is usually composite and includes:

* A foreign key that references the primary key of the identifying table.
* Another column that makes the composite primary key unique.
  If no suitable column is available in the weak table, an artificial column can be created.

Database design
^^^^^^^^^^^^^^^
* Implement strong entities as tables.
* Create an artificial key when no suitable primary key exists.
* Implement subtype entities as tables.
* Implement weak entities as tables.
* Specify cascade and restrict actions for identifying relationships.


4.8 Implementing relationships
------------------------------

Implementing many-one relationships
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* The foreign key goes in the table on the 'many' side of the relationship.

* The foreign key refers to the primary key on the 'one' side.

* The foreign key name is the primary key name with an optional prefix.
  The prefix is derived from the relationship name and clarifies the meaning of the foreign key.

Implementing one-one relationships
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* The foreign key can go in the table on either side of the relationship.
  Usually, the foreign key is placed in the table with fewer rows, to minimize the number of NULL values.

* The foreign key refers to the primary key on the opposite side of the relationship.

* The foreign key name is the primary key name with an optional prefix.
  The prefix is derived from the relationship name and clarifies the meaning of the foreign key.

Implementing many-many relationships
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A many-may relationship becomes a new weak table.

* The new table contains two foreign keys, referring to the primary keys of the related tables.

* The primary key of the new table is the composite of the two foreign keys.

* The new table is identified by the related tables, so primary key cascade and foreign key restrict rules are specified.

* The new table name consists of the related table names with an optional qualifier in between.
  The qualifier is derived from the relationship name and clarifies the meaning of the table.


4.9 Implementing attributes
---------------------------

Implementing plural attributes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
In the "implement entities" step, entities become tables and attributes becom columns.
Singular attributes remain in the initial table, but plural attributes move to a new weak table:

* The new table contains the plural attribute and a foreign key referencing the initial table.

* The primary key of the new table is the composite of the plural attribute and the foreign key.

* The new table is identified by the initial table, so primary key cascade and foreign key restrict rules are specified.

* The new table name consists of the initial table name followed by the attribute name.

If a plural attribute has a small, fixed maximum, the plural attribute can be implemented as multiple columns in the initial table.
However, implementing plural attributes in a new table simplifies queries and is usually a better solution.

Implementing attributes types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Each attribute has a type.
During the discovery step, attribute types are selected from a list of standard attribute types in the glossary.
During logical design, an SQL datatype is defiend for each attribute type and documented in the glossary.

Implementing attribute cardinality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Attributes can be unique, required, or optional:

* Each unique attribute instance describes at most one entity instance.
* Each entity instance has a least one required attribute instance.
* Each entity instance can have zero optional attribute instances.

Unique and required attributes are implemented with keywords following the column name in the CREATE TABLE statement.

* UNIQUE is specified on columns derived from unique attributes.
* NOT NULL is specified on columns derieved from required attributes.
* PRIMARY KEY is specified for primary key columns.
  The PRIMARY KEY keyword automatically enforces unique and required, so additional keywords NOT NULL and UNIQUE are unnecessary.

UNIQUE and NOT NULL are also specified on foreign key columns derived from unique and required relationships.
Optional attributes and relationshps become columns with NULLs allowed and do not require special keywords.

::

  CREATE TABLE Airport (
    AirportCode CHAR(3) PRIMARY KEY,
    AirportName VARCHAR(30) NOT NULL UNIQUE,
    CountryCode CHAR(3) NOT NULL,
    CityName VARCHAR(30)
  );

Database design
^^^^^^^^^^^^^^^
* Implement plural attributes as new weak tables.
* Specify cascade and restrict rules on new foreign keys in weak tables.
* Specify column datatypes corresponding to attribute types.
* Enforce relationship and attribute cardinality with UNIQUE and NOT NULL keywords.


4.10 First, second, and third normal form
-----------------------------------------

Functional dependence
^^^^^^^^^^^^^^^^^^^^^
A ➞  B
B depends on A.
For each value of A there is exactly one value of B.

Normal forms
^^^^^^^^^^^^
The idea of a normal form (in math) is to take some reducable expression and
turn it into a simplified, or more reduced, expression by applying
transformation rules to it. In DBMS, the transformations are mostly about
centralizing where data is stored, removing duplication, and making sure
data can be uniquely identified. All of these things help ensure that there
are no data modifications that accidentally violate data integerity.

Data modifications that violate integrity are called **anomolies**. Some
different types of anomolies include insertion anomaly, update anomaly,
and deletion anomaly.

First normal form (1NF)
^^^^^^^^^^^^^^^^^^^^^^^
* Every cell must hold exactly one value.
* There must be a primary key which uniquely identifies each row.
* No duplicate rows are allowed.

Second normal form (2NF)
^^^^^^^^^^^^^^^^^^^^^^^^
* Meet first normal form.
* Non-key columns must depend only on the entire primary key, not just part of it.

Third normal form (3NF)
^^^^^^^^^^^^^^^^^^^^^^^
* Meet second normal form.
* Non-key columns must depend directly on the primary key, instead of other non-key columns.

Boyce-Codd normal form (BCNF)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Meet third normal form.
* If a key uniquely identifies a column, it must also uniquely identify every row in the table.
* In other words, unnecessary or redundant identifying columns should be removed.

When you're actually implementing BCNF, you'll want to follow these three steps:

1. **List all unique columns.** Remove any columns in composite keys that are not necessary for uniqueness.
2. **Identify dependencies on non-unique columns.**
3. **Eliminate dependencies on non-uniqe columns.**
