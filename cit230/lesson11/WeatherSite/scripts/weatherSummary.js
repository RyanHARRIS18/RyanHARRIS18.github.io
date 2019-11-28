var currentDate = new Date();
var currentDateString;

// get day of week
var weekDayNumber = currentDate.getDay();

var daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
];
var weekDay = daysOfWeek[weekDayNumber];


var months = [
    'Janurary',
    'Feburary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'];
var monthNumber = currentDate.getMonth();
var month = months[monthNumber];

var year = currentDate.getFullYear();
var date = currentDate.getDate();
 /* ------------------------------------------
                    Footer Date Calculation
               --------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------ */

currentDateString = weekDay + ', ' + date + ' ' + month + ' ' + year;
document.getElementById('currentDate').innerHTML = currentDateString;

function toggleMenu() {
    document.getElementsByClassName("navigation")[0].classList.toggle("responsive");
  
}

 /* ------------------------------------------------------------------------------------------------------------------------------
            ------------------------------------------
                    5 Day Forecast Script
               --------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------ */

currentDay = (currentDate.getDay())+1;
var daysInputted = 0;
for( i=1; currentDay <= 6; i++){
        var nameOfDay= daysOfWeek[currentDay++];
        var c = String(i);
        document.getElementById("day"+ c).innerHTML = nameOfDay;
        daysInputted++;
    }
    var remaniderDays = 5 - daysInputted;  
   currentDay = 0;
    while (remaniderDays > 0) {
        weekDay = daysOfWeek[currentDay]
        var c = String(++daysInputted);
        document.getElementById("day"+ c).innerHTML = weekDay; 
        currentDay++;
        remaniderDays--;
    } 


let currentTemp = 41;
let windSpeed = 8;
let high = 50;
let humididy = 5+"%";
let windChill = 0;

if (currentTemp < 50 && windSpeed > 3){
let windChill = Math.round(35.74 + (0.6215 * currentTemp) - (35.75 * Math.pow(windSpeed, 0.16)) + (0.4275 * currentTemp * Math.pow(windSpeed, 0.16)));
}

document.getElementById("Forecast1").innerHTML = "Current Temperature: " + currentTemp + '&deg;';
document.getElementById("Forecast2").innerHTML = "High: " + high;
document.getElementById("Forecast3").innerHTML = "Wind Chill: " + windChill + '&deg;';
document.getElementById("Forecast4").innerHTML = "Humidity: " + humididy;
if (windChill ===0){
    document.getElementById("Forecast5").innerHTML = "Wind Chill:  N/A";
}
document.getElementById("Forecast5").innerHTML = "Wind Speed: " + windSpeed + "mph";

