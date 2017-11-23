/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Local Functions and Variable Capture

If we wanted to implement such a stable sort, one choice might be a [merge
sort](https://en.wikipedia.org/wiki/Merge_sort). The merge sort algorithm is
made up of two parts: a division into sublists of one element, followed by a
merge of those lists. Often, it's nice to define `merge` as a separate function.
But this leads to a problem — `merge` requires some temporary scratch storage:

*/

extension Array where Element: Comparable {
    private mutating func merge(lo: Int, mi: Int, hi: Int) {
        var tmp: [Element] = []
        var i = lo, j = mi
        while i != mi && j != hi {
            if self[j] < self[i] {
                tmp.append(self[j])
                j += 1
            } else {
                tmp.append(self[i])
                i += 1
            }
        }
        tmp.append(contentsOf: self[i..<mi])
        tmp.append(contentsOf: self[j..<hi])
        replaceSubrange(lo..<hi, with: tmp)
    }

    mutating func mergeSortInPlaceInefficient() {
        let n = count
        var size = 1
        while size < n {
            for lo in stride(from: 0, to: n-size, by: size*2) {
                merge(lo: lo, mi: (lo+size), hi: Swift.min(lo+size*2,n))
            }
            size *= 2
        }
    }
}

/*:
> Note: because `Array` has a method named `min()` defined, we need to write
> `Swift.min`. This tells the compiler to explicitly use the standard library's
> free function named `min` (instead of the method on `Array`).

Of course, we could allocate this storage externally and pass it in as a
parameter, but this is a little ugly. It's also complicated by the fact that
arrays are value types — passing in an array we created outside wouldn't help.
There's an optimization that replaces `inout` parameters with references, but
the documentation tells us specifically not to rely on that.

As another solution, we can define `merge` as an inner function and have it
capture the storage defined in the outer function's scope:

*/

extension Array where Element: Comparable {
    mutating func mergeSortInPlace() {
        // Define the temporary storage for use by all merges
        var tmp: [Element] = []
        // and make sure it's big enough
        tmp.reserveCapacity(count)

        func merge(lo: Int, mi: Int, hi: Int) {
            // Wipe the storage clean while retaining its capacity
            tmp.removeAll(keepingCapacity: true)
            // The same code as before
            var i = lo, j = mi
            while i != mi && j != hi {
                if self[j] < self[i] {
                    tmp.append(self[j])
                    j += 1
                } else {
                    tmp.append(self[i])
                    i += 1
                }
            }
            tmp.append(contentsOf: self[i..<mi])
            tmp.append(contentsOf: self[j..<hi])
            replaceSubrange(lo..<hi, with: tmp)
        }

        let n = count
        var size = 1
        while size < n {
            for lo in stride(from: 0, to: n-size, by: size*2) {
                merge(lo: lo, mi: (lo+size), hi: Swift.min(lo+size*2,n))
            }
            size *= 2
        }
    }
}

/*:
Since closures (including inner functions) capture variables by reference, every
call to `merge` within a single call to `mergeSortInPlace` will share this
storage. But it's still a local variable — separate concurrent calls to
`mergeSortInPlace` will use separate instances. Using this technique can give a
significant speed boost to the sort without needing major changes to the
original version.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
