//
//  TrackingViewController.h
//  Patient_Care
//
//  Created by Jose Alvarado on 4/6/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface TrackingViewController : UIViewController<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapview;

@end
