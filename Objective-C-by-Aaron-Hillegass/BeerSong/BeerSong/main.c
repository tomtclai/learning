//
//  main.c
//  BeerSong
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
void singSongFor(int numberOfBottles)
{
    if (numberOfBottles ==0) {
        printf("There are simply not more bottles of beer on the wall.\n\n");
    } else {
        printf("%d bottles of beer on the wall, %d bottles of beer. \n",
               numberOfBottles, numberOfBottles);
        int oneFewer = numberOfBottles - 1;
        if(oneFewer>0) printf ("Take one down, pass it around, %d bottles of beer on the wall.\
               \n\n", oneFewer);
        singSongFor(oneFewer); // This function calls itself
        
        //Pring a message just before the function ends
        
        printf("Put a bottle in the recycling, %d empty bottles in the bin.\n",
               numberOfBottles);
    }
}
int main(int argc, const char * argv[]) {
    // insert code here...
    singSongFor(4);
    return 0;
}
