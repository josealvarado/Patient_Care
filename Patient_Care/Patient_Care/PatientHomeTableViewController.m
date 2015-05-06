//
//  PatientHomeTableViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/25/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "PatientHomeTableViewController.h"
#import "Settings.h"
//#import <CoreLocation/CoreLocation.h>

@interface PatientHomeTableViewController ()

@end

@implementation PatientHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //---- For getting current gps location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
        
        [self requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self CurrentLocationIdentifier]; // call this method
    
}
- (NSString *)deviceLocation
{
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
}

-(void) locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *) newLocation
           fromLocation: (CLLocation *) oldLocation{
    
    
    float latitude = oldLocation.coordinate.latitude;
    float longitude = oldLocation.coordinate.longitude;
    
    NSLog(@"IN METHOD 3: %f, %f", latitude, longitude);
    
    
    latitude = manager.location.coordinate.latitude;
    longitude = manager.location.coordinate.longitude;
    
//    NSLog(@"IN METHOD 3: %f, %f", latitude, longitude);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Info" message:[NSString stringWithFormat:@"3 %f, %f", latitude, longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
//    [alert show];
}

//this works.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    float latitude = currentLocation.coordinate.latitude;
    float longitude = currentLocation.coordinate.longitude;
    
    NSLog(@"MAYBE IN METHOD 2: %f, %f", latitude, longitude);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Info" message:[NSString stringWithFormat:@"2 %f, %f", latitude, longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alert show];
}



- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"FAILED TO GET LOCATION");
}

//// Delegate method from the CLLocationManagerDelegate protocol.
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray *)locations {
//    // If it's a relatively recent event, turn off updates to save power.
//    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
//        // If the event is recent, do something with it.
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//              location.coordinate.latitude,
//              location.coordinate.longitude);
//    }
//}

//------------ Current Location Address-----
//better one
-(void)CurrentLocationIdentifier
{
    
    NSLog(@"dev %@",[self deviceLocation]);
    
    //------
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    
    NSLog(@"%f, %f", latitude, longitude);
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Info" message:[NSString stringWithFormat:@"1 %f, %f", latitude, longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                          
//    [alert show];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:[Settings instance].serverPorts[@"tracking"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh-mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSArray* foo = [resultString componentsSeparatedByString: @" "];
    
    NSString* date = [foo objectAtIndex: 0];
    NSString* time = [foo objectAtIndex: 1];
    
    
    NSDictionary *mapData = [[NSDictionary alloc] init ];
    
    NSLog(@"patient id %@", [Settings instance].patient_id);
    
    mapData = @{
                @"patient_id" : [Settings instance].patient_id,
                @"lat" : [NSString stringWithFormat:@"%f", latitude],
                @"long" : [NSString stringWithFormat:@"%f", longitude],
                @"date" : date,
                @"time" : time};
    
    NSLog(@"%@", mapData);
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
            
            
            // 304 couldn't be found
            // 405 unsupported
            
            if (status_code == 202) {
                
                NSLog(@"successfully updated GPS");
                
                //                [self performSegueWithIdentifier:@"PatientHome" sender:sender];
                
                
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

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    currentLocation = [locations objectAtIndex:0];
//    [locationManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (!(error))
//         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//             NSLog(@"%@",CountryArea);
//         }
//         else
//         {
//             NSLog(@"Geocode failed with error %@", error);
//             NSLog(@"\nCurrent Location Not Detected\n");
//             //return;
////             CountryArea = NULL;
//         }
//         /*---- For more results
//          placemark.region);
//          placemark.country);
//          placemark.locality);
//          placemark.name);
//          placemark.ocean);
//          placemark.postalCode);
//          placemark.subLocality);
//          placemark.location);
//          ------*/
//     }];
//}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
