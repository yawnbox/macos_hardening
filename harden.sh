#!/bin/bash

# Function to check and print the status of a service
print_service_status() {
    service=$1
    description=$2
    status=$(sudo launchctl print-disabled system | grep "$service" | grep -c "disabled")

    if [ "$status" -eq 0 ]; then
        echo "Service: $service - Enabled - $description"
    else
        echo "Service: $service - Disabled - $description"
    fi
}

# Function to describe and offer to disable a service
disable_service() {
    service=$1
    description=$2
    status=$(sudo launchctl print-disabled system | grep "$service" | grep -c "disabled")

    if [ "$status" -eq 0 ]; then
        echo "Service: $service"
        echo "Description: $description"
        echo "Status: Enabled"
        read -p "Do you want to disable this service? (y/n): " choice

        if [ "$choice" = "y" ]; then
            sudo launchctl disable system/$service
            echo "$service has been disabled."
        else
            echo "$service remains enabled."
        fi
    else
        echo "Service: $service is already disabled."
    fi
}

# Array of services and descriptions
declare -a services=(
    "com.apple.AEServer:Remote Apple Events: Allows remote AppleScript execution."
    "com.apple.CSCSupportd:Core Services Support Daemon: Provides various core services."
    "com.apple.uucp:Unix-to-Unix Copy Program: An old method for transferring files."
    "com.apple.ftpd:FTP Daemon: Provides FTP server capabilities."
    "com.apple.mdmclient.daemon.runatboot:Mobile Device Management Client: Manages device configurations."
    "com.apple.smbd:SMB Server: Provides Windows file sharing capabilities."
    "com.apple.bootpd:BOOTP Daemon: Offers BOOTP network services."
    "com.apple.tftpd:TFTP Server: A simple file transfer protocol server."
    "com.apple.ftp-proxy:FTP Proxy: Manages FTP traffic through a proxy."
    "com.apple.telnetd:Telnet Daemon: Provides Telnet remote login capabilities."
    "com.apple.screensharing:Screen Sharing: Allows others to view or control your desktop."
    "com.openssh.sshd:Remote Login (SSH): Allows users to log into your Mac over a network using SSH."
    "com.apple.sharingd:AirDrop: Allows file sharing with nearby Apple devices."
    "com.apple.mDNSResponder:Bonjour: Used for zero-configuration networking to discover devices and services on a local network."
    "com.apple.AirPlayXPCHelper:AirPlay Receiver: Allows your Mac to receive AirPlay content."
    "com.apple.metadata.mds:Spotlight Indexing: Indexes content for quick searching."
    "com.apple.AppleFileServer:File Sharing (AFP): Shares files over the network using AFP."
    "com.apple.InternetSharing:Internet Sharing: Shares your Mac’s internet connection with other devices."
    "com.apple.BluetoothSharing:Bluetooth Sharing: Allows sharing of files over Bluetooth."
    "com.apple.backupd:Time Machine Backup: Automated system backup."
)

# Print initial status
echo "Initial Service Status:"
for entry in "${services[@]}"; do
    IFS=":" read -r service description <<< "$entry"
    print_service_status "$service" "$description"
done

echo "---------------------------------"

# Check and offer to disable each service
for entry in "${services[@]}"; do
    IFS=":" read -r service description <<< "$entry"
    disable_service "$service" "$description"
done

echo "---------------------------------"

# Print final status
echo "Final Service Status:"
for entry in "${services[@]}"; do
    IFS=":" read -r service description <<< "$entry"
    print_service_status "$service" "$description"
done
