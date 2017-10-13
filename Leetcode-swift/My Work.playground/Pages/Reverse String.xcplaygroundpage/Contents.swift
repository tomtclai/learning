  func reverseString(_ s: String) -> String {
    var scString = s.utf8CString
    
    let length = s.characters.count
    var i = 0
    var j = length - 1
    while i < j {
        swap(&scString[i], &scString[j])
        i = i + 1
        j = j - 1
    }
    return String(cString: scString)
  }
