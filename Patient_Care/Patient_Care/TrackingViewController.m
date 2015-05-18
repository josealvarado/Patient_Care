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
#import "PCMarker.h"

@interface TrackingViewController () <GMSMapViewDelegate>

@property(strong, nonatomic) GMSMapView *mapView;
@property(strong, nonatomic) NSURLSession *markerSession;
@property(strong, nonatomic) NSSet *markers;

@end

@implementation TrackingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.774929
                                                            longitude:-122.419416
                                                                 zoom:12
                                                              bearing:0
                                                         viewingAngle:0];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    self.mapView.delegate = self;
    
    self.mapView.mapType = kGMSTypeNormal;
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.zoomGestures = YES;
    
    [self.view addSubview:self.mapView];
    
    [self viewWillAppear:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    NSMutableArray *patientList = [Settings instance].patient_list;
    
    for (int i = 0; i < [patientList count]; i++) {
        NSDictionary *patient = [patientList objectAtIndex:i];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.markerSession = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSString *d = [patient objectForKey:@"id"];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/listlocations?p=%@",[Settings instance].serverPorts[@"tracking"], d]];
        
        
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
                
                //serializing the json response into a dictionary
                
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
                
                NSLog(@"json: %@", json);
                
                
                NSArray* latestLoans = [json objectForKey:@"locations"];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self createMarkerObjectWithJson:latestLoans];
                }];

                if (status_code == 202) {
                    
                } else {
    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Error"
                                                                        message:@"Sending incorrect json data"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    });
                    
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"what?");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
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
    
}

-(void)createMarkerObjectWithJson:(NSArray *)markers{

    NSMutableSet *mutableMarkers = [NSMutableSet setWithSet:self.markers];
    
    for (NSDictionary *markerData in markers){
        
        PCMarker *newMarker = [[PCMarker alloc]init];
        newMarker.gpsId = [markerData[@"gps_id"] stringValue];
        newMarker.position = CLLocationCoordinate2DMake([markerData[@"lat"] doubleValue], [markerData[@"long"] doubleValue]);
        newMarker.title = markerData[@"date"];
        newMarker.snippet = markerData[@"time"];
        newMarker.map = nil;
        
        [mutableMarkers addObject:newMarker];
    }
    self.markers = [mutableMarkers copy];
    
    [self drawMarkers];
}


-(void)drawMarkers {
    for(PCMarker *marker in self.markers){
        
        if(marker.map ==nil){
            NSLog(@"drawing markers");
            marker.map = self.mapView;
        }
        
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
