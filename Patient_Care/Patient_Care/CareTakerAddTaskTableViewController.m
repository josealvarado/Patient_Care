//
//  CareTakerAddTaskTableViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/21/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "CareTakerAddTaskTableViewController.h"
#import "Settings.h"
#import "LinkPatientTableViewCell.h"

@interface CareTakerAddTaskTableViewController ()



- (void) checkTypeOfEmail:(NSString *)title titleOfAlert:(NSString *)msg someMessage:(NSString *)cancelMsg;

@end

@implementation CareTakerAddTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    selected = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"hello");
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"display");

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"count %lu", (unsigned long)[[Settings instance].patient_list count]);
        
        patients = [Settings instance].patient_list;
        
        NSLog(@"counts %lu", (unsigned long)[patients count]);
        
        UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
        
        [tableView reloadData];
        
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [patients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LinkPatientCell";
    LinkPatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LinkPatientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *profile = [[patients objectAtIndex:indexPath.row] objectForKey:@"profile"];
    
    NSString *firstName =[profile objectForKey:@"firstname"];
    cell.patientName.text = firstName;
    
    NSString *relationship = [[patients objectAtIndex:indexPath.row] objectForKey:@"relationship"];
    cell.patientEmail.text = relationship;
    
    UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    [cell.selectButton setImage:btnImage forState:UIControlStateNormal];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell = cell;
    
    selectedPatient = [patients objectAtIndex:indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonPressed:(id)sender {
    
    
    
    
    NSString *patientID = [selectedPatient objectForKey:@"id"];
    
    NSLog(@"%@", patientID );
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"%@/addtask", [Settings instance].serverPorts[@"tasks"]];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
//    {"patient_id": "1", "caretaker_id": "2", "task": "Go for a walk", "date": "April 8 2015", "time": "10:00"}
    
    NSLog(@"task %@", [Settings instance].task_name);
    NSLog(@"time %@", [Settings instance].task_date);
    
    NSArray* foo = [[Settings instance].task_date componentsSeparatedByString: @" "];
    
    NSString* date = [foo objectAtIndex: 0];
    NSString* time = [foo objectAtIndex: 1];
    
    
    //
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    
    if ([Settings instance].reccurentTask == 0){
        mapData = @{@"patient_id": patientID,
                    @"caretaker_id": [Settings instance].caretaker_id,
                    @"task": [Settings instance].task_name,
                    @"date": date, @"time": time,
                    @"recurrent": @"0"};
    } else {
        mapData = @{@"patient_id": patientID,
                    @"caretaker_id": [Settings instance].caretaker_id,
                    @"task": [Settings instance].task_name,
                    @"date": date, @"time": time,
                    @"recurrent": @"1"};
    }
    
    NSLog(@"ADDING A TASK %@", mapData);
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    
    [request setHTTPBody:postData];
    
    
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
            
            NSLog(@"json %@", json);
            
            if (status_code == 202) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"Task has been added"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:@"Email Task", nil];
                    [alert show];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                    message:@"Something did not work"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                });
                
            }
        } else {
            
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Email Task"])
    {
        [self showEmail];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80;
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
@end
