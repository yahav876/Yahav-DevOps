#!/bin/bash

# Set the path to the directory where you want to delete old files
target_directory="/usr/local/fountain/logdata/statlog/log"

# Define the maximum age (in days) for files to be considered "old"
max_age_days=7

# Use the 'find' command to locate and delete old files
find "$target_directory" -type f -mtime +"$max_age_days" -exec rm -f {} \;
