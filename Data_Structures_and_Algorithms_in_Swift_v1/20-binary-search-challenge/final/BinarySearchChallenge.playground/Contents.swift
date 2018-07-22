// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

/*
// Unoptimized version
func findIndices(of value: Int, in array: [Int]) -> Range<Int>? {
  guard let leftIndex = array.index(of: value) else {
    return nil
  }
  guard let rightIndex = array.reversed().index(of: value) else {
    return nil
  }
  return leftIndex..<rightIndex.base
}
*/

func findIndices(of value: Int, in array: [Int]) -> CountableRange<Int>? {
  guard let startIndex = startIndex(of: value, in: array, range: 0..<array.count) else {
    return nil
  }
  guard let endIndex = endIndex(of: value, in: array, range: 0..<array.count) else {
    return nil
  }
  return startIndex..<endIndex
}

func startIndex(of value: Int, in array: [Int], range: CountableRange<Int>) -> Int? {
    let middleIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

    if middleIndex == 0 || middleIndex == array.count - 1 {
      if array[middleIndex] == value {
        return middleIndex
      } else {
        return nil
      }
    }

    if array[middleIndex] == value {
      if array[middleIndex - 1] != value {
        return middleIndex
      } else {
        return startIndex(of: value, in: array, range: range.lowerBound..<middleIndex)
      }
    } else if value < array[middleIndex]  {
      return startIndex(of: value, in: array, range: range.lowerBound..<middleIndex)
    } else {
      return startIndex(of: value, in: array, range: middleIndex..<range.upperBound)
    }
}

func endIndex(of value: Int, in array: [Int], range: CountableRange<Int>) -> Int? {
    let middleIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
  
    if middleIndex == 0 || middleIndex == array.count - 1 {
      if array[middleIndex] == value {
        return middleIndex + 1
      } else {
        return nil
      }
    }

    if array[middleIndex] == value {
      if array[middleIndex + 1] != value {
        return middleIndex + 1
      } else {
        return endIndex(of: value, in: array, range: middleIndex..<range.upperBound)
      }
    } else if value < array[middleIndex]  {
      return endIndex(of: value, in: array, range: range.lowerBound..<middleIndex)
    } else {
      return endIndex(of: value, in: array, range: middleIndex..<range.upperBound)
    }
}

let array = [1, 2, 3, 3, 3, 4, 5, 5]
if let indices = findIndices(of: 3, in: array) {
  indices.forEach { print($0) }
}
