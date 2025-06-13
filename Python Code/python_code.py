import os
import cx_Oracle
import csv
from datetime import date
import pandas as pd
import json
import logging

# Get the current date for creating the log file name
log_date = date.today().strftime("%Y%m%d")

# Configure logging with the date in the log file name
log_directory = 'Output'  # The desired log directory
os.makedirs(log_directory, exist_ok=True)  # Create the log directory if it doesn't exist
log_file = os.path.join(log_directory, f'etl{log_date}.log')
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s [%(levelname)s] - %(message)s')

# Load the 'config' dictionary from the JSON file
with open('config_ps.json') as j:
    config = json.load(j)

# Read table information from the CSV file
table_info = []
with open('table.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)  # Default delimiter is a comma
    next(csvreader)  # Skip the header
    for row in csvreader:
        if len(row) >= 4:  # Make sure the row has enough elements
            source = row[0]
            table_name = row[1].strip('[]')  # Remove square brackets
            cdc = row[2]
            fields = row[3]
            table_info.append({'source': source, 'table_name': table_name, 'cdc': cdc, 'fields': fields})
        else:
            logging.warning("Invalid row: %s", row)

# Get the current date for creating the folder
folder_date = date.today().strftime("%Y%m%d")

# Create a folder with the current date as the folder name
output_folder_path = os.path.join('Output', folder_date)
os.makedirs(output_folder_path, exist_ok=True)

# Loop through the list of table information
for table in table_info:
    source = table['source']
    table_name = table['table_name']
    cdc = table['cdc']
    fields = table['fields']

    # Determine which database configuration to use
    db_config = config.get(source)

    if db_config is None:
        logging.warning("Unknown source: %s", source)
        continue

    # Establish database connection
    try:
        user = db_config.get('user')
        password = db_config.get('password')
        address = db_config.get('address')
        port = db_config.get('port')
        sid = db_config.get('sid')

        if not all((user, password, address, port, sid)):
            logging.warning("Incomplete or missing configuration values for %s.", source)
            continue

        connection = cx_Oracle.connect(user=user, password=password, dsn=f"{address}:{port}/{sid}")
        logging.info("Database %s connected successfully", source)

        # Construct the query based on CDC and Fields
        if cdc == '*':
            query = f'SELECT * FROM {table_name}'
        else:
            query = f'SELECT {fields} FROM {table_name}'

        # Create a cursor
        cur = connection.cursor()

        # Execute the query
        cur.execute(query)

        # Fetch rows from the cursor
        rows = cur.fetchall()

        # Log the row count
        row_count = len(rows)
        logging.info("Table: %s, Row Count: %d", table_name, row_count)

        # Extract column names from cursor description
        col_names = [i[0] for i in cur.description]

        # Close the cursor
        cur.close()

        # Create a DataFrame from the fetched data and column names
        data_df = pd.DataFrame(rows, columns=col_names)

        # Generate the output file name based on the provided format and today's date
        today_date = date.today().strftime("%Y%m%d")
        table_parts = table_name.split('.')
        output_file_name = f'LVL_{source}_{table_parts[-1]}_{today_date}.csv'

        # Save the DataFrame to a CSV file in the specified folder
        output_file_path = os.path.join(output_folder_path, output_file_name)
        data_df.to_csv(output_file_path, index=False)
        logging.info("File saved: %s", output_file_name)

        # Close the database connection
        connection.close()

    except cx_Oracle.Error as error:
        logging.error("Error connecting to %s database: %s", source, error)
        continue

logging.info("ETL process completed.")