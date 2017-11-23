/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Flexibility through Functions 

In the built-in collections chapter, we talked about parameterizing behavior by
passing functions as arguments. Let's look at another example of this: sorting.

Sorting a collection in Swift is simple:

*/

let myArray = [3, 1, 2]
myArray.sorted()

/*:
There are really four sort methods: the non-mutating variant `sorted(by:)`, and
the mutating `sort(by:)`, times two for the versions that default to sorting
comparable things in ascending order and take no arguments. For the most common
case, `sorted()` is all you need. And if you want to sort in a different order,
just supply a function:

*/

myArray.sorted(by: >)

/*:
You can also supply a function if your elements don't conform to `Comparable`
but *do* have a `<` operator, like tuples:

*/

var numberStrings = [(2, "two"), (1, "one"), (3, "three")]
numberStrings.sort(by: <)
numberStrings

/*:
Or, you can supply a more complicated function if you want to sort by some
arbitrary criteria:

*/

let animals = ["elephant", "zebra", "dog"]
animals.sorted { lhs, rhs in
    let l = lhs.reversed()
    let r = rhs.reversed()
    return l.lexicographicallyPrecedes(r)
}

/*:
It's this last ability — the ability to use any comparison function to sort a
collection — that makes the Swift sort so powerful.

Contrast this with the way sorting works in Objective-C. If you want to sort an
array using Foundation, you're met with a long list of different options: there
are sort methods that take a selector, block, or function pointer as a
comparison predicate, or you can pass in an array of sort descriptors. All of
these provide a lot of flexibility and power, but at the cost of complexity —
there isn't an option to "just do a regular sort based on the default ordering."
Some variants in Foundation, like the method that takes a block as a comparison
predicate, are essentially the same as Swift's `sorted(by:)` method; others,
like the version that takes an array of sort descriptors, make great use of
Objective-C's dynamic nature to arrive at a very flexible and powerful (if
weakly typed) API that can't be ported to Swift directly.

Support for selectors and dynamic dispatch is still there in Swift, but the
Swift standard library favors a more function-based approach instead. In this
section, we'll demonstrate how functions as arguments and treating functions as
data can be used to replicate the same functionality in a fully type-safe
manner. Let's look at a complex example inspired by the [Sort Descriptor
Programming
Topics](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/SortDescriptors/Articles/Creating.html)
guide in Apple's documentation.

We'll start by defining a `Person` type. Because we want to show how
Objective-C's powerful runtime system works, we'll have to make this object an
`NSObject` subclass (in pure Swift, a struct might have been a better choice).
We also annotate the class with `@objcMembers` to make all members visible to
Objective-C:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
@objcMembers
final class Person: NSObject {
    let first: String
    let last: String
    let yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }
}

// --- (Hidden code block) ---
extension Person {
    override var description: String {
        return "\(first) \(last) (\(yearOfBirth))"
    }
}
// ---------------------------
/*:
Let's also define an array of people with different names and birth years:

*/

let people = [
    Person(first: "Emily", last: "Young", yearOfBirth: 2002),
    Person(first: "David", last: "Gray", yearOfBirth: 1991),
    Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
    Person(first: "Ava", last: "Barnes", yearOfBirth: 2000),
    Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
    Person(first: "Ava", last: "Barnes", yearOfBirth: 1998),
]

/*:
We want to sort this array first by last name, then by first name, and finally
by birth year. The ordering should respect the user's locale settings. An
`NSSortDescriptor` object describes how to order objects, and we can use them to
express the individual sorting criteria (using `localizedStandardCompare` as the
locale-conforming comparator method):

*/

