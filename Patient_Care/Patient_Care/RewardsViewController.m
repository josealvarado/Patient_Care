//
//  RewardsViewController.m
//  Patient_Care
//
//  Created by Paresh on 30/04/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardsViewController.h"
#import "Settings.h"

@interface RewardsViewController ()

@end

@implementation RewardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.stRewardPoints = self.rewardsPointsLabel.text;
    [self assignRewardBadge];
    self.intRewardPoints = [Settings instance].rewardPoints;
    self.rewardsPointsLabel.text = [NSString stringWithFormat:@"TOTAL POINTS %d", self.intRewardPoints];
    
    // Do any additional setup after loading the view.
}

-(void)assignRewardBadge{
    if([Settings instance].rewardPoints == 10){
        self.rewardsImage.image = [UIImage imageNamed:@"thumbsup.png"];
    } else if([Settings instance].rewardPoints == 50){
        self.rewardsImage.image = [UIImage imageNamed:@"goldstar.png"];
    } else if([Settings instance].rewardPoints == 100){
        self.rewardsImage.image = [UIImage imageNamed:@"honorbadge.png"];
    }
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
