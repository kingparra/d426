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
::

  CREATE TABLE sales (
      id INT AUTO_INCREMENT PRIMARY KEY,
      product_name VARCHAR(50),
      category VARCHAR(50),
      quantity INT,
      price DECIMAL(10, 2)
  );

  INSERT INTO sales (product_name, category, quantity, price)
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

Inner join (intersection)
^^^^^^^^^^^^^^^^^^^^^^^^^
::

  Department                                       Employee                                    Result
  +----------+-------------------+------------+    +---------+------------------+---------+    +--------------------+--------------------+
  | Code[pk] | DepartmentName    | Manager[fk]|    | ID[pk]  |  EmployeeName    |  Salary |    | DepartmentName     | EmployeeName       |
  +----------+-------------------+------------+    +---------+------------------+---------+    +--------------------+--------------------+
  | 44       | Engineering       | 2538       |    | 2538    |  Lisa Ellison    |  45000  |    | Engineering        | Lisa Ellison       |
  | 82       | Sales             | 6381       |    | 5384    |  Sam Snead       |  30500  |    | Sales              | Maria Rodriguez    |
  | 12       | Marketing         | 6381       |    | 6381    |  Maria Rodriguez |  92300  |    | Marketing          | Maria Rodriguez    |
  | 99       | Technical Support | NULL       |    +---------+------------------+---------+    +--------------------+--------------------+
  +----------+-------------------+------------+

  select DepartmentName, EmployeeName
  from Department, Employee
  where Manager = ID;

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

