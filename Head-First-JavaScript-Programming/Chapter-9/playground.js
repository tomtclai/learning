window.onresize = resize;

function resize() {
    var element = document.getElementById("display");
    element.innerHTML = element.innerHTML + "that tickles! ";
}