
$(document).ready(function(){
    var v = false;
    $("button#vegOn").click(function() {
        if (v == false){
            v = true;
        }
        // Detach fish
        $f=$("li.fish").parent().parent().detach();

        // Replace hamburger with Porobello
        $(".hamburger").replaceWith("<li class='portobello'><em>Portobello Mushroom</em></li>");

        // Replace various meat with tofu
        $(".meat").after("<li class='tofu'><em>Tofu</em></li>");
        $m = $(".meat").detach();


    });//end button

    $("button#restoreMe").click(function() {
        if (v == true) {
            v = false;
        }
    });//end button
});//end document ready