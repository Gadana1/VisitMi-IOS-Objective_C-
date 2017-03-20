//
//  GpsLocationObject.m
//  VisitMi
//
//  Created by Samuel Gabriel on 02/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "GpsLocationObject.h"

@implementation GpsLocationObject

BOOL delegateSent;

//Get user's geolocation
- (id)init {
    self = [super init];
    
    delegateSent = false;

    if(self) {
        
        NSLog(@"Starting gps location function");
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        
        [self.locationManager requestWhenInUseAuthorization];
        
        if ([CLLocationManager locationServicesEnabled])
        {
            
            // Using Apple location api
            NSLog(@"Location services enabled");
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager requestLocation];
            
            NSLog(@"Location request sent");
            
            //[self.locationManager startUpdatingLocation];
            
        }
        else
        {
            if (!delegateSent) {
                
                
            }
            if (self.delegate) {
                
                delegateSent =true;

                [self.delegate gpsNotActivated];
            }
            
            NSLog(@"Location services are not enabled");
        }
        
        
    }
    
    return self;
}

+ (GpsLocationObject*)sharedSingleton
{
    static GpsLocationObject* gpsObj = nil;
    gpsObj = [GpsLocationObject new];
    
    return gpsObj;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"GPS Location Successful");

    self.location = [locations lastObject];
    self.coordinate = self.location.coordinate;
   
    if (!delegateSent) {

        if (self.delegate) {
            
            NSLog(@"sending delegate");
            delegateSent =true;
            
            [self.delegate gpsLocationSuccessful:self.coordinate];
        }

    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Apple Location update failed %@",error);
    NSLog(@"Trying Google....");
    
    //using google location api
    
    _placeClient = [[GMSPlacesClient alloc]init];
    
    [_placeClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error){
        
        if (error != nil)
        {
            if (!delegateSent) {
                
                if (self.delegate) {
                    
                    delegateSent =true;

                    [self.delegate gpsLocationFailed];
                }
                
            }
            
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        GMSPlace* place = [likelihoodList.likelihoods firstObject].place;
        NSLog(@"Current Place name %@ at likelihood", place.name);
        NSLog(@"Current Place address %@", place.formattedAddress);
        NSLog(@"Current Place attributions %@", place.attributions);
        NSLog(@"Current PlaceID %@", place.placeID);
        self.coordinate = place.coordinate;
       
        if (!delegateSent) {
            
            if (self.delegate) {
                
                delegateSent =true;
                
                [self.delegate gpsLocationSuccessful:self.coordinate];
            }
            
        }
        
        
    }];
    
}






@end
