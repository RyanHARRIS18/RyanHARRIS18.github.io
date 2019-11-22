// // let currentTemp = 41;
// // let windSpeed = 8;
// // let high = 50;
// // let humididy = 5+"%";
// // let windChill = 0;

// // if (currentTemp < 50 && windSpeed > 3){
// // let windChill = Math.round(35.74 + (0.6215 * currentTemp) - (35.75 * Math.pow(windSpeed, 0.16)) + (0.4275 * currentTemp * Math.pow(windSpeed, 0.16)));
// // }

// document.getElementById("Forecast1").innerHTML = "Current Temperature: " + currentTemp + '&deg;';
// document.getElementById("Forecast2").innerHTML = "High: " + high;
// document.getElementById("Forecast3").innerHTML = "Wind Chill: " + windChill + '&deg;';
// document.getElementById("Forecast4").innerHTML = "Humidity: " + humididy;
// if (windChill ===0){
//     document.getElementById("Forecast5").innerHTML = "Wind Chill:  N/A";
// }
// document.getElementById("Forecast5").innerHTML = "Wind Speed: " + windSpeed + "mph";

// let townName = document.getElementById("pagetitle").innerHTML;
// var townId;
// switch (townName) {
//   case "Preston":
//     townId = "5604473";
//     break;
//   case "Soda Springs":
//     townId = "5678757";
//     break;
//   case "Fish Haven":
//     townId = "5585000";
//     break;
// }
const apiUrl = "https://api.openweathermap.org/data/2.5/forecast?id=5604473&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7&units=imperial";
fetch(apiUrl)
  .then(
    (response) => 
      response.json()
  )
  .then(
    (currentWeather)=>{
      console.log(currentWeather.main.temp);
      //local forecast
      document.querySelector("Forecast1").textContent = currentWeather.main.temp;
      document.querySelector("Forecast2").textContent = currentWeather.main.temp_max;
      document.querySelector("Forecast4").textContent = currentWeather.main.humidity;
      document.querySelector("Forecast5").textContent = currentWeather.wind.speed;
      //windchill function
      let currentTemp = parseInt(document.getElementById("Forecast1").innerHTML);
      let windSpeed = parseInt(document.getElementById("Forecast5").innerHTML);

      if (currentTemp < 50 && windSpeed > 3) {
        let windChill = Math.round(35.74 + (0.6215 * currentTemp) - (35.75 * Math.pow(windSpeed, 0.16)) + (0.4275 * currentTemp * Math.pow(windSpeed, 0.16)));
        document.getElementById("Forecast3").innerHTML = windChill;
      } else {
        windchill = 0 + '&deg;'
        document.getElementById("Forecast3").innerHTML = windChill;
      }

      document.querySelector("Forecast1").textContent += '&deg;';
      document.querySelector("Forecast2").textContent += '&deg;';
      document.querySelector("Forecast4").textContent += '&deg;';
      document.querySelector("Forecast5").textContent += 'mph';

    }
  );