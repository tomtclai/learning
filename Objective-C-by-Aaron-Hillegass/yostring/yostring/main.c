//
//  main.c
//  yostring
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>  // For printf
#include <stdlib.h> // For malloc/free
#include <string.h> // For strlen
void example()
{
    char x = 0x21; // '!'
    while (x <= 0x7e){ //'~'
        printf("%x is %c\n", x, x);
        x++;
    }
    
    const char *start = "Love\n\n\n\n\n";//string literal (constant)
    //add const so you get compliler error instead of runtime error
    
    ////     Get a pointer to 5 bytes of memory on the heap
    //    char *start = malloc(5);
    
    //    // Put 'L' in the first byte
    //    *start = 'L';
    //
    //    // Put 'o' in the second byte
    //    *(start + 1) = 'o';
    //
    //    // Put 'v' in the third byte
    //    *(start + 2) = 'v';
    //
    //    // Put 'e' in the fourth byte
    //    *(start + 3) = 'e';
    //
    //    // Put zero in the fifth byte
    //    *(start + 4) = '\0';
    
    // Print out the string and its length
    printf("%s has %zu characters\n", start, strlen(start));
    //    start[2] = 'z';
    printf("The third letter is %c\n", start[2]);
    
    //    free(start);
    //    start = NULL;

}
int spaceCount(const char * c)
{
    unsigned long length = strlen(c);
    int count = 0;
    const char space = ' ';
    for (unsigned long i = 0; i < length; i ++)
    {
        if (c[i] == space) count++;
    }
    return count;
}

int main(int argc, const char * argv[]) {
    const char *sentence = "He was not in the cab at the time.";
    printf("\"%2s\" has %d spaces \n", sentence, spaceCount(sentence));
    return 0;
}
