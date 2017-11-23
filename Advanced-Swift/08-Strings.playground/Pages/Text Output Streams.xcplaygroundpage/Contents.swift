/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Text Output Streams

The `print` and `dump` functions in the standard library log text to the
standard output. How does that work? The default versions of these functions
forward to overloads named `print(_:to:)` and `dump(_:to:)`. The `to:` argument
is the output target; it can be any type that conforms to the `TextOutputStream`
protocol:

``` swift-example
public func print<Target: TextOutputStream>
    (_ items: Any..., separator: String = " ",
    terminator: String = "\n", to output: inout Target)
```

The standard library maintains an internal text output stream that writes
everything that's streamed to it to the standard output. What else can you write
to? Well, `String` is the only type in the standard library that's an output
stream:

*/

var s = ""
let numbers = [1,2,3,4]
print(numbers, to: &s)
s


/*:
This is useful if you want to reroute the output of the `print` and `dump`
functions into a string. Incidentally, the standard library also harnesses
output streams to allow Xcode to capture all stdout logging. Take a look at
[this global variable declaration in the standard
library](https://github.com/apple/swift/blob/swift-4.0-branch/stdlib/public/core/OutputStream.swift):

``` swift-example
public var _playgroundPrintHook: ((String) -> Void)?
```

If this is non-`nil`, `print` will use a special output stream that routes
everything that's printed both to the standard output *and* to this function.
The declaration is even public, so you can use this for your own shenanigans:

*/

var printCapture = ""
_playgroundPrintHook = { text in
    printCapture += text
}
print("This is supposed to only go to stdout")
printCapture


/*:
But don't rely on it\! It's totally undocumented, and we don't know what
functionality in Xcode will break when you reassign this.

We can also make our own output streams. The protocol has only one requirement:
a `write` method that takes a string and writes it to the stream. For example,
this output stream buffers writes to an array:

*/

struct ArrayStream: TextOutputStream {
    var buffer: [String] = []
    mutating func write(_ string: String) {
        buffer.append(string)
    }
}

var stream = ArrayStream()
print("Hello", to: &stream)
print("World", to: &stream)
stream.buffer


/*:
The documentation explicitly allows functions that write to an output stream to
call `write(_:)` multiple times per writing operation. That's why the array
buffer in the example above contains separate elements for line breaks and even
some empty strings. This is an implementation detail of the `print` function
that may change in future releases.

Another possibility is to extend `Data` so that it takes a stream, writing it as
UTF-8-encoded output:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension Data: TextOutputStream {
    mutating public func write(_ string: String) {
        self.append(contentsOf: string.utf8)
    }
}

var utf8Data = Data()
var string = "café"
utf8Data.write(string)

/*:
The source of an output stream can be any type that conforms to the
`TextOutputStreamable` protocol. This protocol requires a generic method,
`write(to:)`, which accepts any type that conforms to `TextOutputStream` and
writes `self` to it.

In the standard library, `String`, `Substring`, `Character`, and
`Unicode.Scalar` conform to `TextOutputStreamable`, but you can also add
conformance to your own types. One way to do this is with `print(_:to:)`.
However, it's very easy to make a mistake here by accidentally forgetting the
`to:` parameter. Unless you test with a target that's not the standard output,
you might not even notice the oversight. Another option is to call the target
stream's `write` method directly. This is how the queue type we built in the
chapter on collection protocols could adopt `TextOutputStreamable`:

*/

// --- (Hidden code block) ---
/// A type that can `enqueue` and `dequeue` elements.
protocol Queue {
    /// The type of elements held in `self`.
    associatedtype Element
    /// Enqueue `element` to `self`.
    mutating func enqueue(_ newElement: Element)
    /// Dequeue an element from `self`.
    mutating func dequeue() -> Element?
}

/// An efficient variable-size FIFO queue of elements of type `Element`
struct FIFOQueue<Element>: Queue {
    private var left: [Element] = []
    private var right: [Element] = []

    /// Add an element to the back of the queue.
    /// - Complexity: O(1).
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }

    /// Removes front of the queue.
    /// Returns `nil` in case of an empty queue.
    /// - Complexity: Amortized O(1).
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        left = elements.reversed()
        right = []
    }
}
// ---------------------------
extension FIFOQueue: TextOutputStreamable {
    func write<Target: TextOutputStream>(to target: inout Target) {
        target.write("[")
        target.write(map { String(describing: $0) }.joined(separator: ","))
        target.write("]")
    }
}

var textRepresentation = ""
let queue: FIFOQueue = [1,2,3]
queue.write(to: &textRepresentation)
textRepresentation


/*:
This isn't very different from saying `let textRepresentation =
String(describing: queue)`, though, aside from being more complicated. One
interesting aspect of output streams is that a source can call `write` multiple
times and the stream will process each write immediately. You can see this if
you write the following rather silly sample:

*/

struct SlowStreamer: TextOutputStreamable, ExpressibleByArrayLiteral {
    let contents: [String]

    init(arrayLiteral elements: String...) {
        contents = elements
    }

    func write<Target: TextOutputStream>(to target: inout Target) {
        for x in contents {
            target.write(x)
            target.write("\n")
            sleep(1)
        }
    }
}

let slow: SlowStreamer = [
    "You'll see that this gets",
    "written slowly line by line",
    "to the standard output",
]
print(slow)

/*:
As new lines are printed to `target`, the output appears; it doesn't wait for
the call to complete.

As we've seen, internally, `print` is using some `TextOutputStream`-conforming
wrapper on the standard output. You could write something similar for standard
error, like this:

*/

struct StdErr: TextOutputStream {
    mutating func write(_ string: String) {
        guard !string.isEmpty else { return }

        // Strings can be passed directly into C functions that take a
        // const char* - see the interoperability chapter for more!
        fputs(string, stderr)
    }
}

var standarderror = StdErr()
print("oops!", to: &standarderror)

/*:
Streams can also hold state, they can potentially transform their output, and
you can chain them together. The following output stream replaces all
occurrences of the specified phrases with the given alternatives. Like `String`,
it also conforms to `TextOutputStreamable`, making it both a target and a source
of text-streaming operations:

*/

struct ReplacingStream: TextOutputStream, TextOutputStreamable {
    let toReplace: DictionaryLiteral<String, String>
    private var output = ""

    init(replacing toReplace: DictionaryLiteral<String, String>) {
        self.toReplace = toReplace
    }

    mutating func write(_ string: String) {
        let toWrite = toReplace.reduce(string) { partialResult, pair in
            partialResult.replacingOccurrences(of: pair.key, with: pair.value)
        }
        print(toWrite, terminator: "", to: &output)
    }

    func write<Target: TextOutputStream>(to target: inout Target) {
        output.write(to: &target)
    }
}

var replacer = ReplacingStream(replacing: [
    "in the cloud": "on someone else's computer"
])

let source = "People find it convenient to store their data in the cloud."
print(source, terminator: "", to: &replacer)

var output = ""
print(replacer, terminator: "", to: &output)
output

/*:
`DictionaryLiteral` is used in the above code instead of a regular dictionary.
This is useful when you want to be able to use the `[key: value]` literal
syntax, but you don't want the two side effects you'd get from using a
`Dictionary`: elimination of duplicate keys and reordering of the keys. If this
indeed isn't what you want, then `DictionaryLiteral` is a nice alternative to an
array of pairs (i.e. `[(key, value)]`) while allowing the caller to use the more
convenient `[:]` syntax.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
