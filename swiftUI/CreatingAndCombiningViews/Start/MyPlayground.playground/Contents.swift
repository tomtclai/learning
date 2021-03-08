import UIKit
func findBall2(_ grid: [[Int]]) -> [Int] {
    var result : [Int] = []
    var columns = grid[0].count
    var rows = grid.count
    for c in 0..<columns{
        var lastCol = c
        for r in 0..<rows{
            let afterCol = lastCol + grid[r][lastCol]
            if afterCol < 0 || afterCol >= grid[0].count || grid[r][lastCol] != grid[r][afterCol]{
                lastCol = -1
                break
            }
            else{
                lastCol = afterCol
            }
        }
        result.append(lastCol)
    }
    return result
}
func findBall(_ grid: [[Int]]) -> [Int] {
    var columns = grid[0].count
    var result = [Int](repeating: -1, count: columns)
    var rows = grid.count
    mainloop: for c in 0..<columns {
        var lastColumn = c
        for r in 0..<rows {
           if grid[r][lastColumn] == 1 {
              // go right
              guard lastColumn < columns-1 && grid[r][lastColumn+1] != -1 else {
                continue mainloop
              }
              lastColumn += 1
           } else {
              // go left
              guard lastColumn > 0 && grid[r][lastColumn-1] != 1 else {
                continue mainloop
              }
              lastColumn -= 1
           }
        }
        result[c] = lastColumn
    }
   return result
}


findBall([[1]])
