Chapter 5: Data Storage
***********************


5.1 Storage media
-----------------
Data storage media varies on four important dimensions:

* Speed
* Cost
* Capacity
* Volatility

These three types of media are important for database managment:

* Main memory (RAM)
* Flash memory (SSD, etc)
* Magnetic disk (HDD)

::

  Media type             Access time (microseconds)          Transfer rate GB/s      Cost $ per GB      Volatile
  Main memory            .01 to .1                           > 10                    > 1                Yes
  Flash memory           20 to 100                           .5 to 3                 ~.25               No
  Magnetic disk          5000 to 10000                       .05 to .2               ~.2                No

Sectors, pages, and blocks
^^^^^^^^^^^^^^^^^^^^^^^^^^
Magnetic disks groups data in sectors (512b or 4KB).
Flash memory groups data in pages (2KB to 16KB).
Database and filesystems use blocks (2KB to 64KB, but it can be anything).

Row-oriented storage
^^^^^^^^^^^^^^^^^^^^
Databases often store an entire row within one block, which is called row-oriented storage.
The idea is to minimize the number of blocks required for common queries.
Row oritnted storage performs best when row size is small relative to block size, for two reasons:

* **Improved query performance.**
  When row size is small relative to block size, each block contains many rows.
  Queries that read and write multiple rows transfer fewer blocks, resulting in better performance.

* **Less wasted storage.**
  Row-oriented storage wastes a few bytes per block, cine rows do not usually fit evenly into the available space.
  The wasted space is less than the row size.
  If the row size is small relative to block size, the wasted space is insignificant.

Consequently, database administrators might specify a larger block size for databases containing larger rows.

When there are large columns, sometimes they will be stored in a different area
in order to keep the overall row size small enough for efficient block access.
In place of the large column, there will be a link to it, instead.

Column-oriented storage
^^^^^^^^^^^^^^^^^^^^^^^
Analytic applications often read just a few columns from many rows.
In this case, column-oriented storage is optimal.
In column-oriented storage, also called columnar stoarage, each block stores
values for a single columns only.

Column-oriented storage benefits analytic applications in several ways:

* **Faster data access.**
  More column values are transferred per block, reducing time to access storage media.

* **Better data compression.**
  Databases often apply data compression algorithms when storing data.
  Data compression is usually more effective when all values have the same data type.
  As a result, more values are stored per block, which reduces storage and access time.

Row-oriented storage performs better than column-oriented storage for most
transactional databases.

5.2 Table structures
--------------------
A **table structure** is a scheme for organizign rows in blocks on storage media.
Databases commonly support four alternate table structures.

* **Heap table**: no order is imposed on rows. 
  Optimizes for insert operations.
  Fast for bulk load of may rows, since rows are stored in load order. 
  Heap tables are not optimal for queries that read rows in a specific order,
  such as a range of primary key values,
  since rows are scattered randomly across storage media.

* **Sorted table**: A sort column determines physical row order.
  Rows are assigned to blocks according to the value of the sort column.
  Each block contains all rows with values in a given range.
  Within each block, rows are located in order of sort column values.
  Sorted tebles are optimal for queries that read data in order of the sort column, such as:

  * JOIN on the sort column
  * SELECT with range of sort column values in the WHERE clause.
  * SELECT with ORDER BY the sort column.

  Maintainint correct sort order of rows within each block can be slow.
  When an attempt is made to insert a row into a full block, the block splits in two.
  The database moves half the rows from the initial block to a new block, creating space for the insert.
  In summary, sorted tables are optimized for read queries at the expense of insert and update operations.
  Since reads are more frequent than updates and inserts in many databases, sorted tables are often used,
  usually with the primary key as the sort column.

* **Hash table**: In a hash table, rows are assigned to buckets.
  A bucket is a block or group of blocks containing rows.
  hash tables are optimal for inserts and deltes of indidual rows, since row
  location is quickly determined from the hash key.
  Hash tables are slow on queries that select many rows with a range of values,
  since rows are randomly distributed across many blocks.

* **Table cluster**: Table clusters, also called multi-tables, interleave rows of two or more tables in the same storage area.
  I don't know, this one is confusing, and I don't feel motivated to figure it out.

Each table in a database can have a different structure.
Databases assign a default structure to all tables.


5.3 Single-level indexes
------------------------
A **single-level index** is a file containing column values, along with pointers to rows containing the column value.
The pointer identifies the block containing the row.

Query processing
^^^^^^^^^^^^^^^^
A **table scan** is an operation that reads table blocks directly without accessing an index.

An **index scan** reads index blocks sequentially in order to located the needed table blocks.

**Hit ratio** is the percentage of table rows selected by a query.

