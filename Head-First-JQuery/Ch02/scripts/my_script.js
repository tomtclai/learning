$(document).ready(function() {
    $(".guess_box").click(checkForCode);

    function checkForCode () {
        var discount;

        if($.contains(this, document.getElementById("has_discount")))
        {
            var my_num = getRandom(5);
            discount = "<p>Your Discount is "+my_num+"</p>";
        } else {
            discount = "<p>Sorry, no discount this time!</p>";
        }

        $(this).append(discount_msg);

        $(".guess_box").each( function() {
            $(this).unbind('click');
        });
    }
}); //end doc ready