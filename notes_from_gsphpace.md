brb265@jupyterhub-mearsdb-01 /data/gsph_pace_qa $ vi README.md

# how i did the gsph_pace qa on this jupyterhub-mearsdb-01.dbmi.pitt.edu machine

1. psql -> ran VACUUM;

1. created /data/gsph_pace_qa/ dir

1. created /data/gsph_pace_qa/from_postgres_user dir

```sh
# give postgres a folder to write to
chown postgres:postgres ./from_postgres_user/

# bring in latest version of compare script and increment version (it's a wip)
cp /data/alz_ehr_etl_2022/qa/compare_counts_md_v5.sh /data/gsph_pace_qa/compare_counts_md_v6.sh

# bring over latest config
cp /data/alz_ehr_etl_2022/qa/config /data/gsph_pace_qa/config
```

manually set values in /data/gsph_pace_qa/compare_counts_md_v6.sh
 - RESULTS_FROM_NEW_DB_TO_CHECK
 - OUTPUT_FILE

manually set values in /data/gsph_pace_qa/config
 - DB

need to run w/ psql and output to csv this file
  - /data/gsph_pace_qa/gsph_pace_qa_query_formatted.sql

```sh
bash-4.2$  psql -d gsph_pace -A -F "," -f /data/gsph_pace_qa/gsph_pace_qa_query_formatted.sql -o /data/gsph_pace_qa/from_postgres_user/counts_from_newly_loaded_gsph_pace.csv
```

ran
cp /data/alz_ehr_etl_2022/qa/csv2md.sh /data/gsph_pace_qa/

ran ./csv2md.sh
to create an md table


ran
cp /data/alz_ehr_etl_2022/qa/results/add_col.sh /data/gsph_pace_qa/

ran
add_col.sh to append a column of source data

ran compare_counts_md_v6.sh
 - /data/gsph_pace_qa/compare_counts_md_v6.sh





TODO
create qa dirs to include hostname info ?