let lastDescriptor = NSSortDescriptor(key: #keyPath(Person.last), 
    ascending: true,
    selector: #selector(NSString.localizedStandardCompare(_:)))
let firstDescriptor = NSSortDescriptor(key: #keyPath(Person.first), 
    ascending: true,
    selector: #selector(NSString.localizedStandardCompare(_:)))
let yearDescriptor = NSSortDescriptor(key: #keyPath(Person.yearOfBirth), 
    ascending: true)

/*:
To sort the array, we can use the `sortedArray(using:)` method on `NSArray`.
This takes a list of sort descriptors. To determine the order of two elements,
it starts by using the first sort descriptor and uses that result. However, if
two elements are equal according to the first descriptor, it uses the second
descriptor, and so on:

*/

let descriptors = [lastDescriptor, firstDescriptor, yearDescriptor]
(people as NSArray).sortedArray(using: descriptors)

/*:
A sort descriptor uses two runtime features of Objective-C: first, the `key` is
an Objective-C key path, which is really just a string containing a chained list
of property names. Don't confuse these with Swift's native (and strongly typed)
key paths that were introduced in Swift 4. We'll have more to say about the
latter below.

The second Objective-C runtime feature is [key-value
coding](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html),
which looks up the value of that key at runtime. The `selector` parameter takes
a selector (which also is really just a string describing a method name). At
runtime, the selector is used to look up a comparison function, and when
comparing two objects, the values for the key are compared using that comparison
function.

This is a pretty cool use of runtime programming, especially when you realize
the array of sort descriptors can be built at runtime, based on, say, a user
clicking a column heading.

How can we replicate this functionality using Swift's `sort`? It's simple to
replicate *parts* of the sort — for example, if you want to sort an array using
`localizedStandardCompare`:

*/

var strings = ["Hello", "hallo", "Hallo", "hello"]
strings.sort { $0.localizedStandardCompare($1) == .orderedAscending }
strings

/*:
If you want to sort using just a single property of an object, that's also
simple:

*/

people.sorted { $0.yearOfBirth < $1.yearOfBirth }

/*:
This approach doesn't work so great when optional properties are combined with
methods like `localizedStandardCompare`, though — it gets ugly fast. For
example, consider sorting an array of filenames by file extension (using the
`fileExtension` property from the optionals chapter):

*/

// --- (Hidden code block) ---
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
// ---------------------------
var files = ["one", "file.h", "file.c", "test.h"]
files.sort { l, r in r.fileExtension.flatMap { 
    l.fileExtension?.localizedStandardCompare($0) 
} == .orderedAscending }
files

/*:
This is quite ugly. Later on, we'll make it easier to use optionals when
sorting. However, for now, we haven't even tried sorting by multiple properties.
To sort by last name and then first name, we can use the standard library's
`lexicographicallyPrecedes` method. This takes two sequences and performs a
phonebook-style comparison by moving through each pair of elements until it
finds one that isn't equal. So we can build two arrays of the elements and use
`lexicographicallyPrecedes` to compare them. This method also takes a function
to perform the comparison, so we'll put our use of `localizedStandardCompare` in
the function:

*/

people.sorted { p0, p1 in
    let left =  [p0.last, p0.first]
    let right = [p1.last, p1.first]
    return left.lexicographicallyPrecedes(right) {
        $0.localizedStandardCompare($1) == .orderedAscending
    }
}

/*:
At this point, we've almost replicated the functionality of the original sort in
roughly the same number of lines. But there's still a lot of room for
improvement: the building of arrays on every comparison is very inefficient, the
comparison is hardcoded, and we can't really sort by `yearOfBirth` using this
approach.

### Functions as Data

Rather than writing an even more complicated function that we can use to sort,
let's take a step back. So far, the sort descriptors were much clearer, but they
use runtime programming. The functions we wrote don't use runtime programming,
but they're not so easy to write (and read).

A sort descriptor is a way of describing the ordering of objects. Instead of
storing that information as a class, we can define a function to describe the
ordering of objects. The simplest possible definition takes two objects and
returns `true` if they're ordered correctly. This is also exactly the type that
the standard library's `sort(by:)` and `sorted(by:)` methods take as an
argument. Let's define a generic type alias to describe sort descriptors:

*/

/// A sorting predicate that returns `true` iff the first
/// value should be ordered before the second.
typealias SortDescriptor<Value> = (Value, Value) -> Bool

/*:
As an example, we could define a sort descriptor that compares two `Person`
objects by year of birth, or a sort descriptor that sorts by last name:

*/

let sortByYear: SortDescriptor<Person> = { $0.yearOfBirth < $1.yearOfBirth }
let sortByLastName: SortDescriptor<Person> = { 
    $0.last.localizedStandardCompare($1.last) == .orderedAscending 
}

/*:
Rather than writing the sort descriptors by hand, we can write a function that
generates them. It's not nice that we have to write the same property twice: in
`sortByLastName`, we could have easily made a mistake and accidentally compared
`$0.last` with `$1.first`. Also, it's tedious to write these sort descriptors;
to sort by first name, it's probably easiest to copy and paste the
`sortByLastName` definition and modify it.

Instead of copying and pasting, we can define a function with an interface
that's a lot like `NSSortDescriptor`, but without the runtime programming. This
function takes a key and a comparison function, and it returns a sort descriptor
(the function, not the class `NSSortDescriptor`). Here, `key` isn't a string,
but is itself a function; given an element of the array that's being sorted, it
returns the value of the property this sort descriptor is dealing with. The
`areInIncreasingOrder` function is then used to compare two keys. Finally, the
return type is a function as well, even though this fact is slightly obscured by
the type alias:

*/

/// Builds a `SortDescriptor` function from a sorting predicate
/// and a `key` function which, given a value to compare, produces
/// the value that should be used by the sorting predicate.
func sortDescriptor<Value, Key>(
    key: @escaping (Value) -> Key,
    by areInIncreasingOrder: @escaping (Key, Key) -> Bool) 
    -> SortDescriptor<Value>
{
    return { areInIncreasingOrder(key($0), key($1)) }
}

/*:
> The `key` function describes how to drill down into a value and extract the
> information that is relevant for one particular sorting step. It has a lot in
> common with Swift's native key paths that were introduced in Swift 4. We'll
> discuss how to rewrite this with Swift key paths below.

This allows us to define `sortByYear` in a different way:

*/

let sortByYearAlt: SortDescriptor<Person> = 
    sortDescriptor(key: { $0.yearOfBirth }, by: <)
people.sorted(by: sortByYearAlt)

/*:
We can even define an overloaded variant that works for all `Comparable` types:

*/

func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key)
    -> SortDescriptor<Value> where Key: Comparable
{
    return { key($0) < key($1) }
}
let sortByYearAlt2: SortDescriptor<Person> = 
    sortDescriptor(key: { $0.yearOfBirth })

/*:
Both `sortDescriptor` variants above work with functions that return a boolean
value, because that's the standard library's convention for comparison
predicates. Foundation APIs like `localizedStandardCompare`, on the other hand,
expect a three-way `ComparisonResult` value instead (ordered ascending,
descending, or equal). It's possible the standard library will [adopt this
approach in the
future](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170410/035659.html).
Adding support for this is easy as well:

*/

func sortDescriptor<Value, Key>(
    key: @escaping (Value) -> Key,
    ascending: Bool = true,
    by comparator: @escaping (Key) -> (Key) -> ComparisonResult)
    -> SortDescriptor<Value>
{
    return { lhs, rhs in
        let order: ComparisonResult = ascending 
            ? .orderedAscending 
            : .orderedDescending
        return comparator(key(lhs))(key(rhs)) == order
    }
}

/*:
This allows us to write `sortByFirstName` in a much shorter and clearer way:

*/

let sortByFirstName: SortDescriptor<Person> = 
    sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)
