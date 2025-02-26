# Déverser
Simple script to dump onboard SHSH with a valid Generator for iOS devices (now with Linux support!)

## What is this/What does this do

Déverser is a simple script to dump onboard SHSH from iOS devices and convert it to useable SHSH which contains a generator! This is different to just dumping 'ApTicket.der' from the device's filesystem, like some jailbreaks such as Unc0ver allow for, as the 'ApTicket.der' doesn't contain the generator for the ApNonce it is valid for, meaning restores/downgrades using converted ApTicket.der's are not possible unless you know the generator.

This script simply dumps iBoot from /dev/rdisk1 on the device, copies the dump to your computer then converts the dump to valid SHSH using [img4tool](https://github.com/tihmstar/img4tool). This is all possible and easy to do manually, this script just allows for those who are less comfortable with the command line or less knowledgeable to have a simple method to dump onboard SHSH.

Even though this script will give you valid SHSH for the currently installed iOS version on your device, you are still limited by signed SEP and Baseband compatiblity when restoring/downgrading with this dumped SHSH, so please bare that in mind when using this script.

## Requirements

A Linux or macOS machine (Use the .sh file for these platforms) (optional if using a modern jb)

if not running on device: A jailbroken device with a ssh server running (typically OpenSSH)

img4tool installed (If img4tool is not installed, the script will download and install it fter getting the users permission

## Usage (.sh file)

1. Either run `git clone https://github.com/joshuah345/deverser.git` and extract to a folder on your machine or download the latest release zip.
2. 'cd' to the deverser folder and then run 'chmod +x deverser.sh'
3. Run './deverser.sh'
4. Follow what the script asks you to do (Mostly just entering your device's IP address and root password for SSH/SCP)

## Issues/Bugs/Fixes/Improvements

If you have any bugs/issues open an issue [here](https://github.com/joshuah345/deverser/issues) with details about your macOS machine (OS version, other basic info), iOS device (iOS version, jailbreak, etc) and details about what is not working.

Any ideas/fixes/improvements can be sent in a pull request [here](https://github.com/joshuah345/deverser/pulls).

## Credits

Matty - [@mosk_i](https://twitter.com/moski_dev) - For writing the script
Original macOS script can be found [here.](https://github.com/MatthewPierson/deverser/)

Superuser1958 - changes for Linux, rootless and on-device mode

Tihmstar - [@tihmstar](https://twitter.com/tihmstar) - For creating img4tool
