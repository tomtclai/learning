function makePassword(password) {
    var password = password;
    return function(passwordGuess) {
        return (passwordGuess === password);
    };
}

var passwordCheck = makePassword("abcd");

console.log(passwordCheck("abd"));
console.log(passwordCheck("abcd"));

function multN(n) {
    var n = n;
    return function (m) {
        return n*m;
    };
};

var mult2 = multN(2);

console.log(mult2(1));
console.log(mult2(2));
console.log(mult2(3));
console.log(mult2(4));
console.log(mult2(5));
