//
//  ListPatientsTableViewController.h
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListPatientsTableViewController : UITableViewController<NSURLSessionDataDelegate>{
    NSMutableArray *patients;
}
- (IBAction)doneButtonPressed:(id)sender;


@end
