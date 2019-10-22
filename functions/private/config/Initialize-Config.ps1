<#
.SYNOPSIS
 Initializes the configuration from the data files.
#>
function Initialize-Config {

    $ConfigSplat = @{
        Name        = $ModuleName
        CompanyName = ( Import-PowerShellDataFile ( Join-Path $ScriptPath "$ModuleName.psd1" ) ).CompanyName
        DefaultPath = "$ScriptPath\ConfigDefaults.psd1"
    }
    $Script:ModuleConfig = Import-Configuration @ConfigSplat
    
    if ( $Script:ModuleConfig.Keys -notcontains 'ConfigVersion' ) { $Script:ModuleConfig.ConfigVersion = Get-Build }

}
