<#
.SYNOPSIS
loop through groups or groups and build a CSV report containing each group
.DESCRIPTION
 
This script will loop through an active directory and check if users are in the listed groups, then add them to the structured report and export the results to a csv 
.NOTES
  Version:        1.0
  Author:   Keensy
  Creation Date: 16/06/2022
#>
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
 # Groups to audit
 $groups =  "Group one","Group two","Group three"
 $CSV    =  'C:\Users\$env:username\Documents\Groupreport.csv'                        
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
$sScriptVersion = "1.0"
#-----------------------------------------------------------[Functions]------------------------------------------------------------
foreach ($Group in $groups)
    { 
        Get-ADGroup $group -Properties Member |Select-Object -Expand Member|Get-ADUser -Property * |foreach-object
                {

                          [pscustomobject]@{    "Username"                      = $_.SamAccountName
                                                "Display name"                  = $_.Displayname
                                                "First name"                    = $_.givenname
                                                "Last name"                     = $_.Surname
                                                state                           = $_.state
                                                Title                           = $_.title
                                                "Full OU Path"                  = $_.DistinguishedName
                                                Description                     = $_.Description
                                                "Last log on date"              = $_.LastLogonDate
                                                "Account enabled true or false" = $_.Enabled
                                                "Group access"                  = $Group
                                             }

                  } |export-csv $csv -NoTypeInformation -Append 

}
