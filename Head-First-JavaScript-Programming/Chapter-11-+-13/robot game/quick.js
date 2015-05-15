function Game() {
	this.level = 0;
}

Game.prototype.play = function() {
	this.level++;
	console.log("Welcome to level "+ this.level);
	this.unlock();
};

Game.prototype.unlock = function() {
	if (this.level === 42)
	{
		Robot.prototype.deployLaser = function() {
			console.log(this.name + " is blasting you with laser beams.");
		};
	}
};

function Robot(name, year, owner) {
	this.name = name;
	this.year = year;
	this.owner = owner;
}

Robot.prototype.maker = "ObjectRUs";
Robot.prototype.errorMessage = "All systems go.";
Robot.prototype.reportError  = function() {
	console.log(this.name + " says " + this.errorMessage);
};

Robot.prototype.spillWater = function() {
	this.errorMessage = "I appear to have a short circuit!";
};


var game = new Game();
var robby = new Robot("Robby", 1956, "Dr. Morbius");
var rosie = new Robot("Rosie", 1962, "George Jetson");

rosie.reportError();
robby.reportError();
robby.spillWater();
rosie.reportError();
robby.reportError();

console.log(robby.hasOwnProperty("errorMessage"));
console.log(rosie.hasOwnProperty("errorMessage"));

function SpaceRobot(name, year, owner, homePlanet) {
	this.name = name;
	this.year = year;
	this.owner = owner;
	this.homePlanet = homePlanet;
}

SpaceRobot.prototype = new Robot();

SpaceRobot.prototype.speak = function() {
	alert(this.name + " says Sir, if I may venture an opinion...");
};

SpaceRobot.prototype.pilot = function() {
	alert(this.name + " says Trusters? Are they important?");
};

var c3po = new SpaceRobot("C3PO", 1977, "Luke Skywalker", "Tatooine");
// c3po.speak();
// c3po.pilot();
console.log(c3po.name + " was made by " + c3po.maker);

var simon = new SpaceRobot("Simon", 2009, "Carla Diana", "Earth");
//simon.makeCoffee();
//simon.blinkLights();
// simon.speak();

var toy = new Robot("Toy", 2013, "Avary");
console.log(toy.toString());

Robot.prototype.toString = function() {
	return this.name + " Robot belonging to " + this.owner;
};

console.log("Robot is " + toy);