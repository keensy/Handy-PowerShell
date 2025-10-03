<#
.SYNOPSIS
    This script searches for groups (pattern 'g="DOMAIN\..."') in DEM XML config files 
    within a specified path and exports a detailed report.

.DESCRIPTION
    The script performs the following steps:
        1. Specifies the root directory path.
        2. Gets the current date and time.
        3. Gets the logged-in user.
        4. Gets all directories under the specified path.
        5. Specifies the location for logging errors.
        6. Specifies the output path for the CSV report.
        7. Defines a function to look through XML files for groups.
        8. Denormalizes groups into Domain and Group fields.
        9. Outputs results including file location.

.NOTES
    Version:        1.1
    Author:         Keensy
    Creation Date:  02/01/2024
    Last Updated:   03/10/2025
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Specify the root directory path
$path = "\\share\vdi\DEM_Share_DEV\general\FlexRepository\*"

# Get the current date and time
$Date = Get-Date

# Get the logged-in user
$User = $env:USER

# Get all directories under the specified path
$directories = Get-ChildItem -Path $path -Directory

# Specify the location for logging errors
$logLocation = "C:\temp\XMLGroupReport.log"

# Specify the output path for the CSV report
$FinalReportOutput = "C:\temp\XMLGroupReport.csv"

#---------------------------------------------------------[Functions]--------------------------------------------------------------
<#
.SYNOPSIS
    Searches for a specific pattern 'g="DOMAIN\..."' in XML config text within a file 
    and extracts the matching group(s).

.DESCRIPTION
    The function:
        1. Reads the content of the specified file.
        2. Attempts to match 'g="DOMAIN\..."' patterns in the text.
        3. If a match is found, outputs a structured object with Domain, Group, FileName, and FullPath.
        4. Errors are logged to the default log file.

.NOTES
    Version:        1.1
    Author:         Keensy
    Creation Date:  02/01/2024
    Last Updated:   03/10/2025
#>
function Get-XMLADGroup ($path) {

    #---------------------------------------------------------[Initialisations]--------------------------------------------------------
    # Script Version
    $sScriptVersion = "1.1"

    #-------------------------------------------------------------[Start]--------------------------------------------------------------
    try {
        # Read XML config text
        $XMLtext = Get-Content $path -ErrorAction Stop

        # Regex pattern to capture groups g="DOMAIN\GroupName"
        $pattern = 'g="([^\\]+)\\([^"]+)"'

        # Use regex matches instead of -match (handles multiple groups per file)
        $matches = [regex]::Matches($XMLtext, $pattern)

        foreach ($m in $matches) {
            [PSCustomObject]@{
                Domain    = $m.Groups[1].Value
                Group     = $m.Groups[2].Value
                FileName  = [System.IO.Path]::GetFileName($path)
                FullPath  = $path
                Error     = $false
            }
        }
    }
    catch {
        # Handle any errors encountered here
        [PSCustomObject]@{
            Domain    = $null
            Group     = $null
            FileName  = [System.IO.Path]::GetFileName($path)
            FullPath  = $path
            Error     = $_.Exception.Message
        }

        # Log the error message
        "[Report run by $User on $Date for file $path :: ERROR] " + $_.Exception.Message >> $logLocation
    }
}

#-------------------------------------------------------------[Start]--------------------------------------------------------------
try {
    # Final report collection
    $FinalReport = foreach ($Directory in (Get-ChildItem -Path $path).FullName) {
        foreach ($XMLFilePath in (Get-ChildItem -Path $Directory -Filter *.xml).FullName) {
            # Call the function to extract groups from XML file
            Get-XMLADGroup -path $XMLFilePath
        }
    }

    # Remove duplicates if needed
    $FinalReport = $FinalReport | Sort-Object Domain, Group, FileName -Unique

    # Export report to a CSV file
    $FinalReport | Export-Csv -Path $FinalReportOutput -NoTypeInformation

    Write-Host "Report successfully exported to $FinalReportOutput"
}
catch {
    # Handle any errors encountered here
    Write-Host "$_.Exception.Message"

    # Log the error message
    "[Report run by $User on $Date for all directories in $path :: ERROR] " + $_.Exception.Message >> $logLocation
}
