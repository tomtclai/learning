
function Dog(name, breed, weight) {
    this.name = name;
    this.breed = breed;
    this.weight = weight;
}

Dog.prototype.species = "Canine";

Dog.prototype.bark = function() {
    if (this.weight > 25) {
        console.log(this.name + " says woof");
    } else {
        console.log(this.name + " says yip");
    }
};

Dog.prototype.sit = function() {
    console.log(this.name + " is now sitting");
};

Dog.prototype.run = function() {   
    console.log("Run!");
};

Dog.prototype.wag = function() {
    console.log("Wag!");
};

Dog.prototype.sitting = false;

Dog.prototype.sit = function() {
    if (this.sitting) {
        console.log(this.name + " is already sitting");
    } else {
        this.sitting = true;
        console.log(this.name + " is now sitting");
    }
};


// var fluffy = new Dog("Fluffy", "Poodle", 30);
// var spot = new Dog("Spot", "Chihuahua", 10);
// var dogs = [fido, fluffy, spot];

// for (var i = 0; i < dogs.length; i++) {
//     dogs[i].bark();
//     dogs[i].run();
//     dogs[i].wag();
//     console.log(dogs[i].hasOwnProperty("sitting"));
//     dogs[i].sit();
//     console.log(dogs[i].hasOwnProperty("sitting"));
//     dogs[i].sit();
//     console.log(dogs[i].hasOwnProperty("sitting"));
// }

function ShowDog(name, breed, weight, handler) {
    Dog.call(this, name, breed, weight);
    this.handler = handler;
}

ShowDog.prototype = new Dog();  //A ShowDog is a dog
ShowDog.prototype.constructor = ShowDog; //A ShowDog is also a ShowDog

ShowDog.prototype.league = "Webville";
ShowDog.prototype.stack = function() {
    console.log("Stack");
};

ShowDog.prototype.bait = function() {
    console.log("Bait");
};

ShowDog.prototype.gait = function(kind) {
    console.log(kind + "ing");
};

ShowDog.prototype.groom = function() {
    console.log("Groom");
};

//scotty.stack();
//scotty.bark();
//console.log(scotty.league);
//console.log(scotty.species);

//if (fido instanceof Dog) {
//    console.log("Fido is a Dog");
//}
//
//if (fido instanceof ShowDog) {
//    console.log("Fido is a ShowDog");
//}
//
//if (scotty instanceof Dog) {
//    console.log("Scotty is a Dog");
//}
//
//if (scotty instanceof ShowDog) {
//    console.log("Scotty is a ShowDog");
//}
//console.log("Fido constructor is " + fido.constructor);
//console.log("Scotty constructor is " + scotty.constructor);
var fido = new Dog("Fido", "Mixed", 38);
var fluffy = new Dog("Fluffy" , "Poodle", 30);
var spot = new Dog("Spot", "Chihuahua", 10);
var scotty = new ShowDog("Scotty", "Scottish Terrier", 15, "Cookie");
var beatrice = new ShowDog("Beatrice" , "Pomeranian", 5, "Hamilton");
fido.bark();
fluffy.bark();
spot.bark();
scotty.bark();
beatrice.bark();
scotty.gait("Walk");
beatrice.groom();