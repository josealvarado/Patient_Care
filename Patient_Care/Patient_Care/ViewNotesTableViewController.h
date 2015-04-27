//
//  ViewNotesTableViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/22/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewNotesTableViewController : UITableViewController<NSURLSessionDataDelegate>{
    
    NSMutableArray *notes;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
