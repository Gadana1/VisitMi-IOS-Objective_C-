//
//  PlaceObject.h
//  
//
//  Created by Samuel on 10/30/15.
//
//

#import "AppDelegate.h"

@protocol imageDelegate <NSObject>

-(void)imagesDownloaded: (NSData *)imageDATA :(NSInteger)index;

@end

@interface PlaceObject : NSObject <NSURLSessionDelegate>

@property (nonatomic, weak) id<imageDelegate> delegate;

@property (strong, nonatomic) NSString *country_Code;
@property (strong, nonatomic) NSString *country_Name;
@property (strong, nonatomic) NSString *country_Image;
@property (strong, nonatomic) NSString *dialing_Code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *stateCode;
@property (strong, nonatomic) NSString *int_type;
@property (strong, nonatomic) NSString *thumbnailUrl;
@property (strong, nonatomic) NSArray *imageArr;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double latitude;
@property (strong, nonatomic) NSString *stateImage;
@property (strong, nonatomic) NSString *dbstatus;
@property (strong, nonatomic) NSString *dbmessage;


@property(strong,nonatomic)NSData *img;

@property(weak,nonatomic)NSURLSessionDataTask *downloadPhotoTask;


-(void)getDirectionsFromCoordinate:(CLLocationCoordinate2D)coordinate TO_Coordinate:(CLLocationCoordinate2D)destCoordinate;

-(void)setPickUpCoordinate:(CLLocationCoordinate2D)coordinate DropOffCoordinate:(CLLocationCoordinate2D)destCoordinate;


-(void)downloadImages:(NSString *)imgURL :(int)imgNum :(NSString *)name :(NSInteger)imgIndex;
-(void)deleteImages:(int)imgNum :(NSString *)name;


//Instance Methods
- (id)initWithCountries:(NSString *)country_Code CountryName:(NSString *)country_Name DialingCode:(NSString *)dialing_Code CountryImage:(NSString *)country_Image;
- (id)initWithState:(NSString *)state image:(NSString *)stateImage code:(NSString *)stateCode;
- (id)initWithDbResponse:(NSString *)status Message:(NSString *)message;

-(NSString *)getPlaceAddressForLatitude:(CGFloat)lat Longitude:(CGFloat)lng;



@end

