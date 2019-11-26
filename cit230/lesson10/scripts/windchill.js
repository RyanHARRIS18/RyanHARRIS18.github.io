const apiUrl = "https://api.openweathermap.org/data/2.5/weather?id=5604473&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7&units=imperial";
fetch(apiUrl)
  .then(
    (response) => 
      response.json()
  )
  .then(
    (currentWeather)=>{
      console.log(currentWeather.main.temp);
     
      //windchill function
      let currentTemp = parseInt(document.getElementById("Forecast1").innerHTML);
      let windSpeed = parseInt(document.getElementById("Forecast5").innerHTML);

      
       //local forecast
       document.getElementById("Forecast1").textContent = "Current Temperature: " + currentWeather.main.temp + "°F";
       document.getElementById("Forecast2").textContent = "High: " + currentWeather.main.temp_max + '°F';
       document.getElementById("Forecast4").textContent = "Wind Chill: " + currentWeather.main.humidity + '°F';
       document.getElementById("Forecast5").textContent = "Humidity: " + currentWeather.wind.speed + ' mph';
    
      if (currentTemp < 50 && windSpeed > 3) {
        let windchill = Math.round(35.74 + (0.6215 * currentTemp) - (35.75 * Math.pow(windSpeed, 0.16)) + (0.4275 * currentTemp * Math.pow(windSpeed, 0.16)));
        document.getElementById("Forecast3").innerHTML = "Wind Speed: " +  windchill + '°F';
      } else {
        let windchill = 0;
        document.getElementById("Forecast3").innerHTML = "Wind Speed: "  + windchill + "°F";
      }

    }
  )
  

  