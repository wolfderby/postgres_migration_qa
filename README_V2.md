prequistes:
- a postres from_db
- a new host and/or name for the postgres to_db 
- postgres permissions on each host
- psql
- linux servers

- [ ] ssh into host of postgres database you want to migrate (from_db's host)
- [ ] pg_dumpall --roles-only > create_roles.sql
- [ ] scp username@linux_server_ip:/path/to/create_roles.sql /local/path/on/windows/
- [ ] pg_dump -Fc from_db > path/to/dump_file_spot/from_db.dump
  - [ ] mkdir from_db/logs/ on from_host
  - [ ] mkdir from_db/logs/from_postgres/ on from_host
    - [ ] chmod postgres:postgres to_db/from_postgres
  - [ ] mkdir to_db/logs/ on to_host
  - [ ] mkdir to_db/postgres_dumps/ on to_host
    - [ ] chmod postgres:postgres to_db/postgres_dumps
- [ ] ssh into to_host
- [ ] psql -h to_host -U username -d to_database -a -f create_roles.sql
- [ ] rsync file to to_db's host
- [ ] create roles for database
- [ ] create empty to_db
- [ ] pg_restore and out 
  ```sh
   sudo -u postgres pg_~restore -d db_name --verbose /data/db_name/db_name.dump > /data/db_name_090823.log 2>&1
  ```

## stage 0 - set env / conf vars
## stage 1 - Query to queries
```sql
WITH GeneratedQueries AS (
    SELECT 
        'SELECT ''' || table_schema || ''' AS schema_name, ''' || table_name || ''' AS table_name, COUNT(*) FROM "' || table_schema || '"."' || table_name || '" UNION ALL ' as generated_sql
    FROM 
        information_schema.tables 
    WHERE 
        table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema')
)

SELECT 
    rtrim(string_agg(generated_sql, ''), ' UNION ALL ') || ' ORDER BY schema_name ASC, table_name ASC' as final_sql 
FROM 
    GeneratedQueries;

```
## stage 2 - results to csv
## stage 2b - add to csv
## stage 3 - counts to compare
## stage 3 - 