Function formatTitle(){
    param( 
        [Parameter(Mandatory=$true)]$Title,
        [switch]$AllCaps
    )

    function proper($word){
        $nonCapWords = 'a', 'an', 'the', 'for', 'and', 'nor', 'but', 'or', 'yet', 'so', 'at', 'around', 'by', 'after', 'along', 'for', 'from', 'of', 'on', 'to', 'with', 'without';
        $wordCount = $Title.Split(" ");
        $fixedTitle = @();
        $TextInfo = (Get-Culture).TextInfo;
        foreach($word in $wordCount){
            if(!$nonCapWords.Contains($word)){
                $fixedTitle += $TextInfo.ToTitleCase($word);
            }
            else{
                $fixedTitle += $word
            }
        }
        write-host $fixedTitle
    }
    if($AllCaps){
        $Title.ToUpper();
    }
    else{
    proper($Title)
    }
}

  

    
   
