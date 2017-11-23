/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Bridging Errors to Objective-C

Objective-C has no mechanism that's similar to `throws` and `try`. (Objective-C
*does* have exception handling that uses these same keywords, but exceptions in
Objective-C should only be used to signal programmer errors. You rarely catch an
Objective-C exception in a normal app.)

Instead, the common pattern in Cocoa is that a method returns `NO` or `nil` when
an error occurs. In addition, failable methods take a reference to an `NSError`
pointer as an extra argument; they can use this pointer to pass concrete error
information to the caller. For example, the `contents(ofFile:)` method would
look like this in Objective-C:

``` objc
- (NSString *)contentsOfFile(NSString *)filename error:(NSError **)error;
```

Swift automatically translates methods that follow this pattern to the `throws`
syntax. The error parameter gets removed since it's no longer needed, and `BOOL`
return types are changed to `Void`. This is helpful when dealing with existing
frameworks in Objective-C. The method above gets imported like this:

``` swift-example
func contents(ofFile filename: String) throws -> String
```

Other `NSError` parameters — for example, in asynchronous APIs that pass an
error back to the caller in a completion block — are bridged to the `Error`
protocol, so you don't generally need to interact with `NSError` directly.

If you pass a pure Swift error to an Objective-C method, it'll be bridged to
`NSError`. Since all `NSError` objects must have a `domain` string and an
integer error `code`, the runtime will generate default values, using the
qualified type name as the domain and numbering the enum cases from zero for the
error code. Optionally, you can provide your own values by conforming your type
to the `CustomNSError` protocol.

For example, we could extend our `ParseError` like this:

*/

// --- (Hidden code block) ---
enum ParseError: Error {
    case wrongEncoding
    case warning(line: Int, message: String)
}

import Foundation
// ---------------------------
extension ParseError: CustomNSError {
    static let errorDomain = "io.objc.parseError"
    var errorCode: Int {
        switch self {
        case .wrongEncoding: return 100
        case .warning(_, _): return 200
        }
    }
    var errorUserInfo: [String: Any] {
        return [:]
    }
}

/*:
In a similar manner, you can add conformance to one or both of the following
protocols to make your errors more meaningful and provide better
interoperability with Cocoa conventions:

  - **`LocalizedError`** — provides localized messages describing why the error
    occurred (`failureReason`), tips for how to recover (`recoverySuggestion`),
    and additional help text (`helpAnchor`).

  - **`RecoverableError`** — describes an error the user can recover from by
    presenting one or more `recoveryOptions` and performing the recovery when
    the user requests it.

> Even without conforming to `LocalizedError`, every type that conforms to
> `Error` has a `localizedDescription` property. Any type conforming to `Error`
> can also define a custom `localizedDescription`. However, as it's not a
> requirement of the `Error` protocol, the property isn't dynamically
> dispatched. Unless you also conform to `LocalizedError`, your custom
> `localizedDescription` won't be used by Objective-C APIs or if you're inside
> an `Error` existential container. See the protocols chapter for more
> information on dynamic dispatch and existential containers.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
