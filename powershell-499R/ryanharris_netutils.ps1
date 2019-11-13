<#===================================================
 Program Name : Netutils
 Author: Ryan Harris
 I Ryan Harris wrote this script as original work completed by me.
 Your Network Utility Name: traceroute
 Your Network Utility Description: This Functions determines and prints the
  number of hop counts on a traceroute command and displays the number for the user to know

 Support functions: Describe your network support functions.
===================================================

    #  This Validates the IP address #>
    <# FUNCTION Valdiate IP#>
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


        <# FUNCTION Valdiates Subnet#>
    Function IsValidSubnet {
        param( [string]$SubnetMask="")
        try {
        $SubM =  [net.ipaddress] $SubnetMask
        } catch {
        return $false
        }
        return $true
        }


    #CONVERT TO DOTTED DECIMAL
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
    $yesAnswers = 'yes','yeah', 'ok', 'sure', 'why not','y', 'yup','true', 'yep', 'ye' # array for yes matches
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
    Write-Host "Your Network Address is:" $netAdd.IPAddressToString  -ForegroundColor Yellow
    Write-Host "From Subnet Mask:" $SubnetMask  -ForegroundColor CYAN
    Write-Host "From ip address:" $ipAddress  -ForegroundColor CYAN
    return $netAdd.IPAddressToString  
    }

    #if only ip is valid figure out the default subnet
    elseif ($valid -eq $true) {
    Write-host "You either did not enter a valid SubnetMask or did not enter one:"
    $answer = read-host "Do want to get the default subnet based on the ip address? Y/N"

        if($yesAnswers -contains $answer){
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
            Write-Host "Your Network Address is:" $netAdd.IPAddressToString  -ForegroundColor Yellow
            return $netAdd.IPAddressToString    
        }
        else{break}

    }
    
    else{
        Write-Host "You entered an invalid ip address and subnet"
    }
  
}

  
 <# Function 3
Description: The Third function determines if two IP addresses are on the same network.
             Return a $true it they are a $false if they are not.
Name: Test-IPNetwork
Parameters: -IP1, -IP2: IP addresses to test
            –SubnetMask: Subnet mask to use in tests
Features: Allow subnet mask to be entered in CIDR or dotted decimal format.
          Validate IP address and subnet mask, return error if they are not valid. #>
 
    function Test-IPNetwork ($IP1, $IP2, $SubnetMask) {
        $yesAnswers = 'yes','yeah', 'ok', 'sure', 'why not','y', 'yup','true', 'yep', 'ye' # array for yes matches

        $IP1
        $IP2
        $SubnetMask
        $IPNet1 = Get-IPNetwork -ipAddress $IP1 -SubnetMask $SubnetMask 
        $IPNet1 =[string]$IPNet1
        $IPNet2 = Get-IPNetwork -ipAddress $IP2 -SubnetMask $SubnetMask 
        $IPNet2 = [string]$IPNet2
          if ($IPNet1 -eq $IPNet2) {
            Write-Host "The addresses you entered ARE on the same network."
            Write-Host " $IPNet1 is the Net ID."

          }

        else {
            Write-Host "The addresses you entered are NOT on the same network."
        }
    }


 <# Function 4: Worked with Andrew
This Functions determines and prints the number of hop counts on a traceroute command and displays the number for the user to know
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
    



    

