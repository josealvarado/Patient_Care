//
//  CareTakerPatientTaksListTableViewController.m
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "CareTakerPatientTaksListTableViewController.h"
#import "Settings.h"

@interface CareTakerPatientTaksListTableViewController ()

@end

@implementation CareTakerPatientTaksListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    tasks = [[NSMutableArray alloc] init];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self getLatestTasks];
    
}

- (void)getLatestTasks {
    
    NSDictionary *selectedPatient = [Settings instance].selectedPatient;
    NSString *patientID = [selectedPatient objectForKey:@"id"];
    
//    NSMutableArray *patientList = [Settings instance].patient_list;
//    
//    NSDictionary *patient = [patientList objectAtIndex:4];
//        
//    NSString *pID = [patient objectForKey:@"id"];
    
//    NSMutableArray *caretakerList = [Settings instance].caretaker_list;
//    
//    NSDictionary *caretaker = [caretakerList objectAtIndex:4];
//    
//    NSString *cID = [caretaker objectForKey:@"id"];
//    
    
    NSString *caretakerID = [[Settings instance].caretaker objectForKey:@"id"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSLog(@"patientID %@, caretakerID %@", patientID, caretakerID);
    
    NSString *params = [NSString stringWithFormat:@"%@/listtasks?c=%@&p=%@", [Settings instance].serverPorts[@"tasks"], caretakerID, patientID];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"data %@", data);
        
        NSLog(@"response %@", response);
        
        NSLog(@"erorr %@", error);
        
        if (!error) {
            
            NSLog(@"COrrect");
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            
            NSLog(@"json: %@", json);
            
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str %@", newStr);
            
            
            
            if (status_code == 202) {
                
                
                tasks = [json objectForKey:@"tasks"];
                
                for (int i = 0; i < tasks.count; i++) {
                    
                    NSDictionary *task = [tasks objectAtIndex: i];
                    
                    
                }
                
                int count = (int)[tasks count];
                
                [Settings instance].assignedTasksCount = count;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"in here with %lu", (unsigned long)[tasks count]);
                    
                    
                    [self.tableView reloadData];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                          
                                                                    message:@"Failed to get tasks"
                                          
                                                                   delegate:nil
                                          
                                                          cancelButtonTitle:@"OK"
                                          
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                    
                    
                });
                
            }
        }
    else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                      
                                                                message:@"You must be connected to the internet to use this app."
                                      
                                                               delegate:nil
                                      
                                                      cancelButtonTitle:@"OK"
                                      
                                                      otherButtonTitles:nil];
                
                [alert show];
                
                
            });
            
        }
        
    }];
    
    [postDataTask resume];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPatientTaskTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[tasks objectAtIndex:indexPath.row] objectForKey:@"task"];
    
    NSDictionary *receivedTask = [tasks objectAtIndex:indexPath.row];
    
    NSString *time = [NSString stringWithFormat:@"%@ %@", [receivedTask objectForKey:@"date"], [receivedTask objectForKey:@"time"]];
    
    cell.detailTextLabel.text = time;
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}

@end
