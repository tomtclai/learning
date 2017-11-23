/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Dictionaries

Another key data structure is `Dictionary`. A dictionary contains keys with
corresponding values; duplicate keys aren't supported. Retrieving a value by its
key takes constant time on average, whereas searching an array for a particular
element grows linearly with the array's size. Unlike arrays, dictionaries aren't
ordered. The order in which pairs are enumerated in a `for` loop is undefined.

In the following example, we use a dictionary as the model data for a fictional
settings screen in a smartphone app. The screen consists of a list of settings,
and each individual setting has a name (the keys in our dictionary) and a value.
A value can be one of several data types, such as text, numbers, or booleans. We
use an `enum` with associated values to model this:

*/

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String:Setting] = [
    "Airplane Mode": .bool(false),
    "Name": .text("My iPhone"),
]

defaultSettings["Name"]

/*:
We use subscripting to get the value of a setting. Dictionary lookup always
returns an *optional value* — when the specified key doesn't exist, it returns
`nil`. Contrast this with arrays, which respond to an out-of-bounds access by
crashing the program.

The rationale for this difference is that array indices and dictionary keys are
used very differently. We've already seen that it's quite rare that you actually
need to work with array indices directly. And if you do, an array index is
usually directly derived from the array in some way (e.g. from a range like
`0..<array.count`); thus, using an invalid index is a programmer error. On the
other hand, it's very common for dictionary keys to come from some source other
than the dictionary itself.

Unlike arrays, dictionaries are also sparse. The existence of the value under
the key `"name"` doesn't tell you anything about whether or not the key
"address" also exists.

### Mutation

Just like with arrays, dictionaries defined using `let` are immutable: no
entries can be added, removed, or changed. And just like with arrays, we can
define a mutable variant using `var`. To remove a value from a dictionary, we
can either set it to `nil` using subscripting or call `removeValue(forKey:)`.
The latter additionally returns the deleted value, or `nil` if the key didn't
exist. If we want to take an immutable dictionary and make changes to it, we
have to make a copy:

*/

var userSettings = defaultSettings
userSettings["Name"] = .text("Jared's iPhone")
userSettings["Do Not Disturb"] = .bool(true)

/*:
Note that, again, the value of `defaultSettings` didn't change. As with key
removal, an alternative to updating via subscript is the
`updateValue(_:forKey:)` method, which returns the previous value (if any):

*/

let oldName = userSettings
    .updateValue(.text("Jane's iPhone"), forKey: "Name")
userSettings["Name"]
oldName

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
