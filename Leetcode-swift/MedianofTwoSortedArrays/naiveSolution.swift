class Solution {
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        // line the numebrs up in 1 array
        var index1 = 0
        var index2 = 0
        var oneArray = [Int]()
        // 1,2
        // index1 2
        // 3,4
        // index2 2
        // 1,2,3,4
        // 4 
        // left 1
        // right 2
        // 2.5
        while index1 < nums1.count && index2 < nums2.count {
            if nums1[index1] < nums2[index2] {
                oneArray.append(nums1[index1])
                index1 += 1
            } else {
                oneArray.append(nums2[index2])
                index2 += 1
            }
        }
        while index1 < nums1.count {
            oneArray.append(nums1[index1])
                index1 += 1
        }
        while index2 < nums2.count {
            oneArray.append(nums2[index2])
                index2 += 1
        }
        // Find middle point
        if oneArray.count%2 == 0 {
            // count = 6, left index = 2 = (6-1) /2
            // right index = 6 / 2 = 3
            // 0 1 2 3 4 5
            // 1,2,3,4,5,6
            let leftIndex = (oneArray.count - 1) / 2
            let rightIndex = oneArray.count / 2
            return Double(oneArray[leftIndex] + oneArray[rightIndex]) / 2
        } else {
            // count = 5, index = 2 = 5 /2
            // 0 1 2 3 4
            // 1,2,3,4,5
            return Double(oneArray[oneArray.count / 2])
        }
    }
}