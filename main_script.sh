#!/usr/bin/env bash

#checking the number of arguments
if [ "$#" -lt 2 ]; then
echo "wrong number of arguments. enter $0 FOLDER_PATH  %_of_fullness []"
exit 1
fi

#variables
folder_path="$1"
limit="$2"
count="${3:-3}" #default number of files that will be archivating - 3
backup_dir="$HOME/backup_laba"
archive_dir="$HOME/backup_laba/backup"


#searching for the latest created virtual disk
if [ -n "$(ls disk*.img 2>/dev/null)" ]; then
  img_file=$(ls -t disk*.img 2>/dev/null | head -n 1)
else
  echo "sorry, the image file wasnt found: $img_file"
  exit 1
fi

#check whether the path exists
if [ ! -d "$folder_path" ]; then
  echo "the $folder_path does not exist"
  exit 1
fi



folder_size=$(du -sb "$folder_path" 2>/dev/null | awk '{print $1}') #calculating a size of folder with files
echo "size of the folder $folder_path if $folder_size bytes"
total_space=$(du -b "$img_file" | awk '{print $1}') #calculating the size of virtual disk
folder_usage_percent=$(echo "scale=2; 100 * $folder_size / $total_space" | bc) #calculating the percent of fulnessness of the folder according to vd size
echo "the folder is full on $folder_usage_percent%"


#comparison with X (limit)
if [ $(echo "$folder_usage_percent > $limit" | bc) -eq 1 ]; then
  old_files=$(ls -t "$folder_path" | head -n $count) #take n oldest files in the folder
  #check if the folder is empty
  if [ -z "$old_files" ]; then
    echo "the folder is empty"
    exit 0
  fi
  if [ $? -eq 0 ]; then
    archive_name="$archive_dir/archive_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$archive_name" -C "$folder_path" $old_files #archivating
    echo "$count files are archieved into $archive_name"
    for item in $old_files; do  #deleting files
      rm -rf "$folder_path/$item"
      echo "✓ file $item was deleted"
    done
    echo "everything is done. your folder is arhivated."
  else
    echo "arhivation has not started"
    exit 1
  fi
else
  echo "arhivation is not neccessary"
  exit 0
fi
