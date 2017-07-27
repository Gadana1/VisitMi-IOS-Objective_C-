//
//  MoreTableViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 13/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MoreViewController.h"
#import "SWRevealViewController.h"

@interface MoreTableViewController : UITableViewController <SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;

@end
