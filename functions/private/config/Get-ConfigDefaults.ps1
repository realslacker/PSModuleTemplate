<#
.SYNOPSIS
 Returns the default module configuration.

#>
function Get-ConfigDefaults {

    return ( Import-PowerShellDataFile -Path "$ScriptPath\ConfigDefaults.psd1" )

}
