/* playlist.js */

window.onload = init;

function init() {
    var button = document.getElementById("addButton");
    button.onclick = handleButtonClick;

    loadPlaylist();
}

function handleButtonClick(e) {
    var textInput = document.getElementById("songTextInput");
    var songName = textInput.value;
    if (songName == "") {
        alert("Please enter a song");
    } else {
        alert("Adding " + songName);
    }
}
