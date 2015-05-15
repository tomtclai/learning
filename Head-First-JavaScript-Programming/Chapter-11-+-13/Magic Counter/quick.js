function makeCounter() {
    var count = 0;

    function counter() {
        return ++count;
    }
    
    return counter;
}
var doCount = makeCounter();
console.log(doCount());
console.log(doCount());
console.log(doCount());