//
//  main.c
//  TurkeyTimer
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
void showCookingTimeForTurkey(int pounds)
{
    int necessaryMinutes = 15+15*pounds;
    printf("cook for %d minutes.\n", necessaryMinutes);
    if(necessaryMinutes > 120){
        int halfway = necessaryMinutes/2;
        printf("Rotate after %d of the %d minutes. \n",
               halfway, necessaryMinutes);
    }
}
int main(int argc, const char * argv[]) {
    int totalWeight = 10;
    int gibletsWeight = 1;
    int turkeyWeight = totalWeight - gibletsWeight;
    showCookingTimeForTurkey(turkeyWeight);
    return 0;
}
