const templesRequest = "https://raw.githubusercontent.com/RyanHARRIS18/RyanHARRIS18.github.io/master/cit230/TempleInn%26Suites/json/temples.json";
fetch(templesRequest)
  .then(function (response) {
    return response.json();
  })
  .then(function (jsonObject) {
    // console.table(jsonObject);  // temporary checking for valid response and data parsing
    const temples = jsonObject['temples'];


    for (let i = 0; i < 4; i++ ) {
      let section = document.createElement('section');
      section.setAttribute('id', "section" + [i]);
      section.setAttribute('class', "homepage-sections");

      // let href = documnet.createElement('a');
      // href.setAttribute('href'= './' + toLowerCase(temples[i].name));

      let image = document.createElement('img');
      image.setAttribute('src', temples[i].photo);
      image.setAttribute('alt', temples[i].name);
      image.setAttribute('id', temples[i].name + "Img");
      image.setAttribute('class', "homepage-images");
      section.appendChild(image);
     

     let h3 = document.createElement('h3');
      h3.textContent = temples[i].name;
      h3.setAttribute('class', "temples-headers");
      section.appendChild(h3);

      let h4 = document.createElement('h4');
      h4.textContent = 'Address';
      h4.setAttribute('class', "temples-headers");
      section.appendChild(h4);

      let address  = document.createElement('p');
      address.textContent = temples[i].address;
      address.setAttribute('class', "temples-p");
      section.appendChild(address);

      let h42 = document.createElement('h4');
      h42.textContent = 'Milestones';
      h42.setAttribute('class', "temples-headers");
      section.appendChild(h42);
      
      let Milestones  = document.createElement('p');
      Milestones.textContent = temples[i].Milestones;
      Milestones.setAttribute('class', "temples-p");
      section.appendChild(Milestones);

      // let link  = document.createElement('a');
      // link.textContent = 'Dedicatory Prayer';
      // link.href = temples[i].Milestone-Prayer;
      // section.appendChild(link);

      document.querySelector('div.temple-cards').appendChild(section);
    }
  });