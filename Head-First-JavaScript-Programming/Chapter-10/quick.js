var passengers = [{ name: "Jane Doloop", paid: true, ticket: "coach"},
                  { name: "Dr. Evel", paid: true, ticket: "firstclass"},
                  { name: "Sue property", paid: false, ticket: "premium"},
                  { name: "John Funcall", paid: true, ticket: "coach"} ];

function checkNoFlyList(passenger) {
    return (passenger.name === "Dr. Evel");
}

function checkNotPaid(passenger) {
    return (passenger.paid === false);
}

function processPassengers(passengers, testFunction) {
    for (var i = 0 ; i < passengers.length; i++) {
        if (testFunction(passengers[i])) {
            return false;
        }
    }
    return true;
}

function printPassenger(passenger) {
    console.log("name: " + passenger.name + ", paid: "+ passenger.paid);
}

var allCanFly = processPassengers(passengers, checkNoFlyList);
if (!allCanFly) {
    console.log("The plan can't take off: we have a passenger on the no-fly-list. ");
}

var allPaid = processPassengers(passengers, checkNotPaid);
if (!allPaid) {
    console.log("The plane can't take off: not everyone has paid.");
}

processPassengers(passengers,printPassenger);

function createDrinkOrder(passenger) {
    var orderFunction;
    if (passenger.ticket === "firstclass") {
        orderFunction = function () {
            console.log("Would you like a cocktail or wine?");
        };
    } else if (passenger.ticket === "premium") {
        orderFunction = function() {
            console.log("Would you like wine, cola or water?");
        };
    } else {
        orderFunction = function () {
            console.log("Your choice is cola or water.");
        };
    }
    return orderFunction;
}

function createDinnerOrder(passenger) {
    var orderFunction;
    if (passenger.ticket === "firstclass") {
        orderFunction = function () {
            console.log("Would you like chicken or pasta?");
        };
    } else if (passenger.ticket ==="premium") {
        orderFunction = function () {
            console.log("Would you like a snackbox or cheese plate?");
        };
    } else {
        orderFunction = function () {
            console.log("Your choice is peanuts or pretzels")
        };
    }
    return orderFunction;
}

function serveCustomer(passenger) {
    var getDrinkOrderFunction = createDrinkOrder(passenger);
    var getDinnerOrderFunction = createDinnerOrder(passenger);
    // get drink order
    getDrinkOrderFunction(passenger);
    // get dinner order
    getDinnerOrderFunction(passenger);
    getDrinkOrderFunction(passenger);
    getDrinkOrderFunction(passenger);
    // show movie
    getDrinkOrderFunction(passenger);
    // pick trash

}
function servePassengers(passengers) {
    for (var i = 0; i < passengers.length; i++) {
        serveCustomer(passengers[i]);
    }
}

servePassengers(passengers);
