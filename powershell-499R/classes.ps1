class Device {
    $Name
    $IpAddress
    $MacAddress
}

class metal{
    [String]$Symbol; [String]$Name; [int]$Meltingpoint; [double]$SpecificGravity
}

$l = Import-Csv .\lapidary.csv|%{[metal]$_}
$l

class foo{
    static $bar = 1
    hidden static $bar2 = 2
}

enum rarity {common = 0;semiprecious = 1;precious = 2}

class circle{
    hidden static $pi = 3.141659265358979
    $Radius = 0
    circle(){}
    circle($radius){
        $this.radius = $Radius
    }
    static [double] Area([double]$radius){
    return [circle]::pi * [math]::Pow($radius,2)
    }
    [double] Area(){
        return [circle]::pi * [math]::Pow($this.radius,2)
    }

}

class IP:System.Net.IPAddress{
    IP(){}
    [bool]$online
}