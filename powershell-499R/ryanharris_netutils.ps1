<#===================================================
 Program Name : Netutils
 Author: Ryan Harris
 I Ryan Harris wrote this script as original work completed by me.
 Your Network Utility Name: < your network utility name here>
 Your Network Utility Description: <describe your network utility here>
 Support functions: Describe your network support functions.
===================================================

  Function 1
 Description: Function takes a hostname, determines the IP address(es) for the host 
              and pings each IP address to determine if it is online. Return output 
              that shows results of ping.
Name: Test-IPHost
Parameters:[–HostName (name(s) of host to ping)] 
           [-PingCount: *Optional* Number of times to ping the device]
Features: Provide an appropriate error IF the host is NOT FOUND
          allow multiple hostnames to be tested #>
function Test-IPHost ($HostName,$PingCount = 1) {
    foreach ($name in $HostName) {
    # gets ip address from hostname and uses test-connection to ping. returns message if the host is up or down based on the ping results
    Write-Host $name -ForegroundColor "Yellow"
    $ip = ((Resolve-DnsName -Name $name).where({$_.Section -eq "Answer"})).IP4Address
        foreach ($i in $ip) {
            $Status = Test-Connection $i -Count $PingCount -Quiet
            Write-Host "Checking Connection to $i`: " -NoNewline
            $(if($Status -eq $True){"Working!"} 
            else {"Not Working!"})
        }
    }
}

  <# Function 2
    #Description: Given an IP address and a Subnet mask return the network ID. AND THEM
    Name: Get-IPNetwork
    Parameters: –IP: IP address to test
                –SubnetMask: Optional, Subnet Mask to test
    Features: Allow subnet mask to be entered in CIDR or dotted decimal format. 
              For CIDR addresses you must proceed with a /
              Validate IP address and subnet mask, return error if they are not valid.
              If no subnet mask is entered use the class full subnet mask based on the IP address #>
function Get-IPNetwork ($ipAddress, $SubnetMask){
    #if (valid Ip address) 
    #ensure it is not a boardcast or network address
    { 
    $ip = [net.ipaddress]$ipAddress
    #}
    #if(valid subnet mask && valid subnet mask for IP address){ 
    
    $sm=[net.ipaddress]$SubnetMask
    #}
    # both above are true
    $netAdd = [net.ipaddress]($ip.address -band $sm.address)
    Write-Host "Your Network Address is:" $netAdd.IPAddressToString  -ForegroundColor Yellow
}
    # $ip
    # $m
    # $ip|Get-member
    # $Ip
    # $ip.GetType().fullname
    # get-NETIPaddress|ft
    # $ip
    # $ip.Address.GetType()
    # $ip -and $m
    # $ip.address -band $m.address
    # $net = ($ip.address -band $m.address)
    # $net.GetType()


 <# Function 3
Description: The Third function determines if two IP addresses are on the same network.
             Return a $true it they are a $false if they are not.
Name: Test-IPNetwork
Parameters: -IP1, -IP2: IP addresses to test
            –SubnetMask: Subnet mask to use in tests
Features: Allow subnet mask to be entered in CIDR or dotted decimal format.
          Validate IP address and subnet mask, return error if they are not valid. #>
    Function IsValidIP {
        param([string] $IPAddress="")
        try{
            $IP=[net.ipaddress]$IPAddress
        }
        catch{
            return $false
        }
            return $true
        }
    
        Function IpPing{
            param (
                [Parameter()]
                [CalidateScript({IsValidIP $_})]
                [String]$IPaddress
            )
            Test-Connection $ipaddress
        }
 <# Function 4
Check the current bandwidth capability:
total bandwidth

check which browser ofters the best features? IE, CHROME, FIREFOX
#>

<# FUNCTION Validate IP
#>


    Function IsValisIP {
        param( [string]$IPAddress="")
        try {
         $IP =  [net.ipaddress] $IPAddress
        } catch {
        return $false
        }
        return $true
        }


<# FUNCTION Valdiate Subnet#>
Function IsValisSubnet {
    param( [string]$SubnetMask="")
    try {
     $SubM =  [net.ipaddress] $SubnetMask
    } catch {
    return $false
    }
    return $true
    }