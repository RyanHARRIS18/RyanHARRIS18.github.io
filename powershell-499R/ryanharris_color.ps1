#===================================================
# Program Name : Color
# Author: Ryan Harris
# I Ryan Harris wrote this script as original work completed by me.
# Special Feature: I ask for the users Name, I play audio to introduce the user and have background music. 
#===================================================
function IwantToPlayAGame(){
#1) Begin by playing Saw Audio of I wanna play a game
    $IE=new-object -com internetexplorer.application
    $IE.navigate2("https://www.youtube.com/watch?v=SH8wDkqA_50")
    $IE.visible=$false
    Start-Sleep -s 8
    $IE.quit()
# initialize counters# the count of times failed# count of rounds 
    $usersName = Read-Host "What is your name?"   
    $letTheGameBegin = Read-Host "Hello"  $usersName", I want to play a Game: Do you want to play? Y/N"
    $gameTotalTime = [system.diagnostics.stopwatch]::StartNew()
    $gameTable = @{
        "User Name" = $usersName;
        "Total Time (Minutes)" = $gameTotalTime.Elapsed.TotalMinutes;
        "Total Rounds" = 0; # of rounds played
        "Total Guesses" = 0;
        "Total Wins" = 0;
        "Average Round Time" = 0;
    }
    $roundWin = $false # initalize round win to false
    $roundsArray = @() # create rounds array to hold the round times
    $colorsTried = @() # creates colors array to hold the guessed colors of round
    $yesAnswers = 'yes','yeah', 'ok', 'sure', 'why not','y', 'yup','true', 'yep', 'ye' # ask for the user input Y: enter Game N: close Poweshell
   
#background Music opens in a window so user can close when they do want to hear it
        $IE=new-object -com internetexplorer.application
        $IE.navigate2("https://www.youtube.com/watch?v=EPzpqsdX26s")
        $IE.visible=$true
#this is the entire game while loop
while ($yesAnswers -contains $letTheGameBegin) {
    $RoundTotalTime = [system.diagnostics.stopwatch]::StartNew()
    $SystemColors = [System.Enum]::getvalues([System.ConsoleColor])  # intialize the random color
    $randomColorInt = Get-Random -Minimum 0 -Maximum 16
    $MyTrueColor = [string]($SystemColors[$randomColorInt])
    $showMyTrueColors = [String] $SystemColors
    $showMyTrueColors
    $stupidGuesses = $null
    $guess = Read-Host "What is my favorite Color?"  # ask to have user enter input
#this is the round while lop
    while ($roundWin -eq $false) {        
#wrong guess
        while($guess -notmatch $MyTrueColor){
            if ($SystemColors -notcontains $guess)
                    {Write-Host "Incorrect, that is not a listed  color."
                $stupidGuesses += ,$guess} # not a color
                else {
                write-Host ("Incorrect, " + $guess+ " is not my favorite color.") -ForegroundColor $guess
                $colorsTried+= , $guess}  # not correct color
                $gameTable."Total Guesses"++ # add to count of guesses

                "Your guesses so Far: " 
                for($i=0;$i -lt $colorsTried.count; $i++){
                   write-host $colorsTried[$i] -ForegroundColor $colorsTried[$i]
                }
                if($stupidGuesses -ne $null){
                    write-host  $stupidGuesses
                }

                $continue = Read-Host $usersName", will you guess again? Y/N" 
                    #user was asked to continue and they said no
                    if($yesAnswers -notcontains $continue){
                        $roundWin = $null
                        $roundsArray += , $RoundTotalTime.Elapsed.TotalMinutes
                        $gameTable."Average Round Time" = [Math]::Round((($roundsArray | Measure-Object -Average).average), 4)
                        $gameTable."Total Rounds"++
                        $colorsTried = $null
                        $stupidGuesses = $null
                        break
                    } 
                $hint = Read-Host "Do you need a hint? Y/N"
                #user was asked if they needed a hint and they said yes
                    if(($MyTrueColor.substring(0,1) -like "D") -and ($yesAnswers -contains $hint)){
                        Write-Host $MyTrueColor.substring(0,5)
                    }
                    elseif ($yesAnswers -contains $hint) {
                        Write-Host $MyTrueColor.substring(0,1)
                    }  
                $guess = Read-Host "What is my favorite Color?"  # ask to have user enter input
        }       
        #that is my color
        if ($guess -eq $MyTrueColor) {
                $RoundTotalTime.Stop()
                $roundWin = $true
                $roundsArray += , $RoundTotalTime.Elapsed.TotalMinutes
                $gameTable."Total Guesses"++ # add to count of guesses
                $gameTable."Average Round Time" = [Math]::Round((($roundsArray | Measure-Object -Average).average), 4)
                $gameTable."Total Rounds"++
                $gameTable."Total Wins"++
                write-Host ("Correct, " + $MyTrueColor+ " is my favorite color.") -ForegroundColor $MyTrueColor
                $colorsTried = $null
                $stupidGuesses = $null
                break
        }
    }
        $gameTable
        $letTheGameBegin = Read-Host "Hello"  $usersName", I want to play a Game: Do you want to play? Y/N"
        $roundWin = $false # initalize round win to false
}
#this is what happens when the user no longer wants to play
       [int]($gameTable. "Total Time (Minutes)")
        $gameTable
        # The user may have closed the window if so dont throw an error
       try{ $IE.quit() }
       catch {}
        Exit-PSSession
    }    
IwantToPlayAGame


