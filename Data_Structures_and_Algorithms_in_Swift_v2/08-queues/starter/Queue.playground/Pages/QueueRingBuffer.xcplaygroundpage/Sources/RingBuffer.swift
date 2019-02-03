public struct RingBuffer<T> {
  
  private var array: [T?]
  private var readIndex = 0
  private var writeIndex = 0
  
  public init(count: Int) {
    array = Array<T?>(repeating: nil, count: count)
  }
  
  public var first: T? {
    return array[readIndex]
  }
  
  public mutating func write(_ element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }
  
  public mutating func read() -> T? {
    if !isEmpty {
      let element = array[readIndex % array.count]
      readIndex += 1
      return element
    } else {
      return nil
    }
  }
  
  private var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }
  
  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }
  
  private var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }
  
  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}

extension RingBuffer: CustomStringConvertible {
  public var description: String {
    let values = (0..<availableSpaceForReading).map {
      String(describing: array[($0 + readIndex) % array.count]!)
    }
    return "[" + values.joined(separator: ", ") + "]"
  }
}
