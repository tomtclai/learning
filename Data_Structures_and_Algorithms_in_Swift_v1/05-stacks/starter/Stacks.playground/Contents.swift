// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct Stack<Element> {
    private var storage: [Element] = []
    public init() {}
}

extension Stack: CustomStringConvertible {
    public var description: String {
        let top = "top"
        let bottom = "\n_____"

        let stackElements = storage.map{"\($0)"}.reversed().joined(separator: "\n")

        return top + stackElements + bottom
    }
}
