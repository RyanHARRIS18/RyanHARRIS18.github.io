const apiForecastUrl = 'https://api.openweathermap.org/data/2.5/forecast?id=5604473&appid=62fa2f44eb8059b7d0e3a0af3aa66bf7&units=imperial';
fetch(apiForecastUrl)
  .then(
    (response) => 
      response.json()
  )
  .then(
    (forecast) => {
        let nextDate = new Date();
        nextDate.setDate(nextDate.getDate() + 1);
        let dateString = getDateString(nextDate);
        let hourString = '18:00:00'
        let counter = 1;        
        forecast.list.foreach(
            (forecast) => {    
                if((forecast.dt_text.includes(currectForecastDate)) && (forecast.dt_text.includes(hourString))){
                  
                    const element = document.getElementById(`temp ${counter}`);
                    element.innerHTML = forecast.main.temp + '&deg;';

                    counter += 1;
                    nextDate.setDate(nextDate.getDate() + 1);
                    dateString =  getDateString(nextDate);
                }
            }
        );
    }
    );


             //loop through results
       function getDateString(date){
           let dateString = 
        // get full year
     
        date.getFullYear()+ '-' + 

        // get month 
        (date.getMonth() + 1) + '-'+
        
        //get day
        date.getDate();

        return dateString;
}