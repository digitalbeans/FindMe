//
//  ViewController.m
//  FindMe
//
//  Created by Dean Thibault on 8/22/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize beacons;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView 
    numberOfRowsInSection:(NSInteger)section {
    return self.beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// show current info for beacon in table
    UITableViewCell *cell = [tableView 
      dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
          initWithStyle:UITableViewCellStyleSubtitle 
          reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CLBeacon *beacon = (CLBeacon*)[self.beacons 
      objectAtIndex:indexPath.row];
    NSString *proximityLabel = @"";
    switch (beacon.proximity) {
        case CLProximityFar:
            proximityLabel = @"Far";
            break;
        case CLProximityNear:
            proximityLabel = @"Near";
            break;
        case CLProximityImmediate:
            proximityLabel = @"Immediate";
            break;
        case CLProximityUnknown:
            proximityLabel = @"Unknown";
            break;
    }
    
    cell.textLabel.text = proximityLabel;
    
    NSString *detailLabel = [NSString 
      stringWithFormat:
      @"Major: %d, Minor: %d, RSSI: %d, UUID: %@",
      beacon.major.intValue, beacon.minor.intValue, 
      (int)beacon.rssi, beacon.proximityUUID.UUIDString];
    cell.detailTextLabel.text = detailLabel;
    
    return cell;    
}

@end
