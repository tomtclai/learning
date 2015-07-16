/*
Find out the maximum sub-array of non negative numbers from an array.
The sub-array should be continuous. That is, a sub-array created by choosing the second and fourth element and skipping the third element is invalid.

Maximum sub-array is defined in terms of the sum of the elements in the sub-array. Sub-array A is greater than sub-array B if sum(A) > sum(B).

Example:

A : [1, 2, 5, -7, 2, 3]
The two sub-arrays are [1, 2, 5] [2, 3].
The answer is [1, 2, 5] as its sum is larger than [2, 3]
NOTE: If there is a tie, then compare with segment's length and return segment which has maximum length
NOTE 2: If there is still a tie, then return the segment with minimum starting index
*/
vector<int> Solution::maxset(vector<int> &Vec) {
    // Do not write main() function.
    // Do not read input, instead use the arguments to the function.
    // Do not print the output, instead return values as specified
    // Still have a doubt. Checkout www.interviewbit.com/pages/sample_codes/ for more details

    // vector<vector<int>> subArrays = getSubarrays(A);
    // return maximum(subArrays);

    int N = Vec.size();
    long long max_sum = 0;
    long long cur_sum = 0;
    int max_index_lo = -1;
    int max_index_hi = -1;
    int cur_index_lo = 0;
    int cur_index_hi = 0;

    while (cur_index_hi < N) {
        // if negative, start over
        if(Vec[cur_index_hi] < 0) {
            cur_index_lo = ++cur_index_hi ;
            cur_sum = 0;
        // if not negative, update max_index
        } else {
            cur_sum += (long long)Vec[cur_index_hi];
            if(max_sum < cur_sum) {
                max_sum = cur_sum;
                max_index_hi = ++cur_index_hi ;
                max_index_lo = cur_index_lo;

            // if same, take the one with larger range
            // if range is the same, take the one with a smaller index
            } else if (cur_sum == max_sum) {
                if (++cur_index_hi - cur_index_lo > max_index_hi - max_index_lo) {
                    max_index_lo = cur_index_lo;
                    max_index_hi = cur_index_hi ;
                }
            } else { //if not negative and no updated needed, move on to next index
                ++cur_index_hi;
            }
        }
    }
    vector<int> ans;
    if (max_index_lo == -1 || max_index_hi == -1) // if input is all negative
        return ans;

    for (int i = max_index_lo; i < max_index_hi; ++i)
        ans.push_back(Vec[i]);
    return ans;
}
