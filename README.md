# LimeSurvey-XML
PowerShell module for interacting with LimeSurvey's XML-RPC API

Issues and pull requests welcome!

Big thanks to [Warren Frame](https://github.com/RamblingCookieMonster) for his many PowerShell posts and GitHub contributions that I used as templates and springboards.

Also thanks to [Mooser Lee](https://github.com/mosserlee/PSClient-for-XML-RPC) for his XMLRPC PowerShell module from which I borrowed heavily and modified for LimeSurvey's output. 

## Instructions

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the LimeSurvey-XML folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

# Import the module.
    Import-Module LimeSurvey-XML

# Get commands in the module
    Get-Command -Module LimeSurvey-XML

```

## Examples

### Create a session

```powershell
$SessionKey = New-LimeSession -BaseUri 'https://limesurvey.fqdn/limesurvey/index.php?r=admin/remotecontrol' -Credential (Get-Credential)
```

### Query for participants on an existing Survey

```powershell
# After creating a session...
Get-LimeParticipant -SurveyId '123456' -Session $SessionKey -BaseUri $ApiUrl
```

### Add participants to existing Survey

```powershell
# After creating a session...
# Create a participant email hash that contains hashes of each user's properties
$ParticipantEmailHash = @{ 'user1@host.com, @{ email = 'user1@host.com' }.
                           'user2@host.com, @{ firstname = 'user'; lastname = '2'; email = 'user2@host.com' }
                        }
Add-LimeParticipant -SurveyId '123456' -Session $SessionKey -BaseUri $ApiUrl -InputObject $ParticipantEmailHash
```

### Release session key

```powershell
# After creating a session...
Remove-LimeSession -BaseUri $ApiUrl -Session $SessionKey
```
