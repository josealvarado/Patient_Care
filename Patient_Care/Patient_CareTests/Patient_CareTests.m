//
//  Patient_CareTests.m
//  Patient_CareTests
//
//  Created by Jose Alvarado on 3/1/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Settings.h"

@interface Patient_CareTests : XCTestCase

@end

@implementation Patient_CareTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
//        [self testLogin];
    }];
}



- (void) testLogin {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];

    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString: [Settings instance].serverPorts[@"login"] ];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    mapData = @{@"password" : @"aaa",
               @"emailaddress" : @"aaa@gmail.com"};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    
    [request setHTTPBody:postData];
    

    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"data %@", data);
        
        NSLog(@"response %@", response);
        
        NSLog(@"erorr %@", error);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            XCTAssertEqual(3, 2, @"Should be 13 cards");
//
//        });
        
        
//        XCTAssertNotNil(error, @"Should have found a card");

//        XCTAssertEqual(error, !, @"Should be 13 cards");


        if (!error) {
            
            NSLog(@"COrrect");
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            
            XCTAssertEqual(status_code, 202, @"Should have matched");
            
            
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            
            NSLog(@"%@", json);
            
            // verif that json contains city & not empty
            
            NSString *city = [json objectForKey:@"city"];
            
//            XCTAssertTrue(city == nil, @"Should have matched");
            
//            XCTAssertNotNil(Nil, @"Should hound a card");
            XCTAssertNotNil(city, @"Should have found a card");


        } else {
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
        }
        
        [expectation fulfill];
        
        
    }];
    
    [postDataTask resume];
    
//    XCTAssertNotNil(@"ee", @"Should have found a card");
//    XCTAssertNotNil(error, @"Should have found a card");

    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
}

@end
