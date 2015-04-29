//
//  CoreLocationController.h
//  Patient_Care
//
//  Created by Paresh on 29/04/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreLocation/CoreLocation.h"

@protocol CoreLocationControllerDelegate
@required
- (void)update:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) id delegate;

@end
