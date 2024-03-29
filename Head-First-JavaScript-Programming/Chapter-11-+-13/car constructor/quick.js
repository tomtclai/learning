var cadiParams = {make: "GM",
				  model: "Cadillac",
				  year: 1955,
				  color: "tan",
				  passenger:5,
				  convertible: false,
				  mileage: 12892};

var cadi = new Car(cadiParams);

function Car(params) {
	this.make = params.make;
	this.model = params.model;
	this.year = params.year;
	this.color = params.color;
	this.passengers = params.passengers;
	this.convertible = params.convertible;
	this.mileage = params.mileage;
	this.started = false;

	this.start = function() {
		this.started = true;
	};

	this.stop = function() {
		this.started = false;
	};

	this.drive = function() {
		if (this.started) {
			alert("Zoom zoom!");
		} else {
			alert("You need to start the engine first");
		}
	}
}

if (cadi instanceof Car) {
	console.log("Congrats, it's a Car!");
};