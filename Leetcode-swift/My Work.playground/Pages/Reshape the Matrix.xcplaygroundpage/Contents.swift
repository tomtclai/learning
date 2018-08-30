// https://leetcode.com/problems/reshape-the-matrix/description/
  private func dimensionIsValid(rows: Int, cols: Int, forMatrix matrix: [[Int]]) -> Bool {
    let expectedRows = matrix.count
    let expectedCols = matrix.first?.count ?? 0
    return rows * cols == expectedRows * expectedCols
  }
  func matrixReshape(_ nums: [[Int]], _ r: Int, _ c: Int) -> [[Int]] {
    guard dimensionIsValid(rows: r, cols: c, forMatrix: nums) else {
        return nums
    }

    var result = [[Int]]()
    var flattenedNums = nums.flatMap {$0}
    for _ in 0..<r {
        var newRow = [Int]()
        for _ in 0..<c {
            newRow.append(flattenedNums.removeFirst())
        }
        result.append(newRow)
    }
    return result
  }
