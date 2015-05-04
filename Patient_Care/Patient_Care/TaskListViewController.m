//
//  TaskListViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 3/9/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "TaskListViewController.h"
#import "Settings.h"
#import "TaskTableViewCell.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tasks = [[NSMutableArray alloc] init];
    
    UIView *rewardsViewController = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    rewardsViewController.backgroundColor = [UIColor brownColor];
    [self.view addSubview:rewardsViewController];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
  
//    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
//    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/listtasks?c=8&p=7"];

    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/listtasks?c=%@&p=%@", [[[Settings instance].caretaker_list objectAtIndex:0] objectForKey:@"id"], [Settings instance].patient_id];

    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    //    {"patient_id": "1", "caretaker_id": "2", "task": "Go for a walk", "date": "April 8 2015", "time": "10:00"}
    
//    NSLog(@"task %@", [Settings instance].task_name);
//    NSLog(@"time %@", [Settings instance].task_date);
//    
//    NSArray* foo = [[Settings instance].task_date componentsSeparatedByString: @" "];
//    
//    NSString* date = [foo objectAtIndex: 0];
//    NSString* time = [foo objectAtIndex: 1];
    
    
    //
//    NSDictionary *mapData = [[NSDictionary alloc] init ];
//    mapData = @{@"patient_id": patientID,
//                @"caretaker_id": [Settings instance].caretaker_id,
//                @"task": [Settings instance].task_name,
//                @"date": date, @"time": time};
//    
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    
//    [request setHTTPBody:postData];
    
    
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
                
                tasks = [json objectForKey:@"tasks"];
                
                int count = (int)[tasks count];
                
                [Settings instance].assignedTasksCount = count;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                          
//                                                                    message:@"Task has been added"
//                                          
//                                                                   delegate:nil
//                                          
//                                                          cancelButtonTitle:@"OK"
//                                          
//                                                          otherButtonTitles:nil];
//                    
//                    [alert show];
                    
                    
//                    tasks = ppp;
                    
                    NSLog(@"in here with %lu", (unsigned long)[tasks count]);
                    
//                    [_taskTableView reloadData];
                    
                    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"count %lu", (unsigned long)[tasks count]);
    
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskTableViewCell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.nameLabel.text = [[tasks objectAtIndex:indexPath.row] objectForKey:@"task"];
    
    NSDictionary *receivedTask = [tasks objectAtIndex:indexPath.row];
    
    NSString *time = [NSString stringWithFormat:@"%@%@", [receivedTask objectForKey:@"date"], [receivedTask objectForKey:@"time"]];
    
    cell.emailLabel.text = time;
    
    UIImage *btnImage;
    
    if ([[receivedTask objectForKey:@"status"]  isEqual: @"new"]) {
        btnImage = [UIImage imageNamed:@"image.png"];
        
        cell.completedButton.backgroundColor = [UIColor grayColor];

    } else {
        btnImage = [UIImage imageNamed:@"image.png"];
        
        
        cell.completedButton.backgroundColor = [UIColor blueColor];

    }
    
    cell.taskInfo = receivedTask;
    
    
//    [cell.completedButton setImage:btnImage forState:UIControlStateNormal];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 80.0;
}
@end
