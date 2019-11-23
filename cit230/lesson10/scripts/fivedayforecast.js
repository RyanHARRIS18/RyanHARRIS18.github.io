const apiforecastURL = `https://api.openweathermap.org/data/2.5/forecast?id=5604473&units=imperial&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7`;
fetch(apiforecastURL)
    .then((response) => response.json())
    .then((forecasts) => {
        let nextDate = new Date();
        nextDate.setDate(nextDate.getDate() + 1);
        let dateString = getDateString(nextDate);
        let hourString = '18:00:00';
        let counter = 1;
        //Loop through results
        forecasts.list.forEach(
            (forecast) => {
                if (forecast.dt_txt.includes(dateString) && forecast.dt_txt.includes(hourString)) {
                    const currentImage = 'https://openweathermap.org/img/w/' + forecast.weather[0].icon + '.png';
                    document.querySelector(`#icon${counter}`).setAttribute("src", currentImage);
                    document.querySelector(`#icon${counter}`).setAttribute("alt", forecast.weather[0].description);
                    const element = document.getElementById(`temp${counter}`);
                    element.innerHTML = (forecast.main.temp) + '&deg;F';
                    counter += 1;
                    nextDate.setDate(nextDate.getDate() + 1);
                    dateString = getDateString(nextDate);
                }
            }
        );
    });

   
    
    function getDateString(date) {
        let dateString = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        return dateString;
    }
    
