//
//  DistanceMatrixObject.h
//  VisitMi
//
//  Created by Samuel Gabriel on 09/09/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol DistanceDelegate <NSObject>

-(void)distanceDownloaded:(id)obj;

@end

@interface DistanceMatrixObject : NSObject

@property(weak, nonatomic)id<DistanceDelegate>delegate;

-(void)getDistance: (CGFloat)orignLat OrignLongitude:(CGFloat)orignLng DistinationLatitude:(CGFloat)destinationLat DistinationLongitude:(CGFloat)destinationLng Modes:(NSArray *)modes;


@property(strong,nonatomic)NSURLSessionDataTask *downloadTask;
@property (strong, nonatomic) NSMutableData *_downloadedData;

@property(strong, nonatomic)NSString *mode;
@property (assign, nonatomic) NSString *distance;
@property (assign, nonatomic) NSString *duration;

@end
