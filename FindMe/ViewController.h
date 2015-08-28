//
//  ViewController.h
//  FindMe
//
//  Created by Dean Thibault on 8/22/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;
@property (strong) NSArray *beacons;

@end

