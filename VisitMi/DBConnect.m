//
//  DBConnect.m
//  VisitMi
//
//  Created by Samuel Gabriel on 02/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "DBConnect.h"

@implementation DBConnect
{
    
    NSString *country_Code;
    NSString *country_Name;
    NSString *country_Image;
    NSString *dialing_Code;
    NSString *int_type;
    NSString *state;
    NSString *number;
    NSString *stateCode;
    NSString *stateImage;
    NSMutableArray *myPlaces;
    NSString *dbstatus;
    NSString *dbmessage;
    NSString *firstname;
    NSString *lastname;
    NSString *email;
    NSString *session;
    AppDelegate *app;

}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        if([CheckInternet isInternetConnectionAvailable:@"http://api.visitmegh.com"])
        {
            app.serverAddress = @"http://api.visitmegh.com";

        }
        else
        {
            app.serverAddress = @"http://api.visitmegh.com";

        }
    
    }
    
    return self;
}

-(void)GetAppData
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/AppInfo.php",app.serverAddress];
    
    NSLog(@"%@",url);
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"DBKey=%@",app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
   
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 @try
                                 {
                                     
                                     self._downloadedData = [[NSMutableData alloc] init];
                                     
                                     // Append the newly downloaded data
                                     if (data!=NULL || (!error)) {
                                         
                                         [self._downloadedData appendData:data];
                                         
                                         // Parse the JSON that came in
                                         NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                         
                                         //Creating a PList file
                                         app.appData = [NSMutableDictionary
                                                        dictionaryWithDictionary:@{@"AboutUs":[jsonArray valueForKey:@"aboutUs"],
                                                                                   @"Terms":[jsonArray valueForKey:@"termsAndConditions"],
                                                                                   @"CallUs":[jsonArray valueForKey:@"customerCarePhone"],
                                                                                   @"Copyright":[jsonArray valueForKey:@"copyrightLabel"],
                                                                                   @"Version":[jsonArray valueForKey:@"version"],
                                                                                   @"GK":[jsonArray valueForKey:@"GK"],
                                                                                   @"UBK":[jsonArray valueForKey:@"UBK"],
                                                                                   @"FSCI":[jsonArray valueForKey:@"FSCI"],
                                                                                   @"FSCS":[jsonArray valueForKey:@"FSCS"],
                                                                                   @"ZK":[jsonArray valueForKey:@"ZK"],
                                                                                   @"SCK":[jsonArray valueForKey:@"SCK"]

                                                                                   }];
                                         
                                         
                                         
                                         app.googleServiceKey = app.appData[@"GK"];
                                         app.uberClientID = app.appData[@"UBK"];
                                         app.foursquareClientID = app.appData[@"FSCI"];
                                         app.foursquareClientSecret = app.appData[@"FSCS"];
                                         app.zomatoKey = app.appData[@"ZK"];
                                         app.skyScannerKey = app.appData[@"SCK"];

                                         [GMSServices provideAPIKey:app.googleServiceKey];
                                         [GMSPlacesClient provideAPIKey:app.googleServiceKey];
                                         
                                     }
                                     else exit(0);
                                     
                                 }
                                 @catch (NSException *exception)
                                 {
                                     
                                     exit(0);
                                     
                                 }
                                 
                                 


                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}

