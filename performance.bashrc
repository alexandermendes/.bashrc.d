# Speedup terminal by clearing system logs
alias speedup="sudo rm -rf /private/var/log/asl/*"
         
# Find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

