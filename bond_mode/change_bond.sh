#!/bin/bash
echo "Network service will be restarted."
service network restart
cat /proc/net/bonding/bond0
