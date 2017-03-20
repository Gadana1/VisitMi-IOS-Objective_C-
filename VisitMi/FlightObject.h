//
//  FlightObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 13/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol flightDelegate <NSObject>

@optional

-(void)autoCompleteDownloaded:(id)flightOBJ IsDone:(BOOL)done;

@end

@interface FlightObject : NSObject

@property (nonatomic, weak) id<flightDelegate> delegate;

@property(strong,nonatomic) NSString *placeID;
@property(strong,nonatomic) NSString *placeName;
@property(strong,nonatomic) NSString *cityID;
@property(strong,nonatomic) NSString *country;
@property(strong,nonatomic) NSString *countryID;


@property(strong,nonatomic)NSMutableData *_downloadedData;

@property(weak,nonatomic)NSURLSessionDataTask *downloadTask;


-(void)getAutoCompleteForQuery:(NSString *)query CountryCode:(NSString *)countryCode;

@end
