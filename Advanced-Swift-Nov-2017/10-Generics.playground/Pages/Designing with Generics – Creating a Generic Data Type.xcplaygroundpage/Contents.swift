/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Creating a Generic Data Type

The `path` and `parse` parameters of the `loadResource` function are very
tightly coupled; if you change one, you likely have to change the other too.
Let's bundle them up in a struct that describes a resource. Just like functions,
structs (and other types) can also be generic:

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

func jsonArray<A>(_ transform: @escaping (Any) -> A?) -> (Any) -> [A]? {
    return { array in
        guard let array = array as? [Any] else {
            return nil
        }
        return array.flatMap(transform)
    }
}
// ---------------------------
struct Resource<A> {
    let path: String
    let parse: (Any) -> A?
}

/*:
Now we can write an alternative version of `loadResource` as a method on
`Resource`. It uses the resource's properties to determine what to load and how
to parse the result, so the only remaining argument is the callback function:

*/

extension Resource {
    func loadSynchronously(callback: (A?) -> ()) {
        let resourceURL = webserviceURL.appendingPathComponent(path)
        let data = try? Data(contentsOf: resourceURL)
        let json = data.flatMap {
            try? JSONSerialization.jsonObject(with: $0, options: [])
        }
        callback(json.flatMap(parse))
    }
}

/*:
The previous top-level functions to load a specific resource now become
instances of the `Resource` struct. This makes it very easy to add new resources
without having to create new functions:

*/

let usersResource: Resource<[User]> =
    Resource(path: "/users", parse: jsonArray(User.init))
let postsResource: Resource<[BlogPost]> =
    Resource(path: "/posts", parse: jsonArray(BlogPost.init))

/*:
Adding a variant that uses asynchronous networking is now possible with minimal
duplication. We don't need to change any of our existing code describing the
endpoints:

*/

extension Resource {
    func loadAsynchronously(callback: @escaping (A?) -> ()) {
        let resourceURL = webserviceURL.appendingPathComponent(path)
        let session = URLSession.shared
        session.dataTask(with: resourceURL) { data, response, error in
            let json = data.flatMap {
                try? JSONSerialization.jsonObject(with: $0, options: [])
            }
            callback(json.flatMap(self.parse))
        }.resume()
    }
}

/*:
Aside from the usage of the asynchronous `URLSession` API, the only material
difference to the synchronous version is that the `callback` argument must now
be annotated with `@escaping` because the callback function escapes the method's
scope. See the functions chapter if you want to learn more about escaping vs.
non-escaping closures.

We've now completely decoupled our endpoints from the network calls. We boiled
down `usersResource` and `postsResource` to their absolute minimums so that they
only describe where the resource is located and how to parse it. The design is
also extensible: adding more configuration options, such as the HTTP method or a
way to add `POST` data to a request, is simply a matter of adding additional
properties to the `Resource` type. (Specifying default values, e.g. `GET` for
the HTTP method, helps keep the code clean.)

Testing has become much simpler. The `Resource` struct is fully synchronous and
independent of the network, so testing whether a resource is configured
correctly becomes trivial. The networking code is still harder to test, of
course, because it's naturally asynchronous and depends on the network. But this
complexity is now nicely isolated in the `loadAsynchronously` method; all other
parts are simple and don't involve asynchronous code.

In this section, we started with a non-generic function for loading some data
from the network. Next, we created a generic function with multiple parameters,
significantly reducing duplicate code. Finally, we bundled up the parameters
into a separate `Resource` data type. The domain-specific logic for the concrete
resources is fully decoupled from the networking code. Changing the network
stack doesn't require any change to the resources.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
