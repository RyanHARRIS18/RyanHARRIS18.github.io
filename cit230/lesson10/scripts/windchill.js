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
// var id;
// if(document.getElementById("pagetitle") = 'preston'){
//   id=5604473;
// }

// elseif(document.getElementById("pagetitle") = 'Soda-Springs'){
//   id=5604474;  //this is not the real number yet

// }
// else(){
//   id=5604475; //this is not the real number yet

// }

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
       document.getElementById("Forecast1").textContent = "Current Temperature: " + currentWeather.main.temp + " &deg;";
       document.getElementById("Forecast2").textContent = "High: " + currentWeather.main.temp_max + " &deg;";
       document.getElementById("Forecast4").textContent = "Wind Chill: " + currentWeather.main.humidity + " &deg;";
       document.getElementById("Forecast5").textContent = "Humidity: " + currentWeather.wind.speed + ' mph';
    
      if (currentTemp < 50 && windSpeed > 3) {
        let windchill = Math.round(35.74 + (0.6215 * currentTemp) - (35.75 * Math.pow(windSpeed, 0.16)) + (0.4275 * currentTemp * Math.pow(windSpeed, 0.16)));
        document.getElementById("Forecast3").innerHTML = "Wind Speed: " +  windchill + "&deg;";
      } else {
        let windchill = 0 +'&deg;'
        document.getElementById("Forecast3").innerHTML = "Wind Speed: "  + windchill;
      }

    }
  )
  

  