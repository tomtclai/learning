/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Structs and Classes 

In Swift, we can choose from multiple options to store structured data: structs,
enums, classes, and capturing variables with closures. Most of the public types
in Swift's standard library are defined as structs, with enums and classes
making up a much smaller percentage. Part of this may be the nature of the types
in the standard library, but it does give an indication as to the importance of
structs in Swift. Likewise, many of the classes in Foundation now have struct
counterparts specifically built for Swift. That said, we'll focus on the
differences between structs and classes in this chapter. Meanwhile, enums behave
in a way that's similar to structs.

Here are some of the major things that help distinguish between structs and
classes:

  - Structs (and enums) are *value types*, whereas classes are *reference
    types*. When designing with structs, we can ask the compiler to enforce
    immutability. With classes, we have to enforce it ourselves.

  - How memory is managed differs. Structs can be held and accessed directly,
    whereas class instances are always accessed indirectly through their
    references. Structs aren't referenced but instead copied. Structs have a
    single owner, whereas class instances can have many owners.

  - With classes, we can use inheritance to share code. With structs (and
    enums), inheritance isn't possible. Instead, to share code using structs and
    enums, we need to use different techniques, such as composition, generics,
    and protocol extensions.

In this chapter, we'll explore these differences in more detail. We'll start by
looking at the differences between entities and values. Next, we'll continue by
discussing issues with mutability. Then we'll take a look at structs and
mutability. After that, we'll demonstrate how to wrap a reference type in a
struct in order to use it as an efficient value type. Finally, we'll compare the
differences in how memory is managed — particularly how memory is managed in
combination with closures, and how to avoid reference cycles.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
