//
//  main.c
//  ClassCertificates
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include <unistd.h>
void congratulateStudent(char* student, char* course, int numdays)
{
    printf("%s has done as much %s Programming as I could fit into %d days.\n",
           student,course,numdays);
}
int main(int argc, const char * argv[]) {
    congratulateStudent("Kate", "Cocoa", 5);
    sleep(2);
    congratulateStudent("Bo", "Objective-C", 2);
    sleep(2);
    congratulateStudent("Mike", "Python", 5);
    sleep(2);
    congratulateStudent("Liz", "iOS", 5);
}
