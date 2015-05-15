//
//  main.m
//  VowelMovment
//
//  Created by Tsz Chun Lai on 1/19/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ArrayEnumerationBlock) (id, NSUInteger, BOOL *);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *originalStrings = @[@"Sauerkraut", @"Raygun",
                                     @"Big Nerd Ranch", @"Mississippi"];
        NSLog(@"original string :%@", originalStrings);
        
        NSMutableArray *devowelizedStrings = [NSMutableArray array];
        
        NSArray *vowels = @[@"a", @"e", @"i", @"o", @"u"];
        
//        // Declare the block variable
//        ArrayEnumerationBlock devowelizer;
//        devowelizer = ^(id string, NSUInteger i, BOOL *stop)
//        {
//            // Compose a block and assign it to the variable
//            NSMutableString * newString = [NSMutableString stringWithString:string];
//            
//            // Iterate over the array of vowels, replace occurrences of each
//            // with an empty string
//            for (NSString *s in vowels)
//            {
//                NSRange fullRange = NSMakeRange(0, [newString length]);
//                [newString replaceOccurrencesOfString:s
//                                           withString:@""
//                                              options:NSCaseInsensitiveSearch
//                                                range:fullRange];
//                NSRange yRange = [string rangeOfString:@"y"
//                                               options:NSCaseInsensitiveSearch];
//                //Did i find a y?
//                if (yRange.location != NSNotFound)
//                {
//                    *stop = YES;//stop futher iterations
//                    return;     //END this itereation
//                }
//            }
//            
//            [devowelizedStrings addObject:newString];
//        }; // End of block assignment
        
        //Iterate over the array with your block
        [originalStrings
         enumerateObjectsUsingBlock:
         ^(id string, NSUInteger i, BOOL *stop)
         {
             // Compose a block and assign it to the variable
             NSMutableString * newString = [NSMutableString stringWithString:string];
             
             // Iterate over the array of vowels, replace occurrences of each
             // with an empty string
             for (NSString *s in vowels)
             {
                 NSRange fullRange = NSMakeRange(0, [newString length]);
                 [newString replaceOccurrencesOfString:s
                                            withString:@""
                                               options:NSCaseInsensitiveSearch
                                                 range:fullRange];
                 NSRange yRange = [string rangeOfString:@"y"
                                                options:NSCaseInsensitiveSearch];
                 //Did i find a y?
                 if (yRange.location != NSNotFound)
                 {
                     *stop = YES;//stop futher iterations
                     return;     //END this itereation
                 }
             }
             
             [devowelizedStrings addObject:newString];
         } // End of block assignment];
         ];
        NSLog(@"devowelized strings: %@", devowelizedStrings);
        
    }
    return 0;
}
