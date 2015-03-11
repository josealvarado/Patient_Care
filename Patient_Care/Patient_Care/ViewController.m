//
//  ViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *username = [_keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [_keychain objectForKey:(__bridge id)(kSecValueData)];
    
    NSLog(@"%@, %@", username, password);
    
    if (!(username == (id)[NSNull null] || username.length == 0 || password == (id)[NSNull null] || password.length == 0)){
        _textFIeldEmailAddress.text = username;
        _textFieldPassword.text = password;
    }
}

-(void)dismissKeyboard {
    NSLog(@"here");
    
    [_textFieldPassword resignFirstResponder];
    [_textFIeldEmailAddress resignFirstResponder];
}

- (IBAction)buttonLoginPressed:(id)sender {
//        NSError *error;
//    
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//        NSURL *url = [NSURL URLWithString:@"[JSON SERVER"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                           timeoutInterval:60.0];
//    
//        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//        [request setHTTPMethod:@"POST"];
//        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"Machine", @"username",
//                                 @"josealvarado111@gmail.com", @"emailaddress",  @"Password", @"password",
//                                 nil];
//    
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//        [request setHTTPBody:postData];
//    
//    
//        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            
//            if (error) {
//                
//            } else {
//                [_keychain setObject:_textFIeldEmailAddress forKey:(__bridge id)kSecAttrAccount];
//                [_keychain setObject:_textFieldPassword forKey:(__bridge id)kSecValueData];
//                
//                // Login
//            }
//            
//            
//            
//        }];
//        
//        [postDataTask resume];
}
@end
