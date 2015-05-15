//
//  main.c
//  Addresses
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include <math.h>
void meterToFeetInches(double meters, unsigned int *ftPtr, double *inPtr)
{
    double rawFeet = meters * 3.281;
    unsigned int fractionalFoot;
    double inches = 0.0;
    if (ftPtr)
    {
        fractionalFoot = (unsigned int) modf(rawFeet, (double*) ftPtr);
        *ftPtr = rawFeet;
        inches = fractionalFoot * 12;
    }
    if (inPtr)
    {
        *inPtr = inches;
    }
}
int main(int argc, const char * argv[]) {
    int i = 17;
    int *addressOfI = & i;
    printf("i stores its value %d at %p\n", i, &i);
    printf("the int stored at %p is %d\n", addressOfI, *addressOfI);
    printf("the int stored at addressOfI is %d\n", *addressOfI);
    *addressOfI = 89;
    printf("Now i is %d\n", i);
    printf("An int is %zu byte\n", sizeof(int));
    float *myPointer;
    //Has myPointer been set?
    if (myPointer)
    {
        //myPointer is not NULL
    }
    else
    {
        //myPointer is NULL
    }
    printf("A float is %zu byte\n", sizeof(float));
    double pi = 3.14;
    double integerPart;
    double fractionPart;
    //pass address of integerpart as an argument
    fractionPart = modf(pi, &integerPart);
    //find the value stored in integerpart
    printf("%.2f: integerpart = %.0f, fractionPart = %.2f\n", pi, integerPart,
           fractionPart);
    return 0;
}
