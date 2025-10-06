#!/bin/bash

# ============================
#   Simple folder backup utility
# ============================

# Check that arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <folder_to_backup> <project_name> [number_of_archives_to_keep]"
  exit 1
fi

SOURCE_DIR=$1
PROJECT_NAME=$2
MAX_BACKUPS=${3:-5}   # keep 5 archives by default
BACKUP_DIR="./backups"

# Create backups directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Archive name with date and time
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="${PROJECT_NAME}_${DATE}.tar.gz"

# Create archive
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

echo "[OK] Archive created: $BACKUP_DIR/$ARCHIVE_NAME"

# Remove old archives if there are more than $MAX_BACKUPS
TOTAL_BACKUPS=$(ls -1t "$BACKUP_DIR"/${PROJECT_NAME}_*.tar.gz 2>/dev/null | wc -l)

if [ "$TOTAL_BACKUPS" -gt "$MAX_BACKUPS" ]; then
  REMOVE_COUNT=$((TOTAL_BACKUPS - MAX_BACKUPS))
  OLD_FILES=$(ls -1t "$BACKUP_DIR"/${PROJECT_NAME}_*.tar.gz | tail -n "$REMOVE_COUNT")
  echo "[INFO] Removing old archives:"
  echo "$OLD_FILES"
  rm $OLD_FILES
fi
