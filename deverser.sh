#!/bin/sh

if [ -f "dump.raw" ]; then
    rm -rf dump.raw
fi

cat << "intro"
[!] Welcome to Déverser, a simple script to dump onboard SHSH (Blobs) with a valid Generator for iOS devices...
[!] This script will allow you to use dumped blobs with futurerestore at a later date (depending on SEP compatibility)...
intro

if which curl >/dev/null; then
    echo "[i] curl is installed!"
else
    echo "[!] Please install curl before running this script"
    exit 2
fi

if which python3 >/dev/null; then
    echo "[i] python3 is installed!"
else
    echo "[!] Please install python3 before running this script"
    exit 2
fi

if [ -f "img4_to_shsh.py" ]; then
    echo "[!] Found conversion script!"
else
    echo "[#] This script requires a script to convert the dumped blob, do you want to install it (script will close without it)"
    echo "[*] Please enter 'Yes' or 'No':"
    read -r consent
    case $consent in 
        [Yy]* )
            echo "[!] Downloading script..."
            curl -L https://gist.githubusercontent.com/beerpiss/e938cd84ebd9695258feca03444e81e7/raw/dacaa98a8f8a94e0f4a509d1e6b6495053046d71/convert.py -o img4_to_shsh.py
            
            echo "[!] Setting up virtual environment..."
            python3 -m venv env/ && source env/bin/activate
            
            echo "[!] Installing dependencies..."
            pip3 install -U pyasn1
            ;;
        * )
            exit
            ;;
    esac
fi
echo "[!] Please enter your device's IP address (Found in wifi settings)..."
read -r ip
echo "Device's IP address is $ip"
echo "[*] Assuming given IP to be correct, if connecting to the device fails ensure you entered the IP correctly and have OpenSSh installed..."
echo "[!] Please enter the device's root password (Default is 'alpine')..."
ssh root@$ip 'cat /dev/disk1 | dd of=dump.raw bs=256 count=$((0x4000))' >/dev/null 2>&1
echo "[!] Dumped onboard SHSH to device, about to copy to this machine..."
echo "[!] Please enter the device's root password again (Default is 'alpine')..."
if scp root@$ip:dump.raw dump.raw >/dev/null 2>&1; then
   :
else
    echo "[#] Error: Failed to to copy 'dump.raw' from device to local machine..."
    exit
fi
echo "[!] Copied dump.raw to this machine, about to convert to SHSH..."
python3 img4_to_shsh.py dump.raw dumped.shsh >/dev/null 2>&1
if img4tool -s dumped.shsh | grep -q 'failed'; then
    echo "[#] Error: Failed to create SHSH from 'dump.raw'..."
    exit
fi
ecid=$(img4tool -s dumped.shsh | grep "ECID" | cut -c13-)
mv dumped.shsh $ecid.dumped.shsh # Allows multiple devices to be dumped as each dump/converted SHSH will have a filename that links the SHSH to the device
generator=$(cat $ecid.dumped.shsh | grep "<string>0x" | cut -c10-27)

echo "[!] SHSH should be dumped successfully at '$ecid.dumped.shsh' (The number in the filename is your devices ECID)!"
echo "[!] Your Generator for the dumped SHSH is: $generator"
echo "[@] Written by Matty (@mosk_i) - Enjoy!"
exit 0
