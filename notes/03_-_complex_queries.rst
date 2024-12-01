3.1 Special operators and clauses
---------------------------------
First, a gentle reminder: select quereies have to be written in the order
::

  SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY ... LIMIT

IN operator
^^^^^^^^^^^
You can check for membership with IN.

::

  select * from country_langauge where Language in ('Dutch', 'Kongo', 'Albanian');

BETWEEN operator
^^^^^^^^^^^^^^^^
Check if an ordinal is within a range.
::

  select Name from Employee where HireDate between '2000-01-01' and '2020-01-01';

LIKE operator
^^^^^^^^^^^^^
Do case insensitive substring matching (globbing).
``%`` is like ``*`` and ``_`` is like ``?``.
::

  select * from CountryLanguage where Language like 'A%n';

  -- make it case sensitive
  select * from CountryLanguage where Language like binary 'A%n';

DISTINCT clause
^^^^^^^^^^^^^^^
Return only records with unique values for a column.
::

  select distinct Language from ContryLanguage where IsOfficial = 'F';

ORDER BY clause
^^^^^^^^^^^^^^^
Return records in order.
::

  select * from CountryLanguage order by CountryCode, Language DESC;


3.2 Simple functions
--------------------

Common numeric functions
^^^^^^^^^^^^^^^^^^^^^^^^
::

  abs(n), log(n), pow(x,y), rand(), round(n, d), sqrt()

String functions
^^^^^^^^^^^^^^^^
::

  concat(s,s2,...), lower(), replace(s, from, to), substring(s, pos, len), trim(), upper()

Note that SQL uses 1 based indexing.

Date and time functions
^^^^^^^^^^^^^^^^^^^^^^^
::

  curdate() -- '2019-10-25'
  curtime() -- '21:05:44'
  now()     -- '2019-02-25 21:05:44'

  date('2013-03-25 22:11:45') -- '2013-03-25'
  time('2013-03-25 22:11:45') -- '22:11:45'

  day('2016-10-25');   -- 25
  month('2016-10-25'); -- 10
  year('2016-10-25');  -- 2016

  hour(time)
  minute(time)
  second(time)

  datediff(x,y)
  timediff(x,y)


3.3 Aggregate functions
-----------------------
An aggregate function works on multiple rows at once and returns a summary value.
Common aggregate functions are:

::

  count() min() max() sum() avg()

Aggregate functions appear in a SELECT clause and process all rows that satisfy the
WHERE clause condition. If a SELECT statement has no WHERE clause, the aggregate function
processes all rows. Aggregate functions ignore NULL values.

GROUP BY clause
^^^^^^^^^^^^^^^
Aggregate functions are commonly used with the GROUP BY clause.
With a GROUP BY clause, each value of the column(s) becomes a group.

The evaluation process looks something like this:

1. Split the table into groups for each value that you grouped by.
2. Calculate the aggregates from the query for each group.
3. Create a result set with 1 row for each group.

::

  CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    quantity INT,
    price DECIMAL(10, 2)
  );

  INSERT INTO sales
    (product_name, category, quantity, price)
  VALUES
    ('Laptop', 'Electronics', 2, 1500.00),
    ('Smartphone', 'Electronics', 5, 800.00),
    ('Headphones', 'Accessories', 10, 50.00),
    ('Keyboard', 'Accessories', 3, 100.00),
    ('Smartwatch', 'Electronics', 1, 200.00);

  SELECT
    category,
    COUNT(*) AS total_products,
    SUM(quantity) AS total_quantity
  FROM sales
  GROUP BY category;

  -- +-------------+----------------+----------------+
  -- | category    | total_products | total_quantity |
  -- +-------------+----------------+----------------+
  -- | Accessories |              2 |             13 |
  -- | Electronics |              3 |              8 |
  -- +-------------+----------------+----------------+

HAVING clause
^^^^^^^^^^^^^
The HAVING clause is used with the GROUP BY clause to filter group results.
The optional HAVING clause follows up the GROUP BY clause and precedes the optional ORDER BY clause.

