package com.company;

import java.util.HashSet;
import java.util.Set;

public class Main {

    public static void main(String[] args) {
	// write your code here
    }

    // https://leetcode.com/problems/arithmetic-slices/discuss/
    public int numberOfArithmeticSlices(int[] A) {
        int curr = 0, countOfSlices = 0;
        for (int i = 2; i < A.length; i++) {
            if (A[i-2]-A[i-1] == A[i-1]-A[i]) {
                curr += 1;
                countOfSlices += curr;
            } else {
                curr = 0;
            }
        }
        return countOfSlices;
    }

    // https://leetcode.com/problems/binary-number-with-alternating-bits
    public boolean hasAlternatingBits(int n) {
        int nShifted = n / 2; //1010 becomes 0101
        int allOnes = n+nShifted; // 1111
        int allZerosWithLeadingOne = n+nShifted + 1; // 10000
        return (allOnes & allZerosWithLeadingOne) == 0;
    }

    // https://leetcode.com/problems/maximum-depth-of-binary-tree/description/
    public int maxDepth(TreeNode root) {
        if (root == null) { return 0; }
        return maxDepth(root, 1);
    }
    public int maxDepth(TreeNode root, int level) {
        if (root == null) { return Integer.MIN_VALUE; }
        if (root.left == null && root.right == null) {
            return level;
        }
        return Math.max(maxDepth(root.left, level+1),maxDepth(root.right, level+1));

    }

    // https://leetcode.com/problems/two-sum-iv-input-is-a-bst/description/
    public boolean findTarget(TreeNode root, int k) {
        HashSet<Integer> set = new HashSet<Integer>();
        return findTarget(root, k, set);
    }
    private boolean findTarget(TreeNode root, int k, Set<Integer> set) {
        if (root==null) return false;
        if (set.contains(root.val)) {
            return true;
        } else {
            set.add(k - root.val);
            return findTarget(root.left, k, set) || findTarget(root.right, k, set);
        }
    }
}


// Definition for a binary tree node.
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int x) { val = x; }
}
