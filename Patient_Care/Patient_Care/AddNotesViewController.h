//
//  AddNotesViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/22/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNotesViewController : UIViewController<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextView *noteTextField;

@property (strong, nonatomic) NSString *note;
@property (nonatomic) NSInteger *noteNumber;

@property (nonatomic, assign) BOOL *newNote;


@property (strong, nonatomic) NSDictionary *data;


- (IBAction)linkPatientPressed:(id)sender;

- (IBAction)saveButtonPressed:(id)sender;
@end
