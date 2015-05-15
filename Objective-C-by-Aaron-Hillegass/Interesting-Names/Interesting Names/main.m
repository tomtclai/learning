//
//  main.m
//  Interesting Names
//
//  Created by Tsz Chun Lai on 1/17/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Read in a file as a huge string (ignoring the possibility of an error)
        NSString *nameString =
        [NSString stringWithContentsOfFile:@"/usr/share/dict/propernames"
                                  encoding:NSUTF8StringEncoding
                                     error:NULL];
        NSString *wordString =
        [NSString stringWithContentsOfFile:@"/usr/share/dict/words"
                                  encoding:NSUTF8StringEncoding
                                     error:NULL];
        
        // Break it into an array of strings
        NSArray *names = [nameString componentsSeparatedByString:@"\n"];
        NSArray *words = [wordString componentsSeparatedByString:@"\n"];
        
        // Go through the array one string at a time

        int wordMarker = 0;
        int nameMarker = 0;
        
        for (int nameCur = nameMarker; nameCur < names.count; nameCur++) {
            NSString *n = names[nameCur];
            for (int wordCur = wordMarker ; wordCur < words.count; wordCur++)
            {
                NSString *w = words[wordCur];
                //is this name also a word?
                if (n==w)
                {
                    NSLog(@"%@", n);
                    wordMarker = wordCur;
                    nameMarker = nameCur;
                    break;
                }
            }
        }
    }
    return 0;
}
