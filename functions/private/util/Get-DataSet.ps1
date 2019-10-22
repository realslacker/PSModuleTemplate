<#
.SYNOPSIS
 Utility function to get a stored data set from the module.
#>
function Get-DataSet {

    [CmdletBinding()]
    param()

    dynamicparam {

        DynamicParameterDictionary {

            $DataPath = Join-Path $ScriptPath 'Data'

            $DataSets = Get-ChildItem -Path $DataPath -File |
                Where-Object { '.csv', '.json', '.psd1' -contains $_.Extension }
        
            $Param = @{
                Name                            = 'Name'
                ValidateSet                     = $DataSets.BaseName
                Mandatory                       = $true
                Type                            = [string]
                Position                        = 0
            }
            DynamicParameter @Param
        
            $Param = @{
                Name                            = 'Force'
                Type                            = [switch]
                Position                        = 1
            }
            DynamicParameter @Param

        }

    }

    process {

        $Name = $PSBoundParameters.Name

        if ( -not( Get-Variable -Name 'DataSets' -Scope Script -ErrorAction SilentlyContinue ) ) {

            New-Variable -Name 'DataSets' -Scope Script -Value @{}

        }

        if ( $PSBoundParameters.Keys -notcontains 'Force' -and $Script:DataSets.Keys -contains $Name ) {

            return $Script:DataSets[$Name]

        }
    
        $DataPath = Join-Path $ScriptPath 'Data'

        $DataSet = Get-ChildItem -Path $DataPath -File |
            Where-Object { $_.BaseName -eq $Name }

        $Data = switch ( $DataSet.Extension ) {
        
            '.psd1' {

                Import-PowerShellDataFile -LiteralPath $DataSet.FullName

            }

            '.csv' {

                Import-Csv -LiteralPath $DataSet.FullName

            }

            '.json' {

                Get-Content -LiteralPath $DataSet.FullName -Raw |
                    ConvertFrom-Json

            }
        
        }

        $Script:DataSets[$Name] = $Data

        $Script:DataSets[$Name]
    
    }

}
