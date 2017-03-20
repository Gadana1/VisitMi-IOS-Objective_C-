//
//  TourObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 13/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TourObject : NSObject

@property (strong, nonatomic)NSString *activityID;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *thumbnailURL;
@property (strong, nonatomic) NSData *thumbnailData;
@property (assign, nonatomic) CGFloat priceRange;
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;

@property (strong, nonatomic)NSString *desc;
@property (strong, nonatomic)NSString *city;
@property (strong, nonatomic)NSString *category;
@property (strong, nonatomic)NSString *startDate;
@property (strong, nonatomic)NSString *endDate;
@property (strong, nonatomic)NSString *currencyCode;
@property (strong, nonatomic)NSString *priceFootnote;
@property (strong, nonatomic)NSString *duration;
@property (strong, nonatomic)NSString *latlng;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)NSString *stateCode;

@property (strong, nonatomic)NSString *knowBeforeBook;
@property (strong, nonatomic)NSString *highlights;
@property (strong, nonatomic)NSString *termsAndConditions;
@property (strong, nonatomic)NSArray *imageARR;

@property (strong, nonatomic)NSString *valueDate;
@property (strong, nonatomic)NSString *displayDate;

@property (strong, nonatomic)NSString *ticketID;
@property (strong, nonatomic)NSString *ticketType;
@property (assign, nonatomic) CGFloat ticketPrice;


@end
