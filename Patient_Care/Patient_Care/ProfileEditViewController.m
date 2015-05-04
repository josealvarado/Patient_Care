//
//  ProfileEditViewController.m
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "ProfileViewController.h"
@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

@synthesize editPhoneNoLabelTextField;
@synthesize delegate = _delegate;

- (IBAction)editDoneButton:(id)sender {
    [self.delegate done:editPhoneNoLabelTextField.text];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    ProfileViewController *data = [[ProfileViewController alloc]init];
    self.editPhoneNoLabelTextField.text = data.phoneNoLabel.text;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
