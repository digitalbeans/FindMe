//
//  DevicesTableViewController.h
//  FindMe
//
//  Created by Dean Thibault on 8/26/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTable.h"

@interface DevicesTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) DeviceTable *deviceTable;
@end
