// https://leetcode.com/problems/unique-paths-iii/
class Solution {
    
    struct Coordinate {
        var row: Int
        var col: Int
    }
    
    var numberOfPaths = 0
    
    // http://www.icode9.com/content-4-111181.html
    func uniquePathsIII(_ grid: [[Int]]) -> Int {
        var mutableGrid = grid
        let numRows = grid.count
        let numCols = grid[0].count
        var start = Coordinate(row: 0, col: 0)
        var unvisitedSpace = 1 // the ending square at least
        for rowI in 0..<numRows {
            for colI in 0..<numCols {
                if grid[rowI][colI] == 1 {
                    start = Coordinate(row: rowI, col: colI)
                } else if grid[rowI][colI] == 0 {
                    unvisitedSpace += 1
                }
            }
        }
        
        return dfs(&mutableGrid, col: start.col, row: start.row, unvisitedSpace: unvisitedSpace)
    }
    
 
    private func dfs(_ grid: inout [[Int]], col: Int, row: Int, unvisitedSpace: Int) -> Int {
        let numRows = grid.count
        let numCols = grid[0].count
        guard col >= 0, col < numCols, row >= 0, row < numRows, grid[row][col] != -1 else { return 0 }
        if grid[row][col] == 2 {
            return unvisitedSpace == 0 ? 1 : 0
        }
        grid[row][col] = -1
        let path = 
            dfs(&grid, col: col+1, row: row, unvisitedSpace: unvisitedSpace - 1) + 
            dfs(&grid, col: col-1, row: row, unvisitedSpace: unvisitedSpace - 1) + 
            dfs(&grid, col: col, row: row+1, unvisitedSpace: unvisitedSpace - 1) +
            dfs(&grid, col: col, row: row-1, unvisitedSpace: unvisitedSpace - 1)
        grid[row][col] = 0
        
        return path
    }
}