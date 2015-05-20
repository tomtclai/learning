
$(document).ready(function(){
    var isVegan = false;
    $("button#vegOn").click(function() {
        if (isVegan == false){
            isVegan = true;
        }
        // Detach fish
        $f=$("li.fish").parent().parent().detach();

        // Replace hamburger with Portobello
        $(".hamburger").replaceWith("<li class='portobello'><em>Portobello Mushroom</em></li>");

        // Replace various meat with tofu
        $(".meat").after("<li class='tofu'><em>Tofu</em></li>");
        $m = $(".meat").detach();
        $(".tofu").parent().parent().addClass("veg_leaf");

    });//end button

    $("button#restoreMe").click(function() {
        if (isVegan == true) {
            // Put fish back where we removed it
            $(".menu_entrees li").first().before($f);

            // Replace Portobello with hamburger
            $(".portobello").replaceWith("<li class='hamburger'>hamburger</li>");

            // Replace tofu with various meat
            //   for each li of class tofu, insert meat after it
            //   and then remove that li
            $(".tofu").each(function(i) {
                $(this).after($m[i]);
                $(this).parent().parent().removeClass("veg_leaf");
                $(this).remove();
            });
            isVegan = false;
        }

    });//end button
});//end document ready
