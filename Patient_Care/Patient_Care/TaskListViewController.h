//
//  TaskListViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 3/9/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskListViewController : UIViewController<NSURLSessionDataDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *tasks;
    
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView *taskTableView;

@end
