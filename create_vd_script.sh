#!/usr/bin/env bash

#create a folder that will have an unique name - date
date_time=$(date +%Y%m%d_%H%M%S)
img_file="$HOME/backup_laba/disk_$date_time.img" #create an image
mount_dir="$HOME/backup_laba/disk_$date_time" #where to mount on
size_mb=${1:-1000} #the size(may be as an argument)

#creating a virtual disk
echo "the process of creating a virtual disk has started with a size of $size_mb MB..."
dd if=/dev/zero of=$img_file bs=1M count=$size_mb
mke2fs -t ext4 -F "$img_file" > /dev/null 2>&1 #formating as ext4
mkdir -p $mount_dir #creating a directory for mounting if it doesnt exist
mount "$img_file" "$mount_dir" #mounting
 
echo "great, virtual disk was mounted on $mount_dir!"

