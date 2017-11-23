/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### `if var` and `while var`

Instead of `let`, you can use `var` with `if`, `while`, and `for`. This allows
you to mutate the variable inside the statement body:

*/

let number = "1"
if var i = Int(number) {
    i += 1
    print(i)
}

/*:
But note that `i` will be a local copy; any changes to `i` won't affect the
value inside the original optional. Optionals are value types, and unwrapping
them copies the value inside.

### Scoping of Unwrapped Optionals

Sometimes it feels limiting to only have access to an unwrapped variable within
the `if` block it has defined. For example, take the `first` property on arrays
— a property that returns an optional of the first element, or `nil` when the
array is empty. This is convenient shorthand for the following common bit of
code:

*/

let array = [1,2,3]
if !array.isEmpty {
    print(array[0])
}
// Outside the block, the compiler can't guarantee that array[0] is valid

/*:
Using the `first` property, you *have* to unwrap the optional in order to use it
— you can't accidentally forget:

*/

if let firstElement = array.first {
    print(firstElement)
}
// Outside the block, you can't use firstElement

/*:
The unwrapped value is only available inside the `if let` block. This is
impractical if the purpose of the `if` statement is to exit early from a
function when some condition isn't met. This early exit can help avoid annoying
nesting or repeated checks later on in the function. You might write the
following:

*/

func doStuff(withArray a: [Int]) {
    if a.isEmpty {
        return
    }
    // Now use a[0] or a.first! safely
}

/*:
Here, `if let` binding wouldn't work because the bound variable wouldn't be in
scope after the `if` block. But you can nevertheless be sure the array will
contain at least one element, so force-unwrapping the first element is safe,
even if the syntax is still unappealing.

One option for using an unwrapped optional outside the scope it was bound in is
to rely on Swift's deferred initialization capabilities. Consider the following
example, which reimplements part of the `pathExtension` property from `URL` and
`NSString`:

*/

extension String {
    var fileExtension: String? {
        let period: String.Index
        if let idx = index(of: ".") {
            period = idx
        } else {
            return nil
        }
        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }
}

"hello.txt".fileExtension

/*:
The compiler checks your code to confirm there are only two possible paths: one
in which the function returns early, and another where `period` is properly
initialized. There's no way `period` could be `nil` (it isn't optional) or
uninitialized (Swift won't let you use a variable that hasn't been initialized).
So after the `if` statement, the code can be written without you having to worry
about optionals at all.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
