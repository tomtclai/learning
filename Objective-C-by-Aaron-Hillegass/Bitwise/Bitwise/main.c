//
//  main.c
//  Bitwise
//
//  Created by Tsz Chun Lai on 1/25/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
    unsigned char a = 0x3c;
    unsigned char b = 0xa9;
    unsigned char c = a | b;
    printf("Hex : %x | %x = %x \n", a, b ,c);
    
    unsigned char d = a&b;
    printf("Hex: %x & %x = %x\n", a, b, d);
    printf("Decimal: %d & %d = %d\n", a, b, d);
    
    unsigned char e = a^b;
    printf("Hex: %x ^ %x = %x\n", a, b, e);
    printf("Decimal: %d ^ %d = %d\n", a, b, e);
    
    unsigned char f = ~b;
    printf("Hex: ~ %x = %x\n", b, f);
    printf("Decimal: ~ %d = %d\n", b, f);
    
    uint64_t l =  1;
    printf("%lld\n",l);
    for ( int i = 0 ; i <= 32; i++)
    {
        l = l | (l << 2);
        
    }
    printf("%lld\n",l);
}

