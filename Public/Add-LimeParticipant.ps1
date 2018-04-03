Function Add-LimeParticipant {
    <#
    .SYNOPSIS
        Add Participant to specific LimeSurvey
    .DESCRIPTION
        Add Participant to specific LimeSurvey
    .PARAMETER SurveyId
        Survey ID to which to add participant
    .PARAMETER Session
        LimeSurvey session to use (Created by New-LimeSession)
    .PARAMETER BaseUri
        Base URI for LimeSurvey
    .PARAMETER InputObject
        Hashtable containing participant info formatted for LimeSurvey ingestion, e.g.:
        @{
            user1@host.com = @{ email = user1@host.com }
            user2@host.com = @{ firstname = user; lastname = 2; email = user2@host.com }
        }
    .PARAMETER Raw
        If specified, do not parse output
    .EXAMPLE
        Add-LimeParticipant -SurveyId 123456 -Session $Session -BaseUri https://limehost.com/index.php?r=admin/remotecontrol -
    .FUNCTIONALITY
        LimeSurvey
    #>
    [cmdletbinding()]
    Param(
        [parameter(Position = 1)]
        [int]$SurveyId,
        [ValidateNotNull()]
        [string]$Session,

        [Parameter( ValueFromPipeLine = $true,
            ValueFromPipelineByPropertyName = $true )]
        [ValidateNotNull()]
        [hashtable]$InputObject,
        [ValidateNotNull()]
        [string]$BaseUri,
        [switch]$Raw
    )

    $RpcMethodBody = New-RPCMethod 'add_participants' @($Session, $SurveyId, $InputObject)
    if ($Raw) {
        (Invoke-RestMethod -Uri $BaseUri -Method Post -Body $RpcMethodBody).Content
    }
    else {
        Invoke-RpcMethod -RpcServerUri $BaseUri -RequestBody $RpcMethodBody
    }
}