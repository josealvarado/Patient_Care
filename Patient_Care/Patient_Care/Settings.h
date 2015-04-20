//
//  Settings.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/20/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (strong, nonatomic) NSMutableDictionary *ballots;
@property (nonatomic) NSString *caretaker_id;
@property (nonatomic) NSString *patient_id;

+ (Settings *)instance;

@end
