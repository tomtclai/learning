/*: Title
 # Given two strings representing two complex numbers. You need to return a string representing their multiplication. Note i2 = -1 according to the definition.
 
 
 
 ```
 Input: "1+1i", "1+1i"
 Output: "0+2i"
 ```
 Explanation: `(1 + i) * (1 + i) = 1 + i2 + 2 * i = 2i`, and you need convert it to the form of 0+2i.
 
 
 ```
 Input: "1+-1i", "1+-1i"
 Output: "0+-2i"
 ```
 Explanation: `(1 - i) * (1 - i) = 1 + i2 - 2 * i = -2i`, and you need convert it to the form of 0+-2i.
 
 Note:
 
 The input strings will not have extra blank.
 The input strings will be given in the form of a+bi, where the integer a and b will both belong to the range of [-100, 100]. And the output should be also in this form.
 */
import Foundation

    /*
     (1-1i)(1-1i)
     = 1 (1 - 1i) + -1i(1-1i)
     = 1 - 1i -1i + i^2
     = 1 -2i + i^2
     
     (1-1i) (1+1i)
     = 1 (1 + 1i) -1i (1 + 1i)
     = 1 + 1i -1i - i^2
 
 
 (1+1i) (1+1i)
 = 1 (1 + 1i) +1i (1 + 1i)
 = 1 + 1i  + 1i + i^2
 =
     (A+Bi) (C+Di)
     = A (C+Di) + Bi (C+Di)
     = AC + ADi + BCi + BDi^2
     = AC+BD + ADi + BCi
     */
    func complexNumberMultiply(_ a: String, _ b: String) -> String {
        let aNumbers = getComponents(from: a)
        let bNumbers = getComponents(from: b)
        let A = aNumbers.0
        let B = aNumbers.1
        let C = bNumbers.0
        let D = bNumbers.1

        let numberResult = A*C + B*D * -1
        let imaginaryResult = A*D+B*C

        return "\(numberResult)+\(imaginaryResult)i"
    }
    // Expect: 1+-1i
    // return (1,-1)
    func getComponents(from str: String) -> (Int, Int) {
        let arrayOfString = str.components(separatedBy: "+")
        let constant = Int(arrayOfString[0])!
        let imaginaryString = arrayOfString[1]
        let endIndex = imaginaryString.index(imaginaryString.endIndex, offsetBy: -1)
        let indexRange = imaginaryString.startIndex..<endIndex
        let iComponent = Int(imaginaryString.substring(with: indexRange))!
        return (constant, iComponent)
    }
    complexNumberMultiply("1+-1i", "1+-1i")
