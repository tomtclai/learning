/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Some Useful Dictionary Methods

What if we wanted to combine the default settings dictionary with any custom
settings the user has changed? Custom settings should override defaults, but the
resulting dictionary should still include default values for any keys that
haven't been customized. Essentially, we want to merge two dictionaries, where
the dictionary that's being merged in overwrites duplicate keys.

`Dictionary` has a `merge(_:uniquingKeysWith:)` method, which takes the
key-value pairs to be merged in and a function that specifies how to combine two
values with the same key. We can use this to merge one dictionary into another,
as shown in the following example:

*/

// --- (Hidden code block) ---
enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String:Setting] = [
    "Airplane Mode": .bool(false),
    "Name": .text("My iPhone"),
]
// ---------------------------
var settings = defaultSettings
let overriddenSettings: [String:Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overriddenSettings, uniquingKeysWith: { $1 })
settings

/*:
In the example above, we used `{ $1 }` as the policy for combining two values.
In other words, in case a key exists in both `settings` and
`overriddenSettings`, we use the value from `overriddenSettings`.

We can also construct a new dictionary out of a sequence of `(Key,Value)` pairs.
If we guarantee that the keys are unique, we can use
`Dictionary(uniqueKeysWithValues:)`. However, in case we have a sequence where a
key can exist multiple times, we need to provide a function to combine two
values for the same keys, just like above. For example, to compute how often
elements appear in a sequence, we can map over each element, combine it with
a 1, and then create a dictionary out of the resulting element-frequency pairs.
If we encounter two values for the same key (in other words, if we saw the same
element more than once), we simply add the frequencies up using `+`:

*/

extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}
let frequencies = "hello".frequencies
frequencies.filter { $0.value > 1 }

/*:
Another useful method is a `map` over the dictionary's values. Because
`Dictionary` is a `Sequence`, it already has a `map` method that produces an
array. However, sometimes we want to keep the dictionary structure intact and
only transform its values. The `mapValues` method does just this:

*/

let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}
settingsAsStrings

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
