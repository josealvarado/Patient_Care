//
//  CareTakerPatientTaksListTableViewController.h
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CareTakerPatientTaskCellTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface CareTakerPatientTaksListTableViewController : UITableViewController<NSURLSessionDataDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    
    NSMutableArray *tasks;
    
    UIRefreshControl *refreshControl;
    
        NSDictionary *selectedPatient;
    
}

@property (strong, nonatomic) NSDictionary* taskInfo;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;

@end
