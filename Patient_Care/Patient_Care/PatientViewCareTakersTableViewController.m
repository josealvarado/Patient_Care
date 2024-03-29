//
//  PatientViewCareTakersTableViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/21/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "PatientViewCareTakersTableViewController.h"
#import "Settings.h"
#import "LinkPatientTableViewCell.h"

@interface PatientViewCareTakersTableViewController ()

@end

@implementation PatientViewCareTakersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    // Todo
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"%@/listmyusers?q=%@&r=%@",[Settings instance].serverPorts[@"linkpatients"] ,[Settings instance].patient_id, [Settings instance].role];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    //
    //        NSDictionary *mapData = [[NSDictionary alloc] init ];
    //        mapData = @{@"emailaddress" : _seachTextField.text};
    
    //        NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    
    //        [request setHTTPBody:postData];
    
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
            //            NSArray* latestLoans = [json objectForKey:@"loans"];
            
            NSLog(@"json: %@", json);
            
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str %@", newStr);
            
            
            
            if (status_code == 202) {
                
                //                [self performSegueWithIdentifier:@"PatientHome" sender:sender];
                
                
                //                    [json setValue:_seachTextField.text forKey:@"email"];
                
                NSArray *ppp = [json objectForKey:@"users"];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    caretaker_list = [ppp mutableCopy];
                    
                    [Settings instance].caretaker_list = caretaker_list;
                    
                    //                    [patients removeAllObjects];
                    //                    [patients addObject:json];
                    
                    
                    // Assuming you've added the table view as a subview to the current view controller
                    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
                    
                    [tableView reloadData];
                    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [caretaker_list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LinkPatientCell";
    LinkPatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LinkPatientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *profile = [[caretaker_list objectAtIndex:indexPath.row] objectForKey:@"profile"];
    
    NSString *firstName =[profile objectForKey:@"firstname"];
    
    NSLog(@"%@", firstName);
    
    cell.patientName.text = firstName;
    
    NSString *relationship = [[caretaker_list objectAtIndex:indexPath.row] objectForKey:@"relationship"];
    
    cell.patientEmail.text = relationship;
    
    UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    [cell.selectButton setImage:btnImage forState:UIControlStateNormal];
    
    //    cell.patientName.text = [[patients objectAtIndex:indexPath.row] objectForKey:@"firstname"];
    //    cell.patientEmail.text = _seachTextField.text;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
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

@end
