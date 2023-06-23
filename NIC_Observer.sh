#!/bin/sh

#Simple Network Interface Monitoring script developed by ParkJongHa 

# Get a list of all network interfaces starting with "eth"
interfaces=$(ifconfig -a | grep -oP "^(eth|br[0-9]+)")

# Loop through each interface and check its link status
while true; do
    for interface in $interfaces; do
        # Use ethtool to get the link status of the interface
        link_status=$(ethtool $interface | grep 'Link detected' | awk '{print $3}')

        # Get the previous link status for the interface
        prev_status_var="prev_link_status_$interface"
        prev_status=$(eval "echo \$$prev_status_var")

        # If the link status has changed, print a message and update the previous status
        if [ "$prev_status" != "$link_status" ]; then
            if [ "$link_status" = "yes" ]; then
                echo "$interface is UP"
            else
                echo "$interface is DOWN"
            fi
            eval "$prev_status_var=$link_status"
        fi
    done

    # Wait for one second before checking the link status again
    sleep 1
done
