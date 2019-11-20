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

const apiForecastUrl = 'https://api.openweathermap.org/data/2.5/forecast?id=5604473&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7&units=imperial';
fetch(apiForecastUrl)
  .then(
    (response) => 
      response.json()
  )
  .then(
    (forecasts) => {

        console.log(forecasts);

        tomorrowDate = new Date();
        tomorrowDate.setDate(tomorrowDate.getDate() + 1);
        
        //loop through results
       
                // get full year
                let currentForecastDate = 
                tomorrowDate.getFullYear()+ '-' + 

                // get month 
                (tomorrowDate.getMonth() + 1) + '-'+
                
                //get day
                tomorrowDate.getDate();

                //print to console
                console.log(currentForecastDate);
        let hourString = '10:00:00'
        

        forecast.list.foreach(
            (forecast) => {    
                if((forecast.dt_text.includes(currectForecastDate) && 
                   (forecast.dt_text.includes(hourString)) {
                    console.log(forecast.main.temp);

                }
           
        );

   