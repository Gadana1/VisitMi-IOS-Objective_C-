//
//  SettingsTableViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 06/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "SettingsDetailsController.h"
#import "LoginViewController.h"

@interface SettingsTableViewController : UITableViewController <SWRevealViewControllerDelegate,loginDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *countryName;

@property (weak, nonatomic) IBOutlet UILabel *copyrightLB;
@end
