
   get-process notepad|stop-process
    $p1 = gps
    notepad
    $p2 = gps
    $p2|Where {$_.id -notin $p1.id} | export=csb
