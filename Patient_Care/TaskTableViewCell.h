//
//  TaskTableViewCell.h
//  Patient_Care
//
//  Created by Jose Alvarado on 3/9/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
