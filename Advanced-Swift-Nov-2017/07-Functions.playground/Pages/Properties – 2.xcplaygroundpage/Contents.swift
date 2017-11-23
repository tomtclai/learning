/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
If we want to make the `record` property available as read-only to the outside,
but read-write internally, we can use the `private(set)` or `fileprivate(set)`
modifiers:

*/

// --- (Hidden code block) ---
import Foundation
import CoreLocation
// ---------------------------
struct GPSTrack {
    private(set) var record: [(CLLocation, Date)] = []
}

/*:
To access all the timestamps in a GPS track, we create a computed property:

*/

extension GPSTrack {
    /// Returns all the timestamps for the GPS track.
    /// - Complexity: O(*n*), where *n* is the number of points recorded.
    var timestamps: [Date] {
        return record.map { $0.1 }
    }
}

/*:
Because we didn't specify a setter, the `timestamps` property is read-only. The
result isn't cached; each time you access the property, it computes the result.
The Swift API Design Guidelines recommend you document the complexity of every
computed property that isn't `O(1)`, because callers might assume that accessing
a property takes constant time.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
