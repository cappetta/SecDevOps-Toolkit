Setup notes

# Task 3.1 - 3.3 AD Setup

```bash
PS C:\Windows\system32> New-ADGroup AWS-Production -GroupScope Global -GroupCategory Security


PS C:\Windows\system32> New-ADGroup AWS-Dev -GroupScope Global -GroupCategory Security


PS C:\Windows\system32> New-ADUser -Name Bob -PasswordNeverExpires $true -AccountPassword (ConvertTo-SecureString 'Qw1kl@bs' -AsPlainText -Force) -EmailAddress 'bob@mydomain.local' -Enabled $true -UserPrincipalName bob@mydomain.local


PS C:\Windows\system32> Add-ADGroupMember -Identity AWS-Dev -Members bob


PS C:\Windows\system32> Add-ADGroupMember -Identity AWS-Production -Members bob


PS C:\Windows\system32> New-ADUser -Name ADFSSVC -PasswordNeverExpires $true -AccountPassword (ConvertTo-SecureString 'munLv6SotedrANiSegut' -AsPlainText -Force) -Enabled $true -UserPrincipalName adfssvc@mydomain.local -Description 'created AD FS service account'

```