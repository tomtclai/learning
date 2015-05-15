//
//  main.c
//  CountDown
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//
#include <readline/readline.h>
#include <stdio.h>

int main(int argc, const char * argv[]) {
    printf("Where should I start counting?");
    const char *count = readline(NULL);
    for (int i = atoi(count); i > -3; i -= 3)
    {
        printf("%d\n", i);
        if(i%5==0) printf("Found one!\n");
    }
    return 0;
}
