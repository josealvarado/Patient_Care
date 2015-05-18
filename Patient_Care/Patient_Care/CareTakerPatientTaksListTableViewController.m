//
//  CareTakerPatientTaksListTableViewController.m
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "CareTakerPatientTaksListTableViewController.h"
#import "Settings.h"
#import "CareTakerPatientTaskCellTableViewCell.h"

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
                
                int count = (int)[tasks count];
                
                [Settings instance].assignedTasksCount = count;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"in here with %lu", (unsigned long)[tasks count]);
                    
                    
                    [self.tableView reloadData];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get tasks" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    
                });
                
            }
        }
    else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"You must be connected to the internet to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPatientTaskTableViewCell1";
    CareTakerPatientTaskCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CareTakerPatientTaskCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.taskName.text = [[tasks objectAtIndex:indexPath.row] objectForKey:@"task"];
    
    NSDictionary *receivedTask = [tasks objectAtIndex:indexPath.row];
    
    NSString *time = [NSString stringWithFormat:@"%@ %@", [receivedTask objectForKey:@"date"], [receivedTask objectForKey:@"time"]];
    
    cell.taskDetails.text = time;
    
    
    NSString *getStatus = [[tasks objectAtIndex:indexPath.row] objectForKey:@"status"];

    if(![getStatus isEqualToString:@"complete"]){
        cell.taskStatus.text = @"Pending";
        [cell.taskEmailButton setHidden:YES];
    } else{
        cell.taskStatus.text = getStatus;
        [cell.taskEmailButton setHidden:YES];
    }
    
    NSLog(@"button being pressed %@", [Settings instance].emailButtonPressed);
    
    if([[Settings instance].emailButtonPressed isEqual:@"pressed"]){
        
        NSLog(@"button being pressed inside if%@", [Settings instance].emailButtonPressed);
        [self showEmail];
    }
    
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


- (void)showEmail {
    
    NSDictionary *patientProfile = [selectedPatient valueForKey:@"profile"];
    
    NSString *patientEmail = [patientProfile objectForKey:@"email"];
    
    // Email Subject
    NSString *emailTitle = @"Task Assigned";
    
    // Email Content
    NSString *messageBody = [Settings instance].task_name;
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject: patientEmail];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    mc.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail]){
        
        [mc setSubject:emailTitle];
        
        [mc setMessageBody:messageBody isHTML:YES];
        
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:nil];
    }
    else{
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"error"
                                                          message:@"No mail account setup on device"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
        [anAlert addButtonWithTitle:@"Cancel"];
        [anAlert show];
    }
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(error){
        
        switch (result)
        {
            case MFMailComposeResultCancelled:
                
                
                [self checkTypeOfEmail:@"Cancelled" titleOfAlert:@"Your email has been cancelled" someMessage:@"Click to Cancel"];
                
                break;
                
            case MFMailComposeResultSaved:
                
                [self checkTypeOfEmail:@"Saving" titleOfAlert:@"Your email has been saved" someMessage:@"Click to Cancel"];
                
                break;
                
            case MFMailComposeResultSent:
                
                [self checkTypeOfEmail:@"Mail Sent" titleOfAlert:@"Your email has been sent" someMessage:@"Click to dismiss"];
                
                break;
                
            case MFMailComposeResultFailed:
                
                [self checkTypeOfEmail:@"Failure" titleOfAlert:@"Sorry your could not be sent at the moment. Try Again" someMessage:@"Click to Cancel"];
                
                // do it this way cool.
                [self checkTypeOfEmail:@"a" titleOfAlert:@"b" someMessage:@"c"];
                
                break;
                
            default:
                
                break;
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) checkTypeOfEmail:(NSString *)title titleOfAlert:(NSString *)msg someMessage:(NSString *)cancelMsg{
    
    UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:title
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:cancelMsg
                                            otherButtonTitles:nil];
    [anAlert show];
    
}


- (IBAction)taskEmailButton:(id)sender {
}
@end
