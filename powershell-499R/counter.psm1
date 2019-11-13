$script:count = 0
$script:increment = 1

function Get-Count(){
    return $script:count += $increment
}

function Reset-Count(){
     $script:count = 0
}

function Set-Increment([int]$i) {
    $script:increment = $i    
}



