//
//  ProfileEditViewController.m
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "ProfileViewController.h"
#import "Settings.h"
@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

@synthesize editFirstNameTextField;
@synthesize editLastNameTextField;
@synthesize delegate = _delegate;

- (IBAction)editDoneButton:(id)sender {
    [self.delegate done:editFirstNameTextField.text fname:editLastNameTextField.text];
    [Settings instance].first_name =     self.editFirstNameTextField.text;
    [Settings instance].last_name =     self.editLastNameTextField.text ;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editFirstNameTextField.text = [Settings instance].first_name;
    self.editLastNameTextField.text = [Settings instance].last_name;
    self.profileEditImage.image = [Settings instance].profileImage;
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
