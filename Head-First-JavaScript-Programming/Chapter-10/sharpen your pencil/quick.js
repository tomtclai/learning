function fun(echo) {
    console.log(echo);
};

function boo(aFunction) {
    aFunction("boo");
}

boo(fun);
console.log(fun);

fun(boo);

var moreFun = fun;

moreFun("hello again");

function echoMaker() {
    return fun;
}

var bigFun = echoMaker();
bigFun("Is there an echo?");