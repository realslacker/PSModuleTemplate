<# 
.SYNOPSIS
 Utility function to set module options.

#>
function Set-Config {

    [CmdletBinding()]
    param()

    dynamicparam {
        
        . $ScriptPath\ConfigDefinition.ps1
    
    }

    begin {

        $CommonParameters = { function _temp { [CmdletBinding()] param() }; ( Get-Command _temp ).Parameters.Keys }.Invoke()

    }

    process {

        $Defaults = Get-ConfigDefaults

        $PSBoundParameters.Keys |
            Where-Object { $CommonParameters -notcontains $_ } |
            ForEach-Object {
    
                # if the user is trying to reset the default value by passing null or an empty string
                if ( [string]::IsNullOrEmpty( $PSBoundParameters.$_ ) ) {

                    # we check for a default value, and if present use that
                    if ( $Defaults.$_ ) { $Script:ModuleConfig.$_ = $Defaults.$_ }

                    # if there is no default we just unset the variable
                    else { $Script:ModuleConfig.Remove( $_ ) }

                # if there is any value provided we set that instead
                } else {
        
                    $Script:ModuleConfig.$_ = $PSBoundParameters.$_

                }
        
            }

    }

}
