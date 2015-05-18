//
//  PatientHomeTableViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/25/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>


double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;

@interface PatientHomeTableViewController : UITableViewController<CLLocationManagerDelegate, NSURLSessionDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

//@property(nonatomic,retain) CLLocationManager *locationManager;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
