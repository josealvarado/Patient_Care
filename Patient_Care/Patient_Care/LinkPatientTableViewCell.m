//
//  LinkPatientTableViewCell.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "LinkPatientTableViewCell.h"

@implementation LinkPatientTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    [_selectButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)selectButtonPressed:(id)sender {
    
}
@end
