//
//  AddNotesViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/22/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "AddNotesViewController.h"
#import "Settings.h"

@interface AddNotesViewController ()

@end

@implementation AddNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _data = [[NSDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    if (_note) {
        _noteTextField.text = _note;
    }
}

//- (void)updateNote:()

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonPressed:(id)sender {
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSArray* foo = [resultString componentsSeparatedByString: @" "];
    NSString* date = [foo objectAtIndex: 0];
    NSString* time = [foo objectAtIndex: 1];
    
    
//    NSLog(@"hello %@", _noteTextField.text);
//    
//    NSLog(@"before %lu", (unsigned long)[[Settings instance].notes count]);
    
    if ([Settings instance].notes) {
//        NSLog(@"1");
    } else {
//        NSLog(@"2");
        [Settings instance].notes = [[NSMutableArray alloc] init];
    }
    
//    if (_newNote) {
//        [[Settings instance].notes addObject:_noteTextField.text];
//    } else {
//        [[Settings instance].notes setObject:_noteTextField.text atIndexedSubscript:_noteNumber];
//    }
    
    int pos = [Settings instance].selectedNote;

//    NSLog(@"b = %d", pos);
    
    if (pos == -1) {
        [[Settings instance].notes addObject:_noteTextField.text];
        
        
        
        
        
        
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSURL *url = [NSURL URLWithString:@"http://52.11.100.150:17000"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        NSDictionary *mapData = [[NSDictionary alloc] init ];
        mapData = @{
                    @"note" : _noteTextField.text,
                    @"caretaker_id" : [Settings instance].caretaker_id,
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
        
        
        
        
        
        
        
        
        
        
        
    } else {
//        NSString *b = [_data objectForKey:@"pos"];
        
//        int a = (int)b.integerValue;
        
        [[Settings instance].notes setObject:_noteTextField.text atIndexedSubscript:pos];
    }
    
    
    NSLog(@"after %lu", (unsigned long)[[Settings instance].notes count]);

    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
