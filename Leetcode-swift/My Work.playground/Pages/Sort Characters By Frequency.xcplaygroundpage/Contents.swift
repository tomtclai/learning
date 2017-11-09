// https://leetcode.com/problems/sort-characters-by-frequency/description/
func frequencySort(_ s: String) -> String {
    var characterToFreq = [Unicode.Scalar: Int]()
    s.unicodeScalars.forEach { char in
        if characterToFreq.keys.contains(char) {
            characterToFreq[char]! += 1
        } else {
            characterToFreq[char] = 1
        }
    }

    let result = characterToFreq.sorted {
        $0.value > $1.value
        }.map {
            String(repeating: String($0.key), count: $0.value)
    }

    return result.reduce("") { $0 + $1 }
}
