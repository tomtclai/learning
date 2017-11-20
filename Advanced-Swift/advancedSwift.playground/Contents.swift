//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


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
