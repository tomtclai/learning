/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Designing with Generics

As we've seen, generics can be used to provide multiple implementations of the
same functionality. We can write generic functions but provide specific
implementations for certain types. Also, by using protocol extensions, we can
write generic algorithms that operate on many types.

Generics can also be very helpful during the design of your program, in order to
factor out shared functionality and reduce boilerplate. In this section, we'll
refactor a normal piece of code, pulling out the common functionality by using
generics. Not only can we make generic functions, but we can also make generic
data types.

Let's write some functions to interact with a web service. For example, consider
fetching a list of users and parsing it into the `User` datatype. We write a
function named `loadUsers`, which loads the users from the network
asynchronously and then calls a callback with the list of fetched users.

We start by implementing it in a naive way. First, we build the URL. Then, we
load the data synchronously (this is just for the sake of the example; you
should always do networking asynchronously in production code). Next, we parse
the JSON response, which gives us an array of dictionaries. Finally, we
transform the plain JSON objects into `User` structs:

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
func loadUsers(callback: ([User]?) -> ()) {
    let usersURL = webserviceURL.appendingPathComponent("/users")
    let data = try? Data(contentsOf: usersURL)
    let json = data.flatMap {
        try? JSONSerialization.jsonObject(with: $0, options: [])
    }
    let users = (json as? [Any]).flatMap { jsonObject in
      jsonObject.flatMap(User.init)
    }
    callback(users)
}

/*:
Notice that we don't take advantage of the `Codable` system we discussed in the
chapter on encoding and decoding here. We use the "old-fashioned" way of parsing
JSON into a dictionary with `JSONSerialization`, and then the `User` type knows
how to initialize itself from a JSON dictionary.

The `loadUsers` function has three possible error cases: the URL loading can
fail, the JSON parsing can fail, and building user objects from the JSON array
can fail. All three operations return `nil` upon failure. By using `flatMap` on
the optional values, we ensure that subsequent operations are only executed if
the previous ones succeeded. Otherwise, the `nil` value from the first failing
operation will be propagated through the chain to the end, where we eventually
call the callback either with a valid users array or `nil`.

Now, if we want to write the same function to load other resources, we'd need to
duplicate most of the code. For example, if we consider a function to load blog
posts, its type could look like this:

``` swift-example
func loadBlogPosts(callback: ([BlogPost])? -> ())
```

The implementation would be almost the same. Not only would we have duplicated
code, but both functions are hard to test: we need to make sure the test can
access the web service or else find some way to fake the requests. And because
the functions take a callback, we need to make the tests asynchronous too.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
