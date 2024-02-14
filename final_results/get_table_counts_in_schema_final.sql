-- Filename: get_table_counts_in_schema_final.sql

CREATE OR REPLACE FUNCTION get_table_counts_in_schema(schema_name TEXT)
RETURNS TABLE(table_name TEXT, row_count BIGINT) AS $$
DECLARE
    -- Declare a cursor for looping through the tables using a fully qualified column name.
    cur_tables CURSOR FOR 
        SELECT t.table_name 
        FROM information_schema.tables t
        WHERE t.table_schema = schema_name AND t.table_type = 'BASE TABLE';
    v_table_name TEXT; -- Variable to hold each table name from the cursor.
    v_row_count BIGINT; -- Variable to hold the count of rows for each table.
BEGIN
    OPEN cur_tables;
    LOOP
        -- Fetch the next table name from the cursor into the variable.
        FETCH cur_tables INTO v_table_name;
        EXIT WHEN NOT FOUND; -- Exit the loop if there are no more tables.
        
        -- Execute the dynamic SQL to count rows in the current table.
        EXECUTE format('SELECT COUNT(*) FROM %I.%I', schema_name, v_table_name) INTO v_row_count;
        
        -- Set the function's return values.
        table_name := v_table_name; -- Assign the current table name.
        row_count := v_row_count; -- Assign the count of rows for the current table.
        
        RETURN NEXT; -- Return the current row and continue with the next table.
    END LOOP;
    CLOSE cur_tables;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_table_counts_in_schema('staging_fdadrugs');