::

  SELECT CountryCode, SUM(Population)
  FROM city
  GROUP BY CountryCode
  HAVING SUM(Population) > 2300000;

Both WHERE and HAVING filter results, but HAVING is evaluated after grouping with GROUP BY.

Aggregate functions and NULL values
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Aggregate functions ignore NULL values.
For example ``sum(Salary)`` add all non-NULL salaries 
and ignores rows containing a NULL salary.

Aggregate functions and arithmetic operators handle NULL differently.
Arithmetic operators return NULL when either operand is NULL.

As a result, combinations of arithmetic and aggregate functions may
generate surprising results depending on how you combine them.

For example, ``sum(Salary) + sum(Bonus)`` is not equal to ``sum(Salary + Bonus)``.


3.4 Join queries
----------------
https://dev.mysql.com/doc/refman/8.0/en/join.html

Joins combine rows from multiple tables based on a related column.
They allow you to retrieve related data stored in separate tables.
Conceptually, joins are similar to set operations in math.

In SQL, joins are implemented using the FROM+JOIN clause of the
SELECT statement. But inner and outer joins can technically be
written without a join clause.

The related column must have the same datatype in all tables
to be eligible for comparision with join queries.

When only combining two tables at a time, the first is known
as the **left table**, and the second is known as the **right table**.
This terminology reminds me of diff operations.

Prefixes and aliases
^^^^^^^^^^^^^^^^^^^^
When the column names for comparision are the same in each table,
you need to disambiguate it by prefixing the table name and a dot.
You can also incorporate aliases (with AS) to simpilify the rest of the query.

::

  select
    Department.Name as Group,
    Employee.Name   as Supervisor
  from Department, Employee
  where Manager = ID;

You can also alias the name of the tables, like this:

::

  select d.name, e.name
  from
    Department as d,
    Employee as e
  where Manager = ID;

Guidelines for simple joins
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here's some advice to keep your joins as simple as possible.

1. Only use LEFT JOIN and INNER JOIN.

2. Refer to columns as table_name.column_name.

3. Only include 1 condition in your join.

4. One of the joined columns should have unique values.

---------------------------------------------------------------

Inner join (intersection)
^^^^^^^^^^^^^^^^^^^^^^^^^
An inner join is like a set intersection in math.
An inner join selects only rows matching the ON condition which are present in both tables.

::

  -- +----+---------+        +----+-------+        +---------+-------+
  -- | id | name    |        | id | owner |        | name    | owner |
  -- +----+---------+        +----+-------+        +---------+-------+
  -- |  1 | Alice   |        | 10 |  1    |        | Alice   |  1    |
  -- |  2 | Bob     |        | 11 |  2    |        | Bob     |  2    |
  -- |  3 | Charlie |        +----+-------+        +---------+-------+
  -- +----+---------+

  SELECT owners.name, pets.owner
  FROM owners INNER JOIN pets
    ON owners.id = pets.owner;

Outer join
^^^^^^^^^^
An **outer join** is any join that selects unmatched rows, including left, right, and full joins.
MySQL suppors inner, left, and right join but not full join.


Full join (union)
^^^^^^^^^^^^^^^^^
This is like a set union operation.
It selects all left and right table rows regardless of match.
The full join is also known as the full outer join.

::

  -- +----+----------+        +----+-------+        +----------+-------+
  -- | id | name     |        | id | name  |        | emp_name | dept  |
  -- +----+----------+        +----+-------+        +----------+-------+
  -- |  1 | John     |        |  2 | HR    |        | John     | NULL  |
  -- |  2 | Sarah    |        |  3 | IT    |        | Sarah    | HR    |
  -- +----+----------+        +----+-------+        | NULL     | IT    |
  --                                               +----------+-------+

  SELECT employees.name AS emp_name, departments.name AS dept
  FROM employees FULL OUTER JOIN departments
    ON employees.id = departments.id;

Unfortunately, MySQL doesn't support full joins, so you have
to create the same effect by combining left outer joins and
right outer joins using UNION.

