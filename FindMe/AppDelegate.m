//
//  AppDelegate.m
//  FindMe
//
//  Created by Dean Thibault on 8/22/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ViewController.h"
#import "DeviceTable.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	//Register to send notifications
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes :(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil]; [application registerUserNotificationSettings:settings];

	// load beacon info from file and start listening
	[self loadBeaconInfo];
	
	return YES;
}

- (void) loadBeaconInfo
{
	// load device info from file
	DeviceTable *deviceTable = [[DeviceTable alloc] init];
	NSMutableArray *devices = [deviceTable devices];
	// if config file found
	if (devices) {
		// set up the location manager, 1 time
		if (self.locationManager == nil) {
			self.locationManager = [[CLLocationManager alloc] init];
			[self.locationManager requestAlwaysAuthorization];
			self.locationManager.delegate = self;
			self.locationManager.pausesLocationUpdatesAutomatically = NO;
		}

		for (NSDictionary *device in devices) {
			
			//Specify the specific UUID and Identifier of the beacon you will be listening for
			NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:[device objectForKey:@"uuid"]];
			NSString *beaconIdentifier = [device objectForKey:@"identifier"];
			// Instantiate the beacon region to monitor
			CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:beaconIdentifier];
			
			
			[self.locationManager startMonitoringForRegion:beaconRegion];
			[self.locationManager startRangingBeaconsInRegion:beaconRegion];
		}
		// Start generating updates that report the user’s current location.
		[self.locationManager startUpdatingLocation];
	}
}

-(void) sendLocalNotificationWithMessge:(NSString *)message {
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.alertBody = message;
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// Tells the delegate that one or more beacons are in range. This can be
// updated to show app specific notification or do some app specific action.
-(void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
	
	// if main view is visible, update the table
	UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
	UIViewController *viewController = (UIViewController*)navController.topViewController;
	if ([viewController isKindOfClass:[ViewController class]] ) {
		((ViewController*)viewController).beacons = beacons;
		[((ViewController*)viewController).tableView reloadData];
	}
	
	// generate a message and send notification
	NSString *message = @"";
	
	if (beacons.count > 0) {
		CLBeacon *nearestBeacon = beacons.firstObject;
		if (nearestBeacon.proximity == self.lastProximity ||
			nearestBeacon.proximity == CLProximityUnknown) {
    			return;
		}
		self.lastProximity = nearestBeacon.proximity;
		
		switch (nearestBeacon.proximity) {
		  case CLProximityFar:
			message = @"You are far away from the beacon";
			break;
		  case CLProximityNear:
			message = @"You are near the beacon";
			break;
		  case CLProximityImmediate:
			message = @"You are in the immediate proximity of the beacon";
			break;
		  case CLProximityUnknown:
		  	return;
		}
	} else {
		message = @"No Beacons are nearby";
	}
	
	NSLog(@"%@", message);
	[self sendLocalNotificationWithMessge:message];
	
}

// Tells the delegate that the user entered the specified region.
-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
	[manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
	[self.locationManager startUpdatingLocation];
	
	NSLog(@"You entered the region.");
	[self sendLocalNotificationWithMessge:@"You entered the region."];
}

// Tells the delegate that the user left the specified region.
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
	[manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
	[self.locationManager stopUpdatingLocation];
	
	NSLog(@"You exited the region.");
    [self sendLocalNotificationWithMessge:@"You exited the region."];
}



- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
