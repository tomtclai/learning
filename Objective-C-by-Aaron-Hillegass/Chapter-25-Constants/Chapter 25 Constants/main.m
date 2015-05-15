//
//  main.m
//  Chapter 25 Constants
//
//  Created by Tsz Chun Lai on 1/18/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"\u03c0 == %.48f", M_PI);
        NSLog(@"%d is larger", MAX(10,12));
        
        NSLocale *here = [NSLocale currentLocale];
        NSString *currency = [here objectForKey:NSLocaleCurrencyCode];
        NSLog(@"Money is %@", currency);
//        
//        typedef enum BlenderSpeed {
//            BlenderSpeedStir = 1,
//            BlenderSpeedChop = 2,
//            BlenderSpeedLiquify = 5,
//            BlenderSpeedPulse = 9,
//            BlenderSpeedIceCrush = 15
//        } BlenderSpeed;
        
        typedef NS_ENUM(char, BlenderSpeed){
            BlenderSpeedStir,
            BlenderSpeedChop,
            BlenderSpeedLiquify,
            BlenderSpeedPulse,
            BlenderSpeedIceCrush
        };
    }
    return 0;
}
