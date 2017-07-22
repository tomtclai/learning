/*:
 
 Given a nested list of integers, return the sum of all integers in the list weighted by their depth.
 
 Each element is either an integer, or a list -- whose elements may also be integers or other lists.
 
 Example 1:
 Given the list `[[1,1],2,[1,1]]`, return 10. (four 1's at depth 2, one 2 at depth 1)
 
 Example 2:
 Given the list `[1,[4,[6]]]`, return 27. (one 1 at depth 1, one 4 at depth 2, and one 6 at depth 3; 1 + 4*2 + 6*3 = 27)
 
 
 */
import Foundation
// This is the interface that allows for creating nested lists.
// You should not implement it, or speculate about its implementation
protocol NestedInteger {
    // Return true if this NestedInteger holds a single integer, rather than a nested list.
    func isInteger() -> Bool
    
    // Return the single integer that this NestedInteger holds, if it holds a single integer
    // The result is undefined if this NestedInteger holds a nested list
    func getInteger() -> Int
    
    // Set this NestedInteger to hold a single integer.
    func setInteger(value: Int)
    
    // Set this NestedInteger to hold a nested list and adds a nested integer to it.
    func add(elem: NestedInteger)
    
    // Return the nested list that this NestedInteger holds, if it holds a nested list
    // The result is undefined if this NestedInteger holds a single integer
    func getList() -> [NestedInteger]
}
class Solution {
    
    func depthSum(_ nestedList: [NestedInteger], multiplier: Int = 1) -> Int {
        var sum = 0
        for nestedInteger in nestedList {
            var currentInteger = nestedInteger
            if nestedInteger.isInteger() {
                sum += multiplier * nestedInteger.getInteger()
            } else {
                sum += depthSum(currentInteger.getList(), multiplier: multiplier + 1)
            }
        }
        return sum
    }
}