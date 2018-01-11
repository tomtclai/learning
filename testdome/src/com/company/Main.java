package com.company;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;



public class Main {

    public static void main(String[] args) {
        // write your code here
    }
    public static double average(int a, int b) {
        return (a + b) / 2.0;
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

    // https://leetcode.com/problems/single-number-iii/description/
    public int[] singleNumberWithSet(int[] nums) {
        HashSet<Integer> set = new HashSet<Integer>();

        for(int num: nums) {
            if (set.contains(num)) {
                set.remove(num);
            } else {
                set.add(num);
            }
        }
        return set.stream().mapToInt(i -> i.intValue()).toArray();
    }

    public int[] singleNumberWithBitwiseOperation(int[] nums) {
        int xorTheTwoNumbers = 0;
        for(int num: nums) {
            xorTheTwoNumbers ^= num;
        }
        // Get the negative:
        // 0000 1010 (10)
        // 0000 1001 (10 - 1)
        // 1111 0110 (-10)
        //
        // last set bit:
        //    0000 1010 (10)
        // &  1111 0110 (-10)
        //    0000 0010
        int lastSetBit = xorTheTwoNumbers & -xorTheTwoNumbers;
        int num1 = 0;
        int num2 = 0;
        for(int num: nums) {
            if ((num & lastSetBit)== 0) {
                num1 ^= num;
            } else {
                num2 ^= num;
            }
        }
        return new int[]{num1, num2};
    }

    // https://leetcode.com/problems/minimum-moves-to-equal-array-elements-ii/description/
    public int minMoves2(int[] nums) {
        if (nums == null || nums.length < 2) {
            return 0;
        }
        Arrays.sort(nums);
        int sumOfDistance = 0;
        for(int i = 0; i < nums.length / 2; i++) {
            int j = nums.length - i - 1;
            sumOfDistance += nums[j] - nums[i];
        }
        return sumOfDistance;
    }

    // https://leetcode.com/problems/product-of-array-except-self/discuss/
    public int[] productExceptSelf(int[] nums) {
        // 1, 2, 3, 4
        // 24, 12, 8, 6
        // 6 .= 1 x 1 x 2 x 3     x 1
        // 8  = 1 x 1 x 2     x 4 x 1
        // 12 = 1 x 1     x 3 x 4 x 1
        // 24 = 1 x     2 x 3 x 4 x 1

        // [9, 0, -2]
        int[] result = new int[nums.length];
        int temp = 1;
        for (int i = nums.length - 1; i >= 0; i--) {
            result[i] = temp;
            temp *= nums[i];
        }

        temp = 1;
        for (int i = 0; i < nums.length; i++) {
            result[i] *= temp;
            temp *= nums[i];
        }
        return result;
    }
}


// Definition for a binary tree node.
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int x) { val = x; }
}
