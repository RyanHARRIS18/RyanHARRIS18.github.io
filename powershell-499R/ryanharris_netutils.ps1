<#===================================================
 Program Name : Netutils
 Author: Ryan Harris
 I Ryan Harris wrote this script as original work completed by me.
 Your Network Utility Name: traceroute
 Your Network Utility Description: This Functions determines and prints the
  number of hop counts on a traceroute command and displays the number for the user to know

 Support functions: Describe your network support functions.
===================================================

    <# 
    .SYNOPSIS 
      Validate Ip address
    .Description
      This Validates the IP address using the built in net.ipaddress commandlet
    .Example
    Validate '192.168.125.2' as a ip by returning true
    validates that '256.256.256.256' is not a valid ip and returns false
    #>
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


     <# 
    .SYNOPSIS 
      Validate Subnetmask address
    .Description
      This Validates the Subnet address using the built in net.ipaddress commandlet
    .Example
    Validate '255.255.0.0' as a subnet by returning true
    validates that '256.256.256.256' is not a valid ip and returns false
    #>
    Function IsValidSubnet {
        param( [string]$SubnetMask="")
        try {
        $SubM =  [net.ipaddress] $SubnetMask
        } catch {
        return $false
        }
        return $true
        }


     <# 
    .SYNOPSIS 
      Converts to Dotted Decimal Notation
    .Description
     This changes the input from the user that is a cidr to dotted decimal. It first removes the '/' if it has one then creates a 
     local array acts as a comparision 

    .Example
    Validate '192.168.125.2' as a ip by returning true
    validates that '256.256.256.256' is not a valid ip and returns false
    #>
    Function convertToDD($SubnetMask) {
        #take away the / if there was one
        $SubnetMask = $SubnetMask -replace '/', ''
        #  $SubnetMask = $SubnetMask -replace '\', ''
        if(([int]$SubnetMask) -le 32) {
            [Int[]]$totalBits = (1..32)
            # Creat binary number
                for($i=0;$i -lt $totalBits.length;$i++){
                    if($totalBits[$i] -gt $SubnetMask){$totalBits[$i]="0"}else{$totalBits[$i]="1"}
                }
            $SubnetMask = $totalBits -join ""
            # creat 4 octets
            $octetArray = @($SubnetMask.Substring(0,8), $SubnetMask.Substring(8,8), $SubnetMask.Substring(16,8), $SubnetMask.Substring(24,8))
                
            #! Counts octets so it can add a "." after each octet except the last.
            $octetArray | foreach { 
                $counter++
                [string]$newSub += [convert]::ToInt32($_,2)
                if($counter -lt 4) {[string]$newSub += "."}
            }
            return $newSub  
        }
    }
     <# 
    .SYNOPSIS 
      Provide an appropriate error IF the host is NOT FOUND
    allow multiple hostnames to be tested
    .Description
     Function takes a hostname, determines the IP address(es) for the host 
    and pings each IP address to determine if it is online. Return output 
    that shows results of ping.
    .Example
     call 'youtube' and number of pint to be sent to that client and says if ping was sucesful or not
   #>