::

  SELECT users.name, likes.like
  FROM users LEFT OUTER JOIN likes
    ON users.id = likes.user_id
  UNION
  SELECT users.name, likes.like
  FROM users RIGHT OUTER JOIN likes
    ON users.id = likes.user_id;

What a mess.


---------------------------------------------------------------

Left join
^^^^^^^^^
Left join includes every row from the left tabel, even if it's not in the right table.
Rows not in the right table will have missing fields set to NULL.

::

  -- +----+----------+        +----+-------+        +----------+-------+
  -- | id | title    |        | id | score |        | title    | score |
  -- +----+----------+        +----+-------+        +----------+-------+
  -- |  1 | Book A   |        |  1 |   5   |        | Book A   |   5   |
  -- |  2 | Book B   |        +----+-------+        | Book B   | NULL  |
  -- +----+----------+                               +----------+-------+

  SELECT books.title, reviews.score
  FROM books LEFT JOIN reviews
    ON books.id = reviews.id;

If you wanted to, you can write left join using the UNION operator instead of a JOIN
clause. The example below shows two equivalent expressions:

::

  select Department.Name, Employee.Name
  from Department
  left join Employee
  on Manager = ID;

  select Department.Name, Employee.Name
  from Department, Employee
  where Manager = ID
    UNION
  select Department.Name, NULL
  from Department
  where Manager not in (select ID from Employee)
    or Manager is NULL;

Right join
^^^^^^^^^^
Selects all right table rows regardless of match, but only matching left table rows.
Rows not in the left table will have missing fields set to NULL.

::

  -- +----+-------+        +----+-------+        +-------+-------+
  -- | id | total |        | id | name  |        | total | name  |
  -- +----+-------+        +----+-------+        +-------+-------+
  -- |  1 |  100  |        |  1 | Alice |        |  100  | Alice |
  -- +----+-------+        |  2 | Bob   |        | NULL  | Bob   |
  --                       +----+-------+        +-------+-------+

  SELECT orders.total, customers.name
  FROM orders
  RIGHT JOIN customers
  ON orders.id = customers.id;

::

  select *
  from
    (select * from inventory where base_id = 1) as i
  right join supply as s
  on i.supply_id = s.supply_id
  order by s.supply_id;

---------------------------------------------------------------

Self join
^^^^^^^^^
You can also join two fields from the same table
using any of the join operators above.
This is known as a self join.


::

  -- +----+----------+-------+                       +----------+----------+
  -- | id | name     | mgr   |                       | emp_name | mgr_name |
  -- +----+----------+-------+                       +----------+----------+
  -- |  1 | John     | NULL  |                       | Sarah    | John     |
  -- |  2 | Sarah    |  1    |                       | Mike     | John     |
  -- |  3 | Mike     |  1    |                       +----------+----------+
  -- +----+----------+-------+

  SELECT e1.name AS emp_name, e2.name AS mgr_name
  FROM employees e1
  LEFT JOIN employees e2
  ON e1.mgr = e2.id;

::

  SELECT
    m.first_name as fn,
    m.last_name  as ln,
    s.first_name as super_fn,
    s.last_name  as super_ln
  FROM
    martian AS m LEFT JOIN martian AS s
  ON
    m.super_id = s.martian_id
  ORDER BY
    m.martian_id;


Cross join
^^^^^^^^^^
Performs a cross product between two tables.
Connects each row in the left table with each row in the second table.
This is like a cartesian product.

::

  select b.base_id, s.supply_is, s.name,
    coalesce((select quantity from inventory
     where base_id = b.base_id and supply_id = s.supply_id)) as qantity
  from base as b
  cross join supply as s;

::

  -- +----+-------+        +----+-------+        +-------+-------+
  -- | id | color |        | id | size  |        | color | size  |
  -- +----+-------+        +----+-------+        +-------+-------+
  -- |  1 | Red   |        |  1 | Small |        | Red   | Small |
  -- |  2 | Blue  |        |  2 | Large |        | Red   | Large |
  -- +----+-------+        +----+-------+        | Blue  | Small |
  --                                             | Blue  | Large |
  --                                             +-------+-------+

  SELECT colors.color, sizes.size
  FROM colors
  CROSS JOIN sizes;

