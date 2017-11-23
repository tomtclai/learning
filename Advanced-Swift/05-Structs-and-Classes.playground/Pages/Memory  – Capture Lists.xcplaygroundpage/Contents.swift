/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Capture Lists

*/

// --- (Hidden code block) ---
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
    var onRotate: (() -> ())?
    deinit {
        print("Deinit Window")
    }
}

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view
// ---------------------------
/*:
To break the cycle above, we want to make sure the closure won't reference the
view. We can do this by using a *capture list* and marking the captured variable
(`view`) as either `weak` or `unowned`:

*/

window?.onRotate = { [weak view] in
    print("We now also need to update the view: \(view)")
}

/*:
Capture lists can also be used to initialize new variables. For example, if we
wanted to have a weak variable that refers to the window, we could initialize it
in the capture list, or we could even define completely unrelated variables,
like so:

*/

window?.onRotate = { [weak view, weak myWindow=window, x=5*5] in
    print("We now also need to update the view: \(view)")
    print("Because the window \(myWindow) changed")
}

/*:
This is almost the same as defining the variable just above the closure, except
that with capture lists, the scope of the variable is just the scope of the
closure; it's not available outside of the closure.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
