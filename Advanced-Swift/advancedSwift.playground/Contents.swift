//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
extension Array {
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }

    public func map2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) {
            $0 + [transform($1)]
        }
    }

    public func filter2(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]) {
            isIncluded($1) ? $0 + [$1] : $0
        }
    }
    public func flatMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult) rethrows -> [ElementOfResult] {
        var result: [ElementOfResult] = []
        for x in self {
            result.append(try transform(x))
        }
        return result
    }
}

let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J", "Q", "K", "A"]
let result = suits.flatMap { suit in
    ranks.map { rank in
    (suit, rank)
    }
}

[1, 2, 3].forEach {print($0)}

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String: Setting] = [
    "Airplane Mode": .bool(true),
    "Name": .text("My iPhone")
]

let nameSetting = defaultSettings["Name"]

var localizedSettings = defaultSettings
localizedSettings["Name"] = .text("Mein iPhone")

extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
            for (k, v) in other {
                self[k] = v
            }
    }
}

let settingsAsStrings = defaultSettings.mapValues {
    setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let num): return String(num)
    case .bool(let val): return String(val)
    }
}

struct Person {
    var name: String
    var zipCode: Int
    var birthday: Date
}

extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name &&
        lhs.zipCode == rhs.zipCode &&
        lhs.birthday == rhs.birthday
    }
}

extension Person: Hashable {
    // For types that are composed of basic data types that are hashable themselves. XOR'ing the members' hash values canbe a good starting point. However because XOR is symmetric (a^b == b^a) this could make collissions more likely than necessary. You can add a bitwise rotation https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html to avoid this
    var hashValue: Int {
        return name.hashValue ^ zipCode.hashValue ^ birthday.hashValue
    }
}

//Set elements must be hashable.
let natruals: Set = [1, 2, 3, 2]
let iPods: Set = ["iPod Touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]
let discontinuedIPods: Set = ["iPod mini", "iPod Classic"]
let currentIpods = iPods.subtracting(discontinuedIPods)
let hasTouchScreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
let iPodsWithTouchScreen = iPods.intersection(hasTouchScreen)
var discontinued: Set = ["iBook", "Powerbook", "Power Mac"]
discontinued.formUnion(discontinuedIPods)

// Set is adopted by IndexSet and CharacterSet
var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)
let evenIndices = indices.filter {$0 % 2 == 0}

// Unlike IndexSet, CharacterSet isn't a collection

// If we wanted to get all the elements without dupes, we put everything in to set. But if we want the elements to not get shuffled arround -- use filter.
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}
[1, 2, 3, 12, 1, 3, 4, 5, 6, 4, 6].unique()

// Strideable Ranges
let singleDigitNums = 0..<10
let singleDigitNumsClosed = 0...9
// Only half-open range can be empty
let emptyInterval = 0..<0
let oneElementClosed = 0...0
// Not Strideable / not collections / not countable
// You cannot iterate over this range
let lowerCaseLetters = Character("a")...Character("z")

// Illegal
// extension Range: RandomAccessCollection where Bound: Strideable, Bound.Stride: SignedInteger {
//
// }

// This produces an infinite stream, it keeps generating numbers until it reaches integer overflow, then the program crahses
struct FibonacciIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNum = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNum
    }
}

struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index

    init(string: String) {
        self.string = string
        offset = string.startIndex
    }

    mutating func next() -> String? {
        guard offset < string.endIndex else {
            return nil
        }
        offset = string.index(after: offset)
        return String(string[string.startIndex..<offset])

    }
}

struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

PrefixSequence(string: "Hello")

for prefix in PrefixSequence(string: "test") {
    print(prefix)
}

// StrideToIterator is a value type
let seq = stride(from: 0, to: 10, by: 1)
var i1 = seq.makeIterator()
i1.next()
i1.next()

var i2 = i1

i1.next()
i2.next()

// AnyIterator wraps another iterator via reference. so i3 and i4 aren't independent
var i3 = AnyIterator(i1)
var i4 = i3

i3.next()
i4.next()
i3.next()
