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