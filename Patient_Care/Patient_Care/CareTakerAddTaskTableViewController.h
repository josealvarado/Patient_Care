//
//  CareTakerAddTaskTableViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/21/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CareTakerAddTaskTableViewController : UITableViewController<NSURLSessionDataDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>{
    
    NSArray *patients;
    
    int selected;
    
    UITableViewCell *selectedCell;
    
    NSDictionary *selectedPatient;
}

- (IBAction)saveButtonPressed:(id)sender;

- (void) checkTypeOfEmail:(NSString *)title titleOfAlert:(NSString *)msg someMessage:(NSString *)cancelMsg;
@end
