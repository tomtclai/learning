//
//  main.m
//  Affirmation
//
//  Created by Tsz Chun Lai on 1/30/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int count = atoi(argv[2]);
        
        if (argc != 3) {
            fprintf(stderr, "Usage: Affirmation <adjective> <number>\n");
        }
        
        for (int j = 0 ; j < count; j++)
        {
            printf("You are %s!\n", argv[1]);
        }
    }
    return 0;
}
