<#
.SYNOPSIS
This script sets the NTP server to the specified domain controller or other NTP server.

.DESCRIPTION
This script configures the system to use a specific NTP server for time synchronization. It sets the time source to the provided NTP server and restarts the Windows Time service.

The script needs to be run in the admin context.

.NOTES
  Version:        1.0
  Author:         Keensy
  Creation Date:  14/11/2024
#>

# Specify the NTP server (replace with your domain controller or other NTP server)
$NTPServer = ($env:LOGONSERVER -replace "^\\\\", "")+".$env:USERDNSDOMAIN" # Replace with your domain controller or NTP server

# Set the NTP server for Windows Time service
w32tm /config /manualpeerlist:$NTPServer /syncfromflags:manual /reliable:YES /update

# Restart the Windows Time service to apply the changes
Restart-Service w32time

# Force synchronization immediately
w32tm /resync


w32tm /query /status
