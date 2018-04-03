<#
.Synopsis
   Convert object to XML-RPC object string.
.DESCRIPTION
   Convert object to XML-RPC object string.
.EXAMPLE
   ConvertTo-RpcXmlObject 3
   <int>3</int>
   ConvertTo-RpcXmlObject '3'
   <string>3</string>
   ConvertTo-RpcXmlObject 3.5
   <double>3.5</double>
.OUTPUTS
   The XML-RPC object string.
#>
function ConvertTo-RpcXmlObject {
    param(
        $Object
    )
    if ($Object -ne $null) {
        # integer type
        if ( ($Object -is [int]) -or ($Object -is [int64])) {
            return "<int>$Object</int>"
        }
        # double type
        elseif ( ($Object -is [float]) -or ($Object -is [double]) -or ($Object -is [decimal])) {
            return "<double>$Object</double>"
        }
        # string type
        elseif ( $Object -is [string]) {
            return "<string>$Object</string>"
        }
        # date/time type
        elseif ($Object -is [datetime]) {
            $dateStr = $Object.ToString('yyyyMMddTHH:mm:ss')
            return "<dateTime.iso8601>$dateStr</dateTime.iso8601>"
        }
        # boolean type
        elseif ($Object -is [bool]) {
            $bool = [int]$Object
            return "<boolean>$bool</boolean>"
        }
        # base64 type
        elseif ( ($Object -is [array]) -and ($Object.GetType().GetElementType() -eq [byte])) {
            $base64Str = [Convert]::ToBase64String($Object)
            return "<base64>$base64Str</base64>"
        }
        # array type
        elseif ( $Object -is [array]) {
            $result = '<array>
            <data>'
            foreach ($element in $Object) {
                $value = ConvertTo-RpcXmlObject -Object $element
                $result += "<value>{0}</value>" -f $value
            }
            $result += '</data>
            </array>'
            return $result
        }
        # struct type
        elseif ($Object -is [Hashtable]) {
            $result = '<struct>'
            foreach ($key in $Object.Keys) {
                $member = "<member>
                <name>{0}</name>
                <value>{1}</value>
                </member>"
                $member = $member -f $key, (ConvertTo-RpcXmlObject -Object $Object[$key])
                $result = $result + $member
            }
            $result = $result + '</struct>'
            return $result
        }
        elseif ($Object -is [PSCustomObject]) {
            $result = '<struct>'
            $Object |
                Get-Member -MemberType NoteProperty |
                ForEach-Object {
                $member = "<member>
                <name>{0}</name>
                <value>{1}</value>
                </member>"
                $member = $member -f $_.Name, (ConvertTo-RpcXmlObject -Object $Object.($_.Name))
                $result = $result + $member
            }
            $result = $result + '</struct>'
            return $result
        }
        else {
            throw "[$Object] type is not supported."
        }
    }
}