-(void)GetTour_Destinations:(NSString *)countryCode LocCode:(NSString *)locCode ForLoc:(BOOL)forLoc
{
   
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/TourDestinations.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"countryCode=%@&loc_code=%@&forLoc=%d&DBKey=%@",countryCode,locCode,forLoc,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *tour_dest = [jsonArray objectForKey:@"Tour_Destinations"];

                                     for (NSDictionary *items in tour_dest) {
                                         
                                         PlaceObject *PO = [[PlaceObject alloc]init];
                                        
                                         PO.name = [items valueForKey:@"name"];
                                         PO.address = [items valueForKey:@"address"];
                                         PO.desc = [items valueForKey:@"description"];
                                         PO.number = [items valueForKey:@"phone"];
                                         PO.state = [items valueForKey:@"loc_name"];
                                         PO.stateCode = [items valueForKey:@"loc_code"];
                                         PO.int_type = [items valueForKey:@"type"];
                                         PO.thumbnailUrl = [items valueForKey:@"thumbnailUrl"];
                                         PO.latitude = [[items valueForKey:@"latitude"] doubleValue];
                                         PO.longitude = [[items valueForKey:@"longitude"] doubleValue];
                                         
                                         if (self.delegate)
                                         {
                                             [self.delegate tour_DestDownloaded:PO];
                                             
                                         }
                                         
                                     }
                                     
                                     
                                     NSLog(@"TDS Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
   
    
}

-(void)GetTour_DestWithName:(NSString *)tourDestName CountryCode:(NSString *)countryCode Caller:(id)callingObject CallBack:(void (^)(id callingObject))callBack
{

    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/TourDestWithName.php",app.serverAddress];

    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"name=%@&countryCode=%@&DBKey=%@",tourDestName,countryCode,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *items = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]init];
                                     
                                     PO.name = [items valueForKey:@"name"];
                                     PO.address = [items valueForKey:@"address"];
                                     PO.desc = [items valueForKey:@"description"];
                                     PO.number = [items valueForKey:@"phone"];
                                     PO.state = [items valueForKey:@"loc_name"];
                                     PO.int_type = [items valueForKey:@"type"];
                                     PO.imageArr = [items valueForKey:@"images"];
                                     PO.latitude = [[items valueForKey:@"latitude"] doubleValue];
                                     PO.longitude = [[items valueForKey:@"longitude"] doubleValue];
                                     
                                     
                                     callBack(callingObject);


                                     if (self.delegate)
                                     {
                                         [self.delegate tour_DestWithNameDownloaded:PO];
                                         
                                     }
                                     
                                     

                                     NSLog(@"TDWN Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}



-(void)GetTour:(NSString *)countryCode LocCode:(NSString *)locCode ForLoc:(BOOL)forLoc
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/Tours.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"countryCode=%@&loc_code=%@&forLoc=%d&DBKey=%@",countryCode,locCode,forLoc,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *tours = [jsonArray objectForKey:@"Tours"];
                                     
                                     for (NSDictionary *tourObj in tours) {
                                         
                                         TourObject *TO = [[TourObject alloc]init];
                                         
                                         TO.activityID = [NSString stringWithFormat:@"%@", tourObj[@"tourID"]];
                                         TO.title = tourObj[@"title"];
                                         TO.latitude = [tourObj[@"lat"] doubleValue];
                                         TO.longitude = [tourObj[@"lng"] doubleValue];
                                         TO.stateCode = tourObj[@"loc_code"];
                                         TO.category = tourObj[@"category"];
                                         TO.duration = tourObj[@"duration"];
                                         TO.currencyCode = tourObj[@"currencyCode"];
                                         TO.priceRange = [tourObj[@"priceRange"] doubleValue];
                                         TO.highlights  = tourObj[@"highlights"];
                                         TO.thumbnailURL = tourObj[@"thumbnail"];
                                         

                                         if (self.delegate)
                                         {
                                             [self.delegate tourItemsDownloaded:TO :(int)tours.count];
                                         }
                                         
                                         
                                     }
                                     
                                     
                                     NSLog(@"TDS Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}




-(void)GetTourForLocation:(NSString *)countryCode Latitude:(CGFloat)lat Longitude:(CGFloat)lng MaxDistance:(CGFloat)maxDist
{
 
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/ToursForLocation.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"countryCode=%@&lat=%f&lng=%f&maxDistance=%f&DBKey=%@",countryCode,lat,lng,maxDist,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *tours = [jsonArray objectForKey:@"Tours"];
                                     
                                     for (NSDictionary *tourObj in tours) {
                                         
                                         TourObject *TO = [[TourObject alloc]init];
                                         
                                         TO.activityID = [NSString stringWithFormat:@"%@", tourObj[@"tourID"]];
                                         TO.title = tourObj[@"title"];
                                         TO.latitude = [tourObj[@"lat"] doubleValue];
                                         TO.longitude = [tourObj[@"lng"] doubleValue];
                                         TO.stateCode = tourObj[@"loc_code"];
                                         TO.category = tourObj[@"category"];
                                         TO.duration = tourObj[@"duration"];
                                         TO.currencyCode = tourObj[@"currencyCode"];
                                         TO.priceRange = [tourObj[@"priceRange"] doubleValue];
                                         TO.highlights  = tourObj[@"highlights"];
                                         TO.thumbnailURL = tourObj[@"thumbnail"];
                                         
                                         NSLog(@"Tour from db = %@",TO.title);

                                         if (self.delegate)
                                         {
                                             [self.delegate tourItemsDownloaded:TO :(int)tours.count];
                                         }
                                     
                                     
                                     }
                                     
                                     
                                     NSLog(@"TDS Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}

-(void)GetTourWithID:(NSString *)tourID CountryCode:(NSString *)countryCode
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/TourWithID.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"tourID=%@&countryCode=%@&DBKey=%@",tourID,countryCode,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *tourObj = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     TourObject *TO = [[TourObject alloc]init];
                                     
                                     TO.activityID = [NSString stringWithFormat:@"%@", tourObj[@"tourID"]];
                                     TO.desc = tourObj[@"description"];
                                     TO.title = tourObj[@"title"];
                                     TO.latitude = [tourObj[@"lat"] doubleValue];
                                     TO.longitude = [tourObj[@"lng"] doubleValue];
                                     TO.location = tourObj[@"location"];
                                     TO.stateCode = tourObj[@"loc_code"];
                                     TO.category = tourObj[@"category"];
                                     TO.duration = tourObj[@"duration"];
                                     TO.currencyCode = tourObj[@"currencyCode"];
                                     TO.priceRange = [tourObj[@"priceRange"] doubleValue];
                                     TO.startDate = tourObj[@"startDate"];
                                     TO.endDate = tourObj[@"endDate"];
                                     TO.knowBeforeBook = tourObj[@"knowBeforeYouBook"];
                                     TO.highlights  = tourObj[@"highlights"];
                                     TO.termsAndConditions = tourObj[@"termsAndConditions"];
                                     TO.highlights  = tourObj[@"highlights"];
                                     TO.imageARR = tourObj[@"images"];
                                     
                                     if (self.delegate)
                                     {
                                         [self.delegate tourItemsDownloadedWithId:TO];
                                     }
                                     
                                     NSLog(@"TDWD Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}

-(void)GetTourAvailabilities:(NSString *)tourID CountryCode:(NSString *)countryCode
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/TourAvailabilities.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"tourID=%@&countryCode=%@&DBKey=%@",tourID,countryCode,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *availabilities = [jsonArray objectForKey:@"TourAvailabilities"];
                                     
                                     for (NSDictionary *tourObj in availabilities) {
                                         
                                         TourObject *TO = [[TourObject alloc]init];
                                         
                                         TO.displayDate = tourObj[@"displayDate"];
                                         TO.valueDate = tourObj[@"valueDate"];
                                         
                                         if (self.delegate)
                                         {
                                             [self.delegate tourAvailDownloaded:TO];
                                         }
                                         
                                         
                                     }
                                     
                                     
                                     NSLog(@"TDS Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}


-(void)GetTourTickets:(NSString *)tourID CountryCode:(NSString *)countryCode
{
    
    
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/TourTickets.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"tourID=%@&countryCode=%@&DBKey=%@",tourID,countryCode,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *tickets = [jsonArray objectForKey:@"TourTickets"];
                                     
                                     for (NSDictionary *tourObj in tickets) {
                                         
                                         TourObject *TO = [[TourObject alloc]init];
                                         
                                         TO.ticketID = tourObj[@"ticketID"];
                                         TO.ticketType = tourObj[@"type"];
                                         TO.currencyCode = tourObj[@"currencyCode"];
                                         TO.ticketPrice = [tourObj[@"price"] doubleValue];
                                         
                                         if (self.delegate)
                                         {
                                             [self.delegate tourTicketsDownloaded:TO];
                                         }
                                         
                                         
                                     }
                                     
                                     
                                     NSLog(@"Tickets Json error = %@",error);
                                     
                                 }
                                 NSLog(@"Tickets error = %@",error);

                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}

-(void)GetStates:(NSString *)countryCode Type:(NSString *)type
{
    
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/States.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"countryCode=%@&type=%@&DBKey=%@",countryCode,type,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"%@",request.URL);

    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *locations = [jsonArray objectForKey:@"locations"];
                                     
                                     for (NSDictionary *items in locations) {
                                         
                                         stateCode = [items valueForKey:@"loc_code"];
                                         state = [items valueForKey:@"loc_name"];
                                         stateImage = [items valueForKey:@"image"];
                                         
                                         PlaceObject *PO = [[PlaceObject alloc]initWithState:state image:stateImage code:stateCode];

                                         if (self.delegate)
                                         {
                                             [self.delegate stateDownloaded:PO];
                                             
                                         }
                                      
                                     }

                                     NSLog(@"ST Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}

-(void)GetCountries
{
   
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/Countries.php",app.serverAddress];
    NSLog(@"%@",url);

    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"DBKey=%@",app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 @try
                                 {
                                     
                                     // Append the newly downloaded data
                                     if (data!=NULL || (!error)) {
                                         
                                         [self._downloadedData appendData:data];
                                         
                                         // Parse the JSON that came in
                                         NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                         
                                         NSDictionary *countries = [jsonArray objectForKey:@"Countries"];
                                         
                                         
                                         app.countries = [[NSMutableArray alloc]init];
                                         
                                         for (NSDictionary *country in countries) {
                                             
                                             
                                             country_Code = [country valueForKey:@"countryCode"];
                                             country_Name = [country valueForKey:@"countryName"];
                                             dialing_Code = [country valueForKey:@"dialingCode"];
                                             country_Image = [country valueForKey:@"countryImage"];
                                             
                                             PlaceObject *PO = [[PlaceObject alloc]initWithCountries:country_Code CountryName:country_Name DialingCode:dialing_Code CountryImage:country_Image];
                                             
                                             
                                             [app.countries addObject:PO];
                                             
                                             
                                         }
                                         
                                         
                                     }
                                     else
                                     {
                                         exit(0);

                                     }
                                     
                                     if (self.delegate)
                                     {
                                         [self.delegate countriesDownloaded];
                                     }

                                     
                                 }
                                 @catch (NSException *exception)
                                 {
                                     
                                     exit(0);
                                     
                                 }
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate countriesDownloaded];
        }

    }


    
}

-(void)GetInterestTypes:(NSString *)countryCode LocCode:(NSString *)locCode ForLoc:(BOOL)forLoc
{
    
    
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/InterestType.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"countryCode=%@&loc_code=%@&forLoc=%d&DBKey=%@",countryCode,locCode,forLoc,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *tour_dest = [jsonArray objectForKey:@"InterestTypes"];
                                     
                                     
                                     for (NSDictionary *items in tour_dest) {
                                         
                                         
                                         int_type= [items valueForKey:@"type"];
                                         
                                         if (self.delegate)
                                         {
                                             
                                             [self.delegate tour_DestIntTypeDownloaded:int_type];
                                             
                                         }
                                         
                                         
                                     }
                                     
                                     
                                     NSLog(@"INT Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}

-(void)GetHotels:(NSString *)countryCode Latitude:(CGFloat)lat Longitude:(CGFloat)lng MaxDistance:(CGFloat)maxDist
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/Hotels.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"countryCode=%@&lat=%f&lng=%f&maxDistance=%f&DBKey=%@",countryCode,lat,lng,maxDist,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *hotels = [jsonArray objectForKey:@"Hotels"];
                                     NSLog(@"Hotels count %d",(int)hotels.count);
                                     
                                    if(hotels.count > 0)
                                    {
                                        for (NSDictionary *hotelinfo in hotels) {
                                            
                                            HotelObject *HO = [[HotelObject alloc]init];
                                            
                                            
                                            HO.hotelTotal = (int)hotels.count;
                                            HO.hotelID = hotelinfo[@"hotelId"]?hotelinfo[@"hotelId"]:NULL;
                                            HO.name = hotelinfo[@"name"]?hotelinfo[@"name"]:NULL;
                                            
                                            HO.state = hotelinfo[@"loc_name"]?hotelinfo[@"loc_name"]:NULL;
                                            HO.city = hotelinfo[@"city"]?hotelinfo[@"city"]:NULL;
                                            HO.streetAddress = hotelinfo[@"address"]?hotelinfo[@"address"]:NULL;
                                            HO.latitude = [hotelinfo[@"latitude"] doubleValue ]?[ hotelinfo[@"latitude" ] doubleValue]:0;
                                            HO.longitude = [hotelinfo[@"longitude" ] doubleValue]?[hotelinfo[@"longitude" ] doubleValue]:0;
                                            HO.lowRate = [hotelinfo[@"lowRate"] doubleValue]?[hotelinfo[@"lowRate"] doubleValue]:0;
                                            HO.rateCurrencyCode = hotelinfo[@"rateCurrencyCode"]?hotelinfo[@"rateCurrencyCode"]:NULL;
                                            HO.starRating = hotelinfo[@"hotelStarRating"]?hotelinfo[@"hotelStarRating"]:NULL;
                                            HO.thumbnailURL = hotelinfo[@"thumbnailURL"]?hotelinfo[@"thumbnailURL"]:NULL;
                                            HO.detailURL = hotelinfo[@"deepLinkUrl"]?hotelinfo[@"deepLinkUrl"]:NULL;
                                            
                                            CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
                                            
                                            CLLocation *destLocation = [[CLLocation alloc]initWithLatitude:HO.latitude  longitude:HO.longitude];
                                            
                                            HO.distance = [destLocation distanceFromLocation:location];
                                            
                                            int distance = floorf(HO.distance/1000);
                                            
                                            if (distance < 1) {
                                                
                                                HO.place_distance = [NSString stringWithFormat:@"%d m",(int)HO.distance];
                                            }
                                            
                                            
                                            else
                                            {
                                                HO.place_distance = [NSString stringWithFormat:@"%.2f km",HO.distance/1000];
                                            }
                                            
                                            
                                            if (self.delegate)
                                            {
                                                
                                                [self.delegate hotelItemsDownloaded:HO :HO.hotelTotal];
                                            }
                                            
                                            
                                            
                                        }

                                    }
                                     
                                     NSLog(@"TDS Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}



-(void)GetBookingsForUser:(NSString *)useremail
{
    NSLog(@"Bookings Download initiated");

    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (useremail == NULL) {
        
        app.userBookings = [[NSMutableArray alloc]init];
        app.bookingUpdated = false;

        return;
    }
    
    
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/Bookings.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"email=%@&sessionID=%@&DBKey=%@",useremail,app.userDetails[@"SessionID"],app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    

    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     NSDictionary *bookings = [jsonArray objectForKey:@"Bookings"];
                                     [app.userBookings  removeAllObjects];
                                     app.userBookings = [[NSMutableArray alloc]init];

                                     
                                     for (NSDictionary *bookingObj in bookings) {
                                         
                                         BookingObject *BO = [[BookingObject alloc]init];
                                         
                                         if (bookingObj[@"bookingID"]) {
                                             
                                             BO.bookingID = bookingObj[@"bookingID"];
                                             BO.passID = bookingObj[@"passID"];
                                             BO.bookingTitle = bookingObj[@"bookingTitle"];
                                             BO.bookingType = bookingObj[@"type"];
                                             BO.bookingStatus = bookingObj[@"status"];
                                             BO.bookingDate = bookingObj[@"bookingDate"];
                                             BO.currencyCode = bookingObj[@"currencyCode"];
                                             BO.price = [bookingObj[@"price"] doubleValue];
                                             if ([BO.bookingStatus isEqualToString:@"Active"]) {
                                                 
                                                 BO.bookingStatusColor = [UIColor colorWithRed:.4 green:.7 blue:.4 alpha:.8];
                                             }
                                             else if ([BO.bookingStatus isEqualToString:@"Completed"])
                                             {
                                                 BO.bookingStatusColor = [UINavigationBar appearance].tintColor;
                                             }
                                             else
                                             {
                                                 BO.bookingStatusColor = [UIColor darkGrayColor];
                                             }
                                             

                                         }
                                         
                                         if (self.delegate)
                                         {
                                             [self.delegate bookingsDownloaded:BO];
                                         }
                                         
                                         [app.userBookings addObject:BO];

                                     }
                                     app.bookingUpdated = true;

                                     
                                     NSLog(@"Bookings Json error = %@",error);
                                     
                                 }
                                 NSLog(@"Bookings error = %@",error);
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}

-(void)GetBookingsWithID:(NSString *)bookingID Type:(NSString *)type
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/BookingWithID.php",app.serverAddress];

    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"bookingID=%@&type=%@&sessionID=%@&DBKey=%@",bookingID,type,app.userDetails[@"SessionID"],app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *bookingObj = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     BookingObject *BO = [[BookingObject alloc]init];
                                     
                                     if (bookingObj[@"bookingID"]) {
                                         
                                         BO.bookingID = bookingObj[@"bookingID"];
                                         BO.passID = bookingObj[@"passID"];
                                         BO.bookingTitle = bookingObj[@"title"];
                                         BO.bookingType = bookingObj[@"type"];
                                         BO.bookingDate = bookingObj[@"bookingDate"];
                                         BO.bookingStatus = bookingObj[@"status"];
                                         BO.currencyCode = bookingObj[@"currencyCode"];
                                         BO.price = [bookingObj[@"price"] doubleValue];
                                         BO.tourID = bookingObj[@"tourID"];
                                         BO.tourImgUrl = bookingObj[@"tourImgUrl"];
                                         BO.tourDetails = bookingObj[@"tourDetails"];
                                         BO.tourDate = bookingObj[@"tourDate"];
                                         BO.latitude = [bookingObj[@"latitude"] doubleValue];
                                         BO.longitude = [bookingObj[@"longitude"] doubleValue];
                                         BO.tourCountryCode = bookingObj[@"countryCode"];
                                         if ([BO.bookingStatus isEqualToString:@"Active"]) {
                                             
                                             BO.bookingStatusColor = [UIColor colorWithRed:.4 green:.7 blue:.4 alpha:.8];
                                         }
                                         else if ([BO.bookingStatus isEqualToString:@"Completed"])
                                         {
                                             BO.bookingStatusColor = [UINavigationBar appearance].tintColor;
                                         }
                                         else
                                         {
                                             BO.bookingStatusColor = [UIColor darkGrayColor];
                                         }
                                         
                                         BO.payment = (BOOL)[bookingObj[@"payment"] intValue];
                                         NSLog(@"Payment %@",bookingObj[@"payment"]);
                                         

                                     }
                                     
                                     if (self.delegate)
                                     {
                                         [self.delegate bookingsDownloaded:BO];
                                     }
                                     
                                     NSLog(@"Bookings Json error = %@",error);
                                     
                                 }
                                 NSLog(@"Bookings error = %@",error);
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}



-(void)RegisterUser:(NSString *)fname SecondName:(NSString *)lname Email:(NSString *)useremail PhoneNumber:(NSString *)phone Password:(NSString *)password CountryCode:(NSString *)countryCode
{
    
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/RegisterUser.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"firstname=%@&lastname=%@&email=%@&phonenumber=%@&password=%@&countryCode=%@&DBKey=%@",fname,lname,useremail,[phone stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"],password,countryCode,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     NSLog(@"Json data = %@",jsonArray);
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];

                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     
                                     if (self.delegate)
                                     {
                                         
                                         [self.delegate dbConnResponse:PO];
                                         
                                     }
                                     
                                     
                                     
                                     
                                     NSLog(@"REGUS Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}

-(void)LoginUser:(NSString *)useremail Password:(NSString *)password
{
    
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *sessionID = [NSString stringWithFormat:@"%C%C%@",[[useremail uppercaseString] characterAtIndex:0],[[useremail uppercaseString] characterAtIndex:1],[self getRandomPINString:6]];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/LoginUser.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"email=%@&password=%@&sessionID=%@&DBKey=%@",useremail,password,sessionID,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     NSLog(@"Json data = %@",jsonArray);
                                     
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];
                                     
                                     
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                    
                                     if ([dbstatus isEqualToString:@"success"])
                                     {
                                         firstname = jsonArray[@"firstname"];
                                         lastname = jsonArray[@"lastname"];
                                         email = jsonArray[@"email"];
                                         number = jsonArray[@"phonenumber"];
                                         country_Code = jsonArray[@"countryCode"];
                                         session = jsonArray[@"sessionID"];

                                         NSString *fullname = [NSString stringWithFormat:@"%@ %@",firstname,lastname];
                                         
                                         //Creating a PList file
                                         NSMutableDictionary *details = [NSMutableDictionary
                                                                         dictionaryWithDictionary:@{@"Name":fullname,
                                                                                                    @"FirstName":firstname,
                                                                                                    @"LastName":lastname,
                                                                                                    @"Email":email,
                                                                                                    @"CountryCode":country_Code,
                                                                                                    @"SessionID":session,
                                                                                                    @"Phone":number}];
                                         
                                         //get directory from app
                                         NSFileManager *fileManager = [NSFileManager defaultManager];
                                         NSString *fileName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.plist"];
                                         NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"];
                                         
                                         //check if File directoory has been created
                                         BOOL isDirectory;
                                         if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDirectory] || !isDirectory)
                                         {
                                             NSError *error = nil;
                                             NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                                                              forKey:NSFileProtectionKey];
                                             //create file directory if not already created
                                             [fileManager createDirectoryAtPath:fileDir
                                                    withIntermediateDirectories:YES
                                                                     attributes:attr
                                                                          error:&error];
                                             if (error)
                                                 NSLog(@"Error creating directory path: %@", [error localizedDescription]);
                                         }
                                         //specify file path
                                         NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
                                         //write file to path
                                         [details writeToFile:filePath atomically:YES];
                                         
                                         BOOL fileExist =  [fileManager fileExistsAtPath:filePath];
                                         if (fileExist)
                                         {
                                             app.userDetails = [NSDictionary dictionaryWithContentsOfFile:filePath];
                                             
                                         }
                                         
                                         //get Image from storage
                                         NSString *imageName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.png"];
                                         
                                         NSString *imagePath = [fileDir stringByAppendingPathComponent:imageName];
                                         
                                         BOOL imageExist =  [fileManager fileExistsAtPath:imagePath];
                                         if (imageExist)
                                         {
                                             app.userImage = [NSData dataWithContentsOfFile:imagePath];

                                         }
                                         
                                     }
                                     
                                     
                                     //Continue from saving login to File
                                     if (self.delegate)
                                     {
                                         
                                         [self.delegate dbConnResponse:PO];
                                         
                                     }
                                     
                                     
                                     NSLog(@"Login Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}

-(void)VerifyUser:(NSString *)useremail Session:(NSString *)sessionID CallBack:(void (^)(id))callBack
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/VerifyUser.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"email=%@&sessionID=%@&DBKey=%@",useremail,sessionID,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 PlaceObject *PO;
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     NSLog(@"Json data = %@",jsonArray);
                                     
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];
                                     
                                     
                                     
                                     PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     
                                     NSLog(@"Login Json error = %@",error);
                                     
                                 }
                                 
                                 
                                 callBack(PO);

                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}

