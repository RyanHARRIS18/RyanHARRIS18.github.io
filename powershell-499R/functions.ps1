function greet{
    $args.count
    $args
    if($args.count -gt 0){
       "hi $args"
    }
    else{
        "hi nobody"
    }
}

function argsdemo{
    $args.count
    $args|%{$_ * 100}
}

function addit($n1, $n2){
    $n1 + $n2
    $args.count
}

function additt{
   param([int]$n1, [int]$n2 = 100)
    $n1 + $n2
    $args.count
}

function get-soup ( $please, $soup = 'tomato'){
    if($please){
        "$soup soup for you"
    }
    else{
        "No $soup soup for you"
    }
 }

 function rr{
     1
     2
     return 
    dir
     write-host 'hi class'
     Write-Output 'hi out host class'
 } 
function add($n1, $n2){
    begin{
        $total = 0
    }
    process{
        $total += $_
    }
    end{
        $total += $n1+$n2
        $args |%{$total += $_}
        $total
    }
}

filter doubledouble{
    $_ * 2
}

    
