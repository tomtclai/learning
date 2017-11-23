/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Notes

The history of generics traces back to @strachey, Girard's *System F*
\[-@girard\], and @reynolds-polymorphism. Note that these authors refer to
generics as (parametric) polymorphism, a term that's still used in many other
functional languages. Many object-oriented languages use the term polymorphism
to refer to implicit casts arising from subtyping, so the term generics was
introduced to disambiguate between the two concepts.

The process we sketched informally above that explains why there can only be one
possible function with the generic type

``` highlight-swift
(f: (A) -> B, g: (B) -> C) -> (A) -> C
```

can be made mathematically precise. This was first done by
@reynolds-parametricity; later, @wadler referred to this as *Theorems for
free\!* — emphasizing how you can compute a theorem about a generic function
from its type.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
