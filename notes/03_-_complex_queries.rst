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


