//
//  ViewNotesTableViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/22/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewNotesTableViewController : UITableViewController<NSURLSessionDataDelegate>{
    
    NSDictionary *note_details;
    
    NSDictionary *generalNotes;
    
        NSDictionary *note_details_1;
    
    NSMutableArray *notes;
    NSMutableArray *notes2;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
