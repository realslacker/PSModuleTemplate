<#
.SYNOPSIS
 Returns the current module build

#>
function Get-Build {

    [OutputType([version])]
    [CmdletBinding()]
    param()

    [version]$ModuleVersion = ( Import-PowerShellDataFile "$ScriptPath\$ModuleName.psd1" ).ModuleVersion

    if ( [version]'0.0.0.0' -eq $ModuleVersion ) {

        Write-Warning ( Get-LocalizedMessage 'Currently running the development module!' )
        
        [version]( Get-Date -Format yyyy.MM.dd.HHmm )

    } else {

        $ModuleVersion

    }

}
