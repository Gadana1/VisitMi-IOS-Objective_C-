//
//  ViewController.h
//  VisitMi
//
//  Created by Samuel on 10/18/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "DataDynamicTableTableViewController.h"
#import "LocationTableViewCell.h"
#import "HotelObject.h"

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,dbConnDelegate>

@property (strong, nonatomic)AppDelegate *appDelegate;

@property(strong, nonatomic)DataDynamicTableTableViewController * dataView;
@property (strong, nonatomic) IBOutlet UIButton *backBT;

@property (strong, nonatomic) IBOutlet UITableView *locTableView;
@property (strong, nonatomic)  LocationTableViewCell *locCell;

@property(strong, nonatomic) NSMutableArray *locData;
@property (strong, nonatomic)NSString *item_title;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

