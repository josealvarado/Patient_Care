//
//  ProfileViewController.h
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileEditViewController.h"
#import "ViewController.h"

@interface ProfileViewController : UIViewController <ProfileEditViewControllerDelegate>{
    
    IBOutlet UILabel *lastNameLabel;
    IBOutlet UILabel *firstNameLabel;
}


@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;


@end
