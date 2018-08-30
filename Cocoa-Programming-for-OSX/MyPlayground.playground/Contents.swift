//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, Swift"

let constStr = str

var nextYear: Int
var bodyTemp: Float
var hasPet: Bool

var arrayOfInts: [Int]

var dictionaryOfCapitalsByCountry: [String: String]

var winningLotteryNumbers: Set<Int>

let number=42
var countingUp = ["one", "two"]
let nameByParkingSpace = [13: "alice", 27: "bob"]

let secondElement = countingUp[1]

let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()

let defaultNumber = Int()
let defaultBool = Bool()

let meaningOfLife = String(number)
let availableRooms = Set([205, 411, 412])

let defaultFloat = Float()
let floatFromLiteral = Float(3.14)
let pi = 3.14
let floatFromDouble = Float(pi)
let floatingPi: Float = 3.14

emptyString.isEmpty
countingUp.count
countingUp.append("three")
let countingDown = countingUp.reverse()

var anOptionalFLoat: Float?
var anOptionalArrayOfStrings: [String]?
var anOptionalArrayOfOptionalStrings: [String?]?

var reading1: Float?
var reading2: Float?
var reading3: Float?
reading1 = 1
reading2 = 3
reading3 = 4
if  let r1 = reading1,
    let r2 = reading2,
    let r3 = reading3 {
        let avgReading = (r1 + r2 + r3) / 3
    } else {
        let errorString = "A reading was nil"
    }

if let spaceAssignee = nameByParkingSpace[13] {

    ("Key 13 was in the dictionary with the value \"\(spaceAssignee)\"")

}

for var i = 0; i < countingUp.count; i++ {
    let string = countingUp[i]
}

let range = 0..<countingUp.count
for i in range {
    let string = countingUp[i]
}

for string in countingUp {
    string
}

for (i, string) in enumerate(countingUp) {
    i
    string
}
nameByParkingSpace

for (space, name) in nameByParkingSpace {
    let permit = "Space \(space): \(name)"
}

enum PieType: Int {
    case Apple = 0
    case Cherry
    case Pecan
}

let favoritePie = PieType.Apple

var piesToBake: [PieType] = []
piesToBake.append(.Apple)

let name: String
switch favoritePie {
case .Apple:
    name = "Apple"
case .Cherry:
    name = "Cherry"
case .Pecan:
    name = "Pecan"
}

let pieRawValue = PieType.Pecan.rawValue
if let pieType = PieType(rawValue: pieRawValue) {
    pieType
}
