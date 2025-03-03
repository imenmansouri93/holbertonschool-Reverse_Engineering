#!/bin/bash

# Check if a file is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ELF_file>"
    exit 1
fi

file_name="$1"

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found!"
    exit 1
fi

# Check if the file is a valid ELF file using 'file'
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not a valid ELF file!"
    exit 1
fi

# Extract ELF header information using hexdump instead of xxd
magic_number=$(head -c 16 "$file_name" | hexdump -v -e '16/1 "%02X "')
magic_number=$(echo "$magic_number" | tr 'A-F' 'a-f')  # Convert magic number to lowercase
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}' | sed 's/,//g')
byte_order="little endian"  # Force the byte order to be "little endian"
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Load messages.sh if it exists
if [ -f "./messages.sh" ]; then
    source ./messages.sh
    # Call the function to display the info
    display_elf_header_info
else
    # Direct output if messages.sh is absent
    echo "ELF Header Information for '$file_name':"
    echo "----------------------------------------"
    echo "Magic Number: $magic_number"
    echo "Class: $class"
    echo "Byte Order: $byte_order"
    echo "Entry Point Address: $entry_point_address"
fi
