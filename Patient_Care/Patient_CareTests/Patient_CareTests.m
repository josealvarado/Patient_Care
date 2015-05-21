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
    
//    NSURL *url = [NSURL URLWithString: [Settings instance].serverPorts[@"login"] ];
    
    NSURL *url = [NSURL URLWithString: @"http://52.11.100.150:15000/login"];
    

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
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            
            XCTAssertEqual(status_code, 202, @"Should have matched");
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            
            NSLog(@"%@", json);
            
            NSString *city = [json objectForKey:@"city"];
            
            XCTAssertNotNil(city, @"Should have found a json object");
            
            
        } else {
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
        }
        
        [expectation fulfill];
        
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
}

- (void) testPatientRegistration {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString: @"http://52.11.100.150:14000/registration"];
    

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    
    NSLog(@"device token - %@", [Settings instance].deviceToken);
    
    mapData = @{ @"role"     : @"02",
                 @"username" : @"username",
                 @"password" : @"aaa",
                 @"firstname": @"",
                 @"middlename": @"middle name",
                 @"lastname" : @"",
                 @"emailaddress" : @"aaa@gmail.com",
                 @"streetaddress" : @"address here",
                 @"city" : @"san francisco",
                 @"state" : @"california",
                 @"country" : @"usa",
                 @"devicetoken": @"d2df19729d8cc2b98a380ca17ac73d22af957435635f2f4f6823cdb818bcfd37"
                 };
    
    
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
                    
                    XCTAssertEqual(status_code, 202, @"Should have matched");
                    
                }
                
                else if (status_code == 304) {
                    
                    XCTAssertEqual(status_code, 304, @"Should have matched");
                    
                }
                
                else {
                    
                    NSLog(@"Registration Failed");
                    
                    XCTFail("Unable to contact server");
                    
                }
                
            });
            
        } else {
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
}

- (void) testRegistration2{
    
}

- (void) testCaretakerRegistration {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://52.11.100.150:14000/registration"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    
    NSLog(@"device token - %@", [Settings instance].deviceToken);
    
    mapData = @{ @"role"     : @"01",
                 @"username" : @"hello",
                 @"password" : @"123",
                 @"firstname": @"",
                 @"middlename": @"middle",
                 @"lastname" : @"",
                 @"emailaddress" : @"paresh@gmail.com",
                 @"streetaddress" : @"address here",
                 @"city" : @"san francisco",
                 @"state" : @"california",
                 @"country" : @"usa",
                 @"devicetoken": @"d2df19729d8cc2b98a380ca17ac73d22af957435635f2f4f6823cdb818bcfd37"
                 
                 };
    
    
    
    NSLog(@"REGISTRATION JSON %@", mapData);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long status_code = (long)[httpResponse statusCode];
                NSLog(@"response status code: %ld", status_code);
                
                
                
                if (status_code == 202) {
                    
                    XCTAssertEqual(status_code, 202, @"The response should be 202");
                    
                } else if(status_code == 304) {
                    
                    XCTAssertEqual(status_code, 304, @"The response should be 304");
                }
                
            });
            
        } else {
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
}

- (void)testsearchPatient {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:16000/listuser?q=%@", @"aaa@gmail.com"];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            
            NSLog(@"json: %@", json);
            
            NSString *patientID = [json objectForKey:@"id"];
            NSString *points = [json objectForKey:@"points"];
            
            XCTAssertNotNil(patientID, @"Should have found a json object");
            
            XCTAssertEqualObjects(points, @"1");
            XCTAssertEqualObjects(patientID, @"14");
            
            if (status_code == 202) {
                
                XCTAssertEqual(status_code, 202, @"The response should be 202");
                
            } else if(status_code == 304) {
                
                XCTAssertEqual(status_code, 304, @"The response should be 304");
            }
            
        } else {
            
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
    
}

