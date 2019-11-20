const apiUrl = 'https://api.openweathermap.org/data/2.5/weather?id=5604473&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7&units=imperial';
fetch(apiUrl)
  .then(
    (response) => 
      response.json()
  )
  .then(
    (currentWeather)=>{
      console.log(currentWeather.main.temp);

     let currentTemp = (currentWeather.main.temp);
     let currentImageIcon = currentWeather.weather[0].icon;
     let currentWeatherName = currentWeather.weather[0].name;

     let currentImage = 'https://openweathermap.org/img/w/' + currentImageIcon + '.png';
      
      document.querySelector('#current-temp').textContent=currentTemp;
      document.querySelector('#imgsrc').textContent=currentImage;
      document.querySelector('WetherIcon').setAttribute('src',currentImage);
      document.querySelector('WetherIcon').setAttribute('alt',currentWeatherName)[0].main;


      
    }
  );


