//
//  CareTakerPatientTaskCellTableViewCell.m
//  Patient_Care
//
//  Created by Paresh on 18/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "CareTakerPatientTaskCellTableViewCell.h"
#import "LinkPatientTableViewCell.h"
#import "Settings.h"

@implementation CareTakerPatientTaskCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)taskEmailButtonPressed:(id)sender {
    [Settings instance].emailButtonPressed = @"pressed";
    
    NSLog(@"%@", [Settings instance].emailButtonPressed);
}


@end
