/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Autocompletion Using Tries

Now that we've seen binary trees, this last section will cover a more advanced
and purely functional data structure. Suppose that we want to write our own
autocompletion algorithm — given a history of searches and the prefix of the
current search, we should compute an array of possible completions.

Using arrays, the solution is entirely straightforward:

*/

extension String {
    func complete(history: [String]) -> [String] {
        return history.filter { $0.hasPrefix(self) }
    }
}

/*:
Unfortunately, this function isn't very efficient. For large histories and long
prefixes, it may be too slow. Once again, we could improve performance by
keeping the history sorted and using some kind of binary search on the history
array. Instead, we'll explore a different solution, using a custom data
structure tailored for this kind of query.

*Tries*, also known as digital search trees, are a particular kind of ordered
tree. Typically, tries are used to look up a string, which consists of a list of
characters. Instead of storing strings in a binary search tree, it can be more
efficient to store them in a structure that repeatedly branches over the
strings' constituent characters.

Previously, the `BinarySearchTree` type had two subtrees at every node. Tries,
on the other hand, don't have a fixed number of subtrees at every node, but
instead (potentially) have subtrees for every character. For example, we could
visualize a trie storing the string "cat," "car," "cart," and "dog" as follows:

![Trie](artwork/trie.png)

To determine if the string "care" is in the trie, we follow the path from the
root, along the edges labeled 'c,' 'a,' and 'r.' As the node labeled 'r' doesn't
have a child labeled with 'e,' the string "care" isn't in this trie. The string
"cat" is in the trie, as we can follow a path from the root along edges labeled
'c,' 'a,' and 't.'

How can we represent such tries in Swift? As a first attempt, we write a struct
storing a dictionary, mapping characters to subtries at every node:

``` highlight-swift
struct Trie {
    let children: [Character: Trie]
}
```

There are two improvements we'd like to make to this definition. First of all,
we need to add some additional information to the node. From the example trie
above, you can see that by adding "cart" to the trie, all the prefixes of "cart"
— namely "c," "ca," and "car" — also appear in the trie. As we may want to
distinguish between prefixes that are or aren't in the trie, we'll add an
additional boolean, `isElement`, to every node. This boolean indicates whether
or not the current string is in the trie. Finally, we can define a generic trie
that's no longer restricted to only storing characters. Doing so yields the
following definition of tries:

*/

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Trie<Element>]
}

/*:
In the text that follows, we'll sometimes refer to the keys of type `[Element]`
as strings and values of type `Element` as characters. This isn't very precise —
as `Element` can be instantiated with a type different than characters, and a
string isn't the same as `[Character]` — but we hope it does appeal to the
intuition of tries storing a collection of strings.

Before defining our autocomplete function on tries, we'll write a few simple
definitions to warm up. For example, the empty trie consists of a node with an
empty dictionary:

*/

extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

/*:
If we had chosen to set the `isElement` boolean stored in the empty trie to
`true` rather than `false`, the empty string would be a member of the empty trie
— which is probably not the behavior we want.

Next, we define a property to flatten a trie into an array containing all its
elements:

*/

extension Trie {
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map { [key] + $0 }
        }
        return result
    }
}

/*:
This function is a bit tricky. It starts by checking whether or not the current
root is marked as a member of the trie. If it is, the trie contains the empty
key; if it isn't, the `result` variable is initialized to the empty array. Next,
it traverses the dictionary, computing the elements of the subtries — this is
done by the call to `value.elements`. Finally, the 'character' associated with
every subtrie is added to the front of the elements of that subtrie — this is
taken care of by the `map` function. We could've implemented the `elements`
property using `flatMap` instead of a `for` loop, but we believe the code is a
bit clearer like this.

Next, we'd like to define lookup and insertion functions. Before we do so,
however, we'll need a few auxiliary functions. We've represented keys as an
array. While our tries are defined as (recursive) structs, arrays aren't. Yet it
can still be useful to traverse an array recursively. To make this a bit easier,
we define the following two extensions:

*/

extension Array {
   var slice: ArraySlice<Element> {
       return ArraySlice(self)
   }
}

extension ArraySlice {
    var decomposed: (Element, ArraySlice<Element>)? {
        return isEmpty ? nil : (self[startIndex], self.dropFirst())
    }
}

/*:
The `decomposed` property checks whether or not an array slice is empty. If it's
empty, it returns `nil`; if the slice isn't empty, it returns a tuple containing
the first element of the slice, along with the slice itself without its first
element. We can recursively traverse an array by repeatedly calling `decompose`
on a slice until it returns `nil` and the array is empty.

> We've defined `decomposed` on `ArraySlice`, rather than on `Array`, for
> performance reasons. The `dropFirst` method on `Array`s has a complexity of
> `O(n)`, whereas `dropFirst` on an `ArraySlice` only has a complexity of
> `O(1)`. Therefore, this version of `decomposed` is also `O(1)`.

For example, we can use the `decomposed` function to sum the elements of an
array slice recursively, without using a `for` loop or `reduce`:

*/

func sum(_ integers: ArraySlice<Int>) -> Int {
    guard let (head, tail) = integers.decomposed else { return 0 }
    return head + sum(tail)
}

sum([1,2,3,4,5].slice)

/*:
Back to our original problem — we can now use the `decomposed` helper on slices
to write a lookup function that, given a slice of `Element`s, traverses a trie
to determine whether or not the corresponding key is stored:

*/

