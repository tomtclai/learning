//https://leetcode.com/submissions/detail/123585115/
func islandPerimeter(_ grid: [[Int]]) -> Int {
    // scan it twice
    // vertical
    //  goes from 0 to 1 (+1)
    //  goes from 1 to 0 (+1)
    //  starts or end with 1 (+1)
    // horizontal
    //  goes from 0 to 1 (+1)
    //  goes from 1 to 0 (+1)
    //  starts or end with 1 (+1)
    
    var perimeter = 0
    
    for col in 0..<grid.first!.count {
        var lastVal = 0
        for row in 0..<grid.count {
            if lastVal != grid[row][col] {
                perimeter += 1
            }
            lastVal = grid[row][col]
        }
        if grid[grid.count-1][col] == 1 {
            perimeter += 1
        }
    }
    
    for row in 0..<grid.count {
        var lastVal = 0
        for col in 0..<grid.first!.count {
            if lastVal != grid[row][col] {
                perimeter += 1
            }
            lastVal = grid[row][col]
        }
        if grid[row][grid.first!.count - 1] == 1 {
            perimeter += 1
        }
    }
    
    return perimeter
}

