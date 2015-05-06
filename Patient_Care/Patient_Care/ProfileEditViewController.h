//
//  ProfileEditViewController.h
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileEditViewControllerDelegate <NSObject>

-(void)done:(NSString *)editfirstNameTextField fname:(NSString *)editlastNameTextField;

@end

@interface ProfileEditViewController : UIViewController {
    IBOutlet UIBarButtonItem *editDoneButton;
    IBOutlet UITextField *editLastNameTextField;
    IBOutlet UITextField *editFirstNameTextField;
}

@property (strong, nonatomic) IBOutlet UIImageView *profileEditImage;

@property(nonatomic, assign) id <ProfileEditViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *editLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *editFirstNameTextField;



- (IBAction)editDoneButton:(id)sender;


@end
