//
//  main.c
//  Triangle
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
float remainingAngle(const float angleA, const float angleB){
    return 180 - angleA - angleB;
}
int main(int argc, const char * argv[]) {
    float angleA =30.0;
    float angleB =60.0;
    float angleC = remainingAngle(angleA,angleB);
    printf("The third angle is %.2f\n", angleC);
    return 0;
}
