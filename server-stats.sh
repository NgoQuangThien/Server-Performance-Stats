#!/usr/bin/env bash

# Total cpu usage
# total_cpu_usage = 100 - id (Idle CPU Time)
total_cpu_usage=$(top -bn1 | head -n3 | grep "%Cpu(s)" | awk '{print 100 - $8}')

# Total memory usage (Free vs Used including percentage)
read -r _ total_memory memory_used memory_free _ _ _ <<< $(free -m | grep Mem:)
percentage_memory_used=$(awk -v total=$total_memory -v used=$memory_used 'BEGIN {printf "%.2f", (used / total) * 100}')
percentage_memory_free=$(awk -v total=$total_memory -v free=$memory_free 'BEGIN {printf "%.2f", (free / total) * 100}')

# Total disk usage (Free vs Used including percentage)
read -r _ disk_size disk_used disk_free percentage_disk_used _  <<< $(df -h / | tail -n1)
percentage_disk_free="$(awk -v used=$percentage_disk_used 'BEGIN {printf "%.0f", 100 - used}')%"

# Top 5 processes by CPU usage
top_cpu_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | tail -n +2 | awk '{print $3}')

# Top 5 processes by memory usage
top_memory_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tail -n +2 | awk '{print $3}')

# Print the results
echo "Total CPU Usage: $total_cpu_usage%"
echo

echo "Total Memory Used: ${memory_used} MiB"
echo "Total Memory Free: ${memory_free} MiB"
echo "Percentage Memory Used: $percentage_memory_used%"
echo "Percentage Memory Free: $percentage_memory_free%"
echo

echo "Total Disk Used: $disk_used"
echo "Total Disk Free: $disk_free"
echo "Percentage Disk Used: $percentage_disk_used"
echo "Percentage Disk Free: $percentage_disk_free"
echo

echo "Top 5 processes by CPU usage:"
for line in "$top_cpu_processes"; do
    echo "$line"
done
echo

echo "Top 5 processes by Memory usage:"
echo $top_memory_processes
for line in "$top_memory_processes"; do
    echo "$line"
done
echo
