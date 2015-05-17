
$(document).ready(function(){
    var v = false;
    $("button#vegOn").click(function() {
        if (v == false){
            v = true;
        }
        $f=$("li.fish").parent().parent().detach();
        $(".hamburger").replaceWith("<li class='portobello'><em>Portobello Mushroom</em></li>");


    });//end button

    $("button#restoreMe").click(function() {
        if (v == true) {
            v = false;
        }
    });//end button
});//end document ready