- (void)testLinkPatient {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:16000/listmyusers?q=%@&r=%@",@"10", @"01"];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            
            
            
            NSArray *patientDetails = [json objectForKey:@"users"];
            
            NSString *patientID_One = [[patientDetails objectAtIndex:0] objectForKey:@"id"];
            NSString *patientID_Two = [[patientDetails objectAtIndex:1] objectForKey:@"id"];
            NSString *patientID_Three = [[patientDetails objectAtIndex:2] objectForKey:@"id"];
            NSString *patientID_Four = [[patientDetails objectAtIndex:3] objectForKey:@"id"];
            NSString *patientID_Five = [[patientDetails objectAtIndex:4] objectForKey:@"id"];
            NSString *patientID_Six = [[patientDetails objectAtIndex:5] objectForKey:@"id"];
            NSString *patientID_Seven = [[patientDetails objectAtIndex:6] objectForKey:@"id"];
            
            //test for no of patients retreived
            XCTAssertEqual(patientDetails.count, 7, @"Expected to get back 7 patients details");
            
            //test if patients id is beign returned
            XCTAssertEqualObjects(patientID_One, @"9", @"Patient ID should be 9");
            XCTAssertEqualObjects(patientID_Two, @"14", @"Patient ID should be 14");
            XCTAssertEqualObjects(patientID_Three, @"21", @"Patient ID should be 21");
            XCTAssertEqualObjects(patientID_Four, @"26", @"Patient ID should be 26");
            XCTAssertEqualObjects(patientID_Five, @"30", @"Patient ID should be 30");
            XCTAssertEqualObjects(patientID_Six, @"36", @"Patient ID should be 36");
            XCTAssertEqualObjects(patientID_Seven, @"37", @"Patient ID should be 37");
            
            
            if (status_code == 202) {
                
                XCTAssertEqual(status_code, 202, @"Status code should be 202");
                
            } else if (status_code == 304) {
                
                XCTAssertEqual(status_code, 304, @"Status code should be 304");
            }
            
        } else {
            
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
    
}

- (void)testAddTask {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/addtask"];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    
    //posting new task
    mapData = @{@"patient_id": @"30",
                    @"caretaker_id": @"10",
                    @"task": @"adding a test task",
                    @"date": @"17-05-2015", @"time": @"20:30",
                    @"recurrent": @"0"};
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        

        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            
            if (status_code == 202) {
                
                XCTAssertEqual(status_code, 202, @"Status code should be 202");
                
            } else if (status_code == 304) {
                
                XCTAssertEqual(status_code, 304, @"Status code should be 304");
            }
            
        } else {
            
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
    
}

- (void)testViewTaskByPatient {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:17000/listtasks?c=%@&p=%@", @"10", @"30"];
    
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str %@", newStr);
            
            if (status_code == 202) {
                
                XCTAssertEqual(status_code, 202, @"Status code should be 202");
                
                NSMutableArray *tasks = [json objectForKey:@"tasks"];
                
                XCTAssertNotNil(tasks, @"Should have found a tasks json object");
                
                //getting all the tasks
                NSString *getTasks1 = [[tasks objectAtIndex:0]objectForKey:@"task"];
                NSString *getTasks2 = [[tasks objectAtIndex:1]objectForKey:@"task"];
                NSString *getTasks3 = [[tasks objectAtIndex:2]objectForKey:@"task"];
                NSString *getTasks4 = [[tasks objectAtIndex:3]objectForKey:@"task"];
                NSString *getTasks5 = [[tasks objectAtIndex:4]objectForKey:@"task"];
                
                XCTAssertEqualObjects(getTasks1, @"Take Medication", @"tasks not matching");
                XCTAssertEqualObjects(getTasks2, @"Take out Trash", @"tasks not matching");
                XCTAssertEqualObjects(getTasks3, @"Go for a walk", @"tasks not matching");
                XCTAssertEqualObjects(getTasks4, @"adding a test task", @"tasks not matching");
                XCTAssertEqualObjects(getTasks5, @"Take Medication", @"tasks not matching");
                
                
            } else if (status_code == 304) {
                
                XCTAssertEqual(status_code, 304, @"Status code should be 304");
            }
            
        } else {
            
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
    
}

