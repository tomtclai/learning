func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
    let longerArray = nums1.count > nums2.count ? nums1 : nums2
    let shorterArray =  nums1.count > nums2.count ? nums2 : nums1
    var ceilingForCuts = shorterArray.count * 2 // there are 2N spots because it can be either on the number (1,2,3) or between the numbers (1,2,3,4)
    var floorForCuts = 0

    while floorForCuts <= ceilingForCuts {
        let shorterMiddle = (floorForCuts + ceilingForCuts) / 2
        let longerMiddle = longerArray.count + shorterArray.count - shorterMiddle

        let longerLeft = longerMiddle == 0 ?
            Int.min : longerArray[(longerMiddle-1)/2]
        let longerRight = longerMiddle == longerArray.count * 2 ?
            Int.max : longerArray[longerMiddle/2]
        let shorterLeft = shorterMiddle == 0 ?
            Int.min : shorterArray[(shorterMiddle-1)/2]
        let shorterRight = shorterMiddle == shorterArray.count * 2 ?
            Int.max : shorterArray[shorterMiddle/2]

        if longerLeft > shorterRight {
            floorForCuts = shorterMiddle + 1
        } else if shorterLeft > longerRight {
            ceilingForCuts = shorterMiddle - 1
        } else {
            return Double(max(longerLeft, shorterLeft) + min(longerRight, shorterRight)) / 2
        }
    }
    return -1.0
}
