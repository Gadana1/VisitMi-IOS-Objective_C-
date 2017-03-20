//
//  NearByObject.h
//  
//
//  Created by Samuel Gabriel on 09/06/2016.
//
//
#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@protocol nearByDelegate <NSObject>

@optional
-(void)nearByDownloaded:(id)nearByOBJ :(int)nearByCount;
-(void)nearByWithIdDownloaded:(id)nearByOBJ;


@end

@interface NearByObject : NSObject <NSURLSessionDelegate>

@property (nonatomic, weak) id<nearByDelegate> delegate;

- (void)downloadItems : (CGFloat)longitude latitude : (CGFloat)latitude;
- (void)downloadItemsWithId:(NSString *)venueID;

@property (strong, nonatomic) AppDelegate *appDelegate ;

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) int max;

@property (assign, nonatomic)BOOL done;
@property (assign, nonatomic)BOOL contd;

@property (assign, nonatomic)int countDone;

@property (strong, nonatomic) NSMutableData *_downloadedData;

@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *icon_url_tmp;
@property (strong, nonatomic)NSString *icon_url;
@property (strong, nonatomic)NSString *icon_urlEXT;
@property (strong, nonatomic)NSString *place_id;
@property (strong, nonatomic)NSString *canonicalURL;

@property (strong, nonatomic)NSString *phone;

@property (assign, nonatomic)CLLocationDistance distance;

@property (assign, nonatomic) CGFloat place_longitude;
@property (assign, nonatomic) CGFloat place_latitude;
@property (strong, nonatomic)NSString *place_distance;
@property (strong, nonatomic)NSArray *formattedAddress;
@property (strong, nonatomic)NSMutableArray *categories;

@property (strong, nonatomic)NSString *cat_name;

@property(strong,nonatomic)NSData *thumbnailData;

@property(strong,nonatomic)NSURLSessionDataTask *downloadTask;


@end
