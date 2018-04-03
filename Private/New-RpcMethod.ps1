<#
.Synopsis
   New XML_RPC method string.
.DESCRIPTION
   New XML_RPC method string with RPC method and parameters.
.EXAMPLE
   New-RPCMethod -MethodName 'new.post' -Params @("1",2,'string')
.INPUTS
   Object.
.OUTPUTS
   Xml format string.
#>
function New-RpcMethod {
    param(
        [string]$MethodName,
        [Array]$Params
    )
    $xmlMethod = "<?xml version='1.0' encoding='ISO-8859-1' ?>
      <methodCall>
      <methodName>{0}</methodName>
      <params>{1}</params>
     </methodCall>"

    [string]$paramsValue = ""
    foreach ($param in $Params) {
        $paramsValue += '<param><value>{0}</value></param>' -f (ConvertTo-RpcXmlObject -Object $param)
    }
    return ([xml]($xmlMethod -f $MethodName, $paramsValue)).OuterXml
}