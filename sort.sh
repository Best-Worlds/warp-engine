#!/bin/bash  

# Check if input is provided  
if [ "$#" -eq 0 ]; then  
    echo "Usage: $0 version1 version2 ..."  
    exit 1  
fi  

# Function to sort versions  
sort_versions() {  
    for version in "$@"; do  
        # Split version into the main and suffix
        main_version="${version%%-*}"
        suffix="${version#*-}"

        if [ "${main_version}" = "${suffix}"];
        then
            suffix=""
        fi

        # Print main version and suffix for sorting
        # If there's no suffix, just output the main version
        if [ "$suffix" != "$version" ]; then
            echo "$main_version $suffix"
        else
            echo "$main_version"
        fi
    done | sort -Vr | awk '{if (NF > 1) print $1"-"$2; else print $1}'
}

# Call the sorting function
sort_versions "$@"