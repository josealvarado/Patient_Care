//
//  ListPatientsTableViewController.m
//  Patient_Care
//
//  Created by Paresh on 15/05/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ListPatientsTableViewController.h"
#import "Settings.h"
#import "ListPatientTableViewCell.h"

@interface ListPatientsTableViewController ()

@end

@implementation ListPatientsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ListPatientTableViewCell class] forCellReuseIdentifier:@"GetListPatientCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

- (void)viewWillAppear:(BOOL)animated{
    // Todo
    
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"%@/listmyusers?q=%@&r=%@",[Settings instance].serverPorts[@"linkpatients"], [Settings instance].caretaker_id, [Settings instance].role];
    
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
            
            if (status_code == 202) {
                
                NSArray *ppp = [json objectForKey:@"users"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    patients = [ppp mutableCopy];
                    
                    [Settings instance].patient_list = patients;
                    
              
                    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
                    
                    [self.tableView reloadData];
                    
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
            
            NSLog(@"what?");
            
            
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
    return [patients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"GotoDetailsView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *profile = [[patients objectAtIndex:indexPath.row] objectForKey:@"profile"];
    
    NSString *firstName =[profile objectForKey:@"firstname"];
    
    NSLog(@"%@", firstName);
    
    cell.textLabel.text = firstName;
    
    NSString *relationship = [[patients objectAtIndex:indexPath.row] objectForKey:@"relationship"];
    
    
    cell.detailTextLabel.text = relationship;
    
    UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *selectedPatient = [patients objectAtIndex:indexPath.row];
    
    [Settings instance].selectedPatient = selectedPatient;
    
    NSLog(@"%@", selectedPatient);
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

- (IBAction)doneButtonPressed:(id)sender {
    NSDictionary *selectedPatient = [Settings instance].selectedPatient;
    
    NSLog(@"%@", selectedPatient);
    
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSArray* foo = [resultString componentsSeparatedByString: @" "];
    NSString* date = [foo objectAtIndex: 0];
    NSString* time = [foo objectAtIndex: 1];
    
    if (selectedPatient){
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
     
        NSURL *url = [NSURL URLWithString:[Settings instance].serverPorts[@"notes"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        NSDictionary *mapData = [[NSDictionary alloc] init ];
        mapData = @{
                    @"note" : [Settings instance].selectedNote2,
                    @"caretaker_id" : [Settings instance].caretaker_id,
                    @"patient_id" : [[Settings instance].selectedPatient objectForKey:@"id"],
                    @"date" : date,
                    @"time" : time};
        
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
                
                NSLog(@"json: %@", json);
                
                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"str %@", newStr);
                
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    
                    long status_code = (long)[httpResponse statusCode];
                    
                    NSLog(@"response status code: %ld", status_code);
                    
                    if (status_code == 202) {
                        
                                        [self performSegueWithIdentifier:@"ListPatientController" sender:sender];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                              
                                                                        message:@"Something did not work"
                                              
                                                                       delegate:nil
                                              
                                                              cancelButtonTitle:@"OK"
                                              
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                        
                    }
                });
                
                
            } else {
                
                NSLog(@"what?");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                      
                                                                message:@"You must be connected to the internet to use this app."
                                      
                                                               delegate:nil
                                      
                                                      cancelButtonTitle:@"OK"
                                      
                                                      otherButtonTitles:nil];
                
                [alert show];
                
            }
            
        }];
        
        [postDataTask resume];
    }
}
@end
