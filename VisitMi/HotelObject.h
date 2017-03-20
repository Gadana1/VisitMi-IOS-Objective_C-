//
//  HotelObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 01/02/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "AppDelegate.h"

@interface HotelObject : NSObject

@property (strong, nonatomic)NSString *hotelID;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *state;
@property (strong, nonatomic)NSString *stateCode;
@property (strong, nonatomic)NSString *streetAddress;
@property (strong, nonatomic)NSString *city;
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic)NSString *starRating;
@property (assign, nonatomic) CGFloat lowRate;
@property (strong, nonatomic)NSString *rateCurrencyCode;
@property (strong, nonatomic)NSString *detailURL;
@property (strong, nonatomic)NSString *thumbnailURL;
@property (strong, nonatomic)NSData *thumbnailData;

@property (assign, nonatomic)CLLocationDistance distance;

@property (strong, nonatomic)NSString *place_distance;

@property (assign, nonatomic) int hotelTotal;




@end
