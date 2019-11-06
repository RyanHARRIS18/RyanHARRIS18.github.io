
#* Functions for Repeatable tasks
$convertedIP=$null
$counter = $null
function Convert-CIDR ($cidr){
# determines if cidr notation entered is valid
 if($cidr -le 32) {
 # creates an array with 32 elements to count bits for an ip (32 bits in an IP address, 4 octets)
 [Int[]]$totalBits = (1..32)
 # loops through the 32 bits 
 for($i=0;$i -lt $totalBits.length;$i++){
 <# if the bit counter is greater than the cidr mask entered, set all those bits to 0.
 if it's within the cidr mask entered, it sets those bits to 1.
 the cidr mask represents the network portion of the address. all those bits are 1's,
 all the bits after that are 0's (host portion of address)
 #>
 if($totalBits[$i] -gt $cidr){$totalBits[$i]="0"}else{$totalBits[$i]="1"}
 }
 # joins all the bits to form a 32 bit subnet mask in binary form
 $cidr = $totalBits -join ""
 # using substring breaks that binary address into 4 octets and puts it in an array
 $octetArray = @($cidr.Substring(0,8), $cidr.Substring(8,8), $cidr.Substring(16,8), $cidr.Substring(24,8))
 # loops through array and converts each octet to integers and places a decimal between them
 $octetArray | foreach { 
        $counter++
        [string]$convertedIP += [convert]::ToInt32($_,2)
        #! Counts octets so it can add a "." after each octet except the last.
        #? (might want to change this to a join)
        if($counter -le 3) {[string]$convertedIP += "."}

    }
 }
    # returns finshed product, a dotted decimal subnet mask
    return $convertedIP
}
Convert-CIDR 24


function Test-IPHost ($HostName,$Count = 1) {
    foreach ($name in $HostName) {
    # gets ip address from hostname and uses test-connection to ping. returns message if the host is up or down based on the ping results
    Write-Host -Foreground "green" "Up-status for $name"
    $ip = ((Resolve-DnsName -Name $name).where({$_.Section -eq "Answer"})).IP4Address
        foreach ($i in $ip) {
            $upStatus = Test-Connection $i -Count $Count -Quiet
            Write-Host -Foreground "magenta" "$i`: " -NoNewline
            $(if($upStatus -eq $True){Write-Host -Foreground "green" "Up"} else {Write-Host -Foreground "red" "down"})

        }
    }
}


function Test-IPNetwork () {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [Net.IPAddress] $IP1,

        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [Net.IPAddress] $IP2,

        [Parameter(Mandatory=$true)]
        # couldn't figure out how to validate, not enough time
        [string] $SubnetMask
    )
    if ($SubnetMask.length -lt 3) {
        #$SubnetMask.length
        #$SubnetMask.gettype()
        [Net.IPAddress]$SubnetMask = Convert-CIDR $SubnetMask
        Write-Host -foreground "green" "the converted cidr mask is: " $SubnetMask
    }
    else {[Net.IPAddress]$SubnetMask = $SubnetMask}

    if (($IP1.address -band $SubnetMask.address) -eq ($IP2.address -band $SubnetMask.address)) {
        Write-Host "The addresses you entered are on the same network."
        Write-Host -ForegroundColor "green" "The subnet mask is " $SubnetMask
        "IP1 = " + $IP1.gettype()
        "IP2 = " + $IP2.gettype()
        "SubnetMask = " + $SubnetMask.gettype()

    }
    else {
        Write-Host "The addresses you entered are not on the same network."
        "IP1 = " + $IP1.gettype()
        "IP2 = " + $IP2.gettype()
        "SubnetMask = " + $SubnetMask.gettype()
    }
}
function Get-IPNetID {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [Net.IPAddress] $IP,

        [Parameter()]
        # couldn't figure out how to validate, not enough time
        [string] $SubnetMask
    )

    if ($SubnetMask.length -lt 3 -and $SubnetMask.Length -gt 0) {
        <#Write-Host -ForegroundColor "red" "-------------------------------DEBUGGING-----------------------------------"
        "SubnetMask: " + $SubnetMask
        "SubnetMask.Length: " + $SubnetMask.Length
        "SubnetMask.GetType(): " + $SubnetMask.GetType()
        Write-Host -ForegroundColor "red" "---------------------------------------------------------------------------"
        #>
        [Net.IPAddress]$SubnetMask = Convert-CIDR $SubnetMask
        Write-Host -foreground "green" "the converted cidr mask is: " $SubnetMask
    }
    elseif ($SubnetMask.Length -eq 0) {
        Write-Host "You did not provide a subnetmask - the default classful netmask will be used."
        [string]$IP = $IP.IPAddressToString
        $IParray = "$IP" -split ".",0,'SimpleMatch'
        if ([int]$IParray[0] -in 1..127) {
            if ($IParray[0] -eq 127 -and ($IParray[1] -in 0..255)) {
                Write-Host -Foreground "blue" "IP address provided is part of reserved range for loopback addresses, it uses a /8 mask"
                [Net.IPAddress]$SubnetMask = Convert-CIDR 8
            }
            else {
                Write-Host "Using Class A default mask..."
                [Net.IPAddress]$SubnetMask = Convert-CIDR 8
                #$SubnetMask.IPAddressToString 
            }
        }
        elseif ([int]$IParray[0] -in 128..191) {
            if ($IParray[0] -eq 172 -and ($IParray[1] -in 16..31)) {
                Write-Host -Foreground "blue" "IP address provided is part of reserved range that uses a /12 mask"
                [Net.IPAddress]$SubnetMask = Convert-CIDR 12
            }
            else {
                Write-Host "Using Class B default mask..."
                [Net.IPAddress]$SubnetMask = Convert-CIDR 16
                #$SubnetMask.IPAddressToString 
            }           
        }
        elseif ([int]$IParray[0] -in 192..223) {
            if ($IParray[0] -eq 192 -and $IParray[1] -eq 168) {
                Write-Host -Foreground "blue" "IP address provided is part of reserved range that uses a /16 mask"
                [Net.IPAddress]$SubnetMask = Convert-CIDR 16
            }
            else {
                Write-Host "Using Class C default mask..."
                [Net.IPAddress]$SubnetMask = Convert-CIDR 24
                #$SubnetMask.IPAddressToString
            }
            
        }
    }
    else {[Net.IPAddress]$SubnetMask = $SubnetMask}
    [Net.IPAddress]$IP = $IP
    [Net.IPAddress]$netID = $IP.Address -band $SubnetMask.address
    Write-Host -Foreground "green" "The network ID for $IP is" $netID
    #$netID.gettype()

}   

 #Get-IPNetID 172.30.5.10


<#
    6. #* Function 4
        a. #* You get to make your own network utility, it can do whatever you want, have fun and be creative
#>

#* My function calculates the number of valid hosts for a given subnet
function Get-ValidHosts {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $cidrMask
    )

    $hostBits = 32 - $cidrMask
    $numValidHosts = ([math]::pow( 2, $hostBits)) - 2

    Write-Host -ForegroundColor "green" "The number of valid hosts on the /$cidrMask subnet is: " $numValidHosts
}


