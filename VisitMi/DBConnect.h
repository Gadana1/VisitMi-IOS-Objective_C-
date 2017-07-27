//
//  DBConnect.h
//  VisitMi
//
//  Created by Samuel Gabriel on 02/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceObject.h"
#import "HotelObject.h"
#import "TourObject.h"
#import "BookingObject.h"

@protocol dbConnDelegate <NSObject>

@optional
-(void)countriesDownloaded;
-(void)dbConnResponse:(id)placeObj;
-(void)stateDownloaded:(id)placeObj;
-(void)tour_DestDownloaded:(id)placeObj;
-(void)tour_DestWithNameDownloaded:(id)placeObj;
-(void)tour_DestIntTypeDownloaded:(NSString *)intType;
-(void)tourItemsDownloaded:(id)tourOBJ :(int)tourCount;
-(void)tourItemsDownloadedWithId:(id)tourOBJ;
-(void)tourAvailDownloaded:(id)tourOBJ;
-(void)tourTicketsDownloaded:(id)tourOBJ;
-(void)hotelItemsDownloaded:(id)hotelOBJ :(int)hotelCount;
-(void)bookingsDownloaded:(id)bookingOBj;


@end

@interface DBConnect : NSObject

@property (nonatomic, weak) id<dbConnDelegate> delegate;

@property (assign, nonatomic) int count;

@property(strong,nonatomic)NSMutableData *_downloadedData;

@property(weak,nonatomic)NSURLSessionDataTask *downloadTask;


-(void)GetTour_DestWithName:(NSString *)tourDestName CountryCode:(NSString *)countryCode Caller:(id)callingObject CallBack:(void (^)(id callingObject))callBack;

-(void)GetTour_Destinations:(NSString *)countryCode LocCode:(NSString *)locCode ForLoc:(BOOL)forLoc;
-(void)GetTour:(NSString *)countryCode LocCode:(NSString *)locCode ForLoc:(BOOL)forLoc;
-(void)GetTourWithID:(NSString *)tourID CountryCode:(NSString *)countryCode;
-(void)GetTourForLocation:(NSString *)countryCode Latitude:(CGFloat)lat Longitude:(CGFloat)lng MaxDistance:(CGFloat)maxDist;
-(void)GetTourAvailabilities:(NSString *)tourID CountryCode:(NSString *)countryCode;
-(void)GetTourTickets:(NSString *)tourID CountryCode:(NSString *)countryCode;
-(void)GetAppData;
-(void)GetCountries;
-(void)GetStates:(NSString *)countryCode Type:(NSString *)type;
-(void)GetInterestTypes:(NSString *)countryCode LocCode:(NSString *)locCode ForLoc:(BOOL)forLoc;
-(void)GetHotels:(NSString *)countryCode Latitude:(CGFloat)lat Longitude:(CGFloat)lng MaxDistance:(CGFloat)maxDist;
-(void)GetBookingsForUser:(NSString *)useremail;
-(void)GetBookingsWithID:(NSString *)bookingID Type:(NSString *)type;

-(void)RegisterUser:(NSString *)fname SecondName:(NSString *)lname Email:(NSString *)email PhoneNumber:(NSString *)phone Password:(NSString *)password CountryCode:(NSString *)countryCode;
-(void)LoginUser:(NSString *)email Password:(NSString *)password;
-(void)LogOutUser :(NSString *)useremail SessionID:(NSString *)sessionID;
-(void)VerifyUser:(NSString *)useremail Session:(NSString *)sessionID CallBack:(void (^)(id callingObject))callBack;
-(void)UpdateUser:(NSString *)fname SecondName:(NSString *)lname Email:(NSString *)useremail PhoneNumber:(NSString *)phone NewPassword:(NSString *)newPassword CountryCode:(NSString *)countryCode CurrentPassword:(NSString *)currentPassword;

-(void)insertTourBooking:(NSString *)useremail TourID:(NSString *)tourID TourTitle:(NSString *)tourTitle CurrencyCode:(NSString *)currencyCode Price:(CGFloat)price ValueDate:(NSString *)valueDate TourDetails:(NSString *)tourDetails;
-(void)cancelBookingsWithID:(NSString *)bookingID;

@end
