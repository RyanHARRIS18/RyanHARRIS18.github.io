const templesRequest = "https://raw.githubusercontent.com/RyanHARRIS18/RyanHARRIS18.github.io/master/cit230/Templ%20Inn%20%26%20Suites/json/temples.json";
fetch(templesRequest)
  .then(function (response) {
    return response.json();
  })
  .then(function (jsonObject) {
    // console.table(jsonObject);  // temporary checking for valid response and data parsing
    const temples = jsonObject['temples'];


    for (let i = 0; i < 4; i++ ) {
      let section = document.createElement('section');
      section.setAttribute('id', temples[i].name + "section");
      section.setAttribute('class', "homepage-sections");

      let image = document.createElement('img');
      image.setAttribute('src', temples[i].photo);
      image.setAttribute('alt', temples[i].name);
      image.setAttribute('id', temples[i].name + "Img");
      image.setAttribute('class', "homepage-images");
      section.appendChild(image);
     

     let h3 = document.createElement('h3');
      h3.textContent = temples[i].name;
      section.appendChild(h3);

      let address  = document.createElement('p');
      address.textContent = temples[i].address;
      address.setAttribute('class', "address");
      section.appendChild(address);

      
      let Milestones  = document.createElement('p');
      Milestones.textContent = 'Milestones: ' + temples[i].Milestones;
      Milestones.setAttribute('class', "Milestones");
      section.appendChild(Milestones);

    

      document.querySelector('div.temple-cards').appendChild(section);
    }
  });