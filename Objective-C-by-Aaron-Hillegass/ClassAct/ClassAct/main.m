//
//  main.m
//  ClassAct
//
//  Created by Tsz Chun Lai on 1/30/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BNRTowel.h"
NSArray *BNRHierarchyForClass(Class cls) {
    // Declare an array to hold the list of
    // this class and all its superclasses, building a hierarchy
    NSMutableArray *classHierarchy = [NSMutableArray array];
    
    // Keep climbing the class hierarchy until we get to a class with not superclass
    for (Class c = cls; c!= nil; c = class_getSuperclass(c)) {
        NSString *className = NSStringFromClass(c);
        [classHierarchy insertObject:className atIndex:0];
    }
    
    return classHierarchy;
}

NSArray *BNRMethodsForClass(Class cls) {

    unsigned int methodCount = 0;
    
    Method *methodList = class_copyMethodList(cls, &methodCount);
    
    NSMutableArray *methodArray = [NSMutableArray array];
    
    // Keep climbing the class hierarchy until we get to a class with not superclass
    for (int m = 0; m < methodCount; m ++) {
        // Get the current method
        Method currentMethod = methodList[m];
        // Get the selector of the current method
        SEL methodSelector = method_getName(currentMethod);
        // Add its string representation to the array
        [methodArray addObject:NSStringFromSelector(methodSelector)];
    }
    free(methodList);
    return methodArray;
}

NSArray *BNRVariablesForClass(Class cls) {
    
    unsigned int varCount = 0;
    
    Ivar* ivarList= class_copyIvarList(cls, &varCount);
    
    NSMutableArray *IvarArray = [NSMutableArray array];
    
    // Keep climbing the class hierarchy until we get to a class with not superclass
    for (int v = 0; v < varCount; v ++) {
        // Get the current method
        Ivar currentIvar = ivarList[v];
        // Get the selector of the current method
        const char* IvarSelector = ivar_getName(currentIvar);
        // Add its string representation to the array
        [IvarArray addObject:[NSString stringWithCString:IvarSelector encoding:NSASCIIStringEncoding]];
    }
    free(ivarList);
    return IvarArray;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // You don't have an object to do the observing,, but send
        // the addObserver message anyway, to kick of the runtime updates
        BNRTowel *myTowel = [BNRTowel new];
        [myTowel addObserver:nil
                  forKeyPath:@"location"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
        // Create an aarray of dictionaries, where each dictionary
        // will end up holding the class name, hierarchy, and method list
        // for a given class
        NSMutableArray *runtimeClassesInfo = [NSMutableArray array];
        // Declare a variable to hold the number of registered classes
        unsigned int classCount = 0;
        
        // Get a point to a list of all registered classes
        // currently loaded by your applcations.
        // the number of registered classes is returned by reference
        Class *classList = objc_copyClassList(&classCount);
        
        // For each class in the list ...
        for (int i = 0; i < classCount; i++) {
            // Treat the calssList as a C array to get a Class from it
            Class currentClass = classList[i];
            
            // Get the class's name as a string
            NSString *className = NSStringFromClass(currentClass);
            
            NSArray *hierarchy = BNRHierarchyForClass(currentClass);
            NSArray *methods = BNRMethodsForClass(currentClass);
            NSArray *iVars = BNRVariablesForClass(currentClass);
            
            NSDictionary *classInfoDict = @{@"className" : className,
                                            @"heirarchy" : hierarchy,
                                            @"methods"   : methods,
                                            @"variables" : iVars};

            [runtimeClassesInfo addObject:classInfoDict];
        }
        // Sort the classes info array alphabetically by name, and log it
        NSSortDescriptor *alphaAsc = [NSSortDescriptor sortDescriptorWithKey:@"classname"
                                                                   ascending:YES];
        NSArray *sortedArray = [runtimeClassesInfo
                                sortedArrayUsingDescriptors:@[alphaAsc]];
        NSLog(@"There are %ld classes registered with this program's RunTime.", sortedArray.count);
        NSLog(@"%@", sortedArray);
        // We're done with the class list buffer, so free it
        free(classList);
        [myTowel removeObserver:nil forKeyPath:@"location"];
    }
    return 0;
}
