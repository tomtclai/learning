    func distributeCandies(_ candies: [Int]) -> Int {
        var setCandy = Set(candies)
        let howManyKindAtMost = candies.count / 2
        return setCandy.count > howManyKindAtMost ? howManyKindAtMost : setCandy.count
    }

    //https://leetcode.com/problems/distribute-candies/description/
