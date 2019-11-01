#===================================================
# Program Name : Netutils
# Author: Ryan Harris
# I Ryan Harris wrote this script as original work completed by me.
# Your Network Utility Name: < your network utility name here>
# Your Network Utility Description: <describe your network utility here>
# Support functions: Describe your network support functions.
#===================================================


# 3. Function 1
# Description: Function takes a hostname, determines the IP address(es) for the host 
                # and pings each IP address to determine if it is online. Return output 
                #that shows results of ping.
#Name: Test-IPHost
#Parameters:[–HostName (name(s) of host to ping)] 
           #[-PingCount: *Optional* Number of times to ping the device]
#Features: Provide an appropriate error IF the host is NOT FOUND
           #allow multiple hostnames to be tested

Function Test-IPHost($hostname, $PingCount){
    # ask the user to enter  the hostnames(name of the webisite) to be tested

    ping $hostname
    show ip
    ipconfig
    #ask user to enter the number of time to ping the hostnames
    
    if (does not ping){
        give an error message
    }

    $ip = [net.ipaddress]$hostname1
    $ip
$m=[net.ipaddress]'255.255.255.0'
$m
$ip|Get-member
$Ip
Get-History
$ip.GetType().fullname
Gethelp().System.Net.IPAddress
Gethelp.System.Net.IPAddress
System.Net.IPAddress | Get-Help()
System.Net.IPAddress | Get-Help
get-NETIPaddress|ft
$ip
$ip.Address.GetType()
$ip -and $m
$ip -band $m
$ip.address -band $m.address
$net = ($ip.address -band $m.address)
$net.GetType()
[net.ipaddress]($ip.address -band $m.address)
}


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




 
   