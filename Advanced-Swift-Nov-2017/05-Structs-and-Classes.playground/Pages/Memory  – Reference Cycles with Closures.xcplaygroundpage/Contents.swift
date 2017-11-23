/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Reference Cycles with Closures

One of the issues with closures capturing their variables is the (accidental)
introduction of reference cycles. The usual pattern is like this: object A
references object B, but object B stores a callback that references object A.
Let's consider our example from before, where a view references its window, and
the window has a weak reference back to its root view. Additionally, the window
now has an `onRotate` callback, which is optional and has an initial value of
`nil`:

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
    var onRotate: (() -> ())?
    deinit {
        print("Deinit Window")
    }
}

/*:
If we create a view and set up the window like before, all is well, and we don't
have a reference cycle yet:

*/

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view

/*:
The view has a strong reference to the window, but the window has a weak
reference to the view, so there's no cycle. However, if we configure the
`onRotate` callback and use the `view` in there, we've introduced a reference
cycle:

*/

window?.onRotate = {
    print("We now also need to update the view: \(view)")
}

/*:
The view references the window, the window references the callback, and the
callback references the view: a cycle.

In a diagram, it looks like this:

![A retain cycle between the view, window, and
closure](artwork/retain-cycle.png)

We need to find a way to break this cycle. There are three places where we could
break the cycle (each corresponding to an arrow in the diagram):

  - We could make the reference to the `Window` weak. Unfortunately, this would
    make the `Window` disappear, because there are no other references keeping
    it alive.

  - We might want to change the `Window` to make the `onRotate` closure weak,
    but Swift doesn't allow marking closures as `weak`.

  - We could make sure the closure doesn't reference the view by using a capture
    list. This is the only correct option in the above example.

In the case of the (constructed) example above, it's not too hard to figure out
that we have a reference cycle. However, it's not always this easy. Sometimes
the number of objects involved might be much larger, and the reference cycle
might be harder to spot. And to make matters even worse, your code might be
correct the first time you write it, but a refactoring might introduce a
reference cycle without you noticing.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
