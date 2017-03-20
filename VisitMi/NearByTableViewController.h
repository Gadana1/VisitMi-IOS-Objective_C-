//
//  NearByTableViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 09/06/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import "NearByObject.h"
#import "NearByTableViewCell.h"
#import "SVWebViewController.h"

@protocol nearbyTableDelegate <NSObject>

@optional
- (void)nbScrollViewAction:(UITableView *)tableView;
-(void)showMapViewFromNearby;

@end

@protocol nearbyMapDelegate <NSObject>

-(void)selectNearbyMarker:(NSString *)name;

@end

@interface NearByTableViewController : UITableViewController <nearByDelegate>

@property(strong, nonatomic)id<nearbyTableDelegate>delegate;
@property(strong, nonatomic)id<nearbyMapDelegate>delegateForMap;

@property(strong, nonatomic)SVWebViewController *svwWebView;

@property(strong, nonatomic)NearByTableViewCell *NBCell;
@property(strong, nonatomic)NSMutableArray *nearByItems;
@property(strong, nonatomic)NearByObject *NBO;

@property (assign, nonatomic) int NBOount;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) UIAlertController * alert;

-(void)checkNBOdataCount;


@end
