/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Hands-On: Wrapping CommonMark 

Swift's ability to call into C code allows us to take advantage of the abundance
of existing C libraries. Writing a wrapper around an existing library's
interface in Swift is often much easier and involves less work than building
something from scratch; meanwhile, users of our wrapper will see no difference
in terms of type safety or ease of use compared to a fully native solution. All
we need to start is the dynamic library and its C header files.

Our example, the CommonMark C library, is a reference implementation of the
CommonMark spec that's both fast and well tested. We'll take a layered approach
in order to make CommonMark accessible from Swift. First, we'll create a very
thin Swift class around the opaque types the library exposes. Then, we'll wrap
this class with Swift enums in order to provide a more idiomatic API.

### Setup

Setting up a C library so that it can be imported from a Swift project is a
little complicated. Here's a quick rundown of the required steps.

The first step is to install the [cmark
library](https://github.com/commonmark/cmark). We use
[Homebrew](https://brew.sh) as our package manager on macOS to do this:

    $ brew install cmark

At the time of writing, cmark 0.28.2 was the most recent version.

In C, you'd now `#include` one or more of the library's header files to make
their declarations visible to your own code. Swift can't handle C header files
directly; it expects dependencies to be *modules*. For a C or Objective-C
library to be visible to the Swift compiler, the library must provide a *module
map* in the [Clang modules](https://clang.llvm.org/docs/Modules.html) format.
Among other things, the module map lists the header files that make up the
module.

Since cmark doesn't come with a module map, your next task is to make one.
You'll create a package for the Swift Package Manager that won't contain any
code; its only purpose is to act as the module wrapper for the cmark library.

Create a directory for the package and then call `swift package init`, telling
the package manager to create the scaffolding for a *system module*:

    $ mkdir Ccmark
    $ cd Ccmark
    $ swift package init --type system-module

In SwiftPM lingo, *system packages* are libraries installed by systemwide
package managers, such as Homebrew, or APT on Linux. A system module is any
SwiftPM package that refers to such a library. By convention, the names of pure
wrapper modules such as this should be prefixed with `C`.

Edit `Package.swift` to look like this:

``` swift-example
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Ccmark",
    pkgConfig: "libcmark",
    providers: [
        .brew(["cmark"])
    ]
)
```

The `pkgConfig` parameter specifies the name of the
[config](https://en.wikipedia.org/wiki/Pkg-config) file where the package
manager can find the header and library search paths for the imported library.
The `providers` directive is optional. It's an installation hint the package
manager can display when the target library isn't installed.

Before you edit the module map, create a C header file named `shim.h`. It should
contain only the following line:

``` c
#include <cmark.h>
```

Finally, the `module.modulemap` file should look like this:

    module Ccmark [system] {
        header "shim.h"
        link "cmark"
        export *
    }

The shim header works around the limitation that module maps must contain
absolute paths. Alternatively, you could've omitted the shim and specified the
cmark header directly in the module map, as in `header
"/usr/local/include/cmark.h"`. But then the path of `cmark.h` would be hardcoded
into the module map. With the shim, the package manager reads the correct header
search path from the pkg-config file and adds it to the compiler invocation.

The final step for the Ccmark package is to commit everything to a Git
repository:

    $ git init
    $ git add .
    $ git commit -m "Initial commit"

This is necessary because you'll now create a second package which imports
`Ccmark`, and the package manager requires a Git branch or tag name for each
dependency.

Create another directory next to the `Ccmark` directory and call `swift package
init` once more, this time for an executable:

    $ cd ..
    $ mkdir CommonMarkExample
    $ cd CommonMarkExample
    $ swift package init --type executable

You'll need to add the `Ccmark` dependency to the package manifest:

``` swift-example
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CommonMarkExample",
    dependencies: [
        .package(url: "../Ccmark", .branch("master")),
    ],
    targets: [
        .target(
            name: "CommonMarkExample",
            dependencies: []),
    ]
)
```

Notice that we're using a relative file system path to refer to `Ccmark`. If you
want to make this accessible to other team members, push the `Ccmark` repository
to a server and replace its URL here.

Now you should be able to `import Ccmark` and call any cmark API. Add the
following snippet to `main.swift` for a quick test to see if everything works:

``` swift-example
import Ccmark

let markdown = "*Hello World*"
let cString = cmark_markdown_to_html(markdown, markdown.utf8.count, 0)!
let html = String(cString: cString)
print(html)
```

Back in Terminal, run the program:

    $ swift run

If you see `<p><em>Hello World</em></p>` as the output, you just successfully
called a C function from Swift\! Now that we have a working installation, we can
start writing our Swift wrapper.

### Wrapping the C Library

Let's begin by wrapping a single function with a nicer interface. The
`cmark_markdown_to_html` function takes in Markdown-formatted text and returns
the resulting HTML code in a string. The C interface looks like this:

``` c
/// Convert 'text' (assumed to be a UTF-8 encoded string with length
/// 'len') from CommonMark Markdown to HTML, returning a null-terminated,
/// UTF-8-encoded string. It is the caller's responsibility
/// to free the returned buffer.
char *cmark_markdown_to_html(const char *text, size_t len, int options);
```

When Swift imports this declaration, it presents the C string in the first
parameter as an `UnsafePointer` to a number of `Int8` values. From the
documentation, we know that these are expected to be UTF-8 code units. The `len`
parameter takes the length of the string:

``` swift-example
// The function's interface in Swift
func cmark_markdown_to_html
    (_ text: UnsafePointer<Int8>!, _ len: Int, _ options: Int32)
    -> UnsafeMutablePointer<Int8>!
```

We want our wrapper function to work with Swift strings, of course, so you might
think that we need to convert the Swift string into an `Int8` pointer before
passing it to `cmark_markdown_to_html`. However, bridging between native and C
strings is such a common operation that Swift will do this automatically. We do
have to be careful with the `len` parameter, as the function expects the length
of the UTF-8-encoded string in bytes, and not the number of characters. We get
the correct value from the string's `utf8` view, and we can just pass in zero
for the options:

``` swift-example
func markdownToHtml(input: String) -> String {
    let outString = cmark_markdown_to_html(input, input.utf8.count, 0)!
    defer { free(outString) }
    return String(cString: outString)
}
```

Notice that we force-unwrap the string pointer the function returns. We can
safely do this because we know that `cmark_markdown_to_html` always returns a
valid string. By force-unwrapping inside the method, the library user can call
the `markdownToHtml` method without having to worry about optionals — the result
would never be `nil` anyway. This is something the compiler can't do
automatically for us — C and Objective-C pointers without [nullability
annotations](https://clang.llvm.org/docs/AttributeReference.html#nullability-attributes)
are always imported into Swift as implicitly unwrapped optionals.

> The automatic bridging of native Swift strings to C strings assumes that the C
> function you want to call expects the string to be UTF-8 encoded. This is the
> correct choice in most cases, but if the C API assumes a different encoding,
> you can't use the automatic bridging. However, it's often quite easy to
> construct alternative formats. For example, if the C API expects an array of
> UTF-16 code points, you can use `Array(string.utf16)`. The Swift compiler will
> automatically bridge the Swift array to the expected C array, provided that
> the element types match.

#### Wrapping the `cmark_node` Type

In addition to the straight HTML output, the `cmark` library also provides a way
to parse a Markdown text into a structured tree of elements. For example, a
simple text could be transformed into a list of block-level nodes such as
paragraphs, quotes, lists, code blocks, headers, and so on. Some block-level
elements contain other block-level elements (for example, quotes can contain
multiple paragraphs), whereas others contain only inline elements (for example,
a header can contain a part that's emphasized). No element can contain both (for
example, the inline elements of a list item are always wrapped in a paragraph
element).

The C library uses a single data type, `cmark_node`, to represent the nodes.
It's opaque, meaning the authors of the library chose to hide its definition.
All we see in the headers are functions that operate on or return pointers to
`cmark_node`. Swift imports these pointers as `OpaquePointer`s. (We'll take a
closer look at the differences between the many pointer types in the standard
library, such as `OpaquePointer` and `UnsafeMutablePointer`, later in this
chapter.)

> In the future, we might be able to use the "[import as
> member](https://github.com/apple/swift-evolution/blob/master/proposals/0044-import-as-member.md)"
> feature of Swift to import these functions as methods on `cmark_node`. Apple
> has used this to provide more "object-oriented" APIs for Core Graphics and
> Grand Central Dispatch in Swift. It works by annotating the C source code with
> the `swift_name` attribute. Alas, this feature doesn't really work for the
> cmark library yet. It might work for your own C library. There are some bugs
> around import as member, for example, it doesn't always work with opaque
> pointers (which is exactly what's used in cmark).

Let's wrap a node in a native Swift type to make it easier to work with. As we
saw in the chapter on structs and classes, we need to think about value
semantics whenever we create a custom type: is the type a value, or does it make
sense for instances to have identity? In the former case, we should favor a
struct or enum, whereas the latter requires a class. Our case is interesting: on
one hand, the node of a Markdown document is a value — two nodes that have the
same element type and contents should be indistinguishable, hence they shouldn't
have identity. On the other hand, since we don't know the internals of
`cmark_node`, there's no straightforward way to make a copy of a node, so we
can't guarantee value semantics. For this reason, we start with a class. Later
on, we'll write another layer on top of this class to provide an interface with
value semantics.

Our class simply stores the opaque pointer and frees the memory `cmark_node`
uses on `deinit` when there are no references left to an instance of this class.
We only free memory at the document level, because otherwise we might free nodes
that are still in use. Freeing the document will also automatically free all the
children recursively. Wrapping the opaque pointer in this way will give us
automatic reference counting for free:

``` swift-example
public class Node {
    let node: OpaquePointer

    init(node: OpaquePointer) {
        self.node = node
    }

    deinit {
        guard type == CMARK_NODE_DOCUMENT else { return }
        cmark_node_free(node)
    }
}
```

The next step is to wrap the `cmark_parse_document` function, which parses a
Markdown text and returns the document's root node. It takes the same arguments
as `cmark_markdown_to_html`: the string, its length, and an integer describing
parse options. The return type of the `cmark_parse_document` function in Swift
is `OpaquePointer`, which represents the node:

``` swift-example
func cmark_parse_document
    (_ buffer: UnsafePointer<Int8>!, _ len: Int, _ options: Int32)
    -> OpaquePointer!
```

We turn the function into an initializer for our class. Note that the function
can return `nil` if parsing fails. Therefore, our initializer should be failable
and return `nil` (the optional value, not the null pointer) if this occurs:

``` swift-example
public init?(markdown: String) {
    guard let node = cmark_parse_document(markdown, 
        markdown.utf8.count, 0) else { return nil }
    self.node = node
}
```

As mentioned above, there are a couple of interesting functions that operate on
nodes. For example, there's one that returns the type of a node, such as
paragraph or header:

``` c
cmark_node_type cmark_node_get_type(cmark_node *node);
```

In Swift, it looks like this:

``` swift-example
func cmark_node_get_type(_ node: OpaquePointer!) -> cmark_node_type
```

`cmark_node_type` is a C enum that has cases for the various block-level and
inline elements that are defined in Markdown, as well as one case to signify
errors:

``` c
typedef enum {
    // Error status
    CMARK_NODE_NONE,

    // Block
    CMARK_NODE_DOCUMENT,
    CMARK_NODE_BLOCK_QUOTE,
    ...

    // Inline
    CMARK_NODE_TEXT,
    CMARK_NODE_EMPH,
    ...
} cmark_node_type;
```

Swift imports plain C enums as structs containing a single `UInt32` property.
Additionally, for every case in an enum, a global variable is generated:

``` swift-example
struct cmark_node_type : RawRepresentable, Equatable {
    public init(_ rawValue: UInt32)
    public init(rawValue: UInt32)
    public var rawValue: UInt32
}

var CMARK_NODE_NONE: cmark_node_type { get }
var CMARK_NODE_DOCUMENT: cmark_node_type { get }
...
```

> Only enums marked with the `NS_ENUM` macro, used by Apple in its Objective-C
> frameworks, are imported as native Swift enumerations. Additionally, library
> authors can annotate their enum cases with `swift_name` to make them member
> variables.

In Swift, the type of a node should be a property of the `Node` data type, so we
turn the `cmark_node_get_type` function into a computed property of our class:

``` swift-example
var type: cmark_node_type {
    return cmark_node_get_type(node)
}
```

Now we can just write `node.type` to get an element's type.

There are a couple more node properties we can access. For example, if a node is
a list, it can have one of two list types: bulleted or ordered. All other nodes
have the list type "no list." Again, Swift represents the corresponding C enum
as a struct, with a top-level variable for each case, and we can write a similar
wrapper property. In this case, we also provide a setter, which will come in
handy later in this chapter:

``` swift-example
var listType: cmark_list_type {
    get { return cmark_node_get_list_type(node) }
    set { cmark_node_set_list_type(node, newValue) }
}
```

There are similar functions for all the other node properties (such as header
level, fenced code block info, and link URLs and titles). These properties often
only make sense for specific types of nodes, and we can choose to provide an
interface either with an optional (e.g. for the link URL) or with a default
value (e.g. the default header level is zero). This illustrates a major weakness
of the library's C API that we can model much better in Swift. We'll talk more
about this below.

Some nodes can also have children. For iterating over them, the CommonMark
library provides the functions `cmark_node_first_child` and `cmark_node_next`.
We want our `Node` class to provide an array of its children. To generate this
array, we start with the first child and keep adding children until either
`cmark_node_first_child` or `cmark_node_next` returns `nil`, signaling the end
of the list. Note that this C null pointer automatically gets converted to an
optional:

``` swift-example
var children: [Node] {
    var result: [Node] = []
    var child = cmark_node_first_child(node)
    while let unwrapped = child {
        result.append(Node(node: unwrapped))
        child = cmark_node_next(child)
    }
    return result
}
```

We could also have chosen to return a lazy sequence rather than an array (for
example, by using `sequence` or `AnySequence`). However, there's a problem with
this: the node structure might change between creation and consumption of the
sequence. In that case, the iterator for finding the next node would return
wrong values, or even worse, crash. Depending on your use case, returning a
lazily constructed sequence might be exactly what you want, but if your data
structure can change, returning an array is a much safer choice.

With this simple wrapper class for nodes, accessing the abstract syntax tree
produced by the CommonMark library from Swift becomes a lot easier. Instead of
having to call functions like `cmark_node_get_list_type`, we can just write
`node.listType` and get autocompletion and type safety. However, we aren't done
yet. Even though the `Node` class feels much more native than the C functions,
Swift allows us to express a node in an even more natural and safer way, using
enums with associated values.

### A Safer Interface

As we mentioned above, there are many node properties that only apply in certain
contexts. For example, it doesn't make any sense to access the `headerLevel` of
a list or the `listType` of a code block. Enumerations with associated values
allow us to specify only the metadata that makes sense for each specific case.
We'll create one enum for all possible inline elements, and another one for
block-level items. That way, we can enforce the structure of a CommonMark
document. For example, a plain text element just stores a `String`, whereas
emphasis nodes contain an array of other inline elements. These enumerations
will be the public interface to our library, turning the `Node` class into an
internal implementation detail:

``` swift-example
public enum Inline {
    case text(text: String)
    case softBreak
    case lineBreak
    case code(text: String)
    case html(text: String)
    case emphasis(children: [Inline])
    case strong(children: [Inline])
    case custom(literal: String)
    case link(children: [Inline], title: String?, url: String?)
    case image(children: [Inline], title: String?, url: String?)
}
```

Similarly, paragraphs and headers can only contain inline elements, whereas
block quotations always contain other block-level elements. A list is defined as
an array of list items, where each list item is represented by an array of
`Block` elements:

``` swift-example
public enum Block {
    case list(items: [[Block]], type: ListType)
    case blockQuote(items: [Block])
    case codeBlock(text: String, language: String?)
    case html(text: String)
    case paragraph(text: [Inline])
    case heading(text: [Inline], level: Int)
    case custom(literal: String)
    case thematicBreak
}
```

The `ListType` is just a simple enum that states whether a list is ordered or
unordered:

``` swift-example
public enum ListType {
    case unordered
    case ordered
}
```

Since enums are value types, this also lets us treat nodes as values by
converting them to their enum representations. We follow the [API Design
Guidelines](https://swift.org/documentation/api-design-guidelines/) by using
initializers for type conversions. We write two pairs of initializers: one pair
creates `Block` and `Inline` values from the `Node` type, and another pair
reconstructs a `Node` from these enums. This allows us to write functions that
create or manipulate `Inline` or `Block` values and then later reconstruct a
CommonMark document and use the C library to render it into HTML or back into
Markdown text.

Let's start by writing an initializer that converts a `Node` into an `Inline`
element. We switch on the node's type and construct the corresponding `Inline`
value. For example, for a text node, we take the node's string contents, which
we access through the `literal` property in the `cmark` library. We can safely
force-unwrap `literal` because we know that text nodes always have this value,
whereas other node types might return `nil` from `literal`. For example,
emphasis and strong nodes only have child nodes and no literal value. To parse
the latter, we map over the node's children and call our initializer
recursively. Instead of duplicating that code, we create an inline function,
`inlineChildren`, that only gets called when needed. The `default` case should
never get reached, so we choose to trap the program if it does. This follows the
convention that returning an optional or using `throws` should generally only be
used for expected errors, and not to signify programmer errors:

``` swift-example
extension Inline {
    init(_ node: Node) {
        let inlineChildren = { node.children.map(Inline.init) }
        switch node.type {
        case CMARK_NODE_TEXT:
            self = .text(text: node.literal!)
        case CMARK_NODE_SOFTBREAK:
            self = .softBreak
        case CMARK_NODE_LINEBREAK:
            self = .lineBreak
        case CMARK_NODE_CODE:
            self = .code(text: node.literal!)
        case CMARK_NODE_HTML_INLINE:
            self = .html(text: node.literal!)
        case CMARK_NODE_CUSTOM_INLINE:
            self = .custom(literal: node.literal!)
        case CMARK_NODE_EMPH:
            self = .emphasis(children: inlineChildren())
        case CMARK_NODE_STRONG:
            self = .strong(children: inlineChildren())
        case CMARK_NODE_LINK:
            self = .link(children: inlineChildren(), title: node.title, url: node.urlString)
        case CMARK_NODE_IMAGE:
            self = .image(children: inlineChildren(), title: node.title, url: node.urlString)
        default:
            fatalError("Unrecognized node: \(node.typeString)")
        }
    }
}
```

Converting block-level elements follows the same pattern. Note that block-level
elements can have either inline elements, list items, or other block-level
elements as children, depending on the node type. In the `cmark_node` syntax
tree, list items get wrapped with an extra node. In the `listItem` property on
`Node`, we remove that layer and directly return an array of block-level
elements:

``` swift-example
extension Block {
    init(_ node: Node) {
        let parseInlineChildren = { node.children.map(Inline.init) }
        let parseBlockChildren = { node.children.map(Block.init) }
        switch node.type {
        case CMARK_NODE_PARAGRAPH:
            self = .paragraph(text: parseInlineChildren())
        case CMARK_NODE_BLOCK_QUOTE:
            self = .blockQuote(items: parseBlockChildren())
        case CMARK_NODE_LIST:
            let type = node.listType == CMARK_BULLET_LIST ?
                ListType.unordered : ListType.ordered
            self = .list(items: node.children.map { $0.listItem }, type: type)
        case CMARK_NODE_CODE_BLOCK:
            self = .codeBlock(text: node.literal!, language: node.fenceInfo)
        case CMARK_NODE_HTML_BLOCK:
            self = .html(text: node.literal!)
        case CMARK_NODE_CUSTOM_BLOCK:
            self = .custom(literal: node.literal!)
        case CMARK_NODE_HEADING:
            self = .heading(text: parseInlineChildren(), level: node.headerLevel)
        case CMARK_NODE_THEMATIC_BREAK:
            self = .thematicBreak
        default:
            fatalError("Unrecognized node: \(node.typeString)")
        }
    }
}
```

Now, given a document-level `Node`, we can easily convert it into an array of
`Block` elements. The `Block` elements are values: we can freely copy or change
them without having to worry about references. This is very powerful for
manipulating nodes. Since values, by definition, don't care how they were
created, we can also create a Markdown syntax tree in code, from scratch,
without using the CommonMark library at all. The types are much clearer too; you
can't accidentally do things that wouldn't make sense — such as accessing the
title of a list — as the compiler won't allow it. Aside from making your code
safer, this is a very robust form of documentation — by just looking at the
types, it's obvious how a CommonMark document is structured. And unlike
comments, the compiler will make sure that this form of documentation is never
outdated.

It's now very easy to write functions that operate on our new data types. For
example, if we want to build a list of all the level one and two headers from a
Markdown document for a table of contents, we can just loop over all children
and check whether they are headers and have the correct level:

``` swift-example
func tableOfContents(document: String) -> [Block] {
    let blocks = Node(markdown: document)?.children.map(Block.init) ?? []
    return blocks.filter {
        switch $0 {
        case .heading(_, let level) where level < 3: return true
        default: return false
        }
    }
}
```

Before we build more operations like this, let's tackle the inverse
transformation: converting a `Block` back into a `Node`. We need this because we
ultimately want to use the CommonMark library to generate HTML or other text
formats from the Markdown syntax tree we've built or manipulated, and the
library can only deal with `cmark_node_type`.

Our plan is to add two initializers on `Node`: one that converts an `Inline`
value to a node, and another that handles `Block` elements. We start by
extending `Node` with a new initializer that creates a new `cmark_node` from
scratch with the specified type and children. Recall that we wrote a `deinit`,
which frees the root node of the tree (and recursively, all its children). This
`deinit` will make sure that the node we allocate here gets freed eventually:

``` swift-example
extension Node {
    convenience init(type: cmark_node_type, children: [Node] = []) {
        self.init(node: cmark_node_new(type))
        for child in children {
            cmark_node_append_child(node, child.node)
        }
    }
}
```

We'll frequently need to create text-only nodes, or nodes with a number of
children, so let's add three convenience initializers to make that easier:

``` swift-example
extension Node {
    convenience init(type: cmark_node_type, literal: String) {
        self.init(type: type)
        self.literal = literal
    }
    convenience init(type: cmark_node_type, blocks: [Block]) {
        self.init(type: type, children: blocks.map(Node.init))
    }
    convenience init(type: cmark_node_type, elements: [Inline]) {
        self.init(type: type, children: elements.map(Node.init))
    }
}
```

Now we're ready to write the two conversion initializers. Using the initializers
we just defined, it becomes very straightforward: we switch on the element and
create a node with the correct type. Here's the version for inline elements:

``` swift-example
extension Node {
    convenience init(element: Inline) {
        switch element {
        case .text(let text):
            self.init(type: CMARK_NODE_TEXT, literal: text)
        case .emphasis(let children):
            self.init(type: CMARK_NODE_EMPH, elements: children)
        case .code(let text):
            self.init(type: CMARK_NODE_CODE, literal: text)
        case .strong(let children):
            self.init(type: CMARK_NODE_STRONG, elements: children)
        case .html(let text):
            self.init(type: CMARK_NODE_HTML_INLINE, literal: text)
        case .custom(let literal):
            self.init(type: CMARK_NODE_CUSTOM_INLINE, literal: literal)
        case let .link(children, title, url):
            self.init(type: CMARK_NODE_LINK, elements: children)
            self.title = title
            self.urlString = url
        case let .image(children, title, url):
            self.init(type: CMARK_NODE_IMAGE, elements: children)
            self.title = title
            urlString = url
        case .softBreak:
            self.init(type: CMARK_NODE_SOFTBREAK)
        case .lineBreak:
            self.init(type: CMARK_NODE_LINEBREAK)
        }
    }
}
```

Creating a node from a block-level element is very similar. The only slightly
more complicated case is lists. Recall that in the above conversion from `Node`
to `Block`, we removed the extra node the CommonMark library uses to represent
lists, so we need to add that back in here:

``` swift-example
extension Node {
    convenience init(block: Block) {
        switch block {
        case .paragraph(let children):
            self.init(type: CMARK_NODE_PARAGRAPH, elements: children)
        case let .list(items, type):
            let listItems = items.map { Node(type: CMARK_NODE_ITEM, blocks: $0) }
            self.init(type: CMARK_NODE_LIST, children: listItems)
            listType = type == .unordered
                ? CMARK_BULLET_LIST 
                : CMARK_ORDERED_LIST
        case .blockQuote(let items):
            self.init(type: CMARK_NODE_BLOCK_QUOTE, blocks: items)
        case let .codeBlock(text, language):
            self.init(type: CMARK_NODE_CODE_BLOCK, literal: text)
            fenceInfo = language
        case .html(let text):
            self.init(type: CMARK_NODE_HTML_BLOCK, literal: text)
        case .custom(let literal):
            self.init(type: CMARK_NODE_CUSTOM_BLOCK, literal: literal)
        case let .heading(text, level):
            self.init(type: CMARK_NODE_HEADING, elements: text)
            headerLevel = level
        case .thematicBreak:
            self.init(type: CMARK_NODE_THEMATIC_BREAK)
        }
    }
}
```

Finally, to provide a nice interface for the user, we define a public
initializer that takes an array of block-level elements and produces a document
node, which we can then render into one of the different output formats:

``` swift-example
extension Node {
    public convenience init(blocks: [Block]) {
        self.init(type: CMARK_NODE_DOCUMENT, blocks: blocks)
    }
}
```

Now we can go in both directions: we can load a document, convert it into
`[Block]` elements, modify those elements, and turn them back into a `Node`.
This allows us to write programs that extract information from Markdown or even
change the Markdown dynamically. By first creating a thin wrapper around the C
library (the `Node` class), we abstracted the conversion from the underlying C
API. This allowed us to focus on providing an interface that feels like
idiomatic Swift. The entire project is [available on
GitHub](https://github.com/objcio/commonmark-swift).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
