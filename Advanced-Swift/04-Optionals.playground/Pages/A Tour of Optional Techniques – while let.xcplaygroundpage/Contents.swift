/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### `while let`

Very similar to the `if let` statement is `while let` — a loop that only
terminates when its condition returns `nil`.

The standard library's `readLine` function returns an optional string from the
standard input. Once the end of input is reached, it returns `nil`. So to
implement a very basic equivalent of the Unix `cat` command, you use `while
let`:

``` swift-example
while let line = readLine() {
    print(line)
}
```

Similar to `if let`, you can always add a boolean clause to your optional
binding. So if you want to terminate this loop on either `EOF` or a blank line,
add a clause to detect an empty string. Note that once the condition is `false`,
the loop is terminated (you might mistakenly think the boolean condition
functions like a `filter`):

``` swift-example
while let line = readLine(), !line.isEmpty {
    print(line)
}
```

As we saw in the chapter on collection protocols, the `for x in seq` loop
requires `seq` to conform to `Sequence`. This protocol provides a `makeIterator`
method that returns an iterator, which in turn has a `next` method. `next`
returns values until the sequence is exhausted, and then it returns `nil`.
`while let` is ideal for this:

*/

let array = [1, 2, 3]
var iterator = array.makeIterator()
while let i = iterator.next() {
    print(i, terminator: " ")
}

/*:
So given that `for` loops are really just `while` loops, it's not surprising
that they also support boolean clauses, albeit with a `where` keyword:

*/

for i in 0..<10 where i % 2 == 0 {
    print(i, terminator: " ")
}

/*:
Note that the `where` clause above doesn't work like the boolean clause in a
`while` loop. In a `while` loop, iteration stops once the value is `false`,
whereas in a `for` loop, it functions like `filter`. If we rewrite the above
`for` loop using `while`, it looks like this:

*/

var iterator2 = (0..<10).makeIterator()
while let i = iterator2.next() {
    if i % 2 == 0 {
        print(i)
    }
}

/*:
This feature of `for` loops avoids a particularly strange bug with variable
capture that can occur in other languages. Consider the following code, written
in Ruby:

``` ruby
functions = []
for i in 1..3
    functions.push(lambda { i })
end
for f in functions
    print "#{f.call()} "
end
```

Ruby lambdas are like Swift's closure expressions, and as with Swift, they
capture local variables. So the above code loops from 1 to 3 — adding a closure
to the array that captures `i` — and will print out the value of `i` when
called. Then it loops over that array, calling each of the closures. What do you
think will be printed out? If you're on a Mac, you can try it out by pasting the
above into a file and running `ruby` on it from the command line.

If you run it, you'll see it prints out three 3s in a row. Even though `i` held
a different value when each closure was created, they all captured the *same*
`i` variable. And when you call them, `i` now has the value 3 — its value at the
end of the loop.

Now for a similar Swift snippet:

*/

var functions: [() -> Int] = []
for i in 1...3 {
    functions.append { i }
}
for f in functions {
    print("\(f())", terminator: " ")
}

/*:
The output: 1, 2, and 3. This makes sense when you realize `for...in` is really
`while let`. To make the correspondence even clearer, imagine there *wasn't* a
`while let`, and that you had to use an iterator without it:

*/

var functions1: [() -> Int] = []
var iterator1 = (1...3).makeIterator()
var current1: Int? = iterator1.next()
while current1 != nil {
    let i = current1!
    functions1.append { i }
    current1 = iterator1.next()
}

/*:
This makes it easy to see that `i` is a fresh local variable in every iteration,
so the closure captures the correct value even when a *new* local `i` is
declared on subsequent iterations.

By contrast, the Ruby code is more along the lines of the following:

*/

var functions2: [() -> Int] = []

do {
    var iterator2 = (1...3).makeIterator()
    var i: Int
    var current: Int? = iterator2.next()
    while current != nil {
        i = current!
        functions2.append { i }
        current = iterator2.next()
    }
}

/*:
Here, `i` is declared *outside* the loop — and reused — so every closure
captures the same `i`. If you run each of them, they'll all return 3. The `do`
is there because, despite `i` being declared outside the loop, it's still scoped
in such a way that it isn't *accessible* outside that loop — it's sandwiched in
a narrow outer shell.

> Most Swift programmers know `do` blocks as part of the `do { try … } catch { …
> }` construct used for error handling. We'll discuss this usage in the chapter
> on error handling. But `do` blocks can also be used on their own to introduce
> a new scope. Swift landed on this syntax because C's keywordless `{ … }`
> syntax is already used for closure expressions in Swift.

Python behaves like Ruby. C\# had the same behavior too — until C\# 5, when it
was decided that this behavior was dangerous enough to justify a breaking change
in order to make it work like Swift.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
