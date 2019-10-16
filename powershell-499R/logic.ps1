foreach ($file in dir){
$file.fullname
}



$a= 'red','green','blue'
foreach($color in $a){
    $color
}

1..3|% {$_ *10}

1..3|% -begin{$t=0} -process{$t+=$_ *10} -end {"the total is $t"}