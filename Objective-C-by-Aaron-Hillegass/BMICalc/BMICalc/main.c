//
//  main.c
//  BMICalc
//
//  Created by Tsz Chun Lai on 10/26/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

typedef struct {
    float heightInMeters;
    int weightInKilos;
} Person;
//
//float bodyMassIndex(Person p)
//{
//    return p.weightInKilos/(p.heightInMeters * p.heightInMeters);
//}

float bodyMassIndex(Person *p)
{
    return p->weightInKilos/ (p->heightInMeters * p->heightInMeters);
}
//struct tm {
//    int    tm_sec;     /* seconds after the minute [0-60] */
//    int    tm_min;     /* minutes after the hour [0-59] */
//    int    tm_hour;    /* hours since midnight [0-23] */
//    int    tm_mday;    /* day of the month [1-31] */
//    int    tm_mon;     /* months since January [0-11] */
//    int    tm_year;    /* years since 1900 */
//    int    tm_wday;    /* days since Sunday [0-6] */
//    int    tm_yday;    /* days since January 1 [0-365] */
//    int    tm_isdst;   /* Daylight Savings Time flag */
//    long   tm_gmtoff;  /* offset from CUT in seconds */
//    char   *tm_zone;   /* timezone abbreviation */
//};
void challenge()
{
    long secondsSince1970 = time(NULL);
    printf("It has been %ld seconds since 1970\n", secondsSince1970);
    struct tm now;
    localtime_r(&secondsSince1970,&now);
    printf("The time is %d%d%d\n", now.tm_hour, now.tm_min, now.tm_sec);
    long fourMil = secondsSince1970+4000000;
    localtime_r(&fourMil,&now);
    printf("The date is %d/%d/%d\n", now.tm_year+1970, now.tm_mon+1, now.tm_mday);
}

void person()
{
    Person *mikey = (Person *)malloc(sizeof(Person));
    mikey->heightInMeters = 1.7;
    mikey->weightInKilos = 96;
    
    Person *aaron = (Person *)malloc(sizeof(Person));
    aaron->heightInMeters = 1.97;
    aaron->weightInKilos = 84;
    
    printf("mikey is %.2f meters tall\n", mikey->heightInMeters);
    printf("mikey weighs %d kilograms\n", mikey->weightInKilos);
    printf("mikey has a BMI of %.2f\n", bodyMassIndex(mikey));
    
    printf("aaron is %.2f meters tall\n", aaron->heightInMeters);
    printf("aaron weighs %d kilograms\n", aaron->weightInKilos);
    printf("aaron has a BMI of %.2f\n", bodyMassIndex(aaron));
    
    free(mikey);
    mikey= NULL;
    free(aaron);
    aaron =NULL;
}
int main(int argc, const char * argv[]) {
    challenge();
    return 0;
}
