#!/bin/bash

# Vérifier si un fichier a été fourni en argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ELF_file>"
    exit 1
fi

file_name="$1"

# Vérifier si le fichier existe
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found!"
    exit 1
fi

# Vérifier si le fichier est un ELF valide en utilisant 'file'
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not a valid ELF file!"
    exit 1
fi

# Extraire les informations ELF
magic_number=$(xxd -p -l 4 "$file_name" | tr -d '\n')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Charger messages.sh s'il existe
if [ -f "./messages.sh" ]; then
    source ./messages.sh
    # Appeler la fonction pour afficher les infos
    display_elf_header_info
else
    # Affichage direct si messages.sh est absent
    echo "ELF Header Information for '$file_name':"
    echo "----------------------------------------"
    echo "Magic Number: $magic_number"
    echo "Class: $class"
    echo "Byte Order: $byte_order"
    echo "Entry Point Address: $entry_point_address"
fi
