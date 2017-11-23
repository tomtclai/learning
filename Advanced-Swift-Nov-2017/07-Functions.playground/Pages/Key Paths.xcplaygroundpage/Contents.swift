/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Key Paths

Swift 4 added the concept of *key paths* to the language. A key path is an
uninvoked reference to a property, analogous to an unapplied method reference.
Key paths close a fairly big hole in Swift's type system; previously, it wasn't
possible to refer to a type's property, such as `String.count`, in the same way
you could refer to a method, such as `String.uppercased`. Despite sharing the
same name, Swift's key paths are quite different from the key paths used in
Objective-C and Foundation. We'll have more to say about this later.

Key path expressions start with a backslash, e.g. `\String.count`. The backslash
is necessary to distinguish a key path from a type property of the same name
that may exist (suppose that `String` also had a `static count` property — then
`String.count` would return the value of that property). Type inference works in
key path expressions too: you can omit the type name if the compiler can infer
it from the context, leaving `\.count`.

> Given that key paths and function type references are so closely related, it's
> unfortunate that Swift has different syntaxes for the two. Even so, the Swift
> team has expressed interest in adopting the backslash syntax for function type
> references in a future release.

As the name suggests, a key path describes a *path* through a value hierarchy,
starting at the root value. For example, given the following `Person` and
`Address` types, `\Person.address.street` is a key path that resolves a person's
street address:

*/

struct Address {
    var street: String
    var city: String
    var zipCode: Int
}

struct Person {
    let name: String
    var address: Address
}

let streetKeyPath = \Person.address.street // WritableKeyPath<Person, String>
let nameKeyPath = \Person.name // KeyPath<Person, String>


/*:
Key paths can be composed of any combination of stored and computed properties,
along with optional chaining operators. The compiler automatically generates a
new `[keyPath:]` subscript for all types. You use this subscript to "invoke" the
key path, i.e. to access the property described by it on a given instance. So
`"Hello"[keyPath: \.count]` is equivalent to `"Hello".count`. Or, for our
current example:

*/

let simpsonResidence = Address(street: "1094 Evergreen Terrace", 
    city: "Springfield", zipCode: 97475)
var lisa = Person(name: "Lisa Simpson", address: simpsonResidence)
lisa[keyPath: nameKeyPath]

/*:
If you look at the types of our two key path variables above, you'll notice that
the type of `nameKeyPath` is `KeyPath<Person, String>` (i.e. a strongly typed
key path that can be applied to a `Person` and yields a `String`), whereas
`streetKeyPath`'s type is `WritableKeyPath`. Because all properties that form
this latter key path are mutable, the key path itself allows mutation of the
underlying value:

*/

lisa[keyPath: streetKeyPath] = "742 Evergreen Terrace"

/*:
Doing the same with `nameKeyPath` would produce an error because the underlying
property isn't mutable.

### Key Paths Can Be Modeled with Functions

A key path that maps from a base type `Root` to a property of type `Value` is
very similar to a function of type `(Root) -> Value` — or, for writable key
paths, a *pair* of functions for both getting and setting a value. The major
benefit key paths have over such functions (aside from the syntax) is that they
are *values*. You can test key paths for equality and use them as dictionary
keys (they conform to `Hashable`), and you can be sure that a key path is
stateless, unlike functions, which might capture mutable state. None of these
things are possible with normal functions.

Key paths are also composable by appending one key path to another. Notice that
the types must match: if you start with a key path from `A` to `B`, the key path
you append must have a root type of `B`, and the resulting key path will then
map from `A` to the appended key path's value type, say `C`:

*/

// KeyPath<Person, String> + KeyPath<String, Int> = KeyPath<Person, Int>
let nameCountKeyPath = nameKeyPath.appending(path: \.count)

/*:
Let's rewrite our sort descriptors from earlier in this chapter to use key paths
instead of functions. We previously defined `sortDescriptor` as taking a
function, `(Key) -> Value`:

*/

typealias SortDescriptor<Value> = (Value, Value) -> Bool
func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key)
    -> SortDescriptor<Value> where Key: Comparable {
    return { key($0) < key($1) }
}

// Usage
let streetSD: SortDescriptor<Person> = sortDescriptor { $0.address.street }

/*:
We can add a variant for constructing a sort descriptor from a key path. We use
the subscript for key paths to access the value:

*/

