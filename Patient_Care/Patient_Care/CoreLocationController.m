//
//  CoreLocationController.m
//  Patient_Care
//
//  Created by Paresh on 29/04/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "CoreLocationController.h"
#import "CoreLocation/CoreLocation.h"

@implementation CoreLocationController

- (id)init {
    self = [super init];
    if(self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.delegate update:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.delegate locationError:error];
}

@end