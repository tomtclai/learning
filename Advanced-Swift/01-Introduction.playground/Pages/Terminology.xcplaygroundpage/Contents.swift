/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Terminology

> 'When I use a word,' Humpty Dumpty said, in rather a scornful tone, 'it means
> just what I choose it to mean — neither more nor less.'
> 
> — *Through the Looking Glass*, by Lewis Carroll

Programmers throw around [terms of
art](https://en.wikipedia.org/w/index.php?title=Term_of_art&redirect=no) a lot.
To avoid confusion, what follows are some definitions of terms we use throughout
this book. Where possible, we're trying to adhere to the same usage as the
official documentation, or sometimes a definition that's been widely adopted by
the Swift community. Many of these definitions are covered in more detail in
later chapters, so don't worry if not everything makes sense on first reading.
If you're already familiar with all of these terms, it's still best to skim
through to make sure your accepted meanings don't differ from ours.

In Swift, we make the distinctions between values, variables, references, and
constants.

A **value** is immutable and forever — it never changes. For example, `1`,
`true`, and `[1,2,3]` are all values. These are examples of **literals**, but
values can also be generated at runtime. The number you get when you square the
number five is a value.

When we assign a value to a name using `var x = [1,2]`, we're creating a
**variable** named `x` that holds the value `[1,2]`. By changing `x`, e.g. by
performing `x.append(3)`, we didn't change the original value. Rather, we
replaced the value that `x` holds with the new value, `[1,2,3]` — at least
*logically*, if not in the actual implementation (which might actually just tack
a new entry on the back of some existing memory). We refer to this as
**mutating** the variable.

We can declare **constant** variables (constants, for short) with `let` instead
of `var`. Once a constant has been assigned a value, it can never be assigned a
new value.

We also don't need to give a variable a value immediately. We can declare the
variable first (`let x: Int`) and then later assign a value to it (`x = 1`).
Swift, with its emphasis on safety, will check that all possible code paths lead
to a variable being assigned a value before its value can be read. There's no
concept of a variable having an as-yet-undefined value. Of course, if the
variable was declared with `let`, it can only be assigned to once.

Structs and enums are **value types**. When you assign one struct variable to
another, the two variables will then contain the same value. You can think of
the contents as being copied, but it's more accurate to say that one variable
was changed to contain the same value as the other.

A **reference** is a special kind of value: a value that "points to" another
value. Because two references can refer to the same value, this introduces the
possibility of that value getting mutated by two different parts of the program
at once.

Classes are **reference types**. You can't hold an instance of a class (which we
might occasionally call an **object** — a term fraught with troublesome
overloading\!) directly in a variable. Instead, you must hold a reference to it
in a variable and access it via that reference.

Reference types have **identity** — you can check if two variables are referring
to the exact same object by using `===`. You can also check if they're equal,
assuming `==` is implemented for the relevant type. Two objects with different
identity can still be equal.

Value types don't have identity. You can't check if a particular variable holds
the "same" number 2 as another. You can only check if they both contain the
value 2. `===` is really asking: "Do both these variables hold the same
reference as their value?" In programming language literature, `==` is sometimes
called *structural equality*, and `===` is called *pointer equality* or
*reference equality*.

Class references aren't the only kind of reference in Swift. For example, there
are also pointers, accessed through `withUnsafeMutablePointer` functions and the
like. But classes are the simplest reference type to use, in part because their
reference-like nature is partially hidden from you by syntactic sugar. You don't
need to do any explicit "dereferencing" like you do with pointers in some other
languages. (We'll cover the other kind of references in more detail in the
chapter on interoperability.)

A variable that holds a reference can be declared with `let` — that is, the
reference is constant. This means that the variable can never be changed to
refer to something else. But — and this is important — it *doesn't* mean that
the object it *refers to* can't be changed. So when referring to a variable as a
constant, be careful — it's only constant in what it points to. It doesn't mean
what it points to is constant. (Note: if those last few sentences sound like
doublespeak, don't worry, as we cover this again in the chapter on structs and
classes). Unfortunately, this means that when looking at a declaration of a
variable with `let`, you can't tell at a glance whether or not what's being
declared is completely immutable. Instead, you have to *know* whether it's
holding a value type or a reference type.

