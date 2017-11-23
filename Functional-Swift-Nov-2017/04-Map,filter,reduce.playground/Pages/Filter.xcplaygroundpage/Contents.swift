/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Filter

The `map` function isn't the only function in Swift's standard array library
that uses generics. In the upcoming sections, we'll introduce a few others.

Suppose we have an array containing strings representing the contents of a
directory:

*/

let exampleFiles = ["README.md", "HelloWorld.swift", "FlappyBird.swift"]

/*:
Now suppose we want an array of all the `.swift` files. This is easy to compute
with a simple loop:

*/

func getSwiftFiles(in files: [String]) -> [String] {
    var result: [String] = []
    for file in files {
        if file.hasSuffix(".swift") {
            result.append(file)
        }
    }
    return result
}

/*:
We can now use this function to ask for the Swift files in our `exampleFiles`
array:

*/

getSwiftFiles(in: exampleFiles)

/*:
Of course, we can generalize the `getSwiftFiles` function. For instance, instead
of hardcoding the `.swift` extension, we could pass an additional `String`
argument to check against. We could then use the same function to check for
`.swift` or `.md` files. But what if we want to find all the files without a
file extension, or the files starting with the string `"Hello"`?

To perform such queries, we define a general purpose function called `filter`.
Just as we saw previously with `map`, the `filter` function takes a *function*
as an argument. This function has the type `(Element) -> Bool` — for every
element of the array, this function will determine whether or not it should be
included in the result:

*/

extension Array {
    func filter_sample_impl(_ includeElement: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where includeElement(x) {
            result.append(x)
        }
        return result
    }
}

/*:
It's easy to define `getSwiftFiles` in terms of `filter`:

*/

func getSwiftFiles2(in files: [String]) -> [String] {
    return files.filter { file in file.hasSuffix(".swift") }
}

/*:
Just like `map`, the array type already has a `filter` function defined in
Swift's standard library, so there's no need to reimplement it, other than as an
exercise.

Now you might wonder: is there an even more general purpose function that can be
used to define *both* `map` and `filter`? In the last part of this chapter,
we'll answer that question.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
