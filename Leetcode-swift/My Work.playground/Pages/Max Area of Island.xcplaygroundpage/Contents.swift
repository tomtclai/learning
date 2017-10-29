// https://leetcode.com/problems/max-area-of-island/description/

func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
    var mutableGrid = grid
    var max = 0
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            let area = depthFirstSearch(&mutableGrid, i, j)
            if max < area {
                max = area
            }
        }
    }
    return max
}

func depthFirstSearch(_ grid: inout [[Int]], _ i: Int, _ j: Int) -> Int {
    let rows = grid.count
    let cols = grid[0].count

    guard 0 <= i && i < rows &&
        0 <= j && j < cols &&
        grid[i][j] != 0 else {
            return 0
    }
    grid[i][j] = 0
    return 1 +
        depthFirstSearch(&grid, i-1, j) +
        depthFirstSearch(&grid, i, j-1) +
        depthFirstSearch(&grid, i+1, j) +
        depthFirstSearch(&grid, i, j+1)

}
