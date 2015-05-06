//
//  AboutTableViewController.h
//  Patient_Care
//
//  Created by Paresh on 06/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;

@property (strong, nonatomic) IBOutlet UILabel *supportLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsOfUse;
@property (strong, nonatomic) IBOutlet UILabel *privacyPolicyLabel;
@end