func sortDescriptor<Value, Key>(key: KeyPath<Value, Key>)
    -> SortDescriptor<Value> where Key: Comparable {
    return { $0[keyPath: key] < $1[keyPath: key] }
}

// Usage
let streetSDKeyPath: SortDescriptor<Person> = 
    sortDescriptor(key: \.address.street)

/*:
While it's useful to have a `sortDescriptor` constructor that takes a key path,
it doesn't give us the same flexibility as functions do. The key path relies on
the `Value` being `Comparable`. Using just key paths, we can't easily sort by a
different predicate (for example, performing a localized case-insensitive
comparison).

### Writable Key Paths

A writable key path is special; you can use it to read *or* write a value.
Hence, it's equivalent to a pair of functions: one for getting (`(Root) ->
Value`), and another for setting (`(inout Root, Value) -> Void`) the property.
Writable key paths are a much bigger deal than the read-only key paths. First of
all, they capture a lot of code in a neat syntax. Compare `streetKeyPath` with
the equivalent getter and setter pair:

``` swift-example
let streetKeyPath = \Person.address.street
```

*/

let getStreet: (Person) -> String = { person in
    return person.address.street
}
let setStreet: (inout Person, String) -> () = { person, newValue in
    person.address.street = newValue
}

// Usage
lisa[keyPath: streetKeyPath]
getStreet(lisa)

/*:
Writable key paths are especially useful for *data binding*, where you want to
*bind* two properties to each other: when property one changes, property two
should automatically get updated, and vice versa. For example, you could bind a
`model.name` property to `textField.text`. Users of the API need to specify how
to read and write `model.name` and `textField.text`, and key paths capture just
that.

We also need a way to observe changes to the properties. We use the key-value
observing mechanism in Cocoa for this, which means that this example will only
work with classes and only on Apple platforms. Foundation provides a new
type-safe KVO API that hides the stringly typed world of Objective-C key paths.
The `NSObject` method `observe(_:options:changeHandler:)` observes a key path
(passed in as a strongly typed Swift key path) and calls the change handler
whenever the property has changed. Don't forget to mark any property you want to
observe as `@objc dynamic`, otherwise KVO won't work.

Our goal is to implement a two-way binding between two `NSObject`s, but let's
start with a one-way binding: whenever the observed property of `self` changes,
we change the other object as well. Key paths allow us to make this code generic
over the specific properties involved: the caller specifies the two objects and
the two key paths, and this method takes care of the rest:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension NSObjectProtocol where Self: NSObject {
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>,
        writeTo other: Other,
        _ otherKeyPath: ReferenceWritableKeyPath<Other, A>)
        -> NSKeyValueObservation
        where A: Equatable, Other: NSObjectProtocol
    {
        return observe(keyPath, options: .new) { _, change in
            guard let newValue = change.newValue,
                other[keyPath: otherKeyPath] != newValue else {
                    return // prevent endless feedback loop
            }
            other[keyPath: otherKeyPath] = newValue
        }
    }
}

/*:
There's a lot to unpack in this code snippet. First of all, we define this
method on every subclass of `NSObject`, and by extending the `NSObjectProtocol`
instead of `NSObject`, we're allowed to use `Self`. `ReferenceWritableKeyPath`
is just like `WritableKeyPath`, but it also allows us to write reference
variables (like `other`) that are declared using `let`. (We'll go into more
details on that later.) To avoid unnecessary writes, we only write to `other`
when the value has changed. The `NSKeyValueObservation` return value is a token
the caller can use to control the lifetime of the observation: observation stops
either when this object gets deallocated or when the caller calls its
`invalidate` method.

Given `observe(_:writeTo:_:)`, two-way binding is straightforward: we call
`observe` on both objects and return both observation tokens:

*/

extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self,A>,
        to other: Other,
        _ otherKeyPath: ReferenceWritableKeyPath<Other,A>)
        -> (NSKeyValueObservation, NSKeyValueObservation)
        where A: Equatable, Other: NSObject
    {
        let one = observe(keyPath, writeTo: other, otherKeyPath)
        let two = other.observe(otherKeyPath, writeTo: self, keyPath)
        return (one,two)
    }
}

/*:
Now we can construct two different objects, `Sample` and `MyObj`, and bind the
`name` and `test` properties to each other:

*/

