
const apiUrl = 'https://api.openweathermap.org/data/2.5/weather?id=5604473&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7&units=imperial';
fetch(apiUrl)
  .then(
    (response) => 
      response.json()
  )
  .then(
    (currentWeather)=>{

        console.log(currentWeather);

        let currentTemp =  currentWeather.main.temp;
        let windSpeed = curretWeather.wind.speed;
        // let high = currentWeather.;
        // let humididy = ;
        let windChill;

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
    }
);


