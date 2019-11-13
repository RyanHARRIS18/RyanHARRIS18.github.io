const requestURL = 'https://byui-cit230.github.io/weather/data/towndata.json';
fetch(requestURL)
  .then(function (response) {
    return response.json();
  })
  .then(function (jsonObject) {
    // console.table(jsonObject);  // temporary checking for valid response and data parsing
    const towns = jsonObject['towns'];


    for (let i = 0; i < towns.length; i++ ) {
      let card = document.createElement('section');
      let h2 = document.createElement('h2');
      h2.textContent = towns[i].name;
      card.appendChild(h2);

      let motto  = document.createElement('p');
      motto.textContent = towns[i].motto;
      card.appendChild(motto);

      let yearFounded  = document.createElement('p');
      yearFounded.textContent = 'Year Founded: ' + towns[i].yearFounded;
      card.appendChild(yearFounded);

      let image = document.createElement('img');
      image.setAttribute('src', towns[i].photo);
      image.setAttribute('alt', towns[i].name);
      card.appendChild(image);

      document.querySelector('div.cards').appendChild(card);

    }
  });