---------------------------------------------------------------

Views
-----

Views
^^^^^
Views are a way to create a virtual table that is dynamically updated
with the results of a select statement. The benefit here is that you
don't have to remember the query. You can also assign permissions to
view that differ from the underlying tables the query came from.

::

  CREATE VIEW martian_public AS
  SELECT
    martian_id,
    first_name,
    last_name,
    base_id,
    super_id
  FROM
    martian_confidential;


Set-based operations
--------------------

Unions
^^^^^^
If you want to combine the results of two SELECT queries, you can use a UNION.

::

  SELECT martian_id, first_name, last_name, 'Martian' as status
  FROM martian_public
    UNION
  SELECT visitor_id, first_name, last_name, 'Visitor' as status
  FROM visitor;

For UNION to work without errors, all SELECT statements must have the same
number of columns and the corresponding columns must have the same datatype.
UNION will return duplicate results, unless you change the operator name to
``UNION ALL``.

Intersect
^^^^^^^^^
The INTERSECT operator returns only identical rows from two tables.

::

  SELECT artist FROM artitst
    INTERSECT
  SELECT artist_id from album;

Except
^^^^^^
The EXCEPT operaot returns only those rows from the left table that
are not present in the right table.

::

  select artist_id from artists
    EXCEPT
  select artist_id from album;


Semi-join
^^^^^^^^^
A semi-join chooses records in the first table where a condition
is met in the second table. A semi-join makes use of a WHERE clause
to use th second table as a filter for the first.

::

  select * from albumn
  where artist_id in
    (select artist_id from artists);

Anti-join
^^^^^^^^^
The anti-join chooses records in the first table where a condition is not
met in the second table. It makes use of a where clause to use exclude values
from the second table.

::

  select * from album
  where artist_id not in
    (select artist_id from artist);


3.5 Equijoins, self-joins, and cross-joins
------------------------------------------

Equijoins
^^^^^^^^^
An **eqijoin** compares columns of two tables with the = operator.
Most joins are equijoins.
A **non-equijion** compares columns with an operator other than =, such as < and >.

::

  select Name, Address
  from Buyer left join Property
  on Price < MaxPrice;

Self-joins
^^^^^^^^^^
A **self-join** joins a table to iself.
A self-join can compare any columns of table, as long as the columns have comparable data types.
If a foreign key and the referenced primary key are in the same table, a self-join commonly compares those key columns.
In a self-join aliases are necessary to distinguish left and right tables.

::

  +--------+--------------------+-----------+
  |  ID    |  Name              |  Manager  |
  +--------+--------------------+-----------+
  |  2538  |  Lisa Ellison      |  8820     |
  |  5384  |  Sam Snead         |  8820     |
  |  6381  |  Maria Rodriguez   |  8820     |
  |  8820  |  Jiho Chen         |  NULL     |
  +--------+--------------------+-----------+

  select
    A.Name,
    B.Name
  from
    EmployeeManager as A
    inner join
    EmployeeManager as B
  on
    B.ID = A.Manager;

  +-------------------+-------------+
  |  A.Name           |  B.Name     |
  +-------------------+-------------+
  |  Lisa Ellison     |  Jiho Chen  |
  |  Sam Snead        |  Jiho Chen  |
  |  Maria Rodriguez  |  Jiho Chen  |
  |  Jiho Chen        |  Jiho Chen  |
  +-------------------+-------------+

Cross-joins
^^^^^^^^^^^
A **cross-join** combines two tables without comparing columns.
It's basically a cartesian product of two tables.
A cross-join uses a CROSS JOIN clause without an ON clause.
As a result all possible combinations of rows from both tables appear in the result.
See the cross-join description in 3.4 for an example diagram.


