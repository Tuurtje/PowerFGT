﻿#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Add-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Add a FortiGate ProxyAddress

        .DESCRIPTION
        Add a FortiGate ProxyAddress (host-regex, url, category...)

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0

        Add Address objet type ipmask with name FGT and value 192.2.0.0/24

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -interface port2

        Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and associated to interface port2

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -comment "My FGT Address"

        Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and a comment

        .EXAMPLE
        Add-FGTFirewallAddress -type ipmask -Name FGT -ip 192.2.0.0 -mask 255.255.255.0 -visibility:$false

        Add Address objet type ipmask with name FGT, value 192.2.0.0/24 and disabled visibility

    #>
    [CmdletBinding(PositionalBinding=$false)]
    Param(
        [Parameter (Mandatory = $true)]
        [ValidateSet("host-regex", "url", "method","category",IgnoreCase = $false)]
        [string]$type,
        [Parameter (Mandatory = $true)]
        [string]$name,
        
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )
DynamicParam
  {
        # Define Parameter Default Attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.ParameterSetName = '__AllParameterSets'
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ValueFromPipelineByPropertyName = $false
        $ParameterAttribute.HelpMessage = "Please enter the $type"

        # Expose parameter to the namespace
        $ParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        
        if ($type -eq 'host-regex')
        {
            # Add hostregex parameter (dash is disallowed in variable names)
            $AttributeCollection = New-Object Collections.ObjectModel.Collection[System.Attribute]
            $AttributeCollection.Add($ParameterAttribute)

            # Create Dynamic parameter
            $Parameter = New-Object System.Management.Automation.RuntimeDefinedParameter -ArgumentList @("hostregex", ([string]), $AttributeCollection)
           
            $ParameterDictionary.Add("hostregex", $Parameter)
        }

        if ($type -eq 'url')
        {
            # Get-FGTFirewallAddress & Get-FGTFirewallProxyAddress as validationSet 
            $AttributeCollection = New-Object Collections.ObjectModel.Collection[System.Attribute]
            $AttributeCollection.Add($ParameterAttribute)
            
            $invokeParams = @{ }
            if ( $PsBoundParameters.ContainsKey('vdom') ) {
                $invokeParams.add( 'vdom', $vdom )
            }

            $ValidateSet = (Get-FGTFirewallAddress @invokeParams -filter_type equal -filter_attribute visibility -filter_value enable -connection $connection).name
            $ValidateSet += (Get-FGTFirewallproxyAddress @invokeParams -filter_type equal -filter_attribute visibility -filter_value enable -connection $connection).name
            if ( $ValidateSet ) {
                $ParameterValidateSet = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
                $ParameterValidateSet.IgnoreCase = $true
                $AttributeCollection.Add($ParameterValidateSet)
            }
            
            # Create Dynamic parameter
            $Parameter = New-Object System.Management.Automation.RuntimeDefinedParameter -ArgumentList @('hostObjectName', ([string]), $AttributeCollection)
            
            $ParameterDictionary.Add('hostObjectName', $Parameter)

            $AttributeCollection = New-Object Collections.ObjectModel.Collection[System.Attribute]
            $AttributeCollection.Add($ParameterAttribute)

            # Create Dynamic parameter
            $Parameter = New-Object System.Management.Automation.RuntimeDefinedParameter -ArgumentList @("path", ([string]), $AttributeCollection)
            
            $ParameterDictionary.Add("path", $Parameter)
        }
        
        if ($type -eq 'method')
        {
            # Get-FGTFirewallAddress & Get-FGTFirewallProxyAddress as validationSet 
            $AttributeCollection = New-Object Collections.ObjectModel.Collection[System.Attribute]
            $AttributeCollection.Add($ParameterAttribute)
            
            $invokeParams = @{ }
            if ( $PsBoundParameters.ContainsKey('vdom') ) {
                $invokeParams.add( 'vdom', $vdom )
            }

            $ValidateSet = (Get-FGTFirewallAddress @invokeParams -filter_type equal -filter_attribute visibility -filter_value enable -connection $connection).name
            $ValidateSet += (Get-FGTFirewallproxyAddress @invokeParams -filter_type equal -filter_attribute visibility -filter_value enable -connection $connection).name
            if ( $ValidateSet ) {
                $ParameterValidateSet = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
                $ParameterValidateSet.IgnoreCase = $true
                $AttributeCollection.Add($ParameterValidateSet)
            }

            # Create Dynamic parameter
            $Parameter = New-Object System.Management.Automation.RuntimeDefinedParameter -ArgumentList @('hostObjectName', ([string]), $AttributeCollection)
            
            $ParameterDictionary.Add('hostObjectName', $Parameter)

            $AttributeCollection = New-Object Collections.ObjectModel.Collection[System.Attribute]
            $AttributeCollection.Add($ParameterAttribute)


            # Add validationSet to the method parameter
            $AttributeCollection = New-Object Collections.ObjectModel.Collection[System.Attribute]
            $AttributeCollection.Add($ParameterAttribute)

            $ValidateSet = @('CONNECT', 'DELETE', 'GET', 'HEAD', 'OPTIONS', 'POST', 'PUT', 'TRACE')
            $ParameterValidateSet = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
            $ParameterValidateSet.IgnoreCase = $true
            $AttributeCollection.Add($ParameterValidateSet)
            
            # Create Dynamic parameter
            $Parameter = New-Object System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($type, ([string]), $AttributeCollection)
            
            $ParameterDictionary.Add($type, $Parameter)
        }
        
        return $ParameterDictionary
    
  }

    Begin {
        $hostregex = $PSBoundParameters['hostregex']
        $hostObjectName = $PSBoundParameters['hostObjectName']
        $path = $PSBoundParameters['path']
        $method = $PSBoundParameters['method']
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( Get-FGTFirewallProxyAddress @invokeParams -name $name -connection $connection) {
            Throw "Already an address object using the same name"
        }

        $uri = "api/v2/cmdb/firewall/proxy-address"

        $proxyaddress = new-Object -TypeName PSObject

        $proxyaddress | add-member -name "type" -membertype NoteProperty -Value $type

        $proxyaddress | add-member -name "name" -membertype NoteProperty -Value $name
        
        
        if ( $type -eq 'host-regex' ) {
            $proxyaddress | add-member "host-regex" -membertype NoteProperty -Value $hostregex
        }

        if ( $type -eq 'url' ) {
            if (!(Get-FGTFirewallAddress @invokeParams -name $hostObjectName -connection $connection) -and `
                !(Get-FGTFirewallProxyAddress @invokeParams -name $hostObjectName -connection $connection) `
            ){
                    Throw "FirewallAddres $Hostname not Found"
            }
            $proxyaddress | add-member -name "host" -membertype NoteProperty -Value $hostObjectName
            $proxyaddress | add-member -name "path" -membertype NoteProperty -Value $path
        }

        
        if ( $type -eq 'method' ) {
            $proxyaddress | add-member -name "method" -membertype NoteProperty -Value $method
        }


        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $proxyaddress | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $proxyaddress | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $proxyaddress | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "POST" -body $proxyaddress -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallProxyAddress -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Copy-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Copy/Clone a FortiGate ProxyAddress

        .DESCRIPTION
        Copy/Clone a FortiGate ProxyAddress (host-regex, url, category...)

        .EXAMPLE
        $MyFGTAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTProxyAddress | Copy-FGTFirewallProxyAddress -name MyFGTProxyAddress_copy

        Copy / Clone MyFGTProxyAddress and name MyFGTProxyAddress_copy

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddress $_ })]
        [psobject]$address,
        [Parameter (Mandatory = $true)]
        [string]$name,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }
        
        $uri = "api/v2/cmdb/firewall/proxy-address/$($address.name)/?action=clone&nkey=$($name)"
        
        Invoke-FGTRestMethod -method "POST" -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallproxyAddress -connection $connection @invokeParams -name $name
    }

    End {
    }
}

