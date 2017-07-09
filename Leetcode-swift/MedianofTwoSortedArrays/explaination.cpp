// midLong, midShort:     0 1 2 3 4 5 6 7 8 9 10
// L1, L2, R1, R2:   0   1   2   3   4
// numsLong:          # 1 # 2 # 3 # 4 # 5 #
// numsShort:          # 1 #
 double findMedianSortedArrays(vector<int>& numsLong, vector<int>& numsShort) {
    int N1 = numsLong.size(); // 5
    int N2 = numsShort.size(); // 1
    if (N1 < N2) return findMedianSortedArrays(numsShort, numsLong);	// Make sure A2 is the shorter one.
    // it is 
    
    if (N2 == 0) return ((double)numsLong[(N1-1)/2] + (double)numsLong[N1/2])/2;  // If A2 is empty
    // not empty
    
    int lo = 0, hi = N2 * 2; // the number of spots, including in between elements and before and after array
    // lo = 2, hi = 2

    while (lo <= hi) {
        // 0 <= 2

        int midShort = (lo + hi) / 2;   // midShort =  2
        int midLong = N1 + N2 - midShort;  // midLong = 5+1-2 = 4
        
        double L1 = (midLong == 0) ? INT_MIN : numsLong[(midLong-1)/2];	// L1 = numsLong[1] = 2
        double R1 = (midLong == N1 * 2) ? INT_MAX : numsLong[(midLong)/2]; // R1 = numsLong[2] = 3
        double L2 = (midShort == 0) ? INT_MIN : numsShort[(midShort-1)/2];  // L2 = numsShort[0] = 1
        double R2 = (midShort == N2 * 2) ? INT_MAX : numsShort[(midShort)/2]; // R2 = INT_MAX
        
        if (L1 > R2) lo = midShort + 1;		// lo = midShort + 1 = 2
        else if (L2 > R1) hi = midShort - 1;	// A2's lower half too big; need to move C2 left.
        else return (max(L1,L2) + min(R1, R2)) / 2;	// Otherwise, that's the right cut.
        // (2+3) / 2 = 2.5
    }

    return -1;
} 