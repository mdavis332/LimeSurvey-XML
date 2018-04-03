function New-LimeSession {
    <#
    .Synopsis
        Connects to LimeSurvey Server and returns a Session Key.
    .DESCRIPTION
        Connects to LimeSurvey Server and returns a Session Key so that other LimeSurvey-XML commands can be authenticated when using the -Session paramenter
    .PARAMETER Credential
        A credential to use for LimeSurvey.
    .PARAMETER BaseUri
        Base URI for LimeSurvey.
    .EXAMPLE
        $MyLimeSession = New-LimeSession -Credential (Get-Credential) -BaseUri "https://host.com/limesurvey/index.php?r=admin/remotecontrol"
    .OUTPUTS
        Microsoft.PowerShell.System.String
    .FUNCTIONALITY
        Lime Survey
    #>
    [cmdletbinding()]
    Param (
        [Parameter( ValueFromPipeLine = $true,
            ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [ValidateNotNull()]
        [string]$BaseUri
    )
    Write-Verbose "Creating Lime Session"
    $RpcMethodBody = New-RPCMethod 'get_session_key' @($Credential.UserName, $Credential.GetNetworkCredential().Password)
    Write-Verbose "Sending Lime Session credentials for [$($Credential.UserName)]"
    $SessionKey = Invoke-RpcMethod -RpcServerUri $BaseUri -RequestBody $RpcMethodBody
    # if successful, returned SessionKey should be a 32-charlength alphanumeric key
    if ($SessionKey -match "^(?=.{32}$)[a-zA-Z0-9]*$") {
        $SessionKey
    }
    else {
        Write-Error $SessionKey
    }

}