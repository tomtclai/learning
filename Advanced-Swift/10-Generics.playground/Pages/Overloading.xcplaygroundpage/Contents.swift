/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Overloading

Overloaded functions, i.e. multiple functions that have the same name but
different argument and/or return types, are not generic per se. But like
generics, they allow us to make one interface available to multiple types.

### Overload Resolution for Free Functions

For example, we could define a function named `raise(_:to:)` to perform
exponentiation and provide separate overloads for `Double` and `Float`
arguments:

*/

// --- (Hidden code block) ---
import Darwin
// ---------------------------
func raise(_ base: Double, to exponent: Double) -> Double {
    return pow(base, exponent)
}

func raise(_ base: Float, to exponent: Float) -> Float {
    return powf(base, exponent)
}

/*:
We used the `pow` and `powf` functions declared in Swift's Darwin module (or
Glibc on Linux) for the implementations.

When the `raise` function is called, the compiler picks the correct overload
based on the types of the arguments and/or the return value:

*/

let double = raise(2.0, to: 3.0)
type(of: double)
let float: Float = raise(2.0, to: 3.0)
type(of: float)


/*:
Swift has a complex set of rules for which overloaded function to pick, which is
based on whether or not a function is generic and what kind of type is being
passed in. While the rules are too long to go into here, they can be summarized
as "pick the most specific one." This means that non-generic functions are
picked over generic ones.

As an example, consider the following function that logs certain properties of a
view. We provide a generic implementation for `UIView` that logs the view's
class name and frame, and a specific overload for `UILabel` that prints the
label's text:

*/

// --- (Hidden code block) ---
#if os(iOS)
import UIKit
#else
import Cocoa
class UIView {
   var frame: CGRect
   init(frame: CGRect) {
       self.frame = frame
   }
}

class UILabel: UIView {
    var text: String? = nil
}
class UIButton: UIView { }
#endif
// ---------------------------
func log<View: UIView>(_ view: View) {
    print("It's a \(type(of: view)), frame: \(view.frame)")
}

func log(_ view: UILabel) {
    let text = view.text ?? "(empty)"
    print("It's a label, text: \(text)")
}

/*:
Passing a `UILabel` will call the label-specific overload, whereas passing any
other view will use the generic one:

*/

let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 32))
label.text = "Password"
log(label)

let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
log(button)

/*:
It's important to note that overloads are resolved statically at compile time.
This means the compiler bases its decision of which overload to call on the
static types of the variables involved, and not on the values' dynamic types at
runtime. This is why the generic overload of `log` will be used for both views
if we put the label and the button into an array and then call the `log`
function in a loop over the array's elements:

*/

let views = [label, button] // Type of views is [UIView]
for view in views {
    log(view)
}

/*:
The static type of the `view` variable is `UIView`; it's irrelevant that the
dynamic type `UILabel` would result in a different overload at runtime.

If instead you need runtime polymorphism — that is, you want the function to be
picked based on what a variable points to and not what the type of the variable
is — you should be using methods not functions, i.e. define `log` as a method on
`UIView` and `UILabel`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
