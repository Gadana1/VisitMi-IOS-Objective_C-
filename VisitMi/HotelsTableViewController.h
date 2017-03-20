//
//  HotelsTableViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 01/02/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "AppDelegate.h"
#import "HotelTableViewCell.h"
#import <cache.h>
#import "SVWebViewController.h"

@protocol hotelTableDelegate <NSObject>

@optional
- (void)hoScrollViewAction:(UITableView *)tableView;
-(void)showMapViewFromHotel;

@end

@protocol hotelMapDelegate <NSObject>

-(void)selectHotelMarker:(NSString *)name;

@end

@interface HotelsTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,dbConnDelegate,imageDelegate>

@property(strong, nonatomic)id<hotelTableDelegate>delegate;
@property(strong, nonatomic)id<hotelMapDelegate>delegateForMap;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)SVWebViewController *svwWebView;
@property(weak, nonatomic)HotelTableViewCell * cell ;


@property (retain, nonatomic)HotelObject *HO;
@property (strong, nonatomic)NSMutableArray *hotelsItems;
@property (strong, nonatomic)NSMutableArray *sortHotel;
@property (strong, nonatomic)NSMutableArray *scopes;

@property(assign, nonatomic)BOOL isSorted;

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) NSUInteger hotelCount;
@property (assign, nonatomic) NSUInteger sortedCount;
@property (assign, nonatomic) NSUInteger presentCount;
@property (assign, nonatomic) NSUInteger hotelTotal;

@property (strong, nonatomic) UIAlertController * alert;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sorting;
@property (strong, nonatomic) IBOutlet UIView *mainHeaderView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property(strong,nonatomic)NSMutableArray *indexPaths;
@property (strong, nonatomic) IBOutlet UIButton *optionsBT;

- (IBAction)sortinigAction:(id)sender;
-(void)checkHotelCount;
- (IBAction)optionAcc:(id)sender;

@end
