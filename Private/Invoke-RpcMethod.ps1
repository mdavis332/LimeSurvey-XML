<#
.Synopsis
   Invoke XML_RPC method request.
.DESCRIPTION
   Invoke XML_RPC request to RPC server.
.EXAMPLE
   $blogUrl = 'http://www.pstips.net/myrpc.php'
   $method = New-RPCMethod -MethodName 'wp.getPostTypes' -Params @(1,'userName','password')
.OUTPUTS
   The response result from RPC server.
#>
function Invoke-RpcMethod {
    param(
        [uri]$RpcServerUri,
        [string]$RequestBody
    )
    $xmlResponse = Invoke-RestMethod -Uri $RpcServerUri -Method Post -Body $RequestBody
    if ($xmlResponse) {
        # Normal response
        $paramNodes = $xmlResponse.SelectNodes('methodResponse/params/param/value')
        if ($paramNodes) {
            $paramNodes | ForEach-Object {
                $value = $_.ChildNodes |
                    Where-Object { $_.NodeType -eq 'Element' } |
                    Select-Object -First 1
                ConvertFrom-RpcXmlObject -XmlObject $value
            }
        }

        # Fault response
        $faultNode = $xmlResponse.SelectSingleNode('methodResponse/fault')
        if ($faultNode) {
            $fault = ConvertFrom-RpcXmlObject -XmlObject $faultNode.value.struct
            return $fault
        }
    }
}