/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Memory 

Value types are very common in Swift, and memory management for them is very
easy. Because they have a single owner, the memory needed for them is created
and freed automatically. When using value types, you can't create cyclic
references. For example, consider the following snippet:

*/

struct Person {
    let name: String
    var parents: [Person]
}

// --- (Hidden code block) ---
extension Person: CustomStringConvertible {
    var description: String {
        return ("\(name), parents: \(parents)")
    }
}
// ---------------------------
var john = Person(name: "John", parents: [])
john.parents = [john]
john

/*:
Because of the way value types work, the moment we put `john` in an array, a
copy is created. It'd be more precise to say: "we put the value of `john` in an
array." If `Person` were a class, we'd now have a cycle. With the struct
version, `john` now has a single parent, which is the initial value of `john`
with an empty `parents` array.

For classes, Swift uses automatic reference counting (ARC) to manage memory. In
most cases, this means things will work as expected. Every time you create a new
reference to an object (for example, when you assign a value to a class
variable), the reference count gets increased by one. Once you let go of that
reference (for example, the variable goes out of scope), the reference count
decreases by one. When the reference count goes to zero, the object is
deallocated. A variable that behaves in this manner is also called a *strong
reference* (compared to `weak` or `unowned` references, which we'll discuss in a
bit).

For example, consider the following code:

*/

class View {
    var window: Window
    init(window: Window) {
        self.window = window
    }
}

class Window {
    var rootView: View?
}

/*:
We can now allocate and initialize a window and assign the instance to a
variable. After the first line, the reference count is one. The moment we set
the variable to `nil`, the reference count of our `Window` instance is zero, and
the instance gets deallocated:

*/

var myWindow: Window? = Window() // refcount: 1
myWindow = nil // refcount: 0, deallocating

/*:
When comparing Swift to a garbage-collected language, at first glance it looks
like things are very similar when it comes to memory management. Most times, you
don't even think about it. However, consider the following example:

*/

var window: Window? = Window() // window: 1
var view: View? = View(window: window!) // window: 2, view: 1
window?.rootView = view // window: 2, view: 2
view = nil // window: 2, view: 1
window = nil // window: 1, view: 1

/*:
First, the window gets created, and the reference count for the window will be
one. The view gets created and holds a strong reference to the window, so the
window's reference count will be two, and the view's reference count will be
one. Then, assigning the view as the window's `rootView` will increase the
view's reference count by one. Now, both the view and the window have a
reference count of two. After setting both variables to `nil`, they still have a
reference count of one. Even though they're no longer accessible from a
variable, they strongly reference each other. This is called a *reference
cycle*, and when dealing with graph-like data structures, we need to be very
aware of this. Because of the reference cycle, these two objects will never be
deallocated during the lifetime of the program.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
