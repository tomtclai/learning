window.onload = init;
function init() {
    var map = document.getElementById("map");
    //set up your handler here
    map.onmousemove = showCoords;
}
    
function showCoords(eventObj) {
    var map = document.getElementById("coords");
    //get the coordinates here
    var x = eventObj.pageX;
    var y = eventObj.pageY;
    map.innerHTML = "Coordinates: "+x+ ", " + y;
}