//
//  CareTakerPatientTaskCellTableViewCell.h
//  Patient_Care
//
//  Created by Paresh on 18/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CareTakerPatientTaskCellTableViewCell : UITableViewCell<NSURLSessionDataDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{


    NSDictionary *selectedPatient;

}
@property (strong, nonatomic) NSDictionary* taskInfo;

@property (weak, nonatomic) IBOutlet UILabel *taskName;

@property (weak, nonatomic) IBOutlet UILabel *taskDetails;

@property (strong, nonatomic) IBOutlet UILabel *taskStatus;

@property (strong, nonatomic) IBOutlet UIButton *taskEmailButton;

- (IBAction)taskEmailButtonPressed:(id)sender;

@end
