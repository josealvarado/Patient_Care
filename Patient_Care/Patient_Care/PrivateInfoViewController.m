//
//  PrivateInfoViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 5/18/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "PrivateInfoViewController.h"
#import "Settings.h"

@interface PrivateInfoViewController ()

@end

@implementation PrivateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    _emergengyNumberTextField.text = [Settings instance].emergencyContactNumber;
}

- (IBAction)saveButtonPressed:(id)sender {
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([_emergengyNumberTextField.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // newString consists only of the digits 0 through 9
        [Settings instance].emergencyContactNumber = _emergengyNumberTextField.text;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Updated private information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Invalid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
