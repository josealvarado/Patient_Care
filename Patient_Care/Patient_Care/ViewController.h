//
//  ViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface ViewController : UIViewController<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFIeldEmailAddress;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (strong, nonatomic) KeychainItemWrapper *keychain;


- (IBAction)buttonLoginPressed:(id)sender;


@end

