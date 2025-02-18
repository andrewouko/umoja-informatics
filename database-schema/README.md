# Database Schema Documentation

The schema is defined in two SQL files: `schema.sql`. The queries are in `queries.sql`.

## Files

### schema.sql

This file contains the SQL statements required to create the database schema, including the definitions of tables and indexes. It also contains insert statements to insert the data. If the email is not unique the insert statement for users will not insert and fail silently.

### queries.sql

This file contains the SQL queries;

1. All articles with their authors
2. Count number of comments on each article
3. Fetch the latest 5 articles

## Usage

### Login to the postgres database

```sh
psql -h <db endpoint> -U <username> -d postgres -W
```

### Setup the database once logged in

```sh
\i schema.sql
```

### Use the queries

```sh
\i queries.sql
```
