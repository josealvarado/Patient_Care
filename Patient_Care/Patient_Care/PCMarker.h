//
//  PCMarker.h
//  Patient_Care
//
//  Created by Paresh on 29/04/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface PCMarker : GMSMarker

@property (nonatomic, copy) NSString *gpsId;
@end
