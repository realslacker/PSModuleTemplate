<# 
.SYNOPSIS
 Utility function to get module config options.

#>
function Get-Config {

    [CmdletBinding()]
    param()

    dynamicparam {

        DynamicParameterDictionary {

            $CommonParameters = { function _temp { [CmdletBinding()] param() }; ( Get-Command _temp ).Parameters.Keys }.Invoke()

            $OptionNames = @('All')
            $optionNames += $Script:ModuleConfig.Keys + ( (Get-Command Set-ConfigOption).Parameters | ForEach-Object { $_.Values.Name } ) |
                Where-Object { $CommonParameters -notcontains $_ } |
                Sort-Object -Unique

            DynamicParameter -Name 'Option' -ValidateSet $OptionNames -Position 1

        }

    }

    process {

        if ( $PSBoundParameters.Option -contains 'All' -or $PSBoundParameters.Keys -notcontains 'Option' ) { return $Script:ModuleConfig }

        $Script:ModuleConfig[$PSBoundParameters.Option]
        
    }

}

