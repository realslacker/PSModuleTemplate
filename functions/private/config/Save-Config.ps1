<#
.SYNOPSIS
 Utiltiy function for saving the running configuration to the user profile
#>
function Save-Config {

    # first we grab the default config
    $Private:DefaultConfig = Get-ConfigDefaults

    # copy current config values that are not default
    $Private:UniqueConfig = @{}

    foreach ( $Key in $Script:ModuleConfig.Keys ) {
    
        # if the key does not exist in the default config we always copy it
        if ( $DefaultConfig.Keys -notcontains $Key ) {
        
            $UniqueConfig[$Key] = $Script:ModuleConfig[$Key]
        
        # if the value is not a default we copy it
        } elseif ( $Script:ModuleConfig[$Key] -ne $DefaultConfig[$Key] ) {
        
            $UniqueConfig[$Key] = $Script:ModuleConfig[$Key]

        }
    
    }

    if ( $UniqueConfig.Count -eq 0 ) {
    
        Write-Warning ( Get-LocalizedMessage 'User configuration is empty for ''{0}\{1}''' $env:USERDOMAIN $env:USERNAME )

        return
    
    }

    # set the config version
    [string]$UniqueConfig['ConfigVersion'] = Get-Build

    # save the custom configuration
    $ConfigSplat = @{
        InputObject = $UniqueConfig
        Name        = $ModuleName
        CompanyName = ( Import-PowerShellDataFile ( Join-Path $ScriptPath "$ModuleName.psd1" ) ).CompanyName
        DefaultPath = "$ScriptPath\ConfigDefaults.psd1"
    }
    Export-Configuration @ConfigSplat

    Write-Information ( Get-LocalizedMessage 'User configuration saved.' )
    Write-Information ( Get-LocalizedMessage 'Path: {0}\{1}'  -f (Get-ConfigurationPath -Name $ConfigSplat.Name -CompanyName $ConfigSplat.CompanyName), 'Configuration.psd1' )

}


