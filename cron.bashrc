# Create cron jobs
crontab -r

echo "00 12 * * * clean_downloads" >> /tmp/mycron

crontab /tmp/mycron
rm /tmp/mycron

