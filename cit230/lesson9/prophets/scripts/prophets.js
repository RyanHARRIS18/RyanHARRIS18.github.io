const requestURL = 'https://byui-cit230.github.io/lessons/lesson-09/data/latter-day-prophets.json'

// fetch(requestURL)
//     .then(function (response) {
//         return response.json();
//     })

//     .then(function (jsonOBject){
//         console.table(jsonObject);
//     });


    fetch(requestURL)
    .then( response => {
        response.json()
        .then(
            response => {
                console.table(response.prophets[0]);
               let prophet =response.prophets[0];
               console.log(prophet.name)

            //    console.log(prophet["name"]);
            });
    });
