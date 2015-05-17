//
//  RewardsViewController.h
//  Patient_Care
//
//  Created by Paresh on 30/04/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ViewController.h"


@interface RewardsViewController : ViewController
@property (weak, nonatomic) IBOutlet UIImageView *rewardsImage;
@property (strong, nonatomic) IBOutlet UILabel *rewardsPointsLabel;

@property(nonatomic) int intRewardPoints;
@end
