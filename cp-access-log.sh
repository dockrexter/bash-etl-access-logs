#!/bin/bash
# etl_access_log.sh
# ETL pipeline in Bash to extract, transform, and load web server access logs into PostgreSQL.
# Author: Shaheer Rahi
# Date: 2025-12-27
# License: MIT

# ----------------------------------------
# CONFIGURATION
# ----------------------------------------
# Set PostgreSQL credentials via environment variables for security.
# Example:
#   export PGUSER=postgres
#   export PGPASSWORD=your_password
#   export PGHOST=localhost
DB_NAME="template1"
TABLE_NAME="access_log"
DATA_FILE="web-server-access-log.txt.gz"
EXTRACTED_FILE="extracted-data.txt"
TRANSFORMED_FILE="transformed-data.csv"

# ----------------------------------------
# EXTRACT PHASE
# ----------------------------------------
echo "[INFO] Extracting data from $DATA_FILE"

# Unzip the file if it exists
if [ -f "$DATA_FILE" ]; then
    gunzip -f "$DATA_FILE"
else
    echo "[ERROR] File $DATA_FILE not found!"
    exit 1
fi

# Extract relevant columns (timestamp, latitude, longitude, visitorid)
cut -d"#" -f1-4 "${DATA_FILE%.gz}" > "$EXTRACTED_FILE"

# ----------------------------------------
# TRANSFORM PHASE
# ----------------------------------------
echo "[INFO] Transforming data to CSV format"

# Replace '#' delimiter with ',' to create CSV
tr "#" "," < "$EXTRACTED_FILE" > "$TRANSFORMED_FILE"

# ----------------------------------------
# LOAD PHASE
# ----------------------------------------
echo "[INFO] Loading data into PostgreSQL table '$TABLE_NAME'"

# Check if PostgreSQL environment variables are set
if [ -z "$PGPASSWORD" ] || [ -z "$PGUSER" ] || [ -z "$PGHOST" ]; then
    echo "[ERROR] PostgreSQL environment variables (PGUSER, PGPASSWORD, PGHOST) are not set."
    exit 1
fi

# Copy CSV data into PostgreSQL table
psql --username="$PGUSER" --host="$PGHOST" --dbname="$DB_NAME" <<EOF
\COPY $TABLE_NAME FROM '$(pwd)/$TRANSFORMED_FILE' DELIMITER ',' CSV HEADER;
EOF

echo "[INFO] ETL process completed successfully!"
