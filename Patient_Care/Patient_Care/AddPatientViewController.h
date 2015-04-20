//
//  AddPatientViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPatientViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSURLSessionDataDelegate>{
    
    
    NSMutableArray *patients;
    
    int selected;
    
    NSMutableDictionary *returnedPatient;
}

- (IBAction)searchButtonPressed:(id)sender;

- (IBAction)addPatientButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *seachTextField;

@end
