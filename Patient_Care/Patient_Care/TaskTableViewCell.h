//
//  TaskTableViewCell.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/25/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell<NSURLSessionDelegate>{
    
    BOOL completed;
}

@property (strong, nonatomic) NSDictionary* taskInfo;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UIButton *completedButton;

//- (IBAction)completedButtonPressed:(id)sender;

@end
