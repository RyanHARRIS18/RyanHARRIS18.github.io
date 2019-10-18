function IwantToPlayAGame(){
    #1) Begin by playing Saw Audio of I wanna play a game
# initialize counters# the count of times failed# count of rounds 
    $gameTotalTime = [system.diagnostics.stopwatch]::StartNew()
    $gameTable = @{
        "Total Time (Minutes)" = $gameTotalTime.Elapsed.TotalMinutes;
        "Total Rounds" = 0; # of rounds played
        "Total Guesses" = 0;
        "Total Wins" = 0;
        "Total Quits" = 0;
        "Average Round Time" = 0;
    }
    $coninue = "false"
    $roundsArray = @() # create rounds array to hold the round times
    $colorsTried = @() # creates colors array to hold the guessed colors of round
    $roundWin = "false" # initalize round win to false


    # ask for the user input Y: enter Game N: close Poweshell
    $letTheGameBegin = Read-Host "I want to play a Game: Do you want to play? Y/N"
        # $PlayWav=New-Object System.Media.SoundPlayer
        # $PlayWav.SoundLocation=’C:\Foo\Soundfile.wav’
        # $PlayWav.playsync()

    IF(([string]$letTheGameBegin) -eq "Yes" -or "y") {

        while($continue -eq "Yes" -or "y") {

            if ($gameTable.totalRounds -gt 1) {
                $gameTable
                $roundWin = "false"
                $continue = Read-Host "Are you ready to give up? Y/N" #tell user how to quit round
                if ($continue -like "Yes" -or "y"){
                    break
                }
            }

            while ($roundWin -eq "false") {
                $RoundTotalTime = [system.diagnostics.stopwatch]::StartNew()
                $SystemColors = [System.Enum]::getvalues([System.ConsoleColor])  # intialize the random color
                $randomColorInt = Get-Random -Minimum 0 -Maximum 16
                $MyTrueColor = $SystemColors[$randomColorInt]
                $showMyTrueColors = [String] $SystemColors
                $showMyTrueColors

                $guess = Read-Host "What is my favorite Color?"  # ask to have user enter input
                    if ($guess -like $randomColorInt) {
                        $stopwatch.Stop()
                        $roundWin = "True"
                        $roundsArray += , $RoundTotalTime.Elapsed.TotalMinutes
                        $gameTable."Total Guesses"++ # add to count of guesses
                        $gameTable."Average Round Time" = ($roundsArray | measure -Average).average
                        $gameTable."Total Rounds"++
                        $gameTable."Total Wins"++
                        "Correct, " + (Write-Host $MyTrueColor -ForegroundColor $MyTrueColor)+ " is my favorite color."
                    }

                    else {
                        Write-Host "Incorrect, that is not my favorite color."
                        $gameTable."Total Guesses"++ # add to count of guesses
                        $colorsTried+=$guess
                        [string]$colorsTried
                        $continue= Read-Host "Are you ready to give up? Y/N"
                        $hint = Read-Host "Do you need a hint? Y/N"
                            if ($continue -like "Yes" -or "y") { break}
                        if ($hint -like "Yes" -or "y"){
                                if(($MyTrueColor.substring(0,4)) -like "Dark" ){
                                    $MyTrueColor.substring(0,5)
                                }
                                else{
                                    $MyTrueColor.substring(0,4)
                                }
                        }
                    }
           
            }
    }

    else {
        Exit-PSSession
        $gameTotalTime
    }

}
}
IwantToPlayAGame