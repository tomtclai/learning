/*:
 
 Given an 2D board, count how many battleships are in it. The battleships are represented with `'X'`s, empty slots are represented with `'.'`s. You may assume the following rules:
 
 * You receive a valid board, made of only battleships or empty slots.
 * Battleships can only be placed horizontally or vertically. In other words, they can only be made of the shape `1xN` (1 row, N columns) or `Nx1` (N rows, 1 column), where N can be of any size.
 * At least one horizontal or vertical cell separates between two battleships - there are no adjacent battleships.
 ```
 X..X
 ...X
 ...X
 ```
 In the above board there are 2 battleships.
 ```
 ...X
 XXXX
 ...X
 ```
 This is an invalid board that you will not receive - as battleships will always have a cell separating between them.
 Follow up:
 Could you do it in one-pass, using only O(1) extra memory and without modifying the value of the board?
 

*/

import Foundation

func countBattleships(_ board: [[Character]]) -> Int {
    var count = 0
    var isInTheMiddleOfShip = false
    var previousRow: [Character]?
    for row in board {
        for (index, character) in row.enumerated() {
            if let previousRow = previousRow, previousRow[index] == "X" {
                isInTheMiddleOfShip = true
            }
            if character == "X" {
                if !isInTheMiddleOfShip {
                    count += 1
                    isInTheMiddleOfShip = true
                }
            } else {
                isInTheMiddleOfShip = false
            }
        }
        isInTheMiddleOfShip = false
        previousRow = row
    }
    return count
}

countBattleships([["X", "X", "X"],
                  [".", ".", "."],
                  ["X", "X", "X"]])
countBattleships([["X", ".", "X", ".", "X"],
                  ["X", ".", ".", ".", "X"],
                  ["X", ".", "X", ".", "X"]])

func countBattleships_Oof1Solution(_ board: [[Character]]) -> Int {
    var count = 0
    for (i, row) in board.enumerated() {
        for (j, character) in row.enumerated() {
            if character == "." {
                continue
            }
            if i > 0 && board[i - 1][j] == "X" ||
               j > 0 && row[j - 1] == "X" {
                continue
            }
            count += 1
        }
    }
    return count
}

countBattleships_Oof1Solution([["X", "X", "X"],
                               [".", ".", "."],
                               ["X", "X", "X"]])
countBattleships_Oof1Solution([["X", ".", "X", ".", "X"],
                               ["X", ".", ".", ".", "X"],
                               ["X", ".", "X", ".", "X"]])
