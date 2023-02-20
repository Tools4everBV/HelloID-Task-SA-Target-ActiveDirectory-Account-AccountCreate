# HelloID-Task-SA-Target-ActiveDirectory-AccountCreate
######################################################
# Form mapping
$formObject = @{
    Name                  = $form.Name
    Path                  = $form.Path
    UserPrincipalName     = $form.UserPrincipalName
    SamAccountName        = $form.SamAccountName
    GivenName             = $form.GivenName
    Surname               = $form.Surname
    Title                 = $form.Title
    Description           = $form.Description
    AccountPassword       = (ConvertTo-SecureString -AsPlainText $form.AccountPassword -Force)
    ChangePasswordAtLogon = [bool]$form.ChangePasswordAtLogon
    Enabled               = [bool]$form.Enabled
    PasswordNotRequired   = [bool]$form.PasswordNotRequired
}

try {
    Write-Information "Executing ActiveDirectory action: [CreateAccount] for: [$($formObject.UserPrincipalName)]"
    Import-Module ActiveDirectory -ErrorAction Stop
    $user = Get-ADUser -Filter "userPrincipalName -eq '$($formObject.UserPrincipalName)'"
    if ($user) {
        $auditLog = @{
            Action            = 'CreateAccount'
            System            = 'ActiveDirectory'
            TargetDisplayName = $($formObject.UserPrincipalName)
            TargetIdentifier  = ($user).SID.value
            Message           = "An ActiveDirectory account for: [$($formObject.UserPrincipalName)] does already exist"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "An ActiveDirectory account for: [$($formObject.UserPrincipalName)] does already exist"
    } elseif (-not($user)) {
        $createdUser = New-ADUser @formObject -PassThru
        $auditLog = @{
            Action            = 'CreateAccount'
            System            = 'ActiveDirectory'
            TargetDisplayName = $($formObject.UserPrincipalName)
            TargetIdentifier  = ($createdUser).SID.value
            Message           = "ActiveDirectory action: [CreateAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [CreateAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'CreateAccount'
        System            = 'ActiveDirectory'
        TargetDisplayName = $($formObject.UserPrincipalName)
        TargetIdentifier  = ''
        Message           = "Could not execute ActiveDirectory action: [CreateAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [CreateAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
}
######################################################
