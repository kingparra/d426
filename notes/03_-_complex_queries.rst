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
Do case insensitive substring matching (globbing). ``%`` is like ``*`` and ``_`` is like ``?``.
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

  SELECT category,
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
Aggregate functions ignore NULL values. For example ``sum(Salary)`` add all non-NULL salaries and
ignores rows containing a NULL salary.

Aggregate functions and arithmetic operators handle NULL differently.
Arithmetic operators return NULL when either operand is NULL.

As a result, combinations of arithmetic and aggregate functions may
generate surprising results depending on how you combine them.

For example, ``sum(Salary) + sum(Bonus)`` is not equal to ``sum(Salary + Bonus)``.


3.4 Join queries
----------------
Joins combine rows from multiple tables based on a related column.
They allow you to retrieve related data stored in separate tables.
Conceptually, joins are similar to set operations in math.

In SQL, joins are implemented using the SELECT statement.
The related column must have the same datatype in all tables
to be eligible for comparision with join queries.

::

  select 

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
Here is some advice to keep your joins as simple as possible.

1. Only use LEFT JOIN and INNER JOIN.

2. Refer to columns as table_name.column_name.

3. Only include 1 condition in your join.

4. One of the joined columns should have unique values.


Inner join (intersection)
^^^^^^^^^^^^^^^^^^^^^^^^^
An inner join is like a set intersection in math.
An inner join selects only rows matching the ON condition which are present in both tables.

::

  SELECT *
  FROM owners INNER JOIN cats
    ON cats.owner = owners.id

Full join (union)
^^^^^^^^^^^^^^^^^
This is like a set union operation.
It selects all left and right table rows regardless of match.
The full join is also known as the full outer join.

::

  select *
  from visitor as v
  full join martian as m
  where 
    m.martian_id is null 
    or v.visitor_id is null;


Left join
^^^^^^^^^
Left join includes every row from the left tabel, even if it's not in the right table.
Rows not in the right table will have missing fields set to NULL.

::

  SELECT *
  FROM owners LEFT JOIN cats
    ON cats.owner = owners.id

You can also join two fields from the same table.

::
  
  SELECT
    m.first_name as fn,
    m.last_name as ln,
    s.first_name as super_fn,
    s.last_name as super_ln
  FROM martian AS m
  LEFT JOIN martian AS s
  ON m.super_id = s.martian_id
  ORDER BY m.martian_id;

Right join
^^^^^^^^^^
Selects all right table rows regardless of match, but only matching left table rows.
Rows not in the left table will have missing fields set to NULL.

::

  select *
  from
    (select * from inventory where base_id = 1) as i
  right join supply as s
  on i.supply_id = s.supply_id
  order by s.supply_id;



Cross join
^^^^^^^^^^
Performs a cross product between two tables.
Connects each row in the left table with each row in the second table.
This is like a cartesian product.

::

  select b.base_id, s.supply_is, s.name,
    (select quantity from inventory
     where base_id = b.base_id and supply_id = s.supply_id)
  from base as b
  cross join supply as s;


Views
-----
Views are a way to create a virtual table that is dynamically updated
with the result of a select statement. The benefit here is that you
don't have to remember the query. You can also assign permissions to
view that differ from the underlying tables the query came from.

How to create a view
^^^^^^^^^^^^^^^^^^^^
1. Write a query.
2. Insert a line above the query with "CREATE VIEW name AS".
3. You can now treat name as a table.

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

Unions
------
If you want to combine the results of two SELECT queries, you can use a UNION.

::

  SELECT martian_id, first_name, last_name, 'Martian' as status
  FROM martian_public
    UNION
  SELECT visitor_id, first_name, last_name, 'Visitor' as status
  FROM visitor;

The two select queries must have the same number of columns and the types must be the same.


