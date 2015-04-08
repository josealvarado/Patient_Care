//
//  LinkPatientTableViewCell.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkPatientTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *patientName;

@property (weak, nonatomic) IBOutlet UILabel *patientEmail;

- (IBAction)selectButtonPressed:(id)sender;


@end
