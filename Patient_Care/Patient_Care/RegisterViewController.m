//
//  RegisterViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "RegisterViewController.h"
#import "Settings.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    

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


-(void)dismissKeyboard {    
    [_textFieldPassword resignFirstResponder];
    [_textFieldEmaillAdress resignFirstResponder];
    [_textfieldLastName resignFirstResponder];
    [_textfieldFirstName resignFirstResponder];
}

- (IBAction)buttonRegisterPressed:(id)sender {
    

    NSString *emailAddress = _textFieldEmaillAdress.text;
    NSString *password = _textFieldPassword.text;
    NSString *firstName = _textfieldFirstName.text;
    NSString *lastName = _textfieldLastName.text;
    
    [Settings instance].first_name = firstName;
    [Settings instance].last_name = lastName;
    
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//    NSURL *url = [NSURL URLWithString:@"http://52.11.100.150:14000"];
    NSURL *url = [NSURL URLWithString:[Settings instance].serverPorts[@"registration"]];
//    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
                             
    NSLog(@"device token - %@", [Settings instance].deviceToken);
    
    
//                             initWithObjectsAndKeys: @"Machine", @"username",
//                             @"josealvarado111@gmail.com", @"emailaddress",  @"Password", @"password",
//                             nil];
    
    
    //    { "role": "02",  "username": "jose", "password": "jose",  "firstname": "jose", "middlename":"", "lastname":"jose", "emailaddress": "jose@malmail.com", "fbtoken":"", "streetaddress":"", "city":"", "state":"", "country":""}
    
    if (_profileSegmentedControl.selectedSegmentIndex == 0) {
        mapData = @{ @"role"     : @"02",
                     @"username" : @"username",
                     @"password" : password,
                     @"firstname": firstName,
                     @"middlename": @"middle name",
                     @"lastname" : lastName,
                     @"emailaddress" : emailAddress,
                     @"streetaddress" : @"address here",
                     @"city" : @"san francisco",
                     @"state" : @"california",
                     @"country" : @"usa",
                     @"devicetoken": @"d2df19729d8cc2b98a380ca17ac73d22af957435635f2f4f6823cdb818bcfd37"
//                     @"devicetoken": [Settings instance].deviceToken
                     };
    } else {
        mapData = @{ @"role"     : @"01",
                     @"username" : @"hello",
                     @"password" : password,
                     @"firstname": firstName,
                     @"middlename": @"middle",
                     @"lastname" : lastName,
                     @"emailaddress" : emailAddress,
                     @"streetaddress" : @"address here",
                     @"city" : @"san francisco",
                     @"state" : @"california",
                     @"country" : @"usa",
                     @"devicetoken": @"d2df19729d8cc2b98a380ca17ac73d22af957435635f2f4f6823cdb818bcfd37"
//                     @"devicetoken": [Settings instance].deviceToken

                     };
    }
    
//    mapData = @{ @"role"     : @"02",
//                 @"username" : @"hello",
//                 @"password" : @"password",
//                 @"firstname": @"hahah",
//                 @"middlename": @"middle",
//                 @"lastname" : @"lastname",
//                 @"emailaddress" : @"jose@gmail.com",
//                 @"fbtoken" : @"what",
//                 @"streetaddress" : @"address here",
//                 @"city" : @"san francisco",
//                 @"state" : @"california",
//                 @"country" : @"usa"
//                        // etc.
//                        };
    
    NSLog(@"REGISTRATION JSON %@", mapData);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"data %@", data);
        NSLog(@"response %@", response);
        NSLog(@"error %@", error);
        
        
        
        if (!error) {
            NSLog(@"Hello");

            dispatch_sync(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long status_code = (long)[httpResponse statusCode];
                NSLog(@"response status code: %ld", status_code);
                

                
                if (status_code == 202) {
                  
                    [self performSegueWithIdentifier:@"LoginViewController" sender:sender];
                    
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

            });
            
        } else {
            NSLog(@"what?");
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network c sfsd s onnection"
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


@end
