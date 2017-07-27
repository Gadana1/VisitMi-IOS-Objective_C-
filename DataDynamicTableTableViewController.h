//
//  DataDynamicTableTableViewController.h
//  VisitMi
//
//  Created by Samuel on 10/20/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceObject.h"
#import "NearByObject.h"
#import "AppDelegate.h"
#import "myTabBarController.h"
#import "ItemsTableViewCell.h"
#import "PlaceSearchTableViewCell.h"
#import "HotelTableViewCell.h"
#import "TourTableViewCell.h"
#import "NearByTableViewCell.h"
#import "DinningObject.h"
#import "ShoppingObject.h"
#import "HotelObject.h"
#import "TourObject.h"
#import "DistanceMatrixObject.h"
#import "TourViewController.h"
#import "GpsLocationObject.h"

@interface DataDynamicTableTableViewController : UITableViewController <UITabBarControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating,CLLocationManagerDelegate,GMSAutocompleteResultsViewControllerDelegate,imageDelegate,DinningDelegate,ShoppingDelegate,nearByDelegate,dbConnDelegate,gpsLocationDelegate, UITextViewDelegate>

@property(strong, nonatomic)PlaceObject *PO;
@property(strong, nonatomic)NearByObject *NBO;
@property (strong, nonatomic)DinningObject *DO;
@property(strong, nonatomic)ShoppingObject *SHOP;
@property(strong, nonatomic)HotelObject *HO;
@property(strong, nonatomic)TourObject *TO;

@property(weak, nonatomic)myTabBarController *tabBarController;

@property(strong, nonatomic)SVWebViewController *svwWebView;

@property (assign, nonatomic)CLLocationCoordinate2D coordinate;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLLocation *location;

@property(strong, nonatomic)GMSPlacesClient *placeClient;
@property(strong, nonatomic)GMSAutocompleteResultsViewController *acController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerView;
@property (weak, nonatomic) IBOutlet UIButton *scrollUpBt;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scrollUpBarBt;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBarBt;
@property (strong, nonatomic) IBOutlet UIButton *filterBt;

@property (weak, nonatomic) IBOutlet UIButton *locationBt;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarBt;

@property(weak, nonatomic)ItemsTableViewCell *itemsCell;
@property(weak, nonatomic)PlaceSearchTableViewCell *placeCell;
@property(weak, nonatomic)HotelTableViewCell *hotelCell;
@property(weak, nonatomic)TourTableViewCell *tourCell;
@property(weak, nonatomic)NearByTableViewCell *nearbyCell;

@property(strong,nonatomic)NSMutableArray *finalDataArr;
@property(strong,nonatomic)NSMutableArray *displayRegionArr;
@property(strong,nonatomic)NSString *displayRegion;

@property (strong, nonatomic) UISearchController *searchController;
@property(strong,nonatomic)NSMutableArray *searchArr;
@property(strong,nonatomic)NSString *searchText;
@property(strong,nonatomic)NSMutableArray *scopes;
@property(assign,nonatomic)BOOL isFilltered;
@property(assign,nonatomic)BOOL gpsActivated;
@property(assign,nonatomic)BOOL searchActivated;

@property(strong,nonatomic)NSMutableArray *imgARR;

//Updating table
@property(strong,nonatomic)NSMutableArray *indexPaths;
@property(assign,nonatomic)NSUInteger count;
@property(assign,nonatomic)NSUInteger presentCount;
@property(assign,nonatomic)NSUInteger itemsTotal;

//Favourites
@property(nonatomic, assign)BOOL isFavourites;
@property(nonatomic, strong)NSString *destinationPath;
@property (strong, nonatomic) NSMutableArray *theFav;

@property (weak, nonatomic) IBOutlet UIImageView *bgViewImage;
@property (weak, nonatomic) IBOutlet UILabel *bgViewText;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property(strong,nonatomic)NSMutableArray *rightBarItems;

-(IBAction)fillterAction:(id)sender;
-(IBAction)scrollUpAction:(id)sender;
-(IBAction)myLocAction:(id)sender;
-(void)downloadData;
-(void)getUserLocation;
-(void)updateTableData;
@end
