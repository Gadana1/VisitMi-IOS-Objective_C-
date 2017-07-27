//
//  FlightObject.m
//  VisitMi
//
//  Created by Samuel Gabriel on 13/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "FlightObject.h"

@implementation FlightObject

AppDelegate *app;

-(void)getAutoCompleteForQuery:(NSString *)query CountryCode:(NSString *)countryCode
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"http://partners.api.skyscanner.net/apiservices/autosuggest/v1.0/%@/%@/%@?query=%@&piKey=%@",countryCode,@"USD",@"en-US",query,[app.skyScannerKey substringWithRange:NSMakeRange(0, 16)]];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 @try
                                 {
                                     
                                     self._downloadedData = [[NSMutableData alloc] init];
                                     
                                     // Append the newly downloaded data
                                     if (data!=NULL || (!error)) {
                                         
                                         [self._downloadedData appendData:data];
                                         
                                         // Parse the JSON that came in
                                         NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];

                                         NSArray *placesArr = [jsonArray objectForKey:@"Places"];
                                         
                                         for (NSDictionary *places in placesArr) {
                                             
                                             FlightObject *FOB = [FlightObject new];
                                             FOB.placeID = places[@"PlaceId"];
                                             FOB.placeName = places[@"PlaceName"];
                                             FOB.cityID = places[@"CityId"];
                                             FOB.country = places[@"CountryName"];
                                             FOB.countryID = places[@"CountryId"];
                                             
                                             
                                             if (self.delegate) {
                                                 
                                                 [self.delegate autoCompleteDownloaded:FOB IsDone:places==placesArr.lastObject?YES:NO];
                                             }
                                         }
                                         
                                     }
                                     
                                 }
                                 @catch (NSException *exception)
                                 {
                                     
                                     return;
                                     
                                 }
                                 
                                 
                                 
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
}

@end
