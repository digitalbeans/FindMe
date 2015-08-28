//
//  AppDelegate.h
//  FindMe
//
//  Created by Dean Thibault on 8/22/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLProximity lastProximity;

- (void) loadBeaconInfo;

@end