- (void)testViewGeneralNotes {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *params = [NSString stringWithFormat:@"http://52.11.100.150:19000/listnotes?c=%@",@"10"];
    
    NSURL *url = [NSURL URLWithString:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
            NSLog(@"response status code: %ld", status_code);
            
            NSError* error;
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                  
                                                                 options:kNilOptions
                                  
                                                                   error:&error];
            
            if (status_code == 202) {
                
                XCTAssertEqual(status_code, 202, @"Status code should be 202");
                
                NSMutableArray *notes = [json objectForKey:@"notes"];
                
                for (int i=0; i< notes.count; i++) {
                   
                    NSString *note = [[notes objectAtIndex:i]objectForKey:@"note"];
                    
                    //checking if the json returns a note object
                    XCTAssertNotNil(note, @"Should have found a json object");
                    
                }
                
                
                for (int i = 0; i < notes.count; i++) {
                
                    NSString *getPatientID = [[notes objectAtIndex:i] objectForKey:@"patient_id"];
                    
                    if(getPatientID == (id)[NSNull null]){
                        
                        //checking if the patient id is null
                        XCTAssertEqualObjects(getPatientID, [NSNull null], @"Patient ID should be null");
                        
                        NSString *getGeneralNotes1 = [[notes objectAtIndex:0] objectForKey:@"note"];
                        NSString *getGeneralNotes2 = [[notes objectAtIndex:1] objectForKey:@"note"];
                        NSString *getGeneralNotes3 = [[notes objectAtIndex:2] objectForKey:@"note"];
                        NSString *getGeneralNotes4 = [[notes objectAtIndex:3] objectForKey:@"note"];
                        NSString *getGeneralNotes5 = [[notes objectAtIndex:4] objectForKey:@"note"];
                        NSString *getGeneralNotes10 = [[notes objectAtIndex:10] objectForKey:@"note"];
                        
                        XCTAssertEqualObjects(getGeneralNotes1, @"test noes", @"notes should match");
                        XCTAssertEqualObjects(getGeneralNotes2, @"sdafdas text....", @"notes should match");
                        XCTAssertEqualObjects(getGeneralNotes3, @"adding a new note and linking patient", @"notes should match");
                        XCTAssertEqualObjects(getGeneralNotes4, @"adding a new note and linking patient", @"notes should match");
                        XCTAssertEqualObjects(getGeneralNotes5, @"linkiing pateitn again", @"notes should match");
                        XCTAssertEqualObjects(getGeneralNotes10, @"This is a custom note added from test case", @"notes should match");
                        
                    }
                    
                }

            } else if (status_code == 304) {
                
                XCTAssertEqual(status_code, 304, @"Status code should be 304");
            }
            
        } else {
            
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
    
}

- (void)testAddingGeneralNotes {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"..."];
    
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
    mapData = @{
                @"note" : @"This is a custom note added from test case",
                @"caretaker_id" : @"10",
                @"date" : @"17-05-2015",
                @"time" : @"20:04"};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            long status_code = (long)[httpResponse statusCode];
            
          
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"str %@", newStr);
            
            if (status_code == 202) {
                
                XCTAssertEqual(status_code, 202, @"Status code should be 202");
                
            } else if (status_code == 304) {
                
                XCTAssertEqual(status_code, 304, @"Status code should be 304");
            }
            
        } else {
            
            NSLog(@"did we have an error");
            
            XCTFail("Unable to contact server");
            
        }
        
        [expectation fulfill];
        
    }];
    
    [postDataTask resume];
    
    [self waitForExpectationsWithTimeout:postDataTask.originalRequest.timeoutInterval handler:^(NSError *error) {
        [postDataTask cancel];
    }];
    
}



@end
