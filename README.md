# Bash ETL Access Logs

This repository contains a Bash-based ETL pipeline that extracts, transforms, and loads web server access logs into a PostgreSQL database.

## Overview

The ETL process consists of three phases:

1. **Extract:** Unzip the raw log file and extract relevant columns (timestamp, latitude, longitude, visitor ID).  
2. **Transform:** Convert the delimiter from `#` to `,` to produce a CSV file.  
3. **Load:** Insert the transformed data into a PostgreSQL table (`access_log`) using the `\COPY` command.

## Prerequisites

- Bash shell
- PostgreSQL database
- Environment variables set for PostgreSQL credentials:

## Usage
- bash etl_access_log.sh