extension Trie {
    func lookup(key: ArraySlice<Element>) -> Bool {
        guard let (head, tail) = key.decomposed else { return isElement }
        guard let subtrie = children[head] else { return false }
        return subtrie.lookup(key: tail)
    }
}

/*:
Here we can distinguish three cases:

  - The key is empty — in this case, we return `isElement`, the boolean
    indicating whether or not the string described by the current node is in the
    trie.

  - The key is non-empty, but the corresponding subtrie doesn't exist — in this
    case, we simply return `false`, as the key isn't included in the trie.

  - The key is non-empty — in this case, we look up the subtrie corresponding to
    the first element of the key. If this also exists, we make a recursive call,
    looking up the tail of the key in this subtrie.

We can adapt `lookup` to return the subtrie, containing all the elements that
have some prefix:

*/

extension Trie {
    func lookup(key: ArraySlice<Element>) -> Trie<Element>? {
        guard let (head, tail) = key.decomposed else { return self }
        guard let remainder = children[head] else { return nil }
        return remainder.lookup(key: tail)
    }
}

/*:
The only difference with the `lookup` function is that we no longer return the
`isElement` boolean, but instead return the whole subtrie, containing all the
elements with the argument prefix.

Finally, we can redefine our `complete` function to use the more efficient tries
data structure:

*/

extension Trie {
    func complete(key: ArraySlice<Element>) -> [[Element]] {
        return lookup(key: key)?.elements ?? []
    }
}

/*:
To compute all the strings in a trie with a given prefix, we simply call the
`lookup` method and extract the elements from the resulting trie, if it exists.
If there's no subtrie with the given prefix, we simply return an empty array.

We can use the same pattern of decomposing the key to create tries. For example,
we can create a new trie storing only a single element, as follows:

*/

extension Trie {
    init(_ key: ArraySlice<Element>) {
        if let (head, tail) = key.decomposed {
            let children = [head: Trie(tail)]
            self = Trie(isElement: false, children: children)
        } else {
            self = Trie(isElement: true, children: [:])
        }
    }
}

/*:
We distinguish two cases:

  - If the input key is non-empty and can be decomposed in a `head` and `tail`,
    we recursively create a trie from the `tail`. We then create a new
    dictionary of children, storing this trie at the `head` entry. Finally, we
    create the trie from the dictionary, and as the input key is non-empty, we
    set `isElement` to `false`.

  - If the input key is empty, we create a new empty trie, storing the empty
    string (`isElement: true`) with no children.

To populate a trie, we define the following insertion function:

*/

extension Trie {
    func inserting(_ key: ArraySlice<Element>) -> Trie<Element> {
        guard let (head, tail) = key.decomposed else {
            return Trie(isElement: true, children: children)
        }
        var newChildren = children
        if let nextTrie = children[head] {
            newChildren[head] = nextTrie.inserting(tail)
        } else {
            newChildren[head] = Trie(tail)
        }
        return Trie(isElement: isElement, children: newChildren)
    }
}


/*:
The insertion function distinguishes three cases:

  - If the key is empty, we set `isElement` to `true` and leave the remainder of
    trie unmodified.

  - If the key is non-empty and the `head` of the key already occurs in the
    `children` dictionary at the current node, we simply make a recursive call,
    inserting the `tail` of the key in the next trie.

  - If the key is non-empty and its first element, `head`, does not yet have an
    entry in the trie's `children` dictionary, we create a new trie storing the
    remainder of the key. To complete the insertion, we associate this trie with
    the `head` key at the current node.

As an exercise, you can rewrite the `insert` as a `mutating` function.

### String Tries

In order to use our autocompletion algorithm, we can now write a few wrappers
that make working with string tries a bit easier. First, we can write a simple
wrapper to build a trie from a list of words. It starts with the empty trie and
then inserts each word, yielding a trie with all the words combined. Because our
tries work on arrays, we need to convert every string into an array slice of
characters. Alternatively, we could write a variant of `insert` that works on
any `Sequence`:

*/

extension Trie {
    static func build(words: [String]) -> Trie<Character> {
        let emptyTrie = Trie<Character>()
        return words.reduce(emptyTrie) { trie, word in
            trie.inserting(Array(word.characters).slice)
        }
    }
}

/*:
Finally, to get a list of all our autocompleted words, we can call our
previously defined `complete` method, turning the result back into strings. Note
how we prepend the input string to each result. This is because the `complete`
method only returns the rest of the word, excluding the common prefix:

*/

extension String {
    func complete(_ knownWords: Trie<Character>) -> [String] {
        let chars = Array(characters).slice
        let completed = knownWords.complete(key: chars)
        return completed.map { chars in
            self + String(chars)
        }
    }
}

/*:
To test our functions, we can use a simple list of words, build a trie, and list
the autocompletions:

*/

let contents = ["cat", "car", "cart", "dog"]
let trieOfWords = Trie<Character>.build(words: contents)
"car".complete(trieOfWords)

/*:
Currently, our interface only allows us to insert array slices. It's easy to
create an alternative `inserting` method that allows us to insert any kind of
collection. The type signature would be more complicated, but the body of the
function would stay the same.

``` swift-example
func inserting<S: Sequence>(key: Seq) -> Trie<Element>
    where S.Iterator.Element == Element
```

It's very easy to make the `Trie` data type conform to `Sequence`, which will
add a lot of functionality: it automatically provides functions like `contains`,
`filter`, `map`, and `reduce` on the elements. We'll look at `Sequence` in more
detail in the chapter on iterators and sequences.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
