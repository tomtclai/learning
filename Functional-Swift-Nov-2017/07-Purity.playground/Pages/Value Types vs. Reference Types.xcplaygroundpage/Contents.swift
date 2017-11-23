/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Value Types vs. Reference Types

The careful treatment of mutability isn't present only in variable declarations.
Swift distinguishes between *value* types and *reference* types. The canonical
examples of value and reference types are structs and classes, respectively. To
illustrate the difference between value types and reference types, we'll define
the following struct:

*/

struct PointStruct {
    var x: Int
    var y: Int
}

/*:
Now consider the following code fragment:

*/

var structPoint = PointStruct(x: 1, y: 2)
var sameStructPoint = structPoint
sameStructPoint.x = 3

/*:
After executing this code, `sameStructPoint` is clearly equal to `(x: 3,`
`y: 2)`. However, `structPoint` still has its original value. This is the
crucial distinction between value types and reference types: when assigned to a
new variable or passed as an argument to a function, value types are copied. The
assignment to `sameStructPoint.x` does *not* update the original `structPoint`,
because the prior assignment, `sameStructPoint` `=` `structPoint`, has *copied*
the value.

To further illustrate the difference, we could declare a class for points:

*/

class PointClass {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

/*:
Then we can adapt our code fragment from above to use this class instead:

*/

var classPoint = PointClass(x: 1, y: 2)
var sameClassPoint = classPoint
sameClassPoint.x = 3

/*:
Now the assignment to `sameClassPoint.x` modifies the object the
`sameClassPoint` variable is pointing to, because classes are *reference types*.
The `classPoint` variable is pointing to the same object; therefore, accessing
`classPoint.x` returns the new value as well.

It's extremely important to understand the distinction between value types and
reference types in order to predict how assignments modify your data and to
determine which parts of your code are affected by such modifications.

The difference between value types and reference types is also apparent when
calling functions. Consider the following (somewhat contrived) function that
always returns the origin:

*/

func setStructToOrigin(point: PointStruct) -> PointStruct {
    var newPoint = point
    newPoint.x = 0
    newPoint.y = 0
    return newPoint
}

/*:
We use this function to compute a point:

*/

var structOrigin = setStructToOrigin(point: structPoint)

/*:
All value types, such as structs, are copied when passed as function arguments.
Therefore, in this example, the original `structPoint` is unmodified after the
call to `setStructToOrigin`.

Now suppose we had written the following function, operating on classes rather
than structs:

*/

func setClassToOrigin(point: PointClass) -> PointClass {
    point.x = 0
    point.y = 0
    return point
}

/*:
Now the following function call *would* modify the `classPoint`:

*/

var classOrigin = setClassToOrigin(point: classPoint)

/*:
When assigned to a new variable or passed to a function, value types are
*always* copied, whereas reference types are *not*. Instead, only the
*reference* to the existing object is copied. Any changes to the object itself
will also show up when accessing the same object through another reference: both
`classPoint` and `classOrigin` are affected by the call to `setClassToOrigin`.

Swift also provides `mutating` methods on structs. These can only be called on
struct variables that are declared with `var`. For example, we could rewrite
`setStructToOrigin`:

*/

extension PointStruct {
    mutating func setStructToOrigin() {
        x = 0
        y = 0
    }
}

/*:
The nice thing about `mutating` methods on structs is that they don't have the
same side effects as methods that operate on classes. A `mutating` method only
works on a single variable and doesn't influence other variables:

*/

var myPoint = PointStruct(x: 100, y: 100)
let otherPoint = myPoint
myPoint.setStructToOrigin()
otherPoint
myPoint

/*:
As we can see, in the code above, calling the `mutating` method is perfectly
safe, and it doesn't influence any other variables. While it's even easier to
reason about a variable using `let`, mutation can sometimes really help
readability as well. Swift structs allow us to have local mutability without
global side effects\[^andy\].

\[^andy\]: Andy Matuschak provides some very useful intuition for the difference
between value types and reference types in [his article for
objc.io](https://objc.io/issues/16-swift/swift-classes-vs-structs/).

Structs are used throughout Swift's standard library — for example, arrays,
dictionaries, numbers, and booleans are all defined as structs. Moreover, tuples
and enums are value types as well (the latter will be covered in the coming
chapter). Classes are the exception rather than the rule. The pervasive use of
value types in the standard library is one example of how Swift is moving away
from object-oriented programming in favor of other programming paradigms.
Likewise, in Swift 3, many of the classes from Foundation now have a
corresponding value type in Swift.

### Structs and Classes: Mutable or Not?

In the examples above, we've declared all our points and their fields to be
mutable, using `var` rather than `let`. The interaction between compound types,
such as structs and classes, and the `var` and `let` declarations, requires some
explanation.

Suppose we create the following immutable `PointStruct`:

*/

let immutablePoint = PointStruct(x: 0, y: 0)

/*:
Of course, assigning a new value to this `immutablePoint` isn't accepted:

``` swift-example
immutablePoint = PointStruct(x: 1, y: 1) // Rejected
```

Similarly, trying to assign a new value to one of the point's properties is also
rejected, although the properties in `PointStruct` have been defined as `var`,
since `immutablePoint` is defined using `let`:

``` highlight-swift
immutablePoint.x = 3 // Rejected
```

However, if we declare the point variable as mutable, we could change its
components after initialization:

*/

var mutablePoint = PointStruct(x: 1, y: 1)
mutablePoint.x = 3;

/*:
If we declare the `x` and `y` properties within the struct using the `let`
keyword, then we can't ever change them after initialization, no matter whether
the variable holding the point instance is mutable or immutable:

*/

struct ImmutablePointStruct {
    let x: Int
    let y: Int
}

var immutablePoint2 = ImmutablePointStruct(x: 1, y: 1)

/*:
``` highlight-swift
immutablePoint2.x = 3 // Rejected!
```

Of course, we can still assign a new value to `immutablePoint2`:

*/

immutablePoint2 = ImmutablePointStruct(x: 2, y: 2)

/*:
### Objective-C

The concept of mutability and immutability should already be familiar to
Objective-C programmers. Many of the data structures provided by Apple's Core
Foundation and Foundation frameworks — such as `NSArray` and `NSMutableArray`,
`NSString` and `NSMutableString`, and others — exist in immutable and mutable
variants. Using the immutable types is the default choice in most cases, just as
Swift favors value types over reference types.

In contrast to Swift, however, there's no foolproof way to enforce immutability
in Objective-C. We could declare the object's properties as read-only (or only
expose an interface that avoids mutation), but this won't stop us from
(unintentionally) mutating values internally after they've been initialized.
When working with legacy code, for instance, it's all too easy to break
assumptions about mutability that can't be enforced by the compiler. Without
checks by the compiler, it's very hard to enforce any kind of discipline in the
use of mutable variables.

When dealing with framework code, we can often wrap existing mutable classes in
a struct. However, we need to be careful here: if we store an object in a
struct, the reference is immutable, but the object itself is not. Swift arrays
work like this: they use a low-level mutable data structure, but provide an
efficient and immutable interface. This is done using a technique called
*copy-on-write*. You can read more about wrapping existing APIs in our book,
[Advanced Swift](https://objc.io/books/advanced-swift).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
