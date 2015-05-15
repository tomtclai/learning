//
//  main.c
//  Turkey
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
    //Declare the vairable called 'weight' of type float
    float weight;
    //store a number in that vairable
    weight = 14.2;
    //Log it to the user
    printf("The turkey weights %f.\n", weight);
    //Declare another vairable of type float
    float cookingTime;
    //Calculate the cooking time and store it in the variable
    //In this case, '*' means 'multiplied by'
    cookingTime = 15.0 + 15.0 * weight;
    //Log that to the user
    printf("Cook it for %f minutes.\n",cookingTime);
    //end this function and indicate success
    return 0;
}
