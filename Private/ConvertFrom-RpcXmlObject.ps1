<#
.Synopsis
   Convert to object from XML-RPC object string.
.DESCRIPTION
   Convert to object from XML-RPC object string.
.EXAMPLE
   $s1= '<i4>1919</i4>'
   ConvertFrom-RpcXmlObject -XmlObject $s1
.OUTPUTS
   The XML-RPC object string.
#>
function ConvertFrom-RpcXmlObject {
    param($XmlObject)
    if ($XmlObject -is [string]) {
        $XmlObject = ([xml]$XmlObject).DocumentElement
    }
    elseif ( $XmlObject -is [xml] ) {
        $XmlObject = $XmlObject.DocumentElement
    }
    elseif ( $XmlObject -isnot [Xml.XmlElement]) {
        throw 'Only types [string](xml format), [xml], [System.Xml.XmlElement] are supported.'
    }

    $node = $XmlObject
    if ($node) {
        $typeName = $node.Name
        switch ($typeName) {
            # Bool
            ('boolean') {
                if ($node.InnerText -eq '1') {
                    return $true
                }
                return $false
            }

            # Number
            ('i4') {[int64]::Parse($node.InnerText) }
            ('int') {[int64]::Parse($node.InnerText) }
            ('double') { [double]::Parse($node.InnerText) }

            # String
            ('string') { $node.InnerText }

            # Base64
            ('base64') {
                [Text.UTF8Encoding]::UTF8.GetBytes($node.InnerText)
            }

            # Date Time
            ('dateTime.iso8601') {
                $format = 'yyyyMMddTHH:mm:ss'
                $formatProvider = [Globalization.CultureInfo]::InvariantCulture
                [datetime]::ParseExact($node.InnerText, $format, $formatProvider)
            }

            # Array
            ('array') {
                $node.SelectNodes('data/value') | ForEach-Object {
                    ConvertFrom-RpcXmlObject -XmlObject $_.FirstChild
                }
            }

            # Struct
            ('struct') {
                $hashTable = @{}
                $node.SelectNodes('member') | ForEach-Object {
                    # sometimes the value element will be empty. if so, handle that case by adding an empty string
                    if ($_.value.FirstChild -eq $null) {
                        $hashTable.Add($_.name.InnerText, '')
                    }
                    elseif ($_.name.InnerText -eq $null) {
                        $hashTable.Add($_.name, (ConvertFrom-RpcXmlObject -XmlObject $_.value.FirstChild))
                    }
                    else {
                        $hashTable.Add($_.name.InnerText, (ConvertFrom-RpcXmlObject -XmlObject $_.value.FirstChild))
                    }

                }
                [psobject]$hashTable
            }
        }
    }
}