people.sorted(by: sortByFirstName)

/*:
This `SortDescriptor` is just as expressive as its `NSSortDescriptor` variant,
but it's type safe, and it doesn't rely on runtime programming.

Currently, we can only use a single `SortDescriptor` function to sort arrays. If
you recall, we used the `NSArray.sortedArray(using:)` method to sort an array
with more than one comparison operator. We could easily add a similar method to
`Array`, or even to the `Sequence` protocol. However, we'd have to add it twice:
once for the mutating variant, and once for the non-mutating variant of `sort`.

We take a different approach so that we don't have to write more extensions.
Instead, we write a function that combines multiple sort descriptors into a
single sort descriptor. It works just like the `sortedArray(using:)` method:
first it tries the first descriptor and uses that comparison result. However, if
the result is equal, it uses the second descriptor, and so on, until we run out
of descriptors:

*/

func combine<Value>
    (sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
    return { lhs, rhs in
        for areInIncreasingOrder in sortDescriptors {
            if areInIncreasingOrder(lhs, rhs) { return true }
            if areInIncreasingOrder(rhs, lhs) { return false }
        }
        return false
    }
}

/*:
We can now finally replicate the initial example:

*/

let combined: SortDescriptor<Person> = combine(
    sortDescriptors: [sortByLastName, sortByFirstName, sortByYear]
)
people.sorted(by: combined)

/*:
We ended up with the same behavior and functionality as the Foundation version,
but our solution is safer and a lot more idiomatic in Swift. Because the Swift
version doesn't rely on runtime programming, the compiler can also optimize it
much better. Additionally, we can use it with structs or non-Objective-C
objects.

One drawback of the function-based approach is that functions are opaque. We can
take an `NSSortDescriptor` and print it to the console, and we get some
information about the sort descriptor: the key path, the selector name, and the
sort order. Our function-based approach can't do this. If it's important to have
that information, we could wrap the functions in a struct or class and store
additional debug information.

This approach of using functions as data — storing them in arrays and building
those arrays at runtime — opens up a new level of dynamic behavior, and it's one
way in which a statically typed compile-time-oriented language like Swift can
still replicate some of the dynamic behavior of languages like Objective-C or
Ruby.

We also saw the usefulness of writing functions that combine other functions,
which is one of the building blocks of functional programming. For example, our
`combine(sortDescriptors:)` function took an array of sort descriptors and
combined them into a single sort descriptor. This is a very powerful technique
with many different applications.

Alternatively, we could even have written a custom operator to combine two sort
functions:

*/

