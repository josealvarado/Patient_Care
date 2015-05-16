//
//  CareTakerAddTaskViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/20/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "CareTakerAddTaskViewController.h"
#import "Settings.h"

@interface CareTakerAddTaskViewController ()

@end

@implementation CareTakerAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    taskSelected = -1;
    [Settings instance].reccurentTask = 0;
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

- (IBAction)addTaskButtonPressed:(id)sender {
    [Settings instance].task_name = selectedButton.titleLabel.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:_datePicker.date];
    
    NSLog(@"date %@", strDate);
    
    [Settings instance].task_date = strDate;
    [Settings instance].reccurentTask =  0;

}

- (IBAction)addRecurrentTaskButtonPressed:(id)sender {
    [Settings instance].task_name = selectedButton.titleLabel.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:_datePicker.date];
    
    NSLog(@"date %@", strDate);
    
    [Settings instance].task_date = strDate;
    [Settings instance].reccurentTask =  1;
}


- (void)datePickerChanged:(UIDatePicker *)datePicker
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
//    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
//
//    NSLog(@"date %@", strDate);
//    
//    [Settings instance].task_date = strDate;
}

- (IBAction)taskOnePressed:(id)sender {
    UIButton *button = sender;
    
    if (taskSelected != -1) {
        selectedButton.selected = NO;
        taskSelected = -1;
    }
    
    if (button.selected) {
        button.selected = NO;
        taskSelected = -1;
    } else {
        button.selected = YES;
        taskSelected = 1;
        selectedButton = button;
    }
}

- (IBAction)taskTwoPressed:(id)sender {
    
    UIButton *button = sender;
    
    if (taskSelected != -1) {
        selectedButton.selected = NO;
        taskSelected = -1;
    }
    
    if (button.selected) {
        button.selected = NO;
        taskSelected = -1;
    } else {
        button.selected = YES;
        taskSelected = 1;
        selectedButton = button;
    }
}

- (IBAction)taskThreePressed:(id)sender {
    
    UIButton *button = sender;
    
    if (taskSelected != -1) {
        selectedButton.selected = NO;
        taskSelected = -1;
    }
    
    if (button.selected) {
        button.selected = NO;
        taskSelected = -1;
    } else {
        button.selected = YES;
        taskSelected = 1;
        selectedButton = button;
    }
}
@end
