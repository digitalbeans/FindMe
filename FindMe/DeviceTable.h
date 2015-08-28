//
//  DeviceTable.h
//  FindMe
//
//  Created by Dean Thibault on 8/26/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTable : NSObject

@property (strong, nonatomic) NSMutableArray *deviceArray;

- (NSMutableArray *)devices;

- (void) doLoad;
- (void) doSave;
@end
