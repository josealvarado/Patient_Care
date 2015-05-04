//
//  ProfileViewController.h
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileEditViewController.h"

@interface ProfileViewController : UIViewController <ProfileEditViewControllerDelegate>{
    
    IBOutlet UILabel *phoneNoLabel;
 
}

@property (strong, nonatomic) IBOutlet UILabel *phoneNoLabel;


@end
