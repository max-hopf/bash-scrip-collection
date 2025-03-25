#!/bin/bash

# Function to ask for process scope
get_scope() {
  read -p "Do you want to show (a)ll processes or only current (u)ser-specific ones?: " scope
  if [ "$scope" = "u" ]; then
    echo "Listing processes for user: $USER"
    filter_user=true
  elif [ "$scope" = "a" ]; then
    echo "Listing processes for all users"
    filter_user=false
  else
    echo "Invalid input. Please enter 'a' or 'u'. Exiting."
    exit 1
  fi
}

# Function to ask for sorting option
get_sort_option() {
  read -p "Do you want to sort by Memory usage (m) or CPU consumption (c)?: " sort
  if [ "$sort" = "m" ]; then
    sort_option="-%mem"
  elif [ "$sort" = "c" ]; then
    sort_option="-%cpu"
  else
    echo "No valid input provided. Exiting."
    exit 1
  fi
}

# Function to ask how many processes to display
get_lines() {
  read -p "How many processes do you want to display (type 'a' for all or a number)?: " lines
}

# Function to display the processes
display_processes() {
  echo ""
  if [ "$filter_user" = true ]; then
    filter="$USER"
  else
    filter=""
  fi

  if [ "$lines" = "a" ]; then
    echo "Showing all processes sorted by ${sort_option} ${filter:+for user $filter}"
    echo ""
    ps -eo pid,ppid,user,%mem,%cpu,comm --sort="$sort_option" | grep -i "$filter"
  else
    echo "Showing top ${lines} processes sorted by ${sort_option} ${filter:+for user $filter}"
    echo ""
    ps -eo pid,ppid,user,%mem,%cpu,comm --sort="$sort_option" | grep -i "$filter" | head -n "$lines"
  fi
}

# Main function
main() {
  get_scope
  get_sort_option
  get_lines
  display_processes
}

# Run main
main
