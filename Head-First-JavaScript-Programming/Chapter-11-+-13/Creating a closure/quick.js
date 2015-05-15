function makeTimer(doneMessage, n) {
    setTimeout(function() {
        alert(doneMessage);
    }, n);
    doneMessage = "OUCH!";
}

//function handler() {
//    alert(doneMessage);
//}
//
//function makeTimer(doneMessage, n) {
//    setTimeout(handler, n);
//}


makeTimer("Cookies are done!", 1000);