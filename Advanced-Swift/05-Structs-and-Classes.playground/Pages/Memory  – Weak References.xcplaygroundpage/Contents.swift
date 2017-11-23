/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Weak References

To break the reference cycle, we need to make sure that one of the references is
either `weak` or `unowned`. When you mark a variable as `weak`, assigning a
value to it doesn't change the reference count. Weak references in Swift are
always *zeroing*: the variable will be automatically set to `nil` once the
referred object gets deallocated — this is why weak references must always be
optionals.

Rewriting the example above, we could make the window's `rootView` property
`weak`, which means it won't strongly reference the view and automatically
becomes `nil` once the view is deallocated. To see what's going on, we can add
some print statements to the classes' deinitializers. `deinit` gets called just
before a class deallocates:

*/

class View {
    var window: Window
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("Deinit View")
    }
}

class Window {
    weak var rootView: View?
    deinit {
        print("Deinit Window")
    }
}

/*:
In the code below, we again create a window and a view. As before, the view
strongly references the window; but because the window's `rootView` is declared
as `weak`, the window doesn't strongly reference the view anymore. This way, we
have no reference cycle, and both objects get deallocated when we set the
variables to `nil`:

*/

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view
window = nil
view = nil

/*:
Weak references are very useful when working with delegates, as is common in
Cocoa. The delegating object (e.g. a table view) needs a reference to its
delegate, but it shouldn't *own* the delegate because that would likely create a
reference cycle. Therefore, delegate references are usually weak, and another
object (e.g. a view controller) is responsible for making sure the delegate
stays around for as long as needed.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
