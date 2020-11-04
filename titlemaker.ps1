Function formatTitle(){
    param( 
        [Parameter(Mandatory=$true)][string]$Title
        #[Parameter(Mandatory=$false)][string]$AllCaps
    )
    $TitleArray = @();
    $wordCount = ([regex]::Matches($Title, " " )).count;
    for($i = 0; $i -lt $Title.Length; $i++){
        $TitleArray += $Title.substring($i,1);
    }
    $nonCapWords = 'a', 'an', 'the', 'for', 'and', 'nor', 'but', 'or', 'yet', 'so', 'at', 'around', 'by', 'after', 'along', 'for', 'from', 'of', 'on', 'to', 'with', 'without';
    $evaluatedWordsArray = @();
             $TitleArray += " ";
             $length = $TitleArray.Length;
             $newWord = '';
    for($j = 0; $j -lt $length+1; $j++)
    {
        if($TitleArray[$j] -eq " "){
            $evaluatedWordsArray += $newWord;
            $newWord = "";
            continue;
        }
        else{
        $newWord += $TitleArray[$j];
        }
    }
 $i = 0;
            foreach($word in $evaluatedWordsArray){
                if($i -eq 0 -or !($nonCapWords.Contains($word.toLower()))){
                    $word = $word.substring(0,1).toupper()+$word.substring(1).toLower();
                    $correctCaptilization += $word;
                    $i++ 
                    $correctCaptilization += " ";
                }
                else{
                $correctCaptilization += $word.toLower();
                $correctCaptilization += " ";
                }
                }
                $correctCaptilization


# Switch($num){
#     $Title{
#         $i = 0;
#             foreach($word in $evaluatedWordsArray){
#                 if($i -eq 0 -or !($nonCapWords.Contains($word.toLower()))){
#                     $word = $word.substring(0,1).toupper()+$word.substring(1).toLower();
#                     $correctCaptilization += $word;
#                     $i++ 
#                     $correctCaptilization += " ";
#                 }
#                 else{
#                 $correctCaptilization += $word.toLower();
#                 $correctCaptilization += " ";
#                 }
#                 }
#                 $correctCaptilization
#     }
#     $AllCaps{
#         $i = 0;
#             foreach($word in $evaluatedWordsArray){
#                 $word.toUpper();
#                 $correctCaptilization += $word;
#                 $correctCaptilization += " ";
#             }
#             $correctCaptilization
#     }
   
#     }
}
