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