3.6 Subqueries
--------------
A **subquery** in SQL is a query nested inside another query. It allows you to
use the result of one query as input for another, enabling more complex and
dynamic operations. Think of it as command substitution in bash, but for SQL.

A subquery can appear in...

* SELECT (returning values for computation)
* FROM (as a derived table)
* WHERE or HAVING (to filter results)

Subqueries can return either a...

* Scalar (a single value)
* Row (a row with multiple columns)
* Table (an entire result table)

Subqueries can be nested within other subqueries, however it can make
statements hard to read, and slow down performance.

EX: Find employees earning more than the average salary:

::

  select name from employees
  where salary > (select avg(salary) from employees);

EX: Return language and percentage for rows with a higher percentage of speakers than Dutch.

.. code:: mysql

  -- CountryLanguage
  -- +---------------+------------------+--------------+--------------+
  -- |  CountryCode  |  Language        |  IsOfficial  |  Percentage  |
  -- +---------------+------------------+--------------+--------------+
  -- |  ABW          |  Dutch           |  T           |  5.3         |
  -- |  AFG          |  Balochi         |  F           |  0.9         |
  -- |  AGO          |  Kongo           |  F           |  13.2        |
  -- |  ALB          |  Albanian        |  T           |  97.9        |
  -- |  AND          |  Catalan         |  T           |  32.3        |
  -- +---------------+------------------+--------------+--------------+

  select Langauge, Percentage
  from CountryLanguage
  where
    /* The subquery evaluates to 5.3 */
    Percentage > (select Percentage from CountryLanguage
                  where CountryCode = 'ABW' and IsOfficial = 'T');

  -- +-----------------+--------------+
  -- |  Language       |  Percentage  |
  -- +-----------------+--------------+
  -- |  Kongo          |  13.2        |
  -- |  Albanian       |  97.9        |
  -- |  Catalan        |  32.3        |
  -- +-----------------+--------------+

EX: Add a column showing the department name for each employee:

::

  SELECT name, 
         (SELECT department_name 
          FROM departments 
          WHERE departments.id = employees.department_id) AS dept_name
  FROM employees;

Correlated subqueries
^^^^^^^^^^^^^^^^^^^^^
**A subquery is correlated when the subquery's WHERE clause references a column from the outer query.**
In a correlated subquery, the rows selected depend on what row is currently being examined by the outer query.

Since you are often dealing with multiple tables that may share the same column names in these subqueries,
you should use aliases or prefixes to disambiguate which table the column belongs to.

EXISTS operator
^^^^^^^^^^^^^^^
Correlated subqueries commonly use the EXISTS opeator, which returns TRUE if a subquery selects at least
one row and FALSE if no rows are selected. The NOT operator negates the return value of EXISTS.

::

  Select Name, CountryCode
  FROM City as C
  WHERE EXISTS (SELECT * 
                FROM CountryLanguage
                WHERE CountryCode = C.CountryCode 
                      AND Percentage > 97);

Flattening subqueries
^^^^^^^^^^^^^^^^^^^^^
.. TODO Skim from here on and circle back.

**This is where I start to lose reading comprehension.**

Many subqueries can be rewritten as a join.
Most databases optimize a subquery and outer query separately, whereas joins are optimized in one pass.
So joins are usually faster and preferred when performance is a concern.

Replacing a subquery with an equivalent join is called **flattening** a query.
The criteria for flattening subqueries are complex and depend on the SQL implementation in each database system.
**Most subqueries that follow IN or EXISTS, or return a single value, can be flattened.**
Most subqueries that follow NOT EXISTS or contain a GROUP BY clause cannot be flattened.

The following steps are a first pass at flattening a query:

1. Retain the outer SELECT, FROM, GROUP BY, HAVING, and ORDER BY clauses.

2. Add INNER JOIN clauses for each subquery table.

3. Move comparisons between subquery and outer query columns to ON clauses.

4. Add a WHERE clause with the remaining expressions in the subquery and outer query WHERE clauses.

5. If necessary, remove duplicate rows with SELECT DISTINCT.

