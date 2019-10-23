$x=1
function foo 
{
    $y=2
    write-host " x=$x y=$y"

    $x=11
    $y = 22
    'change x to 11 y to  22 in funciton foo'

    write-host "x=$x y=$y"
    write-host " Global x=$global:x"

}
Write-host "x=$x y=$y"
'running foo'
foo
write-host "x=$x y=$y"