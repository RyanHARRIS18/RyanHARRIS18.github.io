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

currentDateString = weekDay + ', ' + date + ' ' + month + ' ' + year;
document.getElementById('currentDate').innerHTML = currentDateString;

function toggleMenu() {
	document.getElementsByClassName("navigation")[0].classList.toggle("responsive");
}





//Get the 5 day forecast
var daysInputted = 0;
for( i=1; i<6; i++){
        document.getElementById("day"+ String(i)).innerHTML = weekDay++;
        daysInputted++;
    }
    var remaniderDays = 5 - daysInputted;  
   weekDay = 0;
    while (!(remainderDays=0)) {
        document.getElementById("day"+ String(daysInputted++)).innerHTML = weekDay; 
        weekDay++;
        remaniderDays--;
    } 
