//
//  RegisterViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmaillAdress;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UITextField *textfieldFirstName;

@property (weak, nonatomic) IBOutlet UISegmentedControl *profileSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *textfieldLastName;


- (IBAction)buttonRegisterPressed:(id)sender;

@end
