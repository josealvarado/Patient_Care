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


int addeventGranted;

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tasks = [[NSMutableArray alloc] init];
    
    eventList = [[NSMutableArray alloc] initWithCapacity:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(getLatestTasks) forControlEvents:UIControlEventValueChanged];
    
    [_taskTableView addSubview:refreshControl];
}

- (void)getLatestTasks {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"%@/listtasks?c=%@&p=%@", [Settings instance].serverPorts[@"tasks"], [[[Settings instance].caretaker_list objectAtIndex:0] objectForKey:@"id"], [Settings instance].patient_id];
    
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
            
            NSLog(@"tasks - json: %@", json);
            
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str %@", newStr);
            
            
            
            if (status_code == 202) {
                
                tasks = [json objectForKey:@"tasks"];
                
                for (int i = 0; i < tasks.count; i++) {
                    
                    NSDictionary *task = [tasks objectAtIndex: i];
                    
                    NSString *taskID = [[Settings instance].notifications objectForKey:[task objectForKey:@"id"]];
                    
                    
                    NSLog(@"%d", i);
                    
                    if (taskID != nil){
                        
                        NSLog(@"reminder set");
                        
                        [[Settings instance].notifications setObject:@"DONE" forKey:[task objectForKey:@"id"]];
                        
                        
                    } {
                        NSLog(@"reminder has already been set");
                    }
                    
                }
                
                int count = (int)[tasks count];
                
                [Settings instance].assignedTasksCount = count;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self reloadData];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get tasks" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    
                    // End the refreshing
                    if (refreshControl) {
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"MMM d, h:mm a"];
                        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                                    forKey:NSForegroundColorAttributeName];
                        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                        refreshControl.attributedTitle = attributedTitle;
                        
                        [refreshControl endRefreshing];
                    }
                    
                });
                
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"You must be connected to the internet to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
                // End the refreshing
                if (refreshControl) {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MMM d, h:mm a"];
                    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                                forKey:NSForegroundColorAttributeName];
                    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                    refreshControl.attributedTitle = attributedTitle;
                    
                    [refreshControl endRefreshing];
                }
                
            });
            
        }
        
    }];
    
    [postDataTask resume];
    
}

- (void)reloadData
{
    // Reload table data
    //    [_taskTableView reloadData];
    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
    
    [tableView reloadData];
    
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/listtasks?c=%@&p=%@", [[[Settings instance].caretaker_list objectAtIndex:0] objectForKey:@"id"], [Settings instance].patient_id];
    
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
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            NSLog(@"json: %@", json);
            
            if (status_code == 202) {
                
                tasks = [json objectForKey:@"tasks"];
                
                int count = (int)[tasks count];
                
                [Settings instance].assignedTasksCount = count;
                
                for (int i = 0; i < tasks.count; i++) {
                    
                    NSDictionary *task = [tasks objectAtIndex: i];
                    
                    NSString *taskID = [[Settings instance].notifications objectForKey:[task objectForKey:@"id"]];
                    
                    if (!taskID){
                        
                        NSLog(@"reminder set");
                        
                        [[Settings instance].notifications setObject:@"DONE" forKey:[task objectForKey:@"id"]];
                        
                        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
                        localNotification.alertBody = [task objectForKey:@"task"];
                        localNotification.timeZone = [NSTimeZone defaultTimeZone];
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        
                        // Request to reload table view data
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
                        
                    } else {
                        NSLog(@"reminder has already been set");
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UITableView *tableView = (UITableView *)[self.view viewWithTag:1];
                    
                    [tableView reloadData];
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get tasks" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    
                });
                
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"  message:@"You must be connected to the internet to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
            });
            
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
    
    if ([tasks count] != 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        tableView.backgroundView = nil;
        
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //        [messageLabel sizeToFit];
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
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
    
    NSString *time = [NSString stringWithFormat:@"%@ %@", [receivedTask objectForKey:@"date"], [receivedTask objectForKey:@"time"]];
    
    cell.emailLabel.text = time;
    
    UIImage *btnImage;
    
    if ([[receivedTask objectForKey:@"status"]  isEqual: @"new"]) {
        btnImage = [UIImage imageNamed:@"image.png"];
        
        
        cell.completedButton.backgroundColor = [UIColor grayColor];
        
    } else if ([[receivedTask objectForKey:@"status"]  isEqual: @"complete"]) {
        btnImage = [UIImage imageNamed:@"image.png"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.completedButton.userInteractionEnabled = NO;
        
        cell.completedButton.backgroundColor = [UIColor blueColor];
        
    } else {
        cell.completedButton.backgroundColor = [UIColor greenColor];
    }
    
    cell.taskInfo = receivedTask;
    
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

//Code to Add event to Calendar - Added by Paresh

- (IBAction)addEventToCalendar {
    
    [self addEvent];
    [self performSelector:@selector(Alert) withObject:nil afterDelay:0.3];
    
}

-(void)addEvent{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
    
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
            if (granted) {
            
                addeventGranted = 1;
                
                EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                
                for (int i = 0; i < tasks.count; i++) {

                    NSString *getTask = [[tasks objectAtIndex:i] objectForKey:@"task"];
                    
                    NSDictionary *receivedTask = [tasks objectAtIndex:i];
                    
                    NSString *getDate = [NSString stringWithFormat:@"%@",[receivedTask objectForKey:@"date"]];
                    
                    NSString *getTime = [NSString stringWithFormat:@"%@",[receivedTask objectForKey:@"time"]];
                    
                    
                    NSString *concatDate = [NSString stringWithFormat:@"%@ %@", getDate, getTime];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
                    
                    NSDate *dateFromString = [[NSDate alloc] init];
                    
                    dateFromString = [dateFormatter dateFromString:concatDate];
                    

                    [event setTitle: getTask];
                    
                    
                    EKEventStore *store = [[EKEventStore alloc] init];
                    
                    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
 
                        if (!granted) {
                            return;
                        }
                        
                        
                        EKEvent *event = [EKEvent eventWithEventStore:store];
                        event.title = getTask;

                        event.startDate = dateFromString;
                        
                        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
                        
                        [event setCalendar:[store defaultCalendarForNewEvents]];
                        
                        NSError *err = nil;
                        
                        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                        
                        NSString *savedEventId = event.eventIdentifier;

                    }];

                }
            }
        }];
    }
}

-(void)Alert {
    if (addeventGranted == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success"
                                                        message:@"Event successfully added"
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}


@end