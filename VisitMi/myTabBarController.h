//
//  myTabBarController.h
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelObject.h"
#import "NearByObject.h"
#import "AppDelegate.h"
#import "TourObject.h"
#import "OverviewViewController.h"
#import "MapViewController.h"
#import "HotelsTableViewController.h"
#import "NearByTableViewController.h"
#import "UIViewAnimation.h"


@interface myTabBarController : UITabBarController <UITableViewDelegate, dbConnDelegate, nearByDelegate,nearbyTableDelegate, hotelTableDelegate,tourTableDelegate,dbConnDelegate, imageDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate ;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *favBarButton;
@property (strong, nonatomic) IBOutlet UIButton * favButton;

@property(weak, nonatomic)HotelsTableViewController *hotelViewController;
@property(weak, nonatomic)MapViewController *mapViewController;
@property(weak, nonatomic)OverviewViewController *overviewViewController;
@property(weak, nonatomic)NearByTableViewController *nearbyTableViewController;

@property (retain, nonatomic)PlaceObject *PO;
@property (retain, nonatomic)HotelObject *HO;
@property(retain, nonatomic)NearByObject *NBO;
@property(retain, nonatomic)TourObject *TO;



@property (strong, nonatomic) IBOutlet UIButton *scrollUpBt;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *scrollUpBarBt;

@property (weak, nonatomic) IBOutlet UITableView *selectedTableView;

@property(strong,nonatomic)NSMutableArray *rightBarItems;

@property (strong, strong) NSString *favoriteFilter;
@property (strong, strong) NSString *favoriteType;
@property (strong, strong) NSString *favoriteImgURL;
@property (strong, strong) NSString *favoriteImgNO;
@property (strong, strong) NSString *favoriteDetails;



 
@property(nonatomic, assign)BOOL isFavourites;
@property(nonatomic, strong)NSString *destinationPath;


 @property (strong, nonatomic) NSMutableArray *theFav;
 

-(void)addItemToFavorites:(id)sender;
-(BOOL)checkIfFavrouite;
- (IBAction)scrollUpAction:(id)sender;



@end
