# Bootable-Creation
A simple Bash and YAD utility to lend a GUI to the process of creating a Bootable USB-disk with the image file of choice.<br>
This program was made specifically for the Bash shell and Linux/Unix-like systems.<br> 
This is a program which makes it easy to create a Bootable flash drive on Linux/Unix based systems with the help of a GUI form. All the user needs to do is insert a USB flash drive, and run the program and do as the form guides them to do. No need to list out all the drives in the terminal and figure out which one is the flash drive of them all, that is taken care of and only the drives which are removable shall be listed in the menu. This is to make the process of creating the bootable flash drive simpler for users who do not understand Linux's file system and drive partitioning scheme natively yet. <br>
Software prerequisites:<br>
<ul>GNU bash, version 5.1.8(1)-release</ul>
<ul>YAD 9.3 (GTK+ 3.24.31)</ul>

![alt text](https://github.com/nahorov/Bootable-Creation/blob/main/screenshot.png?raw=true)

<br>
First, YAD needs to be installed on your system for this utility to work. If it doesn't have YAD, then<br>
For Ubuntu 20.04/Debian 10 based distros<br>
```
$ sudo apt update
$ sudo apt install yad
```

For Ubuntu 14.04 - 19.10/Debian 7 - 9 based distros:<br>
```
$ sudo apt-get update
$ sudo apt-get install yad
```

For RHEL/CentOS/Fedora:<br>
```
$ sudo dnf update
$ sudo dnf install yad
```

To run, first make sure you have sudoer rights. Then, do the following:<br>
```
$ sh usb.sh
```
<br>
Or you could turn it into an executable with<br>

```
$ chmod +x usb.sh
```
and then<br>

```
$ ./usb.sh
```
<br>
The form is designed to give a GUI to the dd command. 


