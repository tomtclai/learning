/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Extracting Common Functionality

A better approach is to try to move the `User`-specific parts outside the
function in order to make the other parts reusable. For example, we could add
the path and the conversion function that turns JSON objects into domain objects
as parameters. We name this new function `loadResource` to indicate its
universality. Because we want the conversion function to handle arbitrary types,
we also make the function generic over `A`:

*/

// --- (Hidden code block) ---
import Foundation

let webserviceURL = URL(string: "http://api.example.com")!

typealias BlogPost = String

struct User {
    let name: String
    let bio: String
}

extension User {
    init?(json: Any) {
        return nil
    }
}

extension BlogPost {
    init?(json: Any) {
        return nil
    }
}

struct ForceUnwrapError: Error { }
// ---------------------------
func loadResource<A>(at path: String,
    parse: (Any) -> A?, callback: (A?) -> ())
{
    let resourceURL = webserviceURL.appendingPathComponent(path)
    let data = try? Data(contentsOf: resourceURL)
    let json = data.flatMap {
        try? JSONSerialization.jsonObject(with: $0, options: [])
    }
    callback(json.flatMap(parse))
}

/*:
Now we can base our `loadUsers` function on `loadResource`:

*/

func loadUsers(callback: ([User]?) -> ()) {
    loadResource(at: "/users", parse: jsonArray(User.init), callback: callback)
}

/*:
We use a helper function, `jsonArray`, to convert JSON into user objects. It
first tries to convert an `Any` to an array of `Any`s, and then it tries to
parse each element using the supplied function, returning `nil` if any of the
steps fail:

*/

func jsonArray<A>(_ transform: @escaping (Any) -> A?) -> (Any) -> [A]? {
    return { array in
        guard let array = array as? [Any] else {
            return nil
        }
        return array.flatMap(transform)
    }
}

/*:
To load the blog posts, we just change the path and the parsing function:

*/

func loadBlogPosts(callback: ([BlogPost]?) -> ()) {
    loadResource(at: "/posts", parse: jsonArray(BlogPost.init), callback: callback)
}

/*:
This avoids a lot of duplication. And if we later decide to switch from
synchronous to asynchronous networking, we don't need to update either
`loadUsers` or `loadBlogPosts`. But even though these functions are now very
short, they're still hard to test — they remain asynchronous and depend on the
web service being accessible.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
