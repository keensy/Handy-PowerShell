function Set-scanner
{ 
    # Define the input parameter for the function (scanner delay time)
    param($Scannedelay)
    
    <#
    .SYNOPSIS
    This script will run for a specified amount of time when a user session is started. 
    It silently reviews the device manager and sets the appropriate scanner as the default.

    .NOTES
    Name: Set-scanner
    Author: Keensy
    Version: 1.0
    DateCreated: 05/12/2021

    .EXAMPLE
    .'\path\Set-scanner'
    $Timeout = 60
    Set-scanner $Scannedelay
    #>

    #---------------------------------------------------------[Initialisations]---------------------------------------------------------------------------
    
    # Get a list of PnP devices classified as "Image" (scanners or cameras) with status "OK"
    # Select the FriendlyName of each device for further processing.
    $Device = Get-PnpDevice -Class Image | where status -EQ "OK" | Select-Object -property friendlyname
    
    # Stop any running processes related to 'TWAIN_App_mfc32' (scanner-related app)
    # Use -Force to terminate it and -ErrorAction Ignore to handle errors if the process is not found.
    Stop-Process -Name 'TWAIN_App_mfc32' -Force -ErrorAction Ignore

    #---------------------------------------------------------[Loop through devices and select the correct scanner]---------------------------------------
    
    # Ensure the "TWAIN" registry key exists under the current user registry path
    New-Item -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\" -force -Name TWAIN

    # Loop for the specified number of seconds as per $Scannedelay
    for ($i = 1; $i -lt $Scannedelay; $i++) {
        
        # Wait 1 second between iterations to allow device state to settle
        start-sleep -Seconds 1

        # Check if the scanner's friendly name contains "FI" (indicating Fujitsu scanner)
        If ($Device.FriendlyName -like "*FI*") {

            # If the "TWAIN" registry path exists, set the "Default Source" to Fujitsu scanner .ds file
            if (test-path -path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\") {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\" `
                                 -Name "Default Source" -Value "C:\WINDOWS\twain_32\Fjicube\Fjic8300.ds" -Force
            }
            # If the "TWAIN" registry path does not exist, create it and set the "Default Source"
            else {
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\" `
                                 -Name "Default Source" -Value "C:\WINDOWS\twain_32\Fjicube\Fjic8300.ds" `
                                 -PropertyType "String" -Force
            }

            # Log a warning to indicate that the Fujitsu scanner has been set as default
            Write-Warning "Fujitsu"
        }

        # Check if the scanner's friendly name is exactly 'CANON DR-C225 USB' (Canon scanner)
        ElseIf ($Device.FriendlyName -eq 'CANON DR-C225 USB') {

            # Update the registry with the Canon scanner .ds file if the "TWAIN" registry path exists
            if (test-path -path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\") {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\" `
                                 -Name "Default Source" -Value "C:\windows\twain_32\Canon Electronics\DRC225.ds" -Force
            }
            # If the "TWAIN" registry path does not exist, create it and set the "Default Source"
            else {
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\" `
                                 -Name "Default Source" -Value "C:\windows\twain_32\Canon Electronics\DRC225.ds" `
                                 -PropertyType "String" -Force
            }

            # Log a warning to indicate that the Canon scanner has been set as default
            Write-Warning "Canon"
        }

        # Check if the scanner's friendly name is exactly 'VMware Virtual WIA Scanner' (VMware scanner)
        elseif ($Device.FriendlyName -eq 'VMware Virtual WIA Scanner') {

            # Update the registry with the VMware scanner .ds file if the "TWAIN" registry path exists
            if (test-path -path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\") {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\" `
                                 -Name "Default Source" -Value "C:\Windows\twain_32\ScannerRedirection\twain32.ds" -Force
            }
            # If the "TWAIN" registry path does not exist, create it and set the "Default Source"
            else {
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\TWAIN\" `
                                 -Name "Default Source" -Value "C:\WINDOWS\twain_32\ScannerRedirection\twain32.ds" `
                                 -PropertyType "String" -Force
            }

            # Log a warning to indicate that the VMware scanner has been set as default
            Write-Warning "VMware"
        }
    }
}
