var catNames = ["Tom", "Jerry", "Paul", "Mary", "Hillary Clinton"];
var numOfCats = catNames.length;
var count = [];

$(document).ready(function () {

        for (i in catNames) {
            $('#catList').append(
                $('<li class="button">').text(catNames[i]).click(makeMainCat(i))
            );
            count[i] = 0;
        }

        function makeMainCat(i) {
            return function () {
                console.log('show cat ' + i);

                $('#catContainer').html(
                    '<div class="catBox" id="catBox' + i + '">\
                    <h2 class="catName" id="catName1">' + catNames[i] + '</h2>\
                    <h2 class="count" id="count' + i + '">' + count[i] + '</h2>\
                    <img class="catPic" id="cat' + i + '" src="cat' + i + '.jpg">\
                    </div>'
                );

                $('#cat' + i).click(createCountIncrement(i));
            }
        }







        function createCountIncrement(i) {
            return function countIncrement(e) {
                console.log(i);
                count[i]++;
                $('#count' + i).text(count[i]);
            }
        }


    })
    /*
    // code for adding all cats to container
            $('#catContainer').append(
                '<div class="catBox" id="catBox' + i + '">\
                <h2 class="catName" id="catName1">' + catNames[i] + '</h2>\
                <h2 class="count" id="count' + i + '">0</h2>\
                <img class="catPic" id="cat' + i + '" src="cat' + i + '.jpg">\
                </div>'
            );
    */
