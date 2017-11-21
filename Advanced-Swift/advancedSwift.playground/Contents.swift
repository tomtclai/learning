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
let ranks = ["J","Q","K","A"]
let result = suits.flatMap { suit in
    ranks.map { rank in
    (suit, rank)
    }
}

[1,2,3].forEach{print($0)}

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String: Setting] = [
    "Airplane Mode": .bool(true),
    "Name": .text("My iPhone"),
]

let nameSetting = defaultSettings["Name"]

var localizedSettings = defaultSettings
localizedSettings["Name"] = .text("Mein iPhone")

extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value){
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
