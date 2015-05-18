//
//  AddPatientViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "AddPatientViewController.h"
#import "LinkPatientTableViewCell.h"
#import "Settings.h"

@interface AddPatientViewController ()

@end

@implementation AddPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    patients = [[NSMutableArray alloc] init];
    selected = -1;
    
    self.relationTextField.delegate = self;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(dismissKeyboard)];
    
//    [self.view addGestureRecognizer:tap];
    
    
}

//Method to dismiss the keyboard on hitting the return key
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

//Method to dismiss the keyboard on touching outside the text field
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated{
    // Get list of all patients
}

-(void)dismissKeyboard {
    
    [_seachTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)searchButtonPressed:(id)sender {
    
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"%@/listuser?q=%@",[Settings instance].serverPorts[@"linkpatients"],_seachTextField.text];

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
                //            NSArray* latestLoans = [json objectForKey:@"loans"];
    
                NSLog(@"json: %@", json);
                
                if (status_code == 202) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        returnedPatient = [json mutableCopy];
                        
                        [patients removeAllObjects];
                        [patients addObject:json];
                        
                        // Assuming you've added the table view as a subview to the current view controller
                        UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
                        
                        [tableView reloadData];
                        
                    });
                    
                } else {
    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                    message:@"Something did not work"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
    
                    [alert show];
    
                }
            } else {
    
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                                message:@"You must be connected to the internet to use this app."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
                
            }
            
        }];
        
        [postDataTask resume];
    
    // Assuming you've added the table view as a subview to the current view controller
    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
    
    [tableView reloadData];
}

- (IBAction)addPatientButtonPressed:(id)sender {
    if (selected == -1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select a patient"
                                                        message:@"Select a patient"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                        
        [alert show];
        
        return;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://52.11.100.150:16000"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *relationInput = self.relationTextField.text;
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    mapData = @{
                @"patient_id" : [returnedPatient objectForKey:@"id"],
                @"caretaker_id" : [Settings instance].caretaker_id,
                @"relationshiptopatient" : relationInput};

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
            
            if (status_code == 202) {
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                message:@"Something did not work"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
        } else {
            
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

- (IBAction)searchTextField:(id)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [patients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LinkPatientCell";
    LinkPatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LinkPatientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.patientName.text = [[patients objectAtIndex:indexPath.row] objectForKey:@"firstname"];
    cell.patientEmail.text = _seachTextField.text;
    
    UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    [cell.selectButton setImage:btnImage forState:UIControlStateNormal];
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (selected == -1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selected = 1;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        selected = -1;
    }
}
@end
