#! /bin/bash

echo -n "$1" | tee -a ./favorite-characters.txt
echo "" >> ./favorite-characters.txt
