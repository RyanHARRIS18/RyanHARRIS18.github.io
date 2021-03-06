
const request = "https://ryanharris18.github.io/cit230/lesson9/Week09/scripts/towndata.json";
fetch(request)
  .then(function (response) {
    return response.json();
  })
  .then(function (jsonObject) {
    // console.table(jsonObject);  // temporary checking for valid response and data parsing
    const towns = jsonObject['towns'];


    for (let i = 0; i < 3; i++ ) {
      let section = document.createElement('section');
      section.setAttribute('id', towns[i].name + "section");
      section.setAttribute('class', "homepage-sections");
     

     let h3 = document.createElement('h3');
      h3.textContent = towns[i].name;
      section.appendChild(h3);

      let motto  = document.createElement('p');
      motto.textContent = towns[i].motto;
      motto.setAttribute('class', "motto");
      section.appendChild(motto);

      let yearFounded  = document.createElement('p');
      yearFounded.textContent = 'Year Founded: ' + towns[i].yearFounded;
      yearFounded.setAttribute('class', "yearFounded");
      section.appendChild(yearFounded);

      let currentPopulation  = document.createElement('p');
      currentPopulation.textContent = 'Current Population: ' + towns[i].currentPopulation;
      currentPopulation.setAttribute('class', "currentPopulation");
      section.appendChild(currentPopulation);

      let averageRainfall  = document.createElement('p');
      averageRainfall.textContent = 'Average Rainfall: ' + towns[i].averageRainfall;
      averageRainfall.setAttribute('class', "averageRainfall");
      section.appendChild(averageRainfall);

      let image = document.createElement('img');
      image.setAttribute('src', towns[i].photo);
      image.setAttribute('alt', towns[i].name);
      image.setAttribute('id', towns[i].name + "Img");
      image.setAttribute('class', "homepage-images");

      section.appendChild(image);
      
      document.querySelector('div.cards').appendChild(section);


    }
  });