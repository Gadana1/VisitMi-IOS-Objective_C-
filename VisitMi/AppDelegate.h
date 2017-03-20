//
//  AppDelegate.h
//  VisitMi
//
//  Created by Samuel on 10/18/15.
//  Copyright © 2015 Mi S. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Photos/Photos.h>
#import "DBConnect.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "CheckInternet.h"
#import "UIViewAnimation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, strong) NSString *storyboardID;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;

@property (strong, strong) NSString *serverAddress;

@property (strong, strong) NSString *googleServiceKey;
@property (strong, strong) NSString *uberClientID;
@property (strong, strong) NSString *foursquareClientID;
@property (strong, strong) NSString *foursquareClientSecret;
@property (strong, strong) NSString *zomatoKey;
@property (strong, strong) NSString *skyScannerKey;

@property (strong, nonatomic) NSData *countryImage;
@property (strong, nonatomic) NSDictionary *userCountry;

@property (strong, nonatomic) NSData *userImage;
@property (strong, nonatomic) NSDictionary *userDetails;
@property (strong, nonatomic) NSDictionary *appData;
@property (strong, nonatomic) NSDictionary *infoDict;

@property (strong, nonatomic) NSMutableArray *countries;

@property (strong, nonatomic) NSMutableDictionary *bookingData;
@property (assign, nonatomic) BOOL bookingUpdated;
@property (strong, nonatomic) NSMutableArray *userBookings;

// Favourite variables
@property (strong, strong) NSString *favoriteName;
@property (strong, strong) NSString *favoritePath;


//Arrays for session variables
@property (strong, nonatomic) NSMutableArray *sessions;

-(UIImage *)qrCodeWith:(NSString *)stringValue ImageSize:(CGSize)size;
-(UIImage *)nonInterpolatedImageWithImage:(CIImage *)ciImage DX:(CGFloat)dx DY:(CGFloat)dy;

@end

