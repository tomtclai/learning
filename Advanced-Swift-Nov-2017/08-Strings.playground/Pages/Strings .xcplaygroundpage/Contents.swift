/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Strings 

All modern programming languages have support for Unicode strings, but that
often only means that the native string type can store Unicode data — it's not a
promise that simple operations like getting the length of a string will return
"sensible" results. In fact, most languages, and in turn most string
manipulation code written in those languages, exhibit a certain level of denial
about Unicode's inherent complexity. This can lead to some unpleasant bugs.

Swift's string implementation goes to heroic efforts to be as Unicode-correct as
possible. A `String` in Swift is a collection of `Character` values, where a
`Character` is what a human reader of a text would perceive as a single
character, regardless of how many Unicode code points it's composed of. As a
result, all standard `Collection` operations like `count` or `prefix(5)` work on
the level of user-perceived characters.

This is great for correctness, but it comes at a price, mostly in terms of
unfamiliarity; if you're used to manipulating strings with integer indices in
other languages, Swift's design will seem unwieldy at first, leaving you
wondering. Why can't I write `str[999]` to access a string's one-thousandth
character? Why doesn't `str[idx+1]` get the next character? Why can't I loop
over a range of `Character` values such as `"a"..."z"`? It also has performance
implications: `String` does *not* support random access, i.e. jumping to an
arbitrary character is not an `O(1)` operation. It can't be — when characters
have variable width, the string doesn't know where the *n*^th^ character is
stored without looking at all characters that come before it.

In this chapter, we'll discuss the string architecture in detail, as well as
some techniques for getting the most out of Swift strings in terms of
functionality and performance. But we'll start with an overview of the required
Unicode terminology.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
