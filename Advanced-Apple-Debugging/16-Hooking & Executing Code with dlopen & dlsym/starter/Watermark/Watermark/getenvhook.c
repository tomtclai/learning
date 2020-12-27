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
  static void *handle;
  static char * (*real_getenv)(const char *);
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    handle = dlopen("/usr/lib/system/libsystem_c.dylib", RTLD_NOW);
    assert(handle);
    real_getenv = dlsym(handle, "getenv");
  });

  if (strcmp(name, "HOME") == 0) {
    return "/WOOT";
  }

  return real_getenv(name);
}
