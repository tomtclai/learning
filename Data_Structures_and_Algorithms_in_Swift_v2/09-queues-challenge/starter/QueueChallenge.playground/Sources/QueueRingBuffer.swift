// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

// MARK: - Ring Buffer Based Queue
public struct QueueRingBuffer<T>: Queue {
  
  private var ringBuffer: RingBuffer<T>
  
  public init(count: Int) {
    ringBuffer = RingBuffer<T>(count: count)
  }
  
  public var isEmpty: Bool {
    return ringBuffer.isEmpty
  }
  
  public var peek: T? {
    return ringBuffer.first
  }
  
  public mutating func enqueue(_ element: T) -> Bool {
    return ringBuffer.write(element)
  }
  
  public mutating func dequeue() -> T? {
    return isEmpty ? nil : ringBuffer.read()
  }
}

extension QueueRingBuffer: CustomStringConvertible {
  
  public var description: String {
    return String(describing: ringBuffer)
  }
}

// MARK: - Ring Buffer

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

//: [Next Challenge](@next)
