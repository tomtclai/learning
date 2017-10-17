    func averageOfLevels(_ root: TreeNode?) -> [Double] {
        guard let root = root else {
            return [Double]()
        }
        // need to have a sum, and a number of nodes for each level
        var sum = [Double]()
        var numberOfNodes = [Double]()
        findSumAndNumberOfNodes(root, sum: &sum, numberOfNodes: &numberOfNodes, level: 0)
        var results = [Double]()
        for i in 0..<numberOfNodes.count {
            results.append(sum[i] / numberOfNodes[i])
        }
        return results
    }

    func findSumAndNumberOfNodes(_ root: TreeNode, sum: inout [Double], numberOfNodes: inout [Double], level: Int) {
        if sum.indices.contains(level) {
            numberOfNodes[level] += 1
            sum[level] += Double(root.val)
        } else {
            numberOfNodes.append(1)
            sum.append(Double(root.val))
        }
        if root.left != nil || root.right != nil {
            if let left = root.left {
                findSumAndNumberOfNodes(left, sum: &sum, numberOfNodes: &numberOfNodes, level: level+1)
            }
            if let right = root.right {
                findSumAndNumberOfNodes(right, sum: &sum, numberOfNodes: &numberOfNodes, level: level+1)
            }
        }
    }
