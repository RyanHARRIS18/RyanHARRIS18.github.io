
var i;
// rome italy
if (document.getElementById("cityID").value === '6542288') {
    makeCard(3);
    makePriceCard(3);
    makeGallery(3);
}
else if (document.getElementById("cityID").value === '5577147') {
    makeCard(2);
    makePriceCard(2);
    makeGallery(2);
}
else if (document.getElementById("cityID").value === '5391811') {
    makeCard(1);
    makePriceCard(1);
    makeGallery(1);
}
else if(document.getElementById("cityID").value === '5780993') {
    makeCard(0);
    makePriceCard(0);
    makeGallery(0);
}

function makeCard(cardNumber){
  var x;
const templesRequest = "https://raw.githubusercontent.com/RyanHARRIS18/RyanHARRIS18.github.io/master/cit230/TempleInn%26Suites/json/temples.json";
fetch(templesRequest)
  .then(function (response) {
    return response.json();
  })
  .then(function (jsonObject) {
    console.table(jsonObject);  // temporary checking for valid response and data parsing
    //make temp information
    const temples = jsonObject['temples'];

      let section = document.createElement('section');
      section.setAttribute('id', "section" + [cardNumber]);
      section.setAttribute('class', "temple-page-information");


      let image = document.createElement('img');
      image.setAttribute('src', temples[cardNumber].photo);
      image.setAttribute('alt', temples[cardNumber].name);
      image.setAttribute('id', temples[cardNumber].name + "Img");
      image.setAttribute('class', "homepage-images");
      section.appendChild(image);
     

     let h3 = document.createElement('h3');
      h3.textContent = temples[cardNumber].name;
      h3.setAttribute('class', "temples-headers");
      section.appendChild(h3);

      let h4 = document.createElement('h4');
      h4.textContent = 'Address';
      h4.setAttribute('class', "temples-headers");
      section.appendChild(h4);

      let address  = document.createElement('p');
      address.textContent = temples[cardNumber].address;
      address.setAttribute('class', "temples-p");
      section.appendChild(address);

      let h42 = document.createElement('h4');
      h42.textContent = 'Milestones';
      h42.setAttribute('class', "temples-headers");
      section.appendChild(h42);
      
      let Milestones  = document.createElement('p');
      Milestones.textContent = temples[cardNumber].Milestones;
      Milestones.setAttribute('class', "temples-p");
      section.appendChild(Milestones);

      let h43 = document.createElement('h4');
      h43.textContent = 'Services';
      h43.setAttribute('class', "temples-headers");
      section.appendChild(h43);
     
      //add the services
      for (let i = 0; i < 4; i++ ) {
      let Services  = document.createElement('p');
      Services.textContent = temples[cardNumber].Services[i];
      Services.setAttribute('class', "temples-p");
      section.appendChild(Services);
      }


      document.querySelector('section.temple-cards').appendChild(section);

             
      //closure cards
      for (let i = 0; i < (temples.closures.length); i++ ) {
        let closureSection = document.createElement('section');
        closureSection.setAttribute('id', "section" + [cardNumber]);
        closureSection.setAttribute('class', "temple-page-information");
  
        let address  = document.createElement('p');
        address.textContent = temples[cardNumber].closures[i];
        address.setAttribute('class', "temples-p");
        closureSection.appendChild(address);
        document.querySelector('section.closure-cards').appendChild(section);
        }

//hotel images card
      const hotelRequest = "https://raw.githubusercontent.com/RyanHARRIS18/RyanHARRIS18.github.io/master/cit230/TempleInn%26Suites/json/price.json";
      fetch(hotelRequest)
      .then(function (response) {
        return response.json();
      })
      .then(function (jsonObject) {
        console.table(jsonObject);  // temporary checking for valid response and data parsing
        const hotel = jsonObject['pricing'];

    
        let hotelImageSection = document.createElement('section');
        hotelImageSection.setAttribute('id', "hoteImageSection"+[cardNumber]);
        hotelImageSection.setAttribute('class', "hotel-image-sections");

        
        let image = document.createElement('img');
        image.setAttribute('src', hotel[cardNumber].hotelPhoto);
        image.setAttribute('alt', hotel[cardNumber].name + "hotel image");
        image.setAttribute('id', 'hotelImage' + [cardNumber]);
        image.setAttribute('class', "hotel-images");
        hotelImageSection.appendChild(image);
        
        let info  = document.createElement('p');
        info.textContent = hotel[cardNumber].hotelDescription;
        info.setAttribute('class', "hotels-info-p");
        hotelImageSection.appendChild(info);

        document.querySelector('section.hotel-images-holder').appendChild(hotelImageSection);
      });
  
  });
}

function makePriceCard(cardNumber){
const priceRequest = "https://raw.githubusercontent.com/RyanHARRIS18/RyanHARRIS18.github.io/master/cit230/TempleInn%26Suites/json/price.json";
fetch(priceRequest)
.then(function (response) {
  return response.json();
})
.then(function (jsonObject) {
  console.table(jsonObject);  // temporary checking for valid response and data parsing
  const pricing = jsonObject['pricing'];

  var j = 0;
  
   for (i in pricing)  {
    let section = document.createElement('section');
    section.setAttribute('id', "pricingSection"+[j]);
    section.setAttribute('class', "temples-pages-sections");

    let h3 = document.createElement('h3');
    h3.textContent = (pricing[cardNumber].roomType[j]);
    h3.setAttribute('class', "temples-pages-headers");
    section.appendChild(h3);
    
    let image = document.createElement('img');
    image.setAttribute('src', pricing[cardNumber].roomTypePhoto[j]);
    image.setAttribute('alt', pricing[cardNumber].roomType[i]);
    image.setAttribute('id', 'roomType' +[i]);
    image.setAttribute('class', "temples-pages-images");
    section.appendChild(image);
    
    let h4 = document.createElement('h4');
    h4.textContent = 'Pricing: ' + pricing[cardNumber].price[i];
    h4.setAttribute('class', "temples-pages-headers");
    section.appendChild(h4);

    document.querySelector('section.hotel-Card-Holder').appendChild(section);
    j++;

    }
})
}

function makeGallery(cardNumber){
  const galleryRequest = "https://raw.githubusercontent.com/RyanHARRIS18/RyanHARRIS18.github.io/master/cit230/TempleInn%26Suites/json/gallery.json";
  fetch(galleryRequest)
  .then(function (response) {
    return response.json();
  })
  .then(function (jsonObject) {
    console.table(jsonObject);  // temporary checking for valid response and data parsing
    var gallery = jsonObject['gallery'];
    var j = 0;
     for (i in gallery)  {
      let section = document.createElement('section');
      section.setAttribute('id', "gallerySection"+[j]);
      section.setAttribute('class', "gallery-pages-sections");
  
      let image = document.createElement('img');
      image.setAttribute('src', gallery[cardNumber].gallery[j]);
      image.setAttribute('alt', 'Gallery Image of' + gallery[cardNumber].name + [j]);
      image.setAttribute('id', 'gallery' +[j]);
      image.setAttribute('class', "gallery-images");
      section.appendChild(image);
       
      document.querySelector('section.gallery-Card-Holder').appendChild(section);
      j++;
  
      }
  })
  }