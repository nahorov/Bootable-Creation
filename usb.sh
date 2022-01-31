#!/bin/bash

# Creating an array of removable disks to be used in the following form
readarray -t devarr < <(lsblk | grep part | awk '$3 == "1" {gsub(/└─/,"",$1); print $1, $4, $7}')
delim=""
joined=""
for item in "${devarr[@]}"; do
  joined="$joined$delim$item"
  delim=","
done

# Declaring the contents of the combo-boxes that shall appear in the form
device_menu=$(echo "$joined")
cluster_size_menu=$(echo "4096 bytes (default),1024 bytes,2048 bytes,8192 bytes")
# The form itself, the front-end interface in YAD, where all the choices made get saved as a singular string
OUTPUT=$(yad --title="Bootable-Creation-Alpha." --text="Device Properties and Format Options." \
	--form --separator="," --item-separator="," --width=660\
	--field="List Disk":CBE\
	--field="Select ISO":FL --file-filter \*.iso --file-filter \*.img --file-filter \* \
	--field="Cluster size":CBE\
	"$device_menu" "" "$cluster_size_menu")
accepted=$?
if ((accepted != 0)); then
    echo "something went wrong, aborting process."
    exit 1
fi

# For storing the complete path of the device onto which the image shall be burned
device_selected_stream=$(awk -F, '{print $1}' <<<$OUTPUT)
device_name=$(awk '{print $1}' <<<$device_selected_stream)
device_path_selected=$(lsblk -O | grep $device_name | awk '{print $3}')

# Making a variable out of the path of the image-file selected
image_file_selected=$(awk -F, '{print $2}' <<<$OUTPUT)

# Making a usable variable out of the block-size created
cluster_size=$(awk -F, '{print $3}' <<<$OUTPUT)
cluster_size_in_kb=$(sed 's/\s.*$//' <<<$cluster_size)
case $cluster_size_in_kb in
	4096)
		cluster_size_selected="4096"
		;;
	1024)
		cluster_size_selected="1024"
		;;
	2048)
		cluster_size_selected="2048"
		;;
	8192)
		cluster_size_selected="8192"
		;;
	512)
		cluster_size_selected="512B"
		;;
esac

# Echoing all set variables in terminal
echo "$device_path_selected"
echo "$image_file_selected"
echo "$cluster_size_selected"
yad --title=Question --image=dialog-question --text="Are you sure you want to create a bootable on $device_path_selected? 
If you proceed, all the data on this partition will be destroyed irretrievably." 
warning_accepted=$?
if ((warning_accepted !=0)); then
	echo "The process has been aborted by the user."
	exit 1
fi

# Driver Code
sudo umount "$device_path_selected"
sudo mkfs.vfat "$device_path_selected"
sudo dd if="$image_file_selected" of="$device_path_selected" bs="$cluster_size_selected" status=progress