::

  select Name 
  from Country 
  where Code in (select CountryCode 
                 from City 
                 where Population > 10000000);

  select distinct Name 
  from Country inner join City on Code = CountryCode 
  where population > 1000000;


Window functions
----------------
Window functions are an advanced SQL feature.
Window functions are SQL expressions that let you reference values in other rows.
They syntax is:

::

  [expression] OVER ([window definition])

::

  select item, dat - lag(day) over (order by day) from sales;

A window is a set of rows.
A window can be as big as the whole table (an empty OVER is the whole table),
or as small as just one row.

::

  select name, class, grade
    row_number() over (partition by class order by grade desc) as rank_in_class
  from grades;

This reminds me of mapping a function over a collection.

::

  select event, hour,
         hour - lag(hour)
         over(partition by event order by hour asc) as time_since_last
  from baby_log
  where event in ('feeding', 'diaper')
  order by hour asc;

CASE
^^^^
You can do case expressions in SQL.

::

  select first_name, age, case
      when age < 13 then 'child'
      when age < 20 then 'teenager'
      else 'adult'
    end as age_range
  from people;


Common Table Expressions (CTEs)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You can use CTEs in a FROM or WHERE clause.

::

  with popular_dog_names as (
    select name
    from dogs
    group by name
    having count(*) > 2)
  select owner
  from dogs inner join popular_dog_names
    on dogs.name = popular_dog_names.name;


3.7 Complex query example
-------------------------

Writing a complex query
^^^^^^^^^^^^^^^^^^^^^^^
* Examine the Entity Relationship Diagram to understand the tables and relationships.

* Identify tables containing the data needed to answer the question.

* Determine which columns should appear in the result table.

* Write a query that joins the tables on the primary and foreign keys.

* Break the problem into simple queries, writing one part of the query at a time.

Joining tables
^^^^^^^^^^^^^^
**Which books written by a single author generated the most sales to customers from Colorado 
or Oklahoma in Februrary 2020?**

The result table should contain the following **Customer state**, **Book ID**, **Book Title**,
the **number of books purchased**, and **total price**.

::

  -- Input tables: Customer, Sale, Book
  -- Input attributes: Sale.BookID, Book.Title, Sale.Quantity, Sale.UnitPrice
  -- Join on these columns: Customer.ID and Sale.CustID, Book.ID and Sale.BookID
  -- What happens when you have two joins like this?

  SELECT
    Customer.State,
    Sale.BookID,
    Book.Title,
    SUM(Sale.Quantity) AS Quantity,
    SUM(Sale.UnitPrice * Sale.Quantity) AS TotalSales
  FROM 
    Sale
  INNER JOIN Customer ON Customer.ID = Sale.CustID
  INNER JOIN     Book ON Book.ID = Sale.BookID 
  GROUP BY Customer.State, Sale.BookID
  ORDER BY TotalSales DESC;

.. topic:: How do you set a variable?

   SQL doesn't support variables according to the standard,
   but most database engines have extended the language to
   include them.

   ::
    
      -- session variables
      -- MySQL uses "set" and PostgreSQL uses "declare" to initialize a variable with a value.
      set @var_name = 'value';
      select @var_name; -- Output: value

      -- local variables
      create procedure example_proc()
      begin
        declare my_var int;
        set my_var = 10;
        select my_var;
      end;

      call example_proc();


3.8 View tables
---------------

Creating views
^^^^^^^^^^^^^^
A **view table** is a table name associated with a SELECT statment called the **view query**.

::

  CREATE VIEW ViewName [ (Col1, Col2, ...) ]
  AS SelectStatement;

Querying views
^^^^^^^^^^^^^^
A table specified in the view query's FROM clause is called a base table.
Unlike base table data, view table data is not normally stored, but calculated dynamically instead.

In some DBs view data can be stored in a **materalized view**.
Whenever the base table changes, the materalized view is updated.

To avoid the overheaad of refreshing views, MySQL and many other DBs don't support materalized views.

