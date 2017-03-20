//
//  TicketsViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 06/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TicketsTableViewCell.h"
#import "LoginViewController.h"


@protocol displayBookingDeegate <NSObject>

-(void)displayBooking;

@end

@interface TicketsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,dbConnDelegate,loginDelegate>

@property (strong, nonatomic) id <displayBookingDeegate> bookingDelegate;

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic)  NSString *navTitle;

@property (strong, nonatomic) IBOutlet UIButton *proceedBT;
@property (strong, nonatomic) IBOutlet UITableView *ticketsTableView;

@property (strong, nonatomic)  NSMutableArray *tickets;

@property (assign, nonatomic)  CGFloat total;

@property (strong, nonatomic)  NSString *userDetailsFilePath;


- (IBAction)proceedAction:(id)sender;

@end
