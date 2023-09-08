- [ ] ssh into host of postgres database you want to migrate (from_db's host)
- [ ] pg_dump -Fc from_db > path/to/dump_file_spot/from_db.dump
  - [ ] mkdir from_db/logs/ on from_host
  - [ ] mkdir from_db/logs/from_postgres/ on from_host
    - [ ] chmod postgres:postgres to_db/from_postgres
  - [ ] mkdir to_db/logs/ on to_host
  - [ ] mkdir to_db/postgres_dumps/ on to_host
    - [ ] chmod postgres:postgres to_db/postgres_dumps
- [ ] rsync file to to_db's host
- [ ] create roles for database
- [ ] create empty to_db
- [ ] pg_restore and out 
  ```sh
   sudo -u postgres pg_~restore -d db_name --verbose /data/db_name/db_name.dump > /data/db_name_090823.log 2>&1
  ```

## stage 0 - set env / conf vars
## stage 1 - Query to queries
## stage 2 - results to csv
## stage 2b - add to csv
## stage 3 - counts to compare
## stage 3 - 