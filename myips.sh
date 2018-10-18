#!/bin/bash
# usage: /mnt/full/path/linux.scripts/myips.sh | alias myips
# Note: script designed for linux, tested and working perfectly at Ubuntu 18.04 LTS

# Define a working folder and save the IP insinde text files
NOTIFICATION_EMAIL="juanrios@linux.com"
WORKING_FOLDER="/mnt/full/path/linux.scripts/"
IP_LAN_PUBLIC_CURRENT_TXT="IP_LAN_PUBLIC.txt"
IP_LAN_PUBLIC_NEW_TXT="IP_LAN_PUBLIC_new.txt"
IP_LAN_PUBLIC_OLD_TXT="IP_LAN_PUBLIC_old.txt"

cd ${WORKING_FOLDER}

# I think this only works at linux
IP_LOCAL=`hostname -I`

# Copy current IP to old
cp "${WORKING_FOLDER}/${IP_LAN_PUBLIC_CURRENT_TXT}" "${WORKING_FOLDER}/${IP_LAN_PUBLIC_OLD_TXT}"

# Reads new IP
dig +short myip.opendns.com @resolver1.opendns.com > "${WORKING_FOLDER}/${IP_LAN_PUBLIC_NEW_TXT}"

IP_REMOTE_OLD=`cat ${IP_LAN_PUBLIC_OLD_TXT}`
IP_REMOTE_NEW=`cat ${IP_LAN_PUBLIC_NEW_TXT}`

# Pretty prints of the findings
echo ""
echo "###################################################"
echo "I'm not Jarvis, but this are your IPs:"
echo "Local IP/eth0:" ${IP_LOCAL}
echo "Current public IP/LAN:" ${IP_REMOTE_NEW}
echo "Old public IP/LAN:" ${IP_REMOTE_OLD}
echo "###################################################"

# IP old and new files validation

CHECK_IP_LAN_PUBLIC_OLD=`cksum ${IP_LAN_PUBLIC_OLD_TXT} | awk -F" " '{print $1}'`
CHECK_IP_LAN_PUBLIC_NEW=`cksum ${IP_LAN_PUBLIC_NEW_TXT} | awk -F" " '{print $1}'`

if [ ${CHECK_IP_LAN_PUBLIC_NEW} -eq ${CHECK_IP_LAN_PUBLIC_OLD} ]
then
  echo "WLAN Public IP is identical"
else
  echo "WLAN Public IP changed"
  echo "Checksum New IP:" ${CHECK_IP_LAN_PUBLIC_NEW}
  echo "Checksum Old IP:" ${CHECK_IP_LAN_PUBLIC_OLD}
   # Notify the boss that the public IP changed
   echo "Public IP changed (new IP: ${IP_REMOTE_NEW}), go and configure services" | mail -s "Linux Public IP changed" ${NOTIFICATION_EMAIL}
fi
