//
//  Settings.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/20/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (strong, nonatomic) NSMutableArray *patient_list;
@property (strong, nonatomic) NSMutableArray *caretaker_list;

@property (nonatomic) NSString *role;

@property (nonatomic) int selectedNote;
@property (nonatomic) int newNote;

@property (nonatomic) NSString *selectedNote2;

@property (nonatomic) NSString *selectedNote_details;

@property (nonatomic) NSDictionary *caretaker;
@property (nonatomic) NSDictionary *patient;

@property (nonatomic) NSString *caretaker_id;
@property (nonatomic) NSString *patient_id;

@property (nonatomic) NSString *task_date;
@property (nonatomic) NSString *task_name;

@property(nonatomic) NSString *emailButtonPressed;

@property (nonatomic) NSString *first_name;
@property (nonatomic) NSString *last_name;
@property (nonatomic) NSString *phone_number;

@property (nonatomic) UIImage *profileImage;


@property (strong, nonatomic) NSMutableArray *notes;

@property (nonatomic) int rewardPoints;

@property (nonatomic) int assignedTasksCount;
@property (nonatomic) int completedTasksCount;

@property (nonatomic) NSDictionary *serverPorts;

@property(nonatomic)NSString *deviceToken;

@property (nonatomic) int reccurentTask;

@property (strong, nonatomic) NSMutableDictionary *notifications;

@property (nonatomic) NSDictionary *selectedPatient;

@property (nonatomic) NSString *emergencyContactNumber;

+ (Settings *)instance;

@end
