//
//  Settings.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/20/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "Settings.h"

@implementation Settings




+ (Settings *)instance {
    static Settings *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [Settings new];
        
    });
    
    return _sharedClient;
}

+ (NSMutableDictionary *) apiCall:(NSDictionary *) data type:(NSString *) type{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString: [Settings instance].serverPorts[@"login"] ];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:type];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"data %@", data);
        NSLog(@"response %@", response);
        NSLog(@"erorr %@", error);
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            
            [result addEntriesFromDictionary:json];
            [result setObject:[NSString stringWithFormat:@"%ld", status_code] forKey:@"status_code"];
            
            
        } else {
            [result setObject:@"No network connection" forKey:@"error"];
        }
    }];
    
    [postDataTask resume];

    return result;
}

@end
