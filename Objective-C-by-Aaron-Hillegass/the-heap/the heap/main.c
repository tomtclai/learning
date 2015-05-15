//
//  main.c
//  the heap
//
//  Created by Tsz Chun Lai on 10/26/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
int main(int argc, const char * argv[]) {
    float *startOfBuffer;
    startOfBuffer = malloc(1000*sizeof(float));
    free(startOfBuffer);
    startOfBuffer = NULL;
    return 0;
}
