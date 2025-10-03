<#
.SYNOPSIS
    This script will stop a user's session
 
.NOTES
    Name: Stop-Session
    Author: Keensy
    Version: V1.0
    DateCreated: 27-05-2022
#>
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
                             
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
$ScriptVersion = "1.0"
#-----------------------------------------------------------[Functions]------------------------------------------------------------
if (([System.Windows.MessageBox]::Show('Do you want to proceed?', 'Confirm', 'YesNoCancel','Error'))-eq 'yes'){shutdown /r} 
