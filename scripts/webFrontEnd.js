// For the Tab Functionality
function openCity(evt, cityName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
  }


  // For the Resume Navigation
  function openNav() {
    document.getElementById("myNav").style.width = "100%";
  }
  
  function closeNav() {
    document.getElementById("myNav").style.width = "0%";
  }

// 1. Vehicle Deprecation Calculator
  function vehicleDeprecation() {
    var startValue = parseFloat(document.getElementById("startValue").value);
    var endValue = parseFloat(document.getElementById("endValue").value);
    var months = parseFloat(document.getElementById("vehicleDeprecationMonthsTotal").value);
    var dv = depreciation(startValue, endValue, months);
    document.getElementById("deprecationPercent").innerHTML = dv;
  }
  function depreciation(startValue, endValue, months) {
    var d = ( startValue - endValue) / months;
    d = Math.round(d * 100) / 100 ;
    return d;
  }

// 2. Mad Lib
    function chooseNoun() {
      var nouns = ["hat", "dress", "pants", "apple", "parrot", "carrot", "jedi", "wizard", "chocolate"];
      // Get a pseudo random index
      var n = Math.floor(Math.random() * nouns.length);
      // Return one of the nouns.
      return nouns[n];
    }

    function chooseVerb(){
      var verb = ["yawn", "fight", "yell", "swim", "galavant", "fly", "meander", "sleep", "run"];
      // Get a pseudo random index
      var v = Math.floor(Math.random() * verb.length);
      // Return one of the nouns.
      return verb[v];
    }
    
    function chooseAdjective(){
      var adjective = ["yellow", "bright", "smooth", "slimy", "ugly", "rough", "cracked", "small", "large"];
      // Get a pseudo random index
      var adj = Math.floor(Math.random() * adjective.length);
      // Return one of the nouns.
      return adjective[adj];
    }
    
    function chooseAdverb(){
      var adverb = ["very", "quickly", "slowly", "silently", "loundly", "obnoxiously", "kindly", "sadly", "happily"];
      // Get a pseudo random index
      var adv = Math.floor(Math.random() * adverb.length);
      // Return one of the nouns.
      return adverb[adv];

    }

    function chooseInteger(){
      var x = 1 + Math.floor(Math.random() * 99);
      return x;
    }

    function crazyStory() {
    var story = "The man comes "
        + chooseVerb() + "ing a horse. The horse is "
        + chooseAdverb() + " " + chooseAdjective()
        + " and has no " + chooseNoun()
        + ". The saddle is " + chooseAdjective()
        + ", and the stirrups don't match. His clothing"
        + " is strange. He wears " + chooseInteger()
        + " hats and a " + chooseAdjective()
        + " shirt. One " + chooseNoun()
        + " of his pants is torn off to the knee. His sword is "
        + chooseAdjective() + " and has a broken hilt and "
        + chooseVerb() + "s from the bottom of the "
        + chooseNoun() + ".";
    document.getElementById('madLibOutput').innerHTML = story;
  } 

// 3. Math Checker
  function checkmathskills() {
    // Get patron status and number of overdue books from the user.
    var x = parseFloat(document.getElementById("x").value);
    var operator = (document.getElementById("operator").value);
    var y = parseFloat(document.getElementById("y").value);
    var ChildAnswer = parseFloat(document.getElementById("childAnswer").value);

            //compute the actual answer 
            var operator
            var realAnswer
            var message
            var ChildAnswer
            
             if ( operator == "-")  {
              (realAnswer = x - y);
             }

             else if ( operator == "+" ) {
               (realAnswer = x + y);
             }

             else if  (operator == "*" ) {
                (realAnswer = x * y);
             }

             else if  (operator == "/")  {
                (realAnswer = x / y);
             }

                
            // compare real answer to childs answer. give message
                if (realAnswer == ChildAnswer) {
                    message = "Correct! Good job.";
                }

                else { message = "Incorrect. Try again!";

                }     
           
     //display product for the user to see
      document.getElementById("mathSkillsOutput").innerHTML = message;
}

// 4. 12 Days of Christmas
  function getVerseNumber() {
    var verseNumber = parseInt(document.getElementById("verseNumber").value);
    // Call the makeVerse Function 
    var verse = makeVerse(verseNumber);
    document.getElementById("christmasOutput").innerHTML = verse; 
 }
 //defining table
 //input: verse number
 //processing: a loop that counts backwards and looks up the gifts
 //output: the text of the correxponding verse
     //Get from the user.
     function makeVerse(verseNumber) {
      //Get from the user.
         var days = ["",  "first", "second", "third", "fourth" , "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelth"
         ];
         var gifts = [  
                         "",
                         "a partridge in a pear tree",
                         "two turtle doves",
                         "three French hens",
                         "four calling birds",
                         "five golden rings",
                         "six geese a laying",
                         "seven swans a swimming",
                         "eight maids a milking",
                         "nine ladies dancing",
                         "ten lords a leaping",
                         "eleven pipers piping",
                         "twelve drummers drumming"
                         ];
     var verse = "On the " + days[verseNumber] +  " day of Christmas, My true love gave to me:" ;
     for (var i = verseNumber; i >= 1; i--){
         verse = verse + gifts[i] + ", ";
     }
     return verse; 
  }

