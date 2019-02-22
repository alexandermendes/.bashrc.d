# Remove files from downloads folder older than 7 days
clean_downloads() {
  find ~/Downloads -mtime +7 -type f -delete
  find ~/Downloads -type d -empty -delete
}

