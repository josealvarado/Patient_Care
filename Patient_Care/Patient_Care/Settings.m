//
//  Settings.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/20/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+ (Settings *)instance {
    static Settings *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [Settings new];
    });
    
    return _sharedClient;
}

@end