final class Sample: NSObject {
    @objc dynamic var name: String = ""
}

class MyObj: NSObject {
    @objc dynamic var test: String = ""
}

let sample = Sample()
let other = MyObj()
let observation = sample.bind(\Sample.name, to: other, \.test)
sample.name = "NEW"
other.test
other.test = "HI"
sample.name

/*:
At the time of writing, key paths are a very new addition to Swift. We expect
that many more interesting use cases will pop up in the future.

> If you come from functional programming, writable key paths might remind you
> of *lenses*. They are closely related: from a `WritableKeypath<Root, Value>`,
> you can create a `Lens<Root, Value>`. Lenses are useful in pure functional
> languages like Haskell or PureScript, but they aren't nearly as useful in
> Swift, because Swift has mutability built in.

### The Key Path Hierarchy

There are five different types for key paths, each adding more precision and
functionality to the previous one:

  - An `AnyKeyPath` is similar to a function `(Any) -> Any?`

  - A `PartialKeyPath<Source>` is similar to a function `(Source) -> Any?`

  - A `KeyPath<Source, Target>` is similar to a function `(Source) -> Target`

  - A `WritableKeyPath<Source, Target>` is similar to a *pair* of functions:
    `(Source) -> Target` and `(inout Source, Target) -> ()`

  - A `ReferenceWritableKeyPath<Source, Target>` is similar to a *pair* of
    functions: `(Source) -> Target` and `(Source, Target) -> ()`. The second
    function can update a `Source` value with `Target`, and works only when
    `Source` is a reference type. The distinction between `WritableKeyPath` and
    `ReferenceWritableKeyPath` is necessary because the setter for the former
    has to take its argument `inout`.

This hierarchy of key paths is currently implemented as a class hierarchy.
Ideally, these would be protocols, but Swift 4's generics system lacks some
features to make this feasible. The class hierarchy is intentionally kept closed
to facilitate changing this in a future release without breaking existing code.

As we've seen before, key paths are different from functions: they conform to
`Hashable`, and in the future they'll probably conform to `Codable` as well.
This is why we say `AnyKeyPath` is *similar* to a function `(Any) -> Any`. While
we can convert a key path into its corresponding function(s), we can't always go
in the other direction.

### Key Paths Compared to Objective-C

In Foundation and Objective-C, key paths are modeled as strings (we'll call
these Foundation key paths to distinguish them from Swift's key paths). Because
Foundation key paths are strings, they don't have any type information attached
to them. In that sense, they're similar to `AnyKeyPath`. If a Foundation key
path is misspelled, is not well formed, or if the types don't match, the program
will probably crash. (The `#keyPath` directive in Swift helps a little with the
misspelling; the compiler can check if a property with the specified name
exists.) Swift's `KeyPath`, `WritableKeypath`, and `ReferenceWritableKeyPath`
are correct by construction: they can't be misspelled and they don't allow for
type errors.

Many Cocoa APIs use (Foundation) key paths when a function might have been
better. This is partially a historical artifact: anonymous functions (or blocks,
as Objective-C calls them) are a relatively recent addition, and key paths have
been around much longer. Before blocks were added to Objective-C, it wasn't easy
to represent something similar to the function `{ $0.address.street }`, except
by using a key path: `"address.street"`.

### Future Directions

Key paths are still under active discussion, and it's likely they'll become more
capable in the future. One possible feature is serialization through the
`Codable` protocol. This would allow us to persist key paths on disk, send them
over the network, and so on. Once we have access to the structure of the key
paths, this enables introspection. For example, we could use the structure of a
key path to construct well-typed database queries. If types could automatically
provide an array of key paths to their properties, this could serve as the basis
for runtime reflection APIs.

Support for allowing subscript expressions in key paths is also planned, but the
implementation didn't quite make the cut for Swift 4.0. In a future release,
you'll probably be able to write things like `\[String].[n].count` to form a key
path to an array's n-th element's character count, or `\[String:
String].["name"]?.isEmpty` for a key path to a property of a value that's stored
in a dictionary under the specified key. The Swift team has also expressed
interest in supporting arbitrary function calls in key path expressions
(provided those functions don't capture mutable state). For example, it’s "not
fair” that `\MyObject.firstFiveElements` and `\MyObject[3]` are valid KeyPaths,
but `\MyObject.prefix(5)` isn't.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
