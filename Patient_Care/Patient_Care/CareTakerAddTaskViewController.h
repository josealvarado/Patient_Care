//
//  CareTakerAddTaskViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/20/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareTakerAddTaskViewController : UIViewController{
    
    int taskSelected;
    UIButton *selectedButton;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)addTaskButtonPressed:(id)sender;

- (IBAction)addRecurrentTaskButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *taskOneButton;

@property (weak, nonatomic) IBOutlet UIButton *task2Button;

@property (weak, nonatomic) IBOutlet UIButton *task3Button;

- (IBAction)taskOnePressed:(id)sender;

- (IBAction)taskTwoPressed:(id)sender;

- (IBAction)taskThreePressed:(id)sender;

@end
