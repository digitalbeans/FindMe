//
//  DevicesTableViewController.m
//  FindMe
//
//  Created by Dean Thibault on 8/26/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "DeviceTable.h"
#import "AppDelegate.h"

@interface DevicesTableViewController ()

@end

@implementation DevicesTableViewController
@synthesize deviceArray, deviceTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.deviceTable = [[DeviceTable alloc]init];
	self.deviceArray = [deviceTable devices];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAddBeacon:)];
	[self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [deviceArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
	
	NSMutableDictionary *deviceDict = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [deviceDict objectForKey:@"identifier"];
	cell.detailTextLabel.text = [deviceDict objectForKey:@"uuid"];
    
    return cell;
}

// show an alert for user input of beacon info
- (IBAction)doAddBeacon:(id)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Beacon", nil) message: nil preferredStyle:UIAlertControllerStyleAlert];
	
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.placeholder = @"UUID";
	}];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.placeholder = @"Identifier";
	}];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.placeholder = @"Major";
	}];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.placeholder = @"Minor";
	}];
	
	UIAlertAction *cancelAction = [UIAlertAction 
            actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                      style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction *action)
                    {
                      NSLog(@"Cancel action");
                    }];
	[alertController addAction:cancelAction];
	
	UIAlertAction *okAction = [UIAlertAction
	  actionWithTitle:NSLocalizedString(@"OK", @"OK action")
	  style:UIAlertActionStyleDefault
	  handler:^(UIAlertAction *action)
	  {
		NSLog(@"Ok action");
		UITextField *uuidField = alertController.textFields.firstObject;
		UITextField *idField = [alertController.textFields objectAtIndex:1];
		UITextField *majorField = [alertController.textFields objectAtIndex:2];
		UITextField *minorField = [alertController.textFields objectAtIndex:3];
		
		NSMutableDictionary *newDevice = [NSMutableDictionary dictionary];
		[newDevice setObject:uuidField.text forKey:@"uuid"];
		[newDevice setObject:idField.text forKey:@"identifier"];
		[newDevice setObject:majorField.text forKey:@"major"];
		[newDevice setObject:minorField.text forKey:@"minor"];
		// Update and save the device table
		[self.deviceTable.deviceArray addObject:newDevice];
		[self.deviceTable doSave];
		[self.tableView reloadData];
		// tell the delegate to reload beacon info
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate loadBeaconInfo];
		}];
	[alertController addAction:okAction];
	[self presentViewController:alertController animated:YES completion:nil];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[self.deviceTable.deviceArray removeObjectAtIndex:indexPath.row];
		[self.deviceTable doSave];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
