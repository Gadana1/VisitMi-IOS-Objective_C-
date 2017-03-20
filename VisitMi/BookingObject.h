//
//  BookingObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 23/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BookingObject : NSObject

@property (strong, nonatomic) NSString *bookingID;
@property (strong, nonatomic) NSString *bookingTitle;
@property (strong, nonatomic) NSString *passID;
@property (strong, nonatomic) NSString *bookingDate;
@property (strong, nonatomic) NSString *bookingType;
@property (strong, nonatomic) NSString *bookingStatus;
@property (strong, nonatomic) NSString *currencyCode;
@property (assign, nonatomic) CGFloat price;

@property (strong, nonatomic) UIColor *bookingStatusColor;

//Tour
@property (strong, nonatomic)NSString *tourID;
@property (strong, nonatomic)NSString *tourDetails;
@property (strong, nonatomic)NSString *tourDate;
@property (strong, nonatomic)NSString *tourImgUrl;
@property (strong, nonatomic)NSString *tourCountryCode;

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;

@end
