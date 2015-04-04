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

@property (weak, nonatomic) IBOutlet UITextField *textfieldPhoneNumber;

@property (weak, nonatomic) IBOutlet UISegmentedControl *profileSegmentedControl;


- (IBAction)buttonRegisterPressed:(id)sender;

@end
