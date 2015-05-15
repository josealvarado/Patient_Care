//
//  CareTakerPatientTaksListTableViewController.h
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareTakerPatientTaksListTableViewController : UITableViewController<NSURLSessionDataDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *tasks;
    
    UIRefreshControl *refreshControl;
    
    
}

@property (strong, nonatomic) NSDictionary* taskInfo;

@property (weak, nonatomic) IBOutlet UITableView *taskTableView;

@end
