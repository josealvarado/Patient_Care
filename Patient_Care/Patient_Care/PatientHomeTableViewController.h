//
//  PatientHomeTableViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/25/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PatientHomeTableViewController : UITableViewController<CLLocationManagerDelegate, NSURLSessionDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

//@property(nonatomic,retain) CLLocationManager *locationManager;


@end