Advantages of views
^^^^^^^^^^^^^^^^^^^
View tables have several advantages:

* Protect sensitive data.

  A view can hide sensitive columns by selecting only needed columns from the base table.
  After that, the view table can be assigned different permissions than the underlying base tables.

* Save complex queries.

* Save optimized queries.

Inserting, updating, and deleting views
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Using views in INSERT, UPDATE, and DELETE statements is problematic.

* **Primary keys.** If a base table primary key doesn't appear in a view,
  an insert to the view generates a NULL primary key value.
  Since primary keys may not be NULL, the insert is not allowed.

* **Aggregate values.** A view query may contain aggregate functions such as AVG() or SUM().
  One aggregate value corresponds to many base table values.
  The conversion is undefined, so the insert or update is not allowed.

* **Join views.** In a join view, foreign keys of one base table may match primary keys of another.
  A delete from a view might delete foreign key rows only, or primary key rows only, or both the primary and foreign key rows.
  The effect of the join view delete is undefined and therefore not allowed.

WITH CHECK OPTION clause
^^^^^^^^^^^^^^^^^^^^^^^^
When WITH CHECK OPTION is specified, the DB rejects inserts and updates that don't satisfy the view query's WHERE clause.

::

  CREATE VIEW ViewName [ (Col1, Col2, ...) ]
  AS SelectStatement
  [ WITH CHECK OPTION ];



3.9 Relational algebra
----------------------

Operations and expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^
In relational algebra, the various operations of SQL are denoted using infix binary operators.

+-----------------+----------+----------------+------------------------------------------------------+
|  Operation      |  Symbol  |  Greek letter  |  Derivation                                          |
+=================+==========+================+======================================================+
|  Select         |    σ     |   sigma        |  Corresponds to Latin letter s, for select.          |
+-----------------+----------+----------------+------------------------------------------------------+
|  Project        |    Π     |   pi           |  Corresponds to Latin letter P, for project.         |
+-----------------+----------+----------------+------------------------------------------------------+
|  Product        |    ×     |                |  Multiplication symbol.                              |
+-----------------+----------+----------------+------------------------------------------------------+
|  Join           |    ⋈     |                |  Multiplication symbol with vertical bars.           |
+-----------------+----------+----------------+------------------------------------------------------+
|  Union          |    ∪     |                |  Set theory.                                         |
+-----------------+----------+----------------+------------------------------------------------------+
|  Intersect      |    ∩     |                |  Set theory.                                         |
+-----------------+----------+----------------+------------------------------------------------------+
|  Difference     |    −     |                |  Set theory.                                         |
+-----------------+----------+----------------+------------------------------------------------------+
|  Rename         |    ρ     |   rho          |  Corresponds to Latin letter r, for rename.          |
+-----------------+----------+----------------+------------------------------------------------------+
|  Aggregate      |    𝛾     |   gamma        |  Corresponds to Latin letter g, for group.           |
+-----------------+----------+----------------+------------------------------------------------------+

Select
^^^^^^
The select operation selects rows based on a predicate expression.
It's written as ``σ<expression>(table)`` and is equivlent to ``SELECT * FROM table WHERE expression``.

Project
^^^^^^^
The project operation selects columns.
It's written as ``Π<expression>(table)``, and is eqivalent to ``SELECT col1, col2, ... FROM table``.

Product
^^^^^^^
The product operation is like a cross join or cartesian product.
It's written as ``table1 × table2`` and is equivalent to ``SELECT * FROM table1 CROSS JOIN table2``.

Join
^^^^
The join operation is written as ``table1 ⋈ <expression> table2``, and is identical to a select on
a product of table1 and table2 ``σ<expression>(table1 × table2)``.
It's equivelent to ``SELECT * FROM table1 INNER JOIN table2 ON expression``.

Union, intersect, difference
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
These operations work just like they do in set theory.
Tables must have the same columns to work with these operators.
There can be no duplicate rows, entries are unique like elements in a set are.

I've lost my motivation to do the rest of this section.
