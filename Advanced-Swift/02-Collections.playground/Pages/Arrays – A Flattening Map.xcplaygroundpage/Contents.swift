/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### A Flattening Map

Sometimes, you want to map an array where the transformation function returns
another array and not a single element.

For example, let's say we have a function, `links`, which reads a Markdown file
and returns an array containing the URLs of all the links in the file. The
function type looks like this:

``` swift-example
func extractLinks(markdownFile: String) -> [URL]
```

If we have a bunch of Markdown files and want to extract the links from all
files into a single array, we could try to write something like
`markdownFiles.map(extractLinks)`. But this returns an array of arrays
containing the URLs: one array per file. Now you could just perform the `map`,
get back an array of arrays, and then call `joined` to flatten the results into
a single array:

``` swift-example
let markdownFiles: [String] = // ...
let nestedLinks = markdownFiles.map(extractLinks)
let links = nestedLinks.joined()
```

The `flatMap` method combines these two operations into a single step. So
`markdownFiles.flatMap(extractLinks)` returns all the URLs in an array of
Markdown files as a single array.

The signature for `flatMap` is almost identical to `map`, except its
transformation function returns an array. The implementation uses
`append(contentsOf:)` instead of `append(_:)` to flatten the result array:

*/

extension Array {
    func flatMap_sample_impl<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}

/*:
Another great use case for `flatMap` is combining elements from different
arrays. To get all possible pairs of two arrays, `flatMap` over one array and
then `map` over the other:

*/

let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]
let result = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