We refer to types as having **value semantics** to distinguish a value type that
performs a *deep copy*. This copy can occur eagerly (whenever a new variable is
introduced) or lazily (whenever a variable gets mutated).

Here we hit another complication. If our struct contains reference types, the
reference types won't automatically get copied upon assigning the struct to a
new variable. Instead, the references themselves get copied. This is called a
*shallow copy*.

For example, the `Data` struct in Foundation is a wrapper around the `NSData`
reference type. However, the authors of the `Data` struct took extra steps to
also perform a deep copy of the `NSData` object whenever the `Data` struct is
mutated. They do this efficiently using a technique called copy-on-write, which
we'll explain in the chapter on structs and classes. For now, it's important to
know that this behavior doesn't come for free.

The collections in Swift are also wrapping reference types and use copy-on-write
to efficiently provide value semantics. However, if the elements in a collection
are references (for example, an array containing objects), the objects won't get
copied. Instead, only the references get copied. This means that a Swift array
only has value semantics if its elements have value semantics too.

Some classes are completely immutable — that is, they provide no methods for
changing their internal state after they're created. This means that even though
they're classes, they also have value semantics (because even if they're shared,
they can never change). Be careful though — only `final` classes can be
guaranteed not to be subclassed with added mutable state.

In Swift, functions are also values. You can assign a function to a variable,
have an array of functions, and call the function held in a variable. Functions
that take other functions as arguments (such as `map`, which takes a function to
transform every element of a sequence) or return functions are referred to as
**higher-order functions**.

Functions don't have to be declared at the top level — you can declare a
function within another function or in a `do` or other scope. Functions defined
within an outer scope, but passed out from it (say, as the returned value of a
function), can "capture" local variables, in which case those local variables
aren't destroyed when the local scope ends, and the function can hold state
through them. This behavior is called "closing over" variables, and functions
that do this are called **closures**.

Functions can be declared either with the `func` keyword or by using a shorthand
`{ }` syntax called a **closure expression**. Sometimes this gets shortened to
"closures," but don't let it give you the impression that only closure
expressions can be closures. Functions declared with the `func` keyword are also
closures when they close over external variables.

Functions are held by reference. This means assigning a function that has
captured state to another variable doesn't copy that state; it shares it,
similar to object references. What's more is that when two closures close over
the same local variable, they both share that variable, so they share state.
This can be quite surprising, and we'll discuss this more in the chapter on
functions.

Functions defined inside a class or protocol are **methods**, and they have an
implicit `self` parameter. Sometimes we call functions that aren't methods
**free functions**. This is to distinguish them from methods.

A fully qualified function name in Swift includes not just the function's base
name (the part before the parentheses), but also the argument labels. For
example, the full name of the method for moving a collection index by a number
of steps is `index(_:offsetBy:)`, indicating that this function takes two
arguments (represented by the two colons), the first one of which has no label
(represented by the underscore). We often omit the labels in the book if it's
clear from the context what function we're referring to (the compiler allows you
to do the same).

Free functions, and methods called on structs, are **statically dispatched**.
This means the function that'll be called is known at compile time. It also
means the compiler might be able to **inline** the function, i.e. not call the
function at all, but instead replace it with the code the function would
execute. The optimizer can also discard or simplify code that it can prove at
compile time won't actually run.

Methods on classes or protocols might be **dynamically dispatched**. This means
the compiler doesn't necessarily know at compile time which function will run.
This dynamic behavior is done either by using
[vtables](https://en.wikipedia.org/wiki/Virtual_method_table) (similar to how
Java or C++ dynamic dispatch work), or in the case of some `@objc` classes and
protocols, by using selectors and `objc_msgSend`.

Subtyping and method **overriding** is one way of getting **polymorphic**
behavior, i.e. behavior that varies depending on the types involved. A second
way is function **overloading**, where a function is written multiple times for
different types. (It's important not to mix up overriding and overloading, as
they behave very differently.) A third way is via generics, where a function or
method is written once to take any type that provides certain functions or
methods, but the implementations of those functions can vary. Unlike method
overriding, the results of function overloading and generics are known
statically at compile time. We'll cover this more in the generics chapter.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
