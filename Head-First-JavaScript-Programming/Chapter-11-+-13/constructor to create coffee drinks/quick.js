function Coffee(roast, ounces) {
    this.roast = roast;
    this.ounces = ounces;
}

function toString (coffee){
    var size = "small";
    if (coffee.ounces > 10)
        size = "medium";
    else if (coffee.ounces > 14)
        size = "large";
    return "You've ordered a "
    + size + " "
    + coffee.roast 
    + " coffee.";
}