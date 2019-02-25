# Clear crontab
crontab -r

# Enable sourcing of bash profile
SHELL=/bin/bash

# Clean downloads folder
echo "00 12 * * * source /Users/mendeaw6/.bash_profile; clean_downloads" >> /tmp/mycron

# Add temp file to crontab
crontab /tmp/mycron
rm /tmp/mycron

