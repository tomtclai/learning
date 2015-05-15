//
//  main.c
//  Degrees
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
//Declare a global variable
static float lastTemperature;
float fahrenheitFromCelsius(float celsius)
{
    lastTemperature = celsius;
    float fahrenheit = celsius * 1.8 + 32.0;
    printf("%f Celsius is %f Fahrenheit\n", celsius, fahrenheit);
    return fahrenheit;
}
int main(int argc, const char * argv[]) {
    float freezeInC = 0;
    float freezeInF = fahrenheitFromCelsius(freezeInC);
    printf("water freezes at %f degrees fahrenheit. \n",freezeInF);
    printf("The last temperature converted was %f. \n", lastTemperature);
    return EXIT_SUCCESS;
}
