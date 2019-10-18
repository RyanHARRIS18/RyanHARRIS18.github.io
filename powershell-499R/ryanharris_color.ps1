function IwantToPlayAGame(){
    #1) Begin by playing Saw Audio of I wanna play a game
# initialize counters# the count of times failed# count of rounds 
    $gameTotalTime = [system.diagnostics.stopwatch]::StartNew()
    $usersName = Read-Host "What is your name?"
    $gameTable = @{
        "User Name" = $usersName;
        "Total Time (Minutes)" = [double]$gameTotalTime.Elapsed.TotalMinutes;
        "Total Rounds" = 0; # of rounds played
        "Total Guesses" = 0;
        "Total Wins" = 0;
        "Average Round Time" = 0;
    }
    $roundWin = $false # initalize round win to false
    $roundsArray = @() # create rounds array to hold the round times
    $colorsTried = @() # creates colors array to hold the guessed colors of round

    $yesAnswers = 'yes','yeah', 'ok', 'sure', 'why not','y', 'yup','true', 'yep', 'ye'
    # ask for the user input Y: enter Game N: close Poweshell
   
    $letTheGameBegin = Read-Host "Hello"  $usersName", I want to play a Game: Do you want to play? Y/N"
        # $PlayWav=New-Object System.Media.SoundPlayer
        # $PlayWav.SoundLocation=’C:\Foo\Soundfile.wav’
        # $PlayWav.playsync()

    while ($yesAnswers -contains $letTheGameBegin) {
        while($roundWin -eq $false) {

            if ($gameTable.totalRounds -gt 1) {
                $gameTable
                $continue = Read-Host $usersName ", will you guess again? Y/N" #tell user how to quit round
                if ($continue -notcontains $yesAnswers){
                    break
                }
            }
                $RoundTotalTime = [system.diagnostics.stopwatch]::StartNew()
                $SystemColors = [System.Enum]::getvalues([System.ConsoleColor])  # intialize the random color
                $randomColorInt = Get-Random -Minimum 0 -Maximum 16
                $MyTrueColor = [string]($SystemColors[$randomColorInt])
                $showMyTrueColors = [String] $SystemColors

            while ($roundWin -eq $false) {
                $showMyTrueColors

                $guess = Read-Host "What is my favorite Color?"  # ask to have user enter input
                    if ($guess -match $MyTrueColor)  {
                        $RoundTotalTime.Stop()
                        $roundWin = $true
                        $roundsArray += , $RoundTotalTime.Elapsed.TotalMinutes
                        $gameTable."Total Guesses"++ # add to count of guesses
                        $gameTable."Average Round Time" = ($roundsArray | Measure-Object -Average).average
                        $gameTable."Total Rounds"++
                        $gameTable."Total Wins"++
                       write-Host ("Correct, " + $MyTrueColor+ " is my favorite color.")  -ForegroundColor $MyTrueColor
                    }

                    else {
                        Write-Host "Incorrect, that is not my favorite color."
                        $gameTable."Total Guesses"++ # add to count of guesses
                        $colorsTried+=$guess
                        "Your guesses so Far: " + [string]$colorsTried
                        $continue = Read-Host $usersName ", will you guess again? Y/N" 
                        $hint = Read-Host "Do you need a hint? Y/N"
                        if ($yesAnswers -notcontains $continue){
                            $roundWin = $null
                            $roundsArray += , $RoundTotalTime.Elapsed.TotalMinutes
                            $gameTable."Average Round Time" = ($roundsArray | Measure-Object -Average).average
                            $gameTable."Total Rounds"++
                            $colorsTried = $null
                            break
                        }
                       
                        if ($yesAnswers -contains $hint){
                                if( $MyTrueColor.substring(0,4) -like "Dark"){
                                   Write-Host $MyTrueColor.substring(0,5)
                                }
                                else{
                                    Write-Host $MyTrueColor.substring(0,1)
                                }
                        }
                    }
           
            }
     }

    $letTheGameBegin = Read-Host "Hello"  $usersName", I want to play a Game: Do you want to play? Y/N"
    $roundWin = $false # initalize round win to false
}
        $gameTotalTime.stop()
        $gameTable
        Exit-PSSession
    } 
IwantToPlayAGame