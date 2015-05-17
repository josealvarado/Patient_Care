//
//  ListPatientNotesTableViewController.h
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListPatientNotesTableViewController : UITableViewController<NSURLSessionDataDelegate>{
    
    NSDictionary *note_details;
    
        NSDictionary *note_details_1;
    
    NSMutableArray *notes;
    NSMutableArray *notes_patient;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
