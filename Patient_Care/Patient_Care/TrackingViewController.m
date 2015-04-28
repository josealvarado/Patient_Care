//
//  TrackingViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "TrackingViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Settings.h"

@interface TrackingViewController ()

@end

@implementation TrackingViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //Controls whether the My Location dot and accuracy circle is enabled.
    mapView_.myLocationEnabled = YES;
    
    _mapview = mapView_;
    
    //Controls the type of map tiles that should be displayed.
    mapView_.mapType = kGMSTypeNormal;
    
    //Shows the compass button on the map
    mapView_.settings.compassButton = YES;
    
    //Shows the my location button on the map
    mapView_.settings.myLocationButton = YES;
    
    //Sets the view controller to be the GMSMapView delegate
    mapView_.delegate = self;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    
    
    
    NSLog(@"here");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    NSMutableArray *patientList = [Settings instance].patient_list;
    
    for (int i = 0; i < [patientList count]; i++) {
        NSDictionary *patient = [patientList objectAtIndex:i];
        
        NSLog(@"%@", patient);
        
        
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSString *d = [patient objectForKey:@"id"];
        
        NSLog(@"%@", d);
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://52.11.100.150:18000/listlocations?p=%@", d]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"GET"];
        
        //    NSDate *currentTime = [NSDate date];
        //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //    [dateFormatter setDateFormat:@"hh-mm"];
        //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //    NSString *resultString = [dateFormatter stringFromDate: currentTime];
        
        //    NSArray* foo = [resultString componentsSeparatedByString: @" "];
        
        //    NSString* date = [foo objectAtIndex: 0];
        //    NSString* time = [foo objectAtIndex: 1];
        
        
//        NSDictionary *mapData = [[NSDictionary alloc] init ];
        //    mapData = @{
        //                @"patient_id" : [Settings instance].patient_id,
        //                @"lat" : [NSString stringWithFormat:@"%f", latitude],
        //                @"long" : [NSString stringWithFormat:@"%f", latitude],
        //                @"date" : date,
        //                @"time" : time};
        
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
        
//        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
//            NSLog(@"data %@", data);
//            
//            NSLog(@"response %@", response);
//            
            NSLog(@"erorr %@", error);
            
            if (!error) {
                
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                
                long status_code = (long)[httpResponse statusCode];
                
                NSLog(@"response status code: %ld", status_code);
                
                NSError* error;
                
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                      
                                                                     options:kNilOptions
                                      
                                                                       error:&error];
                NSArray* latestLoans = [json objectForKey:@"locations"];
                
                NSLog(@"json: %@", json);
                
                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
//                NSLog(@"str %@", newStr);
                
                
                // 304 couldn't be found
                // 405 unsupported
                
                if (status_code == 202) {
                    
                    //                [self performSegueWithIdentifier:@"PatientHome" sender:sender];
                    
                    NSLog(@"Got lat/long");
                    
                    
                    
                } else {
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Something did not work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alert show];
                        
                    });
                    
                }
            } else {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"what?");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"message:@"You must be connected to the internet to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    
                });
                
               
                
            }
            
        }];
        
        [postDataTask resume];
    }
    
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
