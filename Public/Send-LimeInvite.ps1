Function Send-LimeInvite {
    <#
    .SYNOPSIS
        Triggers LimeSurvey to email participants of specific LimeSurvey
    .DESCRIPTION
        Triggers LimeSurvey to email participants of specific LimeSurvey inviting them to complete survey
    .PARAMETER SurveyId
        Survey ID to query
    .PARAMETER Session
        LimeSurvey session to use (Created by New-LimeSession)
    .PARAMETER BaseUri
        Base URI for LimeSurvey
    .PARAMETER Raw
        If specified, do not parse output
    .EXAMPLE
        Send-LimeInvite -SurveyId 123456 -Session $Session -BaseUri https://limehost.com/index.php?r=admin/remotecontrol
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
    $RpcMethodBody = New-RPCMethod 'invite_participants' @($Session, $SurveyId)
    if ($Raw) {
        (Invoke-RestMethod -Uri $BaseUri -Method Post -Body $RpcMethodBody).Content
    }
    else {
        Invoke-RpcMethod -RpcServerUri $BaseUri -RequestBody $RpcMethodBody
    }
}