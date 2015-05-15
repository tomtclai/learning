window.onload = function() {
    var button = document.getElementById("bake");
    button.onclick = function () {
        console.log("Time to bake the cookies.");
        cookies.bake(2500);
    };
};

var cookies = {
    instructions: "Preheat oven to 350...",
    bake: function(time) {
        console.log("Baking the cookies.");
        setTimeout(function() {
            alert("Cookies are cool, time to eat!");
        }, time);
    }
};