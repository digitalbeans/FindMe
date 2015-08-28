//
//  DeviceTable.m
//  FindMe
//
//  Created by Dean Thibault on 8/26/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "DeviceTable.h"

@implementation DeviceTable
@synthesize deviceArray;

- (NSMutableArray *)devices
{
	if (!self.deviceArray) {
    	[self doLoad];
		if (!self.deviceArray) {
    		self.deviceArray = [NSMutableArray array];
			NSMutableDictionary *aDevice = [NSMutableDictionary dictionary];
			[deviceArray addObject:aDevice];
			[self doSave];
		}
	}
	return self.deviceArray;
}

- (void) doLoad
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *fName = [NSString stringWithFormat:@"%@/devicetable", documentsDirectory];
	deviceArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fName];
}

- (void) doSave
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *fName = [NSString stringWithFormat:@"%@/devicetable", documentsDirectory];
	[NSKeyedArchiver archiveRootObject:deviceArray toFile:fName];

}

@end