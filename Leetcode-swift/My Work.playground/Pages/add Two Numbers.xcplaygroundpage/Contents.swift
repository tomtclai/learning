public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var node1 = l1
        var node2 = l2
        var carryOver = 0
        var headResult: ListNode?
        var previousResult: ListNode?
        while node1 != nil || node2 != nil || carryOver != 0 {
            let node2Val = node2?.val ?? 0
            let node1Val = node1?.val ?? 0
            let sum = node1Val + node2Val + carryOver
            carryOver = sum / 10
            let resultNode = ListNode(sum % 10)
            // next iteration
            if previousResult == nil {
                previousResult = resultNode
                headResult = resultNode
            } else {
                previousResult!.next = resultNode
            }
            previousResult = resultNode
            node1 = node1?.next
            node2 = node2?.next
        }
        
        return headResult
    }
}