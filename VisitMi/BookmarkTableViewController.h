//
//  BookmarkTableViewController.h
//  VisitMi
//
//  Created by Samuel on 10/25/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "myTabBarController.h"
#import "BookmarkTableViewCell.h"
#import "SVWebViewController.h"
#import "SWRevealViewController.h"

@interface BookmarkTableViewController : UITableViewController <UITabBarControllerDelegate,imageDelegate, SWRevealViewControllerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate ;
@property(nonatomic, strong)NSString *destinationPath;
@property(nonatomic, strong)NSFileManager *fileManager;
@property(nonatomic, strong)NSString *imgageDir;
@property(nonatomic, strong)NSString *imagePath;


@property(strong, nonatomic)SVWebViewController *svwWebView;

@property(strong, nonatomic)PlaceObject *PO;
@property (retain, nonatomic)HotelObject *HO;
@property (retain, nonatomic)NearByObject *NBO;
@property(strong, nonatomic)TourObject *TO;

@property(weak, nonatomic)myTabBarController *tabBarController;

@property(strong, nonatomic)BookmarkTableViewCell *itemsCell;

@property(strong, nonatomic)UITableViewCell *cell;

@property (strong, nonatomic) IBOutlet UIButton *sidebarButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property(weak,nonatomic)UIImageView *imageView;
@property(weak,nonatomic)UILabel *textlabel;
@property(weak,nonatomic)UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *bgViewImage;
@property (weak, nonatomic) IBOutlet UILabel *bgViewText;


@property (strong, nonatomic)  NSMutableArray *theFavorites;


@end
