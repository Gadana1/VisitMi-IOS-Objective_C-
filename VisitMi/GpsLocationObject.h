//
//  GpsLocationObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 02/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//


#import "AppDelegate.h"

@protocol gpsLocationDelegate <NSObject>

-(void)gpsLocationSuccessful:(CLLocationCoordinate2D)coordinate;
-(void)gpsLocationFailed;
-(void)gpsNotActivated;

@end

@interface GpsLocationObject : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id <gpsLocationDelegate> delegate;

@property (assign, nonatomic)CLLocationCoordinate2D coordinate;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLLocation *location;
@property(strong, nonatomic)GMSPlacesClient *placeClient;

+ (GpsLocationObject *)sharedSingleton;

@end
