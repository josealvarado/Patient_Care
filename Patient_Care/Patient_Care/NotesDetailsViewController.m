//
//  NotesDetailsViewController.m
//  Patient_Care
//
//  Created by Paresh on 17/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "NotesDetailsViewController.h"
#import "Settings.h"
@interface NotesDetailsViewController ()

@end

@implementation NotesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog([Settings instance].selectedNote_details);
    self.notesDetailLabel.text = [Settings instance].selectedNote_details;
    
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
