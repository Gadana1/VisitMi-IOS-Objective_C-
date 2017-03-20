//
//  MapViewController.h
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInternet.h"
#import "PlaceObject.h"
#import "HotelObject.h"
#import "NearByObject.h"
#import "HotelsTableViewController.h"
#import "NearByTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SVWebViewController.h"


@interface MapViewController : UIViewController <GMSMapViewDelegate,hotelMapDelegate,nearbyMapDelegate,nearByDelegate>

@property(strong, nonatomic)SVWebViewController *svwWebView;

@property (weak, nonatomic)MapViewController *annotation;
@property (assign, nonatomic)CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *pinName;

@property (weak, nonatomic) IBOutlet GMSMapView *mapview;

@property (assign, nonatomic) int countChKDownTimes;

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic) NSData *imgData;


@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *state;

@property (retain, nonatomic)HotelObject *HO;
@property (retain, nonatomic)NearByObject *NBO;


@property (nonatomic,retain) UIView *actionOverlayCalloutView;

@property(strong, nonatomic)NSMutableArray *pointsItems;
@property(strong, nonatomic)NSMutableArray *hotelItems;

@property(strong, nonatomic)NSMutableArray *addedMarkers;

@property(strong, nonatomic)NSMutableDictionary *markers;
@property(strong, nonatomic)NSMutableDictionary *details;


@property(assign, nonatomic)NSUInteger hotelsCount;
@property(assign, nonatomic)NSUInteger pointsCount;

@property (weak, nonatomic) IBOutlet UIButton *refreshBT;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *markersLoading;

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIView *locDetailView;
@property (weak, nonatomic) IBOutlet UIView *poiDetailView;


@property (weak, nonatomic) IBOutlet UIImageView *locationTypeImg;
@property (weak, nonatomic) IBOutlet UITextView *locationName;
@property (weak, nonatomic) IBOutlet UIImageView *locBackground;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumberTXT;
@property (weak, nonatomic) IBOutlet UITextView *addressTXT;

@property (weak, nonatomic) IBOutlet UIImageView *ho_background;
@property (weak, nonatomic) IBOutlet UILabel *ho_Name;
@property (weak, nonatomic) IBOutlet UIImageView *ho_Img;
@property (weak, nonatomic) IBOutlet UIImageView *ho_Rating;

@property (weak, nonatomic) IBOutlet UIImageView *poi_background;
@property (weak, nonatomic) IBOutlet UIImageView *poi_Img;
@property (weak, nonatomic) IBOutlet UILabel *poi_Name;
@property (weak, nonatomic) IBOutlet UILabel *poi_type;

@property (strong, nonatomic) IBOutlet UIImageView *mapPin;

- (IBAction)refresh:(id)sender;
-(void)loadAnnotations: (int)count :(NSString *)annotationType;
-(BOOL)checkKDwnloadCompleted;


@end
