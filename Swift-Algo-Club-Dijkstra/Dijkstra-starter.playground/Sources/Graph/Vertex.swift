public struct Vertex<T: Hashable> {
	public var data: T
}

extension Vertex: Hashable {
	public var hashValue: Int {
		return "\(data)".hashValue
	}
	
	static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
		return lhs.data == rhs.data
	}
}

extension Vertex: CustomStringConvertible {
	public var description: String {
		return "\(data)"
	}
}
