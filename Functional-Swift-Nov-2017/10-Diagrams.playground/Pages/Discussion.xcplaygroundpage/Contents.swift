/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Discussion

The code in this chapter is inspired by the Diagrams library for Haskell
\[@yorgey\]. Although we can draw simple diagrams, there are many possible
improvements and extensions to the library we've presented here. Some things are
still missing but can be added easily. For example, it's straightforward to add
more attributes and styling options. A bit more complicated would be adding
transformations (such as rotation), but this is certainly still possible.

When we compare the library that we've built in this chapter to the library in
Chapter 2, we can see many similarities. Both take a problem domain (regions and
diagrams) and create a small library of functions to describe this domain. Both
libraries provide an interface through functions that are highly composable.
Both of these little libraries define a *domain-specific language* (or DSL)
embedded in Swift. A DSL is a small programming language tailored to solve a
particular problem.

You're probably already familiar with lots of DSLs, such as regular expressions,
SQL, or HTML — each of these languages isn't a general-purpose programming
language in which to write *any* application, but instead is more restricted to
solve a particular kind of problem. Regular expressions are used for describing
patterns or lexers, SQL is used for querying a database, and HTML is used for
describing the content of a webpage.

However, there's an important difference between the two DSLs we've built in
this book: in the chapter on thinking functionally, we created functions that
return a boolean for each position. To draw the diagrams, we built up an
intermediate structure, the `Diagram` enum. A *shallow embedding* of a DSL in a
general-purpose programming language like Swift does not create any intermediate
data structures. A *deep embedding*, on the other hand, explicitly creates an
intermediate data structure, like the `Diagram` enumeration described in this
chapter.

The term embedding refers to how the DSL for regions or diagrams are embedded
into Swift. Both have their advantages. A shallow embedding can be easier to
write, there's less overhead during execution, and it can be easier to extend
with new functions. However, when using a deep embedding, we have the advantage
of analyzing an entire structure, transforming it, or assigning different
meanings to the intermediate data structure.

If we'd rewrite the DSL from Chapter 2 to instead use deep embedding, we'd need
to define an enumeration representing the different functions from the library.
There would be members for our primitive regions, like circles or squares, and
members for composite regions, such as those formed by intersection or union. We
could then analyze and compute with these regions in different ways: generating
images, checking whether or not a region is primitive, determining whether or
not a given point is in the region, or performing an arbitrary computation over
the intermediate data structure.

Rewriting the diagrams library from this chapter to a shallow embedding would be
complicated. The intermediate data structure can be inspected, modified, and
transformed. To define a shallow embedding, we'd need to call Core Graphics
directly for every operation that we wish to support in our DSL. It's much more
difficult to compose drawing calls than it is to first create an intermediate
structure and only render it once the diagram has been completely assembled.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
