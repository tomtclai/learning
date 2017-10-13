  func reverseString(_ s: String) -> String {
    var characters = Array(s.characters)

    let length = s.characters.count
    var i = 0
    var j = length - 1
    while i < j {
        characters.swapAt(i, j)
        i = i + 1
        j = j - 1
    }

    return String(characters)
  }
