//
//  ProfileEditViewController.h
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileEditViewControllerDelegate <NSObject>

-(void)done:(NSString *)editPhoneNoLabelTextField;

@end

@interface ProfileEditViewController : UIViewController {
    IBOutlet UIBarButtonItem *editDoneButton;
    IBOutlet UITextField *editPhoneNoLabelTextField;
}


@property(nonatomic, assign) id <ProfileEditViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *editPhoneNoLabelTextField;


- (IBAction)editDoneButton:(id)sender;


@end
