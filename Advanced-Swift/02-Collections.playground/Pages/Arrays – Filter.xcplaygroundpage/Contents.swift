/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Filter

Another very common operation is to take an array and create a new array that
only includes those elements that match a certain condition. The pattern of
looping over an array and selecting the elements that match the given predicate
is captured in the `filter` method:

*/

let nums = [1,2,3,4,5,6,7,8,9,10]
nums.filter { num in num % 2 == 0 }

/*:
We can use Swift's shorthand notation for arguments of a closure expression to
make this even shorter. Instead of naming the `num` argument, we can write the
above code like this:

*/

nums.filter { $0 % 2 == 0 }

/*:
For very short closures, this can be more readable. If the closure is more
complicated, it's almost always a better idea to name the arguments explicitly,
as we've done before. It's really a matter of personal taste — choose whichever
is more readable at a glance. A good rule of thumb is this: if the closure fits
neatly on one line, shorthand argument names are a good fit.

By combining `map` and `filter`, we can easily write a lot of operations on
arrays without having to introduce a single intermediate variable, and the
resulting code will become shorter and easier to read. For example, to find all
squares under 100 that are even, we could map the range `0..<10`, in order to
square it, and then filter out all odd numbers:

*/

(1..<10).map { $0 * $0 }.filter { $0 % 2 == 0 }

/*:
The implementation of `filter` looks much the same as `map`:

*/

extension Array {
    func filter_sample_impl(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}

/*:
For more on the `where` clause we use in the `for` loop, see the optionals
chapter.

One quick performance tip: if you ever find yourself writing something like the
following, stop\!

``` swift-example
bigArray.filter { someCondition }.count > 0
```

`filter` creates a brand new array and processes every element in the array. But
this is unnecessary. This code only needs to check if one element matches — in
which case, `contains(where:)` will do the job:

``` swift-example
bigArray.contains { someCondition }
```

This is much faster for two reasons: it doesn't create a whole new array of the
filtered elements just to count them, and it exits early, as soon as it finds
the first match. Generally, only ever use `filter` if you want all the results.

Often you want to do something that can be done with `contains`, but it looks
pretty ugly. For example, you can check if every element of a sequence matches a
predicate using `!sequence.contains { !condition }`, but it's much more readable
to wrap this in a new function that has a more descriptive name:

*/

extension Sequence {
    public func all(matching predicate: (Element) -> Bool) -> Bool {
        // Every element matches a predicate if no element doesn't match it:
        return !contains { !predicate($0) }
    }
}

let evenNums = nums.filter { $0 % 2 == 0 }
evenNums.all { $0 % 2 == 0 }


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
