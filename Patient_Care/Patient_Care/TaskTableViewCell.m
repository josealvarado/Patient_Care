//
//  TaskTableViewCell.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/25/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "Settings.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    completed = NO;
    _taskInfo = [[NSMutableDictionary alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)completedButtonPressed:(id)sender {
    
    
    NSLog(@"In here");
    
    if (completed == NO) {
        completed = YES;
        
        
        
//        UIImage *btnImage = [UIImage imageNamed:@"image.png"];
//        [_completedButton setImage:btnImage forState:UIControlStateNormal];
        
        
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/completetask"];
        
        //    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/listtasks?c=8&p=%@", [Settings instance].patient_id];
        
        
        NSURL *url = [NSURL URLWithString:params];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        //    {"patient_id": "1", "caretaker_id": "2", "task": "Go for a walk", "date": "April 8 2015", "time": "10:00"}
        
        //    NSLog(@"task %@", [Settings instance].task_name);
        //    NSLog(@"time %@", [Settings instance].task_date);
        //
        //    NSArray* foo = [[Settings instance].task_date componentsSeparatedByString: @" "];
        //
        //    NSString* date = [foo objectAtIndex: 0];
        //    NSString* time = [foo objectAtIndex: 1];
        
        
        
        int completedPoints = (int)[Settings instance].completedTasksCount;
        int totalPoints = (int)[Settings instance].assignedTasksCount;
        
        NSLog(@"Before Points %d, %d", completedPoints, totalPoints);
        
        if (completedPoints) {
//            NSLog(@"not null");
//            count = count + 1;
        } else {
//            NSLog(@"null");
            [Settings instance].completedTasksCount = 0;
            completedPoints = 0;
        }
        
        NSDictionary *mapData;
        
        NSLog(@"Points %d, %d", completedPoints, totalPoints);
        
        if (completedPoints + 1 == totalPoints) {
            mapData = [[NSDictionary alloc] init ];
            mapData = @{@"id": [_taskInfo objectForKey:@"id"],
                        @"status": @"complete",
                        @"patient_id": [Settings instance].patient_id,
                        @"points": [NSString stringWithFormat:@"%d", totalPoints]};
        } else {
            mapData = [[NSDictionary alloc] init ];
            mapData = @{@"id": [_taskInfo objectForKey:@"id"],
                        @"patient_id": [Settings instance].patient_id,
                        @"status": @"complete"};
        }
        
        //
        
        
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
                //            NSArray* latestLoans = [json objectForKey:@"loans"];
                
                NSLog(@"json: %@", json);
                
                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"str %@", newStr);
                
                
                
                if (status_code == 202) {
                    
                    //                [self performSegueWithIdentifier:@"PatientHome" sender:sender];
                    
                    
                    //                    [json setValue:_seachTextField.text forKey:@"email"];
                    
//                    NSArray *ppp = [json objectForKey:@"users"];
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                              
                                                                        message:@"Task has been completed"
                                              
                                                                       delegate:nil
                                              
                                                              cancelButtonTitle:@"OK"
                                              
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                        
                        int count = [Settings instance].completedTasksCount;
                        
                        NSLog(@"before %d" , count);
                        
//                        if (count) {
//                            NSLog(@"not null");
                            count = count + 1;
//                        } else {
//                            NSLog(@"null");
//                            [Settings instance].completedTasksCount = 0;
//                        }
                        
                        [Settings instance].completedTasksCount = count;
                        
                        
                        NSLog(@"Cummulative %d" , count);
                        
//                        if ([Settings instance].completedTasksCount == [Settings instance].assignedTasksCount ) {
//                            
//                            
//                            [self updateScore];
//                        }
                        
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
    
    
}

- (void)updateScore{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://52.11.100.150:19000"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    
    NSLog(@"%@", [Settings instance].patient_id);
    
//    mapData = @{
//                @"patient_id" : [Settings instance].patient_id,
//                @"lat" : [NSString stringWithFormat:@"%f", latitude],
//                @"long" : [NSString stringWithFormat:@"%f", latitude],
//                @"date" : date,
//                @"time" : time};
    
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
            //            NSArray* latestLoans = [json objectForKey:@"loans"];
            
            NSLog(@"json: %@", json);
            
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str %@", newStr);
            
            
            // 304 couldn't be found
            // 405 unsupported
            
            if (status_code == 202) {
                
                //                [self performSegueWithIdentifier:@"PatientHome" sender:sender];
                
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                      
                                                                message:@"Something did not work"
                                      
                                                               delegate:nil
                                      
                                                      cancelButtonTitle:@"OK"
                                      
                                                      otherButtonTitles:nil];
                
                [alert show];
                
            }
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

//- (IBAction)completedButtonPressed:(id)sender {
//}
@end
