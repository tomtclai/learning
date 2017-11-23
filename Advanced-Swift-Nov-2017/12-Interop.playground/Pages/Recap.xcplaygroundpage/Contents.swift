/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

Rewriting an existing C library from scratch in Swift is certainly fun, but it
may not be the best use of your time (unless you're doing it for learning, which
is totally awesome). There's a lot of well-tested C code out there, and throwing
it all out would be a huge waste. Swift is great at interfacing with C code, so
why not make use of it? Having said that, there's no denying that most C APIs
feel very foreign in Swift. Moreover, it's probably not a good idea to spread C
constructs like pointers and manual memory management across your entire code
base.

Writing a small wrapper that handles the unsafe parts internally and exposes an
idiomatic Swift interface — as we did in this chapter for the Markdown library —
gives you the best of both worlds: you don't have to reinvent the wheel (i.e.
write a complete Markdown parser) and yet it feels 100 percent native to
developers using the API.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
