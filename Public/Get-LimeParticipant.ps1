Function Get-LimeParticipant {
    <#
    .SYNOPSIS
        GET Participant info on specific LimeSurvey
    .DESCRIPTION
        GET Participant info on specific LimeSurvey
    .PARAMETER SurveyId
        Survey ID to query
    .PARAMETER Session
        LimeSurvey session to use (Created by New-LimeSession)
    .PARAMETER BaseUri
        Base URI for LimeSurvey
    .PARAMETER Raw
        If specified, do not parse output
    .EXAMPLE
        Get-LimeParticipants -SurveyId 123456 -Session $Session -BaseUri https://limehost.com/index.php?r=admin/remotecontrol
    .FUNCTIONALITY
        LimeSurvey
    #>
    [cmdletbinding()]
    Param(
        [parameter(Position = 1)]
        [int]$SurveyId,

        [Parameter( ValueFromPipeLine = $true,
            ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNull()]
        [string]$Session,
        [ValidateNotNull()]
        [string]$BaseUri,
        [switch]$Raw
    )

    $RpcMethodBody = New-RpcMethod 'list_participants' @($Session, $SurveyId)

    if ($Raw) {
        $Result = (Invoke-RestMethod -Uri $BaseUri -Method Post -Body $RpcMethodBody).Content
    }
    else {
        $Result = Invoke-RpcMethod -RpcServerUri $BaseUri -RequestBody $RpcMethodBody
    }

    if ($Result.faultCode -ne $null) {
        Write-Error "Fault Code: $($Result.faultCode) . Fault String: $($Result.faultString)"
    }
    else {
        $Result
    }
}
