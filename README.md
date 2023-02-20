# HelloID-Task-SA-Target-ActiveDirectory-Account-AccountCreate

## Prerequisites

- [ ] The HelloID SA on-premises agent installed

- [ ] The `ActiveDirectory` module is installed on the server where the HelloID SA on-premises agent is running.

## Description

This code snippet will create a new user within Active Directory and executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties of the `New-ADUser` cmdlet, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "Path": "",
    "ChangePasswordAtLogon": true,
    "PasswordNotRequired": true,
    "Surname": "",
    "Description": "",
    "UserPrincipalName": "",
    "GivenName": "",
    "Name": "",
    "Title": "",
    "SamAccountName": "",
    "AccountPassword": "",
    "Enabled": true
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hash table is appropriately adjusted to match your form fields.

2. Imports the ActiveDirectory module.

3. Verify if the user that must be created already exists based on the `userPrincipalName` using the `Get-ADUser` cmdlet.

4. If the user does not exist, a new user is created using the `New-ADUser` cmdlet. The hash table called `$formObject` is passed to the `New-ADUser` cmdlet using the `@` symbol in front of the hash table name.

> :bulb: Splatting is a technique in PowerShell where you store the parameters and their values in a hash table, and then pass the hash table to a cmdlet or function.
