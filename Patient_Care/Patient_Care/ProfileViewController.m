//
//  ProfileViewController.m
//  Patient_Care
//
//  Created by Paresh on 03/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"
#import "ViewController.h"
#import "Settings.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize lastNameLabel;
@synthesize firstNameLabel;
@synthesize profileImage;


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"profileEditViewController"]){
        ProfileEditViewController *profileEditViewController = segue.destinationViewController;
        profileEditViewController.delegate = self;
    }
}

-(void)done:(NSString *)firstName fname:(NSString *)lastName{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    self.firstNameLabel.text = firstName;
    self.lastNameLabel.text = lastName;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameLabel.text = [Settings instance].first_name;
    self.lastNameLabel.text = [Settings instance].last_name;
    
    self.profileImage.image = [UIImage imageNamed:@"profileimage"];
    [Settings instance].profileImage = self.profileImage.image;
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
