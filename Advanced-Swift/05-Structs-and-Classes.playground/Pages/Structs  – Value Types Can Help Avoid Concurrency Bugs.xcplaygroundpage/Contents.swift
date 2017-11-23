/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Value Types Can Help Avoid Concurrency Bugs

Let's revisit the `BinaryScanner` example from the introduction of this chapter.
We had the following problematic code snippet:

``` swift-example
for _ in 0..<Int.max {
    let newScanner = BinaryScanner(data: Data("hi".utf8))
    DispatchQueue.global().async {
        scanRemainingBytes(scanner: newScanner)
    }
    scanRemainingBytes(scanner: newScanner)
}
```

If we make `BinaryScanner` a struct instead of a class, each call to
`scanRemainingBytes` gets its own independent copy of `newScanner`. Therefore,
the calls can safely keep iterating over the array without having to worry that
the struct gets mutated from a different method or thread. Since the two threads
no longer share a single `position` value, this small change fundamentally
alters the program's behavior: it'll now print each byte twice per loop
iteration.

Also keep in mind that structs don't magically make your code thread-safe. For
example, if we keep `BinaryScanner` as a struct but inline the
`scanRemainingBytes` method, we end up with the same race condition we had
before. The two `while` loops refer to the same `newScanner` variable and will
mutate it from different threads at the same time:

``` swift-example
for _ in 0..<Int.max {
    let newScanner = BinaryScanner(data: Data("hi".utf8))
    DispatchQueue.global().async {
        while let byte = newScanner.scanByte() {
          print(byte)
        }
    }
    while let byte = newScanner.scanByte() {
      print(byte)
    }
}
```

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
