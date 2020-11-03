Function formatTitle(){
    param( [string]$misformatedString)
    Write-Host $misformatedString
    <# Make the string an array & make an array of the common words that are not to be 
    captilized in titles Articles, Coordinate Conjuncctions ( aka FANBOYS), & Prepositions #>
    $misformatedStringArray = $misformatedString.ToCharArray() | %{[char]$_}
    write-host "Print out the array"
    
    $misformatedString.ToCharArray() | %{[char]$_}
    $nonCapWords = 'a', 'an', 'the', 'for', 'and', 'nor', 'but', 'or', 'yet', 'so', 'at', 'around', 'by', 'after', 'along', 'for', 'from', 'of', 'on', 'to', 'with', 'without';
    $evaluatedWordsArray = @();
    $indicateNewWord = "-------"
    Write-Host $indicateNewWord
$i = 0;    
foreach($char in $misformatedStringArray){
    write-host "char equals:" $char
    write-host "Counter equals:" $i
    write-host $misformatedStringArray[$char]; 
             write-host "start word index:" $i
             $length = misformatedStringArray.Length;
             $currentIndex = $i;
                for($j = $currentIndex; $j -lt $length; $j++)
                {
                    $i++
                    if($misformatedStringArray[$j] -eq " "){
                        $indicateNewWord
                        continue;
                    }
                $newWord += $misformatedStringArray[$i];
                write-host "new Word:" $newWord
         }
        $evaluatedWordsArray += $newWord;
        #$i++
        $indicateNewWord = "-------"
    }
    $i = 0;
  foreach($word in $evaluatedWordsArray){
      if($i -eq 0 -or $nonCapWords.Contains($word)){
        $word = $word.substring(0,1).toupper()+$word.substring(1).tolower();
        $i++ 
      }
      foreach($word in $evaluatedWordsArray){ write-host "This is the evaluate word " $word}
    }
    $evaluatedWordsArray = @();

}
