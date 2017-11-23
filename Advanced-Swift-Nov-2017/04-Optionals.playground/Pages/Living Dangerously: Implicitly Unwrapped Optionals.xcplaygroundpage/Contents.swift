/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Living Dangerously: Implicitly Unwrapped Optionals

Make no mistake: implicitly unwrapped optionals — types marked with an
exclamation point, such as `UIView!` — are still optionals, albeit ones that are
automatically force-unwrapped whenever you use them. Now that we know
force-unwraps will crash your application if they're ever `nil`, why on earth
would you use them? Well, two reasons really.

Reason 1: Temporarily, because you're calling Objective-C code that hasn't been
audited for nullability.

The sole reason implicitly unwrapped optionals even exist is to make
interoperability with Objective-C and C easier. Of course, on the first day you
start writing Swift against an existing Objective-C code base, any Objective-C
method that returns a reference will translate into an implicitly unwrapped
optional. Since, for most of Objective-C's lifetime, there was no way to
indicate that a reference was nullable, there was little option other than to
assume any call returning a reference might return a `nil` reference. But few
Objective-C APIs *actually* return null references, so it'd be incredibly
annoying to automatically expose them as optionals. Since everyone was used to
dealing with the "maybe null" world of Objective-C objects, implicitly unwrapped
optionals were a reasonable compromise.

So you see them in unaudited bridged Objective-C code. But you should *never*
see a pure native Swift API returning an implicit optional (or passing one into
a callback).

Reason 2: Because a value is `nil` *very* briefly, for a well-defined period of
time, and is then never `nil` again.

For example, if you have a two-phase initialization, then by the time your class
is ready to use, the implicitly wrapped optionals will all have a value. This is
the reason Xcode/Interface Builder uses them in the view controller lifecycle:
in Cocoa and Cocoa Touch, view controllers create their view lazily, so there
exists a time window — after a view controller has been initialized but before
it has loaded its view — when the view objects its outlets reference have not
yet been created.

### Implicit Optional Behavior

While implicitly unwrapped optionals usually behave like non-optional values,
you can still use most of the unwrap techniques to safely handle them like
optionals — chaining, `nil`-coalescing, `if let`, `map`, or just comparing them
to `nil` all work the same:

*/

var s: String! = "Hello"
s?.isEmpty
if let s = s { print(s) }
s = nil
s ?? "Goodbye"

/*:
As much as implicit optionals try to hide their optional-ness from you, there
are a few times when they behave slightly differently than plain values. For
example, you can't pass an implicit optional into a function that takes the
wrapped type as an `inout`:

``` swift-example
func increment(_ x: inout Int) {
      x += 1
}

var i = 1     // Regular Int
increment(&i) // Increments i to 2
var j: Int! = 1 // Implicitly unwrapped Int
increment(&j)
// Error: Cannot pass immutable value of type 'Int' as inout argument
```

The reason is that `inout` requires an *lvalue*, which optionals (implicitly
unwrapped or not) aren't. We'll have more to say on lvalues in the chapter on
functions.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
