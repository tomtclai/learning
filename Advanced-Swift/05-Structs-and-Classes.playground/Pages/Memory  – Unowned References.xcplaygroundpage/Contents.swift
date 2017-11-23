/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Unowned References

Weak references must always be optional types because they can become `nil`, but
sometimes we may not want this. For example, maybe we know that our views will
always have a window (so the property shouldn't be optional), but we don't want
a view to strongly reference the window. In other words, assigning to the
property should leave the reference count unchanged. For these situations,
there's the `unowned` keyword:

*/

class View {
    unowned var window: Window
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("Deinit View")
    }
}

class Window {
    var rootView: View?
    deinit {
        print("Deinit Window")
    }
}

/*:
In the code below, we can see that both objects get deallocated, as in the
previous example with a weak reference:

*/

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view
view = nil
window = nil

/*:
So there's still no reference cycle, but now we're responsible for ensuring that
the window outlives the view. If the window is deallocated and the unowned
variable is accessed, there'll be a runtime crash.

The Swift runtime keeps a second reference count in the object to keep track of
unowned references. When all strong references are gone, the object will release
all of its resources (for example, any references to other objects). However,
the memory of the object itself will still be there until all unowned references
are gone too. The memory is marked as invalid (sometimes also called *zombie*
memory), and any time we try to access an unowned reference, a runtime error
will occur.

Note that this isn't the same as undefined behavior. There's a third option,
`unowned(unsafe)`, which doesn't have this runtime check. If we access an
invalid reference that's marked as `unowned(unsafe)`, we get undefined behavior.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
