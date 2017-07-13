
func lengthOfLongestSubstring(_ s: String) -> Int {
    var characters = Array(s.characters)
    var startIndex = 0
    var length = 0
    var characterSet = Set<Character>()
    var resultLength = 0
    for c in characters {
        while characterSet.contains(c) {
            characterSet.remove(characters[startIndex])
            startIndex += 1
            length -= 1
        }
        characterSet.insert(c)
        length += 1
        if resultLength < length {
            resultLength = length
        }
    }
    
    return resultLength
}
