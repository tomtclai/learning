var catNames = ["Tom", "Jerry"];
var numOfCats = catNames.length;
var count = [];

$(document).ready(function () {

    for (i in catNames) {
        $('#catContainer').append(
            '<div class="catBox" id="catBox' + i + '">\
            <h1 class="catName" id="catName1">Cat ' + i + '</h1>\
            <h1 class="count" id="count' + i + '">0</h1>\
            <img class="catPic" id="cat' + i + '" src="cat' + i + '.jpg">\
            </div>'
        );

        count[i] = 0;

        $('#cat' + i).click(createCountIncrement(i));

        function createCountIncrement(i) {
            return function countIncrement(e) {
                console.log(i);
                count[i]++;
                $('#count' + i).text(count[i]);
            }
        }


    }

})
