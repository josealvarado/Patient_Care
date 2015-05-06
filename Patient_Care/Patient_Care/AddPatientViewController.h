//
//  AddPatientViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPatientViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSURLSessionDataDelegate, UITextFieldDelegate>{
    

    
    NSMutableArray *patients;
    
    int selected;
    
    NSMutableDictionary *returnedPatient;
    
    
}

- (IBAction)searchButtonPressed:(id)sender;

- (IBAction)addPatientButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *seachTextField;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UITextField *relationTextField;


@end
