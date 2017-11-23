/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Arrays and Optionals 

Swift arrays provide all the usual operations you'd expect, like `isEmpty` and
`count`. Arrays also allow for direct access of elements at a specific index
through subscripting, like `fibs[3]`. Keep in mind that you need to make sure
the index is within bounds before getting an element via subscript. Fetch the
element at index 3, and you'd better be sure the array has at least four
elements in it. Otherwise, your program will trap, i.e. abort with a fatal
error.

The reason for this is mainly driven by how array indices are used. It's pretty
rare in Swift to actually need to calculate an index:

  - Want to iterate over the array?  
    `for x in array`

  - Want to iterate over all but the first element of an array?  
    `for x in array.dropFirst()`

  - Want to iterate over all but the last 5 elements?  
    `for x in array.dropLast(5)`

  - Want to number all the elements in an array?  
    `for (num, element) in collection.enumerated()`

  - Want to find the location of a specific element?  
    `if let idx = array.index { someMatchingLogic($0) }`

  - Want to transform all the elements in an array?  
    `array.map { someTransformation($0) }`

  - Want to fetch only the elements matching a specific criterion?  
    `array.filter { someCriteria($0) }`

Another sign that Swift wants to discourage you from doing index math is the
removal of traditional C-style `for` loops from the language in Swift 3.
Manually fiddling with indices is a rich seam of bugs to mine, so it's often
best avoided. And if it can't be, well, we'll see in the generics chapter that
it's easy enough to write a new reusable general function that does what you
need and in which you can wrap your carefully tested index calculations.

But sometimes you do have to use an index. And with array indices, the
expectation is that when you do, you'll have thought very carefully about the
logic behind the index calculation. So to have to unwrap the value of a
subscript operation is probably overkill — it means you don't trust your code.
But chances are you do trust your code, so you'll probably resort to
force-unwrapping the result, because you *know* that the index must be valid.
This is (a) annoying, and (b) a bad habit to get into. When force-unwrapping
becomes routine, eventually you're going to slip up and force-unwrap something
you don't mean to. So to avoid this habit becoming routine, arrays don't give
you the option.

> While a subscripting operation that responds to a invalid index with a
> controlled crash could arguably be called *unsafe*, that's only one aspect of
> safety. Subscripting is totally safe in regard to *memory safety* — the
> standard library collections always perform bounds checks to prevent
> unauthorized memory access with an out-of-bounds index.

Other operations behave differently. The `first` and `last` properties have an
optional type; they return `nil` if the array is empty. `first` is equivalent to
`isEmpty ? nil : self[0]`. Similarly, the `removeLast` method will trap if you
call it on an empty array, whereas `popLast` will only delete and return the
last element if the array isn't empty, and will otherwise do nothing and return
`nil`. Which one you'd want to use depends on your use case. When you're using
the array as a stack, you'll probably always want to combine checking for
`empty` and removing the last entry. On the other hand, if you already know
through invariants whether or not the array is empty, dealing with the optional
is fiddly.

We'll encounter these tradeoffs again later in this chapter when we talk about
dictionaries. Additionally, there's an entire chapter dedicated to optionals.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
