/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## A Tour of Optional Techniques

Optionals have a lot of extra support built into the language. Some of the
examples below might look very simple if you've been writing Swift for a while,
but it's important to make sure you know all of these concepts well, as we'll be
using them again and again throughout the book.

### `if let`

Optional binding with `if let` is just a short step away from the `switch`
statement above:

*/

var array = ["one", "two", "three", "four"]
if let idx = array.index(of: "four") {
    array.remove(at: idx)
}

/*:
An optional binding with `if let` can have boolean clauses as well. So suppose
you didn't want to remove the element if it happened to be the first one in the
array:

*/

if let idx = array.index(of: "four"), idx != array.startIndex {
    array.remove(at: idx)
}

/*:
You can also bind multiple values in the same `if` statement. What's more is
that later entries can rely on the earlier ones being successfully unwrapped.
This is very useful when you want to make multiple calls to functions that
return optionals themselves. For example, these `URL` and `UIImage` initializers
are all "failable" — that is, they can return `nil` — if your URL is malformed,
or if the data isn't an image. The `Data` initializer can throw an error, and by
using `try?`, we can convert it into an optional as well. All three can be
chained together, like this:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
// --- (Hidden code block) ---
import UIKit
import PlaygroundSupport
// ---------------------------
let urlString = "https://www.objc.io/logo.png"
if let url = URL(string: urlString),
    let data = try? Data(contentsOf: url),
    let image = UIImage(data: data)
{
    let view = UIImageView(image: image)
    PlaygroundPage.current.liveView = view
}

/*:
Any part of a multi-variable `let` can have a boolean clause as well:

*/

if let url = URL(string: urlString), url.pathExtension == "png",
    let data = try? Data(contentsOf: url),
    let image = UIImage(data: data)
{
    let view = UIImageView(image: image)
}

/*:
If you need to perform a check *before* performing various `if let` bindings,
you can supply a leading boolean condition. Suppose you're transitioning to a
new scene in an iOS app and want to check the segue identifier before casting to
a specific kind of view controller:

*/

// --- (Hidden code block) ---
let segue = UIStoryboardSegue(identifier: nil, source: UIViewController(), destination: UIViewController())

class UserDetailViewController: UIViewController {
    var screenName: String? = ""
}
// ---------------------------
if segue.identifier == "showUserDetailsSegue",
    let userDetailVC = segue.destination
        as? UserDetailViewController
{
    userDetailVC.screenName = "Hello"
}

/*:
You can also mix and match optional bindings, boolean clauses, and `case let`
bindings within the same `if` statement.

This kind of `if let` binding is a good match for the `Scanner` type in
Foundation, which returns a boolean value to indicate whether or not it
successfully scanned something, after which you can unwrap the result:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let scanner = Scanner(string: "lisa123")
var username: NSString?
let alphas = CharacterSet.alphanumerics
if scanner.scanCharacters(from: alphas, into: &username),
    let name = username {
    print(name)
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
