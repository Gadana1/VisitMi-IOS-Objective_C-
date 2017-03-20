//
//  ShoppingObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 02/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol ShoppingDelegate <NSObject>

-(void)shoppingDownloaded:(id)nearByOBJ :(int)nearByCount;

@optional

-(void)shoppingWithIdDownloaded:(id)nearByOBJ;

@end

@interface ShoppingObject : NSObject

- (void)downloadItems : (CGFloat)longitude latitude : (CGFloat)latitude;
-(void)downloadItemsForeSquare:(CGFloat)longitude latitude:(CGFloat)latitude;
- (void)downloadItemsForeSquareWithId:(NSString *)venueID;



@property (nonatomic, weak) id<ShoppingDelegate> delegate;



@property (strong, nonatomic) NSMutableData *_downloadedData;

@property (strong, nonatomic)CLLocation *location;

@property (assign, nonatomic)CLLocationDistance distance;
@property (strong, nonatomic)CLLocation *destLocation;

@property (strong, nonatomic)NSString *country;
@property (strong, nonatomic)NSString *state;
@property (strong, nonatomic)NSString *type;

@property (assign, nonatomic)BOOL doneGoogle;
@property (assign, nonatomic)BOOL doneForeSquare;

@property (strong, nonatomic)NSString *next_token;

@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSData *icon_url;
@property (strong, nonatomic)UIImage *provider_icon;
@property (strong, nonatomic)NSString *place_id;
@property (strong, nonatomic)NSString *canonicalURL;
@property (strong, nonatomic)NSString *rating;
@property (strong, nonatomic)NSString *phone;
@property (assign, nonatomic) CGFloat loc_longitude;
@property (assign, nonatomic) CGFloat loc_latitude;

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic)NSString *place_distance;
@property (strong, nonatomic)NSMutableString *address;
@property (strong, nonatomic)NSArray *formattedAddress;
@property (strong, nonatomic)NSMutableArray *types;
@property (strong, nonatomic)NSString *Dine_type;
@property (assign, nonatomic)BOOL open_now;
@property (strong, nonatomic)NSString *photoReference;

@property(strong,nonatomic)NSData *thumbnailData;

@property(strong,nonatomic)NSURLSessionDataTask *downloadTask;



@end
