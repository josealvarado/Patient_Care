//
//  ViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ViewController.h"
#import "Settings.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [Settings instance].serverPorts = [NSDictionary dictionaryWithObjectsAndKeys:
                                       
                                       @"http://52.11.100.150:14000", @"registration",
                                       
                                       @"http://52.11.100.150:15000", @"login",
                                       
                                       @"http://52.11.100.150:16000", @"linkpatients",
                                       
                                       @"http://52.11.100.150:17000", @"tasks",
                                       
                                       @"http://52.11.100.150:18000", @"tracking",
                                       
                                       @"http://52.11.100.150:19000", @"notes", nil];
    
    [Settings instance].rewardPoints = 0;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [Settings instance].notifications = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    
    [_textFieldPassword resignFirstResponder];
    [_textFIeldEmailAddress resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *username = [_keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [_keychain objectForKey:(__bridge id)(kSecValueData)];
    
    if (!(username == (id)[NSNull null] || username.length == 0 || password == (id)[NSNull null] || password.length == 0)){
        _textFIeldEmailAddress.text = username;
        _textFieldPassword.text = password;
    }
}

- (IBAction)buttonLoginPressed:(id)sender {
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSURL *url = [NSURL URLWithString: [Settings instance].serverPorts[@"login"] ];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];

    NSDictionary *mapData = [[NSDictionary alloc] init ];
    mapData = @{ @"password" : [NSString stringWithFormat:@"%@",_textFieldPassword.text ], @"emailaddress" : [NSString stringWithFormat:@"%@",_textFIeldEmailAddress.text ]};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
        NSLog(@"data %@", data);
        NSLog(@"response %@", response);
        NSLog(@"erorr %@", error);

        if (!error) {

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

                NSString *role = [json objectForKey:@"role"];
                
                [Settings instance].role = role;
                
                if ([role  isEqual: @"01"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Settings instance].caretaker_id = [json objectForKey:@"id"];
                        [Settings instance].caretaker= json;

                        
                        [self performSegueWithIdentifier:@"CareTakerHome" sender:sender];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Settings instance].patient_id = [json objectForKey:@"id"];
                        [Settings instance].patient= json;
                        
                        [self performSegueWithIdentifier:@"PatientHome" sender:sender];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Something did not work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    
                });
                
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"You must be connected to the internet to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
            });
        }

    }];
    
    [postDataTask resume];
    
}
@end