function Get-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Get list of all "proxy-address"

        .DESCRIPTION
        Get list of all "proxy-address" (host-regex, url, category...)

        .EXAMPLE
        Get-FGTFirewallProxyAddress

        Get list of all proxy-address object

        .EXAMPLE
        Get-FGTFirewallProxyAddress -name myFGTPoxyAddress

        Get proxy-address named myFGTProxyAddress

        .EXAMPLE
        Get-FGTFirewallProxyAddress -name FGT -filter_type contains

        Get proxy-address contains with *FGT*

        .EXAMPLE
        Get-FGTFirewallProxyAddress -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        Get proxy-address with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

        .EXAMPLE
        Get-FGTFirewallProxyAddress -skip

        Get list of all proxy-address object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallProxyAddress -vdom vdomX

        Get list of all proxy-address on VdomX

  #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "uuid" {
                $filter_value = $uuid
                $filter_attribute = "uuid"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/proxy-address' -method 'GET' -connection $connection @invokeParams

        $response.results

    }

    End {
    }

}

function Set-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Configure a FortiGate proxyAddress

        .DESCRIPTION
        Change a FortiGate "proxy-address" (host-regex, url, category...)

        .EXAMPLE
        $MyFGTProxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTProxyAddress | Set-FGTFirewallProxyAddress -ip 192.2.0.0 -mask 255.255.255.0

        Change MyFGTProxyAddress to value (ip and mask) 192.2.0.0/24

        .EXAMPLE
        $MyFGTproxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTproxyAddress | Set-FGTFirewallproxyAddress -ip 192.2.2.1

        Change MyFGTProxyAddress to value (ip) 192.2.2.1

        .EXAMPLE
        $MyFGTproxyAddress = Get-FGTFirewallproxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTProxyAddress | Set -interface port1

        Change MyFGTProxyAddress to set associated interface to port 1

        .EXAMPLE
        $MyFGTproxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTproxyAddress | Set -comment "My FGT proxyAddress" -visibility:$false

        Change MyFGTproxyAddress to set a new comment and disabled visibility

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTproxyAddress $_ })]
        [psobject]$address,
        [Parameter (Mandatory = $false)]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [ipaddress]$ip,
        [Parameter (Mandatory = $false)]
        [ipaddress]$mask,
        [Parameter (Mandatory = $false)]
        [string]$interface,
        [Parameter (Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$comment,
        [Parameter (Mandatory = $false)]
        [boolean]$visibility,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/address/$($address.name)"

        $_address = new-Object -TypeName PSObject

        if ( $PsBoundParameters.ContainsKey('name') ) {
            #TODO check if there is no already a object with this name ?
            $_address | add-member -name "name" -membertype NoteProperty -Value $name
            $address.name = $name
        }

        if ( $PsBoundParameters.ContainsKey('ip') -or $PsBoundParameters.ContainsKey('mask') ) {
            if ( $PsBoundParameters.ContainsKey('ip') ) {
                $subnet = $ip.ToString()
            }
            else {
                $subnet = $address.'start-ip'
            }

            $subnet += "/"

            if ( $PsBoundParameters.ContainsKey('mask') ) {
                $subnet += $mask.ToString()
            }
            else {
                $subnet += $address.'end-ip'
            }

            $_address | add-member -name "subnet" -membertype NoteProperty -Value $subnet
        }

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            #TODO check if the interface (zone ?) is valid
            $_address | add-member -name "associated-interface" -membertype NoteProperty -Value $interface
        }

        if ( $PsBoundParameters.ContainsKey('comment') ) {
            $_address | add-member -name "comment" -membertype NoteProperty -Value $comment
        }

        if ( $PsBoundParameters.ContainsKey('visibility') ) {
            if ( $visibility ) {
                $_address | add-member -name "visibility" -membertype NoteProperty -Value "enable"
            }
            else {
                $_address | add-member -name "visibility" -membertype NoteProperty -Value "disable"
            }
        }

        Invoke-FGTRestMethod -method "PUT" -body $_address -uri $uri -connection $connection @invokeParams | out-Null

        Get-FGTFirewallAddress -connection $connection @invokeParams -name $address.name
    }

    End {
    }
}

function Remove-FGTFirewallProxyAddress {

    <#
        .SYNOPSIS
        Remove a FortiGate ProxyAddress

        .DESCRIPTION
        Remove an Proxyaddress object on the FortiGate

        .EXAMPLE
        $MyFGTProxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTproxyAddress | Remove-FGTFirewallProxyAddress

        Remove address object $MyFGTProxyAddress

        .EXAMPLE
        $MyFGTproxyAddress = Get-FGTFirewallProxyAddress -name MyFGTProxyAddress
        PS C:\>$MyFGTproxyAddress | Remove-FGTFirewallProxyAddress -noconfirm

        Remove address object $MyFGTProxyAddress with no confirmation

    #>

    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTProxyAddress $_ })]
        [psobject]$address,
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/firewall/proxy-address/$($address.name)"

        if ( -not ( $Noconfirm )) {
            $message = "Remove proxyaddress on Fortigate"
            $question = "Proceed with removal of proxyAddress $($address.name) ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove ProxyAddress"
            $null = Invoke-FGTRestMethod -method "DELETE" -uri $uri -connection $connection @invokeParams
            Write-Progress -activity "Remove ProxyAddress" -completed
        }
    }

    End {
    }
}