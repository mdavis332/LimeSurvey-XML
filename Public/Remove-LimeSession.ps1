Function Remove-LimeSession {
    <#
    .SYNOPSIS
        Closes out LimeSurvey session and relases the session key
    .DESCRIPTION
        Closes out LimeSurvey session and relases the session key
    .PARAMETER Session
        LimeSurvey session to use (Created by New-LimeSession)
    .PARAMETER BaseUri
        Base URI for LimeSurvey
    .EXAMPLE
        Get-LimeParticipants -Session $Session -BaseUri https://limehost.com/index.php?r=admin/remotecontrol
    .FUNCTIONALITY
        LimeSurvey
    #>
    [CmdletBinding()]
    Param(
        [Parameter( Position = 1, ValueFromPipeLine = $true, ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNull()]
        [string]$Session,

        [ValidateNotNull()]
        [string]$BaseUri
    )
    $RpcMethodBody = New-RpcMethod 'release_session_key' @($Session)
    $SessionKeyReleaseResult = Invoke-RpcMethod -RpcServerUri $BaseUri -RequestBody $RpcMethodBody

    if ($SessionKeyReleaseResult -ne 'OK') {
        Write-Error "Error releasing session key: $SessionKeyReleaseResult"
    }
    else {
        Write-Debug "Successfully released session key"
    }
}