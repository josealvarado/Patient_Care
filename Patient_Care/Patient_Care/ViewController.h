//
//  ViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textFIeldEmailAddress;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

- (IBAction)buttonLoginPressed:(id)sender;


@end

