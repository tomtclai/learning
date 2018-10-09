function getSum(num1, num2) {
    return num1 + num2;
}
var mySum = function (num1, num2) {
    num1 = parseIfNeeded(num1);
    num2 = parseIfNeeded(num2);
    return num1 + num2;
};
var parseIfNeeded = function (num) {
    if (typeof num == "string") {
        return parseInt(num);
    }
    if (typeof num == "number") {
        return num;
    }
    return undefined;
};
console.log(mySum(3, 5));
function getName(firstName, lastName) {
    if (lastName == undefined) {
        return firstName;
    }
    return firstName + " " + lastName;
}
console.log(getName("John"));
function myVoid() {
    return;
}
