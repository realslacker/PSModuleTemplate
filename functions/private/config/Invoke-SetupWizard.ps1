<#
.SYNOPSIS
 A wizard to configure runtime options for the MethodeOffice365 module.
#>
function Invoke-MethodeAdminSetupWizard {

    # first a welcome message
    Write-Host ( ( Get-LocalizedMessage WizardTitle ) -f (Get-MethodeAdminBuild -WarningAction SilentlyContinue) ) -ForegroundColor Cyan
    Write-Host ( Get-LocalizedMessage WizardBody ) -ForegroundColor White

    Write-Host ''

    # confirm that the user wants to run this wizard
    if ( Test-MethodeAdminIsAcceptableConfigVersion ) {

        $Question = ( Get-LocalizedMessage QuestionFormat ) -f ( Get-LocalizedMessage WizardContinuePrompt ), ( Get-LocalizedMessage YesPrompt ).ToUpper(), ( Get-LocalizedMessage NoPrompt ).ToLower()
        if ( (Read-Host $Question) -match "^$(( Get-LocalizedMessage NoAnswerLetter ))" ) { return }

    } else {
        
        Write-Warning ( Get-LocalizedMessage ConfigurationNeedsUpdateWarning )
        
    }

    Write-Host ''

    # prompt for Exchange Online Tenant Domain
    Write-Host ( Get-LocalizedMessage WizardExchangeOnlineTenantPrompt ) -ForegroundColor White
    $Question = ( Get-LocalizedMessage InputFormat ) -f ( Get-LocalizedMessage WizardTenantDomainPrompt ), (Get-MethodeAdminOption TenantDomain)
    $Answer   = Read-Host $Question
    if ( -not [string]::IsNullOrEmpty($Answer) ) {
    
        Set-MethodeAdminOption -TenantDomain $Answer
    
    }

    Write-Host ''

    # prompt for Exchange Online user name
    Write-Host ( Get-LocalizedMessage WizardExchangeOnlineUserNamePrompt ) -ForegroundColor White
    $Question = ( Get-LocalizedMessage InputFormat ) -f ( Get-LocalizedMessage WizardUserNamePrompt ), (Get-MethodeAdminOption ExchangeOnlineUserName)
    $Answer   = Read-Host $Question
    if ( -not [string]::IsNullOrEmpty($Answer) ) {
    
        Set-MethodeAdminOption -ExchangeOnlineUserName $Answer
    
    }

    # if a default exchange online user name is set, but there is no password cached
    # prompt to save the password
    if ( ($ExchangeOnlineUserName = Get-MethodeAdminOption ExchangeOnlineUserName) -and -not(Test-CredentialCached -UserName $ExchangeOnlineUserName) ) {
    
        Write-Host ( Get-LocalizedMessage WizardSavingPasswordMessage )
        Write-Host "Add-CredentialToCache -UserName '$ExchangeOnlineUserName'"

        Add-CredentialToCache -UserName $ExchangeOnlineUserName

        Write-Host ( Get-LocalizedMessage WizardPasswordSavedMessage )
        Write-Host "Add-CredentialToCache -UserName '$ExchangeOnlineUserName' -Force"
    
    }

    Write-Host ''

    # prompt for default domain
    Write-Host ( Get-LocalizedMessage WizardDefaultDomainPrompt ) -ForegroundColor White
    $DomainInfo = Get-MethodeDataSet DomainInfo

    for ( $i = 1; $i -le $DomainInfo.Count; $i ++ ) {
    
        Write-Host ( ' {0}) {1}' -f $i, $DomainInfo[($i - 1)].DnsDomain )

        if ( $DomainInfo[($i - 1)].DnsDomain -eq (Get-MethodeAdminOption DefaultADDomain) ) { $DefaultADDomainSelection = $i }

    }

    $Question = ( Get-LocalizedMessage InputFormat ) -f ( Get-LocalizedMessage WizardDefaultDomainSelectionPrompt ), $DefaultADDomainSelection
    [int]$DomainSelection = Read-Host $Question
    if ( $DomainSelection -ne $DefaultADDomainSelection -and $DomainSelection -ge 1 -and $DomainSelection -le $DomainInfo.Count ) {

        Set-MethodeAdminOption -DefaultADDomain $DomainInfo[($DomainSelection - 1)].DnsDomain

    }

    Write-Host ''

    # prompt for credentials
    if ( -not ($CredentialMap = Get-MethodeAdminOption DomainCredentialMap) ) { $CredentialMap = @{} }
    foreach ( $Domain in $DomainInfo.DnsDomain ) {

        Write-Host ( ( Get-LocalizedMessage WizardDefaultDomainUserNamePrompt ) -f $Domain ) -ForegroundColor White
        $Question = ( Get-LocalizedMessage InputFormat ) -f ( Get-LocalizedMessage WizardUserNamePrompt ), $CredentialMap.$Domain
        $Answer   = Read-Host $Question
        if ( -not [string]::IsNullOrEmpty($Answer) ) {
    
            $CredentialMap.$Domain = $Answer
    
        }

        Write-Host ''

        # if a user name is set, but there is no password cached prompt to save the password
        if ( $null -ne $CredentialMap.$Domain -and -not(Test-CredentialCached -UserName $CredentialMap.$Domain) ) {
    
            Write-Host ( Get-LocalizedMessage WizardSavingPasswordMessage )
            Write-Host "Add-CredentialToCache -UserName '$($CredentialMap.$Domain)'"

            Add-CredentialToCache -UserName $CredentialMap.$Domain

            Write-Host ( Get-LocalizedMessage WizardPasswordSavedMessage )
            Write-Host "Add-CredentialToCache -UserName '$($CredentialMap.$Domain)' -Force"

            Write-Host ''
    
        }

    }
    Set-MethodeAdminOption -DomainCredentialMap $CredentialMap

    Write-Host ''

    # prompt for AzureAD Connect server
    Write-Host ( Get-LocalizedMessage WizardAzureADConnectServerPrompt ) -ForegroundColor White
    $Question = ( Get-LocalizedMessage InputFormat ) -f ( Get-LocalizedMessage WizardAzureADConnectPrompt ), ( Get-MethodeAdminOption AzureADConnectServer )
    $Answer   = Read-Host $Question
    if ( -not [string]::IsNullOrEmpty($Answer) ) {
    
        Set-MethodeAdminOption -AzureADConnectServer $Answer
    
    }

    Write-Host ''

    # prompt for AzureAD Connect user name
    Write-Host ( Get-LocalizedMessage WizardAzureADConnectUserNamePrompt ) -ForegroundColor White
    $Question = ( Get-LocalizedMessage InputFormat ) -f ( Get-LocalizedMessage WizardUserNamePrompt ), (Get-MethodeAdminOption AzureADConnectUserName)
    $Answer   = Read-Host $Question
    if ( -not [string]::IsNullOrEmpty($Answer) ) {
    
        Set-MethodeAdminOption -AzureADConnectUserName $Answer
    
    }

    # if a default AzureAD Connect user name is set, but there is no password cached
    # prompt to save the password
    if ( ($AzureADConnectUserName = Get-MethodeAdminOption AzureADConnectUserName) -and -not(Test-CredentialCached -UserName $AzureADConnectUserName) ) {
    
        Write-Host ( Get-LocalizedMessage WizardSavingPasswordMessage )
        Write-Host "Add-CredentialToCache -UserName '$AzureADConnectUserName'"

        Add-CredentialToCache -UserName $AzureADConnectUserName

        Write-Host ( Get-LocalizedMessage WizardPasswordSavedMessage )
        Write-Host "Add-CredentialToCache -UserName '$AzureADConnectUserName' -Force"
    
    }

    Write-Host ''

    # ask if we should run this wizard again next time
    $Question = ( Get-LocalizedMessage QuestionFormat ) -f ( Get-LocalizedMessage WizardHidePrompt ), ( Get-LocalizedMessage YesPrompt ).ToLower(), ( Get-LocalizedMessage NoPrompt ).ToUpper()
    if ( (Read-Host $Question) -match "^$(( Get-LocalizedMessage YesAnswerLetter ))" ) {
    
        Set-MethodeAdminOption -HideWizard $false

    } else {
    
        Set-MethodeAdminOption -HideWizard $true

    }

    Save-MethodeAdminConfig

}


