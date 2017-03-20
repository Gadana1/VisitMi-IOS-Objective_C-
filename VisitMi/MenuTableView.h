//
//  MenuTableView.h
//  VisitMi
//
//  Created by Samuel Gabriel on 08/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SettingsTableViewController.h"
#import "BookingTableViewController.h"
#import "BookmarkTableViewController.h"
#import "SWRevealViewController.h"

@interface MenuTableView : UITableViewController <loginDelegate,SWRevealViewControllerDelegate,dbConnDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic) IBOutlet UIImageView *loginIMG;
@property (strong, nonatomic) IBOutlet UIButton *loginBT;

@property (strong, nonatomic) IBOutlet UILabel *loginLB;

@property (assign, nonatomic)  BOOL logInStatus;

@property (strong, nonatomic) IBOutlet UILabel *copyrightLB;

- (IBAction)loginAcc:(id)sender;

@end
