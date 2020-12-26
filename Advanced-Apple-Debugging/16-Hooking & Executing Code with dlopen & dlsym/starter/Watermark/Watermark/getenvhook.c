//
//  getenvhook.c
//  HookingSwift
//
//  Created by Lai, Tom on 12/26/20.
//  Copyright © 2020 Razeware. All rights reserved.
//

#import <dlfcn.h>
#import <assert.h>
#import <stdio.h>
#import <dispatch/dispatch.h>
#import <string.h>



char * getenv(const char *name) {
//  return  getenv(name);
  return "YAY";
}