infix operator <||> : LogicalDisjunctionPrecedence
func <||><A>(lhs: @escaping (A,A) -> Bool, rhs: @escaping (A,A) -> Bool)
    -> (A,A) -> Bool 
{
    return { x, y in
        if lhs(x, y) { return true }
        if lhs(y, x) { return false }
        // Otherwise they're the same, so we check for the second condition
        if rhs(x, y) { return true }
        return false
    }
}

/*:
Most of the time, writing a custom operator is a bad idea. Custom operators are
often harder to read than functions are, because the name isn't explicit.
However, they can be very powerful when used sparingly. The operator above
allows us to rewrite our combined sort example, like so:

*/

let combinedAlt = sortByLastName <||> sortByFirstName <||> sortByYear
people.sorted(by: combinedAlt)

/*:
This reads very clearly and perhaps also expresses the code's intent more
succinctly than the alternative, but *only after* you (and every other reader of
the code) have ingrained the meaning of the operator. We prefer the
`combine(sortDescriptors:)` function over the custom operator. It's clearer at
the call site and ultimately makes the code more readable. Unless you're writing
highly domain-specific code, a custom operator is probably overkill.

The Foundation version still has one functional advantage over our version: it
can deal with optionals without having to write any more code. For example, if
we'd make the `last` property on `Person` an optional string, we wouldn't have
to change anything in the sorting code that uses `NSSortDescriptor`.

The function-based version requires some extra code. You can probably guess what
comes next: once again, we write a function that takes a function and returns a
function. We can take a regular comparison function such as
`localizedStandardCompare`, which works on two strings, and turn it into a
function that takes two optional strings. If both values are `nil`, they're
equal. If the left-hand side is `nil`, but the right-hand side isn't, they're
ascending, and the other way around. Finally, if they're both non-`nil`, we can
use the `compare` function to compare them:

*/

func lift<A>(_ compare: @escaping (A) -> (A) -> ComparisonResult) -> (A?) -> (A?)
    -> ComparisonResult 
{
    return { lhs in { rhs in
        switch (lhs, rhs) {
        case (nil, nil): return .orderedSame
        case (nil, _): return .orderedAscending
        case (_, nil): return .orderedDescending
        case let (l?, r?): return compare(l)(r)
        }
    } }
}

/*:
This allows us to "lift" a regular comparison function into the domain of
optionals, and it can be used together with our `sortDescriptor` function. If
you recall the `files` array from before, sorting it by `fileExtension` got
really ugly because we had to deal with optionals. However, with our new `lift`
function, it's very clean again:

*/

let compare = lift(String.localizedStandardCompare)
let result = files.sorted(by: sortDescriptor(key: { $0.fileExtension },
    by: compare))
result

/*:
> We can write a similar version of `lift` for functions that return a `Bool`.
> As we saw in the optionals chapter, the standard library no longer provides
> comparison operators like `>` for optionals. They were removed because using
> them can lead to surprising results if you're not careful. A boolean variant
> of `lift` allows you to easily take an existing operator and make it work for
> optionals when you need the functionality.

This approach has also given us a clean separation between the sorting method
and the comparison method. [The algorithm that Swift's sort
uses](https://github.com/apple/swift/blob/swift-4.0-branch/stdlib/public/core/Sort.swift.gyb)
is a hybrid of multiple sorting algorithms — as of this writing, it's an
[introsort](https://en.wikipedia.org/wiki/Introsort) (which is itself a hybrid
of a quicksort and a heapsort), but it switches to an [insertion
sort](https://en.wikipedia.org/wiki/Insertion_sort) for small collections to
avoid the upfront startup cost of the more complex sort algorithms.

Introsort isn't a
"[stable](https://en.wikipedia.org/wiki/Category:Stable_sorts)" sort. That is,
it doesn't necessarily maintain relative ordering of values that are otherwise
equal according to the comparison function. But if you implemented a stable
sort, the separation of the sort method from the comparison would allow you to
swap it in easily:

``` swift-example
people.stablySorted(by: combine(
    sortDescriptors: [sortByLastName, sortByFirstName, sortByYear]
))
```

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
