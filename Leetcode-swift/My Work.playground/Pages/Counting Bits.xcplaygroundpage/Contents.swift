
import Foundation
/*:
Given a non negative integer number num. For every numbers i in the range 0 ≤ i ≤ num calculate the number of 1's in their binary representation and return them as an array.

```
For num = 5 you should return [0,1,1,2,1,2].
```

Follow up:

1. It is very easy to come up with a solution with run time O(n*sizeof(integer)). But can you do it in linear time O(n) /possibly in a single pass?
2. Space complexity should be O(n).
3. Can you do it like a boss? Do it without using any builtin function like __builtin_popcount in c++ or in any other language.
 */
/*
 1. 1 =                        1
 2. 1 =                    2
 3. 2 =                    2 + 1
 4. 1 =              2^2
 5. 2 =              2^2 +     1
 6. 2 =              2^2 + 2
 7. 3 =              2^2 + 2 + 1
 8. 1 =        2^3
 9. 2 =        2^3 +           1
 10. 2 =       2^3 +       2
 11. 3 =       2^3 +       2 + 1
 12. 2 =       2^3 + 2^2
 13. 3 =       2^3 + 2^2 +     1
 14. 3 =       2^3 + 2^2 + 2
 15. 4 =       2^3 + 2^2 + 2 + 1
 16. 1 = 2^4



 */
//func countBits(_ num: Int) -> [Int] {
//    return [0]
//}