// 5. Wage Calc
  function AfterTaxPaid() {
    // Get the Users hrs and wph.
    var hoursWorked = parseFloat(document.getElementById("hrs").value);
    var hourlyWage = parseFloat(document.getElementById("wph").value);

    // compute the slowest and fastest benificial heart rates
    var grossPay = hoursWorked * hourlyWage;
    var taxamount = grossPay * 0.15;
    var netPay = grossPay - taxamount;

    //display the net pay
    document.getElementById("netPay").innerHTML ="$" + netPay.toFixed(2);
  
}

// 6. Payment Plan Outliner
  function doPayment() {
    var i = parseFloat(document.getElementById("i").value);
    var r = parseFloat(document.getElementById("r").value);
    var n = parseFloat(document.getElementById("n").value);
    var p = parseFloat(document.getElementById("p").value);
   var answer = computePayment(i, r, n, p) 
   var answer = (Math.round( answer * 100)) / 100 ;
   document.getElementById("amountPerPayment").innerHTML = "$" + answer;
}

function computePayment( principal, r, years, periods) {
        rate  = r / periods
        periodsPerYear = (years * periods) * -1 ;
        denom = ( 1 -  Math.pow( 1 + rate, periodsPerYear))
        Payments = ( principal * rate ) / denom
    return Payments
   }
function doBalance() {
    var i = parseFloat(document.getElementById("i").value);
    var r = parseFloat(document.getElementById("r").value);
    var n = parseFloat(document.getElementById("n").value);
    var p = parseFloat(document.getElementById("p").value);
    var d = parseFloat(document.getElementById("d").value);
  //PaymentperPeriod
    var pp = computePayment(i, r, n, p) 
    var pp = (Math.round( pp * 100)) / 100 ;
   var answer = computeBalance(i, r, p, d, pp) 
   var answer = (Math.round( answer * 100)) / 100 ;
   document.getElementById("Balance").innerHTML = "$" + answer;
}
function computeBalance( i, r,  p, d, pp) {
        ratePerPeriod  = r / ( p )
        growthRate = Math.pow( 1 + ratePerPeriod, d)
        var b = (i * growthRate) - ( pp * ( growthRate - 1) ) / ( ratePerPeriod)
    return b
   }         

// 7. Future Investment Calc
function doFV() {
  var i = parseFloat(document.getElementById("iInput").value);
  var r = parseFloat(document.getElementById("rInput").value);
  var n = parseFloat(document.getElementById("nInput").value);
  var p = parseFloat(document.getElementById("pInput").value);
 var answer = computeFutureValue(i, r, n, p) 
 var answer = (Math.round( answer * 100)) / 100 ;
 document.getElementById("investmentOutput").innerHTML = "$" + answer;
}

function computeFutureValue(principal, growthRate, years, periodsPerYear) { 
  //f = a (1 + r)n
  //where f is the future value, a is the investment amount sometimes called the principal, 
  // r is the growth rate per period, and 
  //n is the total number of periods throughout the life of the investment

 var numofPeriods = years * periodsPerYear
 var rate = ( 1 + growthRate / periodsPerYear)
 var total = Math.pow(rate, numofPeriods)
 var f = principal * total

  return f
  }

  // 8. House Volume Calc
  function calcHouseVolume() {
    // Get the input from user
    var height = parseFloat(document.getElementById("height").value);
    var width = parseFloat(document.getElementById("width").value);
    var sweep = parseFloat(document.getElementById("sweep").value);
    var depth = parseFloat(document.getElementById("depth").value);

    // call function using the the arguments
    var housevol = houseVolume( width, depth, height, sweep);

    // diplay for user to see
    document.getElementById("houseVolumeOutput").innerHTML = housevol;
}

function houseVolume(width, depth, height, sweep) {

  var LVol = livingVolume( width, depth, height)

  var rVol = roofVolume( width, depth, height) 

 hVol = LVol + rVol

 return hVol
}


function livingVolume (width, depth, height) {
  var LVol = width * depth * height
  return LVol
}


function roofVolume(width, depth, sweep) {
  var triA = triangleArea (depth, sweep ,sweep) 
 rVol = triA * width
 return rVol

}


function triangleArea (a,b,c){
  var s = (a+b+c) /2 
  triArea = Math.sqrt(s * (s*a) * (s-b) * (s-c));
  return triArea ; 
}


  // 9. Check Days of Week for any Day
  function findDay() {
    // get day from the user
    var input = document.getElementById("date").value;

    //creat a date object
    var date = new Date(input);

    //get the day of the week as a number
    var dayNumber = date.getDay();

    var dayNames = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ];
    var name = dayNames[dayNumber];

    //Display dayiname for the user to see
    document.getElementById("output").innerHTML = name;
}
