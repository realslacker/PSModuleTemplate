<#
.SYNOPSIS
 Utility function to return localized language string.

.PARAMETER Key
 The string key to return.
#>
function Get-LocalizedMessage {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $Key,

        [Parameter(ValueFromRemainingArguments=$true)]
        [Alias('f')]
        [string[]]
        $Strings

    )

    if ( -not( Get-Variable -Name 'Messages' -Scope Script -ErrorAction SilentlyContinue ) ) {

        Import-LocalizedData -BindingVariable 'Messages' -FileName 'Messages' -BaseDirectory (Join-Path $ScriptPath 'lang')

    }

    if ( Get-Config LanguageDebug ) {

        Write-Host ( 'Localized Language Key:     {0}' -f $Key ) -BackgroundColor Magenta -ForegroundColor Black

        for ( $i = 0; $i -lt $Strings.Count; $i ++ ) { Write-Host ( 'Localized Language Param {0}: {1}' -f $i, $Strings[$i] ) -BackgroundColor Magenta -ForegroundColor Black }

    }

    $Message = ( $Messages.$Key, $Key )[ $Messages.Keys -notcontains $Key ]

    if ( $Strings.Count -gt 0 ) {

        $Message -f $Strings

    } else {

        $Message

    }

}
