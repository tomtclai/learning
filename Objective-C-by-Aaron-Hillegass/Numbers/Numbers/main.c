//
//  main.c
//  Numbers
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include "math.h"
int main(int argc, const char * argv[]) {
    unsigned long int x = 255;
    printf("x is %lu. \n",x);
    printf("In octal, x is %lo. \n", x);
    printf("In hexadecimal, x is %lx. \n", x);
    
    double y = 12345.6789;
    printf("y is %.2f\n", y);
    printf("y is %.2e\n", y);
    
    printf("%f\n",sin(1));
    return 0;
}