-(void)LogOutUser :(NSString *)useremail SessionID:(NSString *)sessionID
{
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/LogoutUser.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"email=%@&sessionID=%@&DBKey=%@",useremail,sessionID,app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     NSLog(@"Json data = %@",jsonArray);
                                     
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     
                                     //Deleting PList file
                                     NSFileManager *fileManager = [NSFileManager defaultManager];
                                     NSString *fileName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.plist"];
                                     NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"];
                                     NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
                                     
                                     if ([fileManager fileExistsAtPath:filePath])
                                     {
                                         NSError *error = nil;
                                         [fileManager removeItemAtPath:filePath error:&error];
                                         
                                         app.userDetails = NULL;
                                         app.userImage = NULL;
                                         app.bookingData = NULL;
                                         [app.userBookings removeAllObjects];
                                     }
                                     
                                     //Continue from saving login to File
                                     if (self.delegate)
                                     {
                                         [self.delegate dbConnResponse:PO];
                                         
                                     }
                                     
                                     
                                     NSLog(@"Login Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}


-(void)UpdateUser:(NSString *)fname SecondName:(NSString *)lname Email:(NSString *)useremail PhoneNumber:(NSString *)phone NewPassword:(NSString *)newPassword CountryCode:(NSString *)countryCode CurrentPassword:(NSString *)currentPassword
{
    
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/UpdateUser.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"firstname=%@&lastname=%@&email=%@&phonenumber=%@&password=%@&currentPassword=%@&countryCode=%@&sessionID=%@&DBKey=%@",fname,lname,useremail,[phone stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"],newPassword,currentPassword,countryCode,app.userDetails[@"SessionID"],app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     NSLog(@"Json data = %@",jsonArray);
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];
                                     
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     
                                     if ([dbstatus isEqualToString:@"success"])
                                     {
                                         
                                         [self LogOutUser:useremail SessionID:app.userDetails[@"SessionID"]];
                                         
                                     }
                                     else
                                     {
                                         if (self.delegate)
                                         {
                                             
                                             [self.delegate dbConnResponse:PO];
                                             
                                         }
                                         

                                     }
                                     
                                     
                                     NSLog(@"REGUS Json error = %@",error);
                                     
                                 }
                                 else
                                 {
                                     dbstatus = @"error";
                                     dbmessage = @"failed to get response from server";
                                     
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     if (self.delegate)
                                     {
                                         
                                         [self.delegate dbConnResponse:PO];
                                         
                                     }
                                     

                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}


-(void)insertTourBooking:(NSString *)useremail TourID:(NSString *)tourID TourTitle:(NSString *)tourTitle CurrencyCode:(NSString *)currencyCode Price:(CGFloat)price ValueDate:(NSString *)valueDate TourDetails:(NSString *)tourDetails

{
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    NSString *bookingID = [NSString stringWithFormat:@"%C%C%@",[[useremail uppercaseString] characterAtIndex:0],[[useremail uppercaseString] characterAtIndex:1],[self getRandomPINString:6]];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/InsertTourBooking.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"bookingID=%@&tourID=%@&bookingTitle=%@&email=%@&currencyCode=%@&price=%f&valueDate=%@&tourDetails=%@&sessionID=%@&DBKey=%@",bookingID,tourID,tourTitle,useremail,currencyCode,price,valueDate,tourDetails,app.userDetails[@"SessionID"],app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     NSLog(@"Json data = %@",jsonArray);
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];
                                     
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     //So that app would reload User bookings from database
                                     app.bookingUpdated = false;

                                     if (self.delegate)
                                     {

                                         [self.delegate dbConnResponse:PO];
                                         
                                     }
                                     
                                     
                                     
                                     
                                     NSLog(@"BOOK Json error = %@",error);
                                     
                                 }
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
   
    
}

-(void)cancelBookingsWithID:(NSString *)bookingID
{
 
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Download the json file
    NSString *url = [[NSString alloc]initWithFormat:@"%@/VisitMi/app/CancelBooking.php",app.serverAddress];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:jsonFileUrl];
    NSString *postString = [[NSString alloc]initWithFormat:@"bookingID=%@&sessionID=%@&DBKey=%@",bookingID,app.userDetails[@"SessionID"],app.infoDict[@"DBKey"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        
        //Fetch Tour Destinations from Database
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 if (data!=NULL || (!error)) {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     dbstatus = jsonArray[@"status"];
                                     dbmessage = jsonArray[@"message"];
                                     
                                     PlaceObject *PO = [[PlaceObject alloc]initWithDbResponse:dbstatus Message:dbmessage];
                                     
                                     //So that app would reload User bookings from database
                                     app.bookingUpdated = false;
                                     

                                    
                                     if (self.delegate)
                                     {
                                         [self.delegate dbConnResponse:PO];
                                     }
                                     
                                     NSLog(@"Bookings Json error = %@",error);
                                     
                                 }
                                 NSLog(@"Bookings error = %@",error);
                                 
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
}

-(NSString *)getRandomPINString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}

@end
