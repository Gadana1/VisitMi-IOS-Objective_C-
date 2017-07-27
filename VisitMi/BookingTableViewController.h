//
//  BookingTableViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "BookingTableViewCell.h"
#import "BookingDetailsViewController.h"
#import "AppDelegate.h"

@interface BookingTableViewController : UITableViewController <dbConnDelegate,SWRevealViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *sidebarButton;

@property (strong, nonatomic) NSMutableArray *bookings;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *bgViewImage;
@property (weak, nonatomic) IBOutlet UILabel *bgViewText;


@end