function Test-IPHost ($HostName,$PingCount = 1) {
    $HostName = ,$HostName
    $HostName += $args

# gets ip address from hostname and uses test-connection to ping. returns message if the host is up or down based on the ping results
    foreach ($name in $HostName) {
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

<# 
    .SYNOPSIS 
     Given an IP address and a Subnet mask return the network ID.
    .Description
     Allow subnet mask to be entered in CIDR or dotted decimal format. 
              For CIDR addresses you must proceed with a /
              Validate IP address and subnet mask, return error if they are not valid.
              If no subnet mask is entered use the class full subnet mask based on the IP address 
    .Example
     input 'ip' (172.168.0.5) and 'subnet' (255.255.0.0) which will detrmine the 'netaddress' (172.168.0.0)
   #>
 
function Get-IPNetwork ($ipAddress, $SubnetMask = $false){
    $subValid
    #Throw ip through Validator
    $valid = IsValidIP($ipAddress)
    
    #Throw subnet through Validator if already in dotted decimal |||| IF in CIDR notation ~always less then 4 send to covert to dotted Decimal
    $SubnetMask = [string]$SubnetMask
        if($SubnetMask.substring(0,1) -eq '/' ){ 
            $SubnetMask = convertToDD $SubnetMask
            $subValid = IsValidSubnet $SubnetMask
        }
        else{
            $subValid = IsValidSubnet($SubnetMask) 
        }
        
    #if both are valid
    if (($valid -eq $true) -and ($subValid -eq $true)){
    Write-Host "Both Subnet and IP address are Valid" -ForegroundColor "Green"
    $ip=[net.ipaddress]$ipAddress
    $sm=[net.ipaddress]$SubnetMask
    $netAdd = [net.ipaddress]($ip.address -band $sm.address)
    # Write-Host "Your Network Address is:" $netAdd.IPAddressToString  -ForegroundColor Yellow
    return $netAdd.IPAddressToString  
    }

    #if only ip is valid figure out the default subnet
    elseif ($valid -eq $true) {
            $ip=[net.ipaddress]$ipAddress
           
                #default for Class A
                if([int]($ipAddress.Substring(0,3)) -lt  127){
                    $SubnetMask = '255.0.0.0'
                }
                #default for Class D
                elseif([int]($ipAddress.Substring(0,3)) -lt  192){
                    $SubnetMask = '255.255.0.0'
                }
                #default for Class C
                else{
                    $SubnetMask = '255.255.255.0'
                }
            
            $sm=[net.ipaddress]$SubnetMask
            $netAdd = [net.ipaddress]($ip.address -band $sm.address)
            # Write-Host "Your Network Address is:" $netAdd.IPAddressToString  -ForegroundColor Yellow
            return $netAdd.IPAddressToString    
    }
    
    else{
        Write-Host "You entered an invalid ip address and subnet"
    }
  
}

<# 
    .SYNOPSIS 
      determines if two IP addresses are on the same network.
    .Description
     Return a $true it they are a $false if they are not.
     Use IP1, IP2: IP addresses to test and SubnetMask: Subnet mask to use in tests
     Allow subnet mask to be entered in CIDR or dotted decimal format.
     Validate IP address and subnet mask, return error if they are not valid.
    .Example
     input 'ip' (172.168.0.5) and 'subnet' (255.255.0.0) which will detrmine the 'netaddress' (172.168.0.0)
   #>

    function Test-IPNetwork ($IP1, $IP2, $SubnetMask=$false) {
        $IPNet1 = Get-IPNetwork -ipAddress $IP1 -SubnetMask $SubnetMask 
        $IPNet1 =[string]$IPNet1
        $IPNet2 = Get-IPNetwork -ipAddress $IP2 -SubnetMask $SubnetMask 
        $IPNet2 = [string]$IPNet2
          if ($IPNet1 -eq $IPNet2) {
            $TRUE
          }

        else {
            $False
        }
    }


<# 
    .SYNOPSIS 
      determines number of hopcounts to reach a client
    .Description
     We provide elevator music and then begin the funtion. The tracert built in command is used and
     we then take the output and parse the information to find the total hopcount to reach the destination
    .Example
     input client youtube.com you will wait and it will tell you how many hops it took ie 5
   #>
function traceroute($hostname){

$IE=new-object -com internetexplorer.application
$IE.navigate2("https://www.youtube.com/watch?v=A84-wCLLVjQ")
$IE.visible=$false
Write-Host "---This Step can take some time please wait---"
sleep 5
Write-Host "---It's not Rush but we hope you enjoy the music---"

$initalTest= TRACERT $hostname

$lastline =  ($initalTest[-3])
$IE.quit()

$newstring = [string]$lastline
$lastline = $newstring.subString(0,3)
 Write-Host " --- it took $lastline hops to navigate to $hostname"

}
    



    

