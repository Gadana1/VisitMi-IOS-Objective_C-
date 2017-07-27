//
//  ShoppingObject.m
//  VisitMi
//
//  Created by Samuel Gabriel on 02/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "ShoppingObject.h"

@implementation ShoppingObject

int count;

/*
 Google
 */

//Download items
- (void)downloadItems:(CGFloat)longitude latitude:(CGFloat)latitude
{
    _loc_longitude = longitude;
    _loc_latitude = latitude;
    NSLog(@"Starting download shopping");

    count = 0;
    
    _type = @"shopping_mall" ;
    
    NSString *url = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankby=distance&type=%@&key=AIzaSyBcKHpoJ8DjJzuMgyoyAVdiFuVWqDge8AQ",_loc_latitude,_loc_longitude,_type];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 // Initialize the data object
                
                                 if (data!=NULL && (!error))
                                 {

                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                     
                                     if ([jsonArray valueForKey:@"next_page_token"])
                                     {
                                         _next_token = jsonArray[@"next_page_token"];
                                         
                                     }
                                     else _next_token=NULL;
                                     
                                     //Get number of downloaded results
                                     NSDictionary *results = [jsonArray valueForKey:@"results"];
                                     
                                     count += (int)results.count;
                                     NSLog(@"count %d",count);

                                     if (results.count >0)
                                     {
                                         for (NSDictionary *data in results)
                                         {
                                             [self loadItems:data :count];
                                             
                                         }
                                         
                                         if (_next_token!=NULL)
                                         {
                                             [self downloadItemsWithNextPageToken:_next_token];
                                         }
                                         
                                     }
                                     else
                                     {
                                         NSLog(@"Nothing created");
                                     }
                                     
                                     
                                     
                                 }
                                 else
                                 {
                                     NSLog(@"Error Details %@",error.description);
                                 }
                             }];
        // 3
        [self.downloadTask resume];
        
        if (!_doneForeSquare)
        {
            _doneForeSquare = true;
            [self downloadItemsForeSquare:longitude latitude:latitude];
            
        }
        
    }
    
}


//Parse items
-(void)loadItems :(NSDictionary *)nearByData :(int)count
{
    NSDictionary *location;
    NSDictionary *geometry;
    NSDictionary *opening_hours;
    NSDictionary *photos;
    
    ShoppingObject *SHOP = [[ShoppingObject alloc]init];
    SHOP.name = nearByData[@"name"];
    SHOP.icon_url = nearByData[@"icon"];
    SHOP.place_id = nearByData[@"place_id"];
    SHOP.address = nearByData[@"vicinity"];
    SHOP.api_Type = @"G";

    if([nearByData valueForKey:@"geometry"])
    {
        geometry = [nearByData valueForKey:@"geometry"];
        if([geometry valueForKey:@"location"])
        {
            location = [geometry valueForKey:@"location"];
            SHOP.latitude =[ location[@"lat"] doubleValue ];
            SHOP.longitude =[ location[@"lng" ] doubleValue];
        }
    }
    if([nearByData valueForKey:@"opening_hours"])
    {
        opening_hours = [nearByData valueForKey:@"opening_hours"];
        SHOP.open_now = (BOOL)opening_hours[@"open_now"];
        
    }
    
    if([nearByData valueForKey:@"photos"])
    {
        photos = [nearByData valueForKey:@"photos"];
        for (NSDictionary *photo in photos) {
            SHOP.photoReference = photo[@"photo_reference"];
        }
    }
    if([nearByData valueForKey:@"types"])
    {
        SHOP.types = [nearByData valueForKey:@"types"];
        SHOP.Dine_type = [SHOP.types firstObject];
        
    }
    SHOP.provider_icon = [UIImage imageNamed:@"google.png"];
    
    SHOP.location = [[CLLocation alloc]initWithLatitude:_loc_latitude longitude:_loc_longitude];
    
    SHOP.destLocation = [[CLLocation alloc]initWithLatitude:SHOP.latitude  longitude:SHOP.longitude];
    
    SHOP.distance = [SHOP.destLocation distanceFromLocation:SHOP.location];
    
    
    int distance = floorf(SHOP.distance/1000);
    
    if (distance < 1) {
        
        SHOP.place_distance = [NSString stringWithFormat:@"%d m",(int)SHOP.distance];
    }
    
    else
    {
        SHOP.place_distance = [NSString stringWithFormat:@"%.2f km",SHOP.distance/1000];
    }
    
    
    if (self.delegate)
    {
        [self.delegate shoppingDownloaded:SHOP :count];
    }
    
}

//download more items
- (void)downloadItemsWithNextPageToken:(NSString *)token
{
    NSString *url = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=%@&key=AIzaSyBcKHpoJ8DjJzuMgyoyAVdiFuVWqDge8AQ",token];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];

    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                     
                                     if ([jsonArray valueForKey:@"next_page_token"])
                                     {
                                         _next_token = jsonArray[@"next_page_token"];
                                         
                                     }
                                     else _next_token=NULL;
                                     
                                     
                                     //Get number of downloaded results
                                     NSDictionary *results = [jsonArray valueForKey:@"results"];
                                     
                                     count += (int)results.count;

                                     if (results.count >0)
                                     {
                                         for (NSDictionary *data in results)
                                         {
                                             [self loadItems:data :count];
                                             
                                         }
                                         
                                         if (_next_token!=NULL)
                                         {
                                             
                                             [self downloadItemsWithNextPageToken:_next_token];
                                         }
                                     }
                                     else
                                     {
                                         NSLog(@"Nothing created");
                                     }
                                 }
                                 else
                                 {
                                     NSLog(@"Error Details %@",error.description);
                                 }
                             }];
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}


/*
 ForeSquare
 */

//Download items
-(void)downloadItemsForeSquare:(CGFloat)longitude latitude:(CGFloat)latitude
{
    NSString *shopCatID =@"4d4b7105d754a06378d81259";
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *formattedAdd = [_state stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"%@,+%@",formattedAdd,_country];
    
    NSString *url;
    
    if (_state!=NULL)
    {
        url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/search?near=%@&limit=100&categoryId=%@&client_id=%@&client_secret=%@&v=20160626",urlAddress,shopCatID,app.foursquareClientID,app.foursquareClientSecret];
        
    }
    else
    {
        url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=100&categoryId=%@&client_id=%@&client_secret=%@&v=20160626",latitude,longitude,shopCatID,app.foursquareClientID,app.foursquareClientSecret];
        
    }
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    
    if([ CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 
                                 // 4: Handle response here
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     
                                     
                                     // Parse the JSON that came in
                                     
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                     
                                     //NSLog(@"JSON Details %@",jsonArray);
                                     
                                     //Get number of downloaded results
                                     NSDictionary *response = [jsonArray valueForKey:@"response"];
                                     NSDictionary *venues = [response valueForKey:@"venues"];
                                     
                                     count += (int)venues.count;
                                     
                                     if (venues.count >0)
                                     {
                                         
                                         for (NSDictionary *data in venues)
                                         {
                                             
                                             [self loadItemsForeSquare:data :count];
                                             
                                         }
                                         
                                         
                                     }
                                     
                                     else
                                     {
                                         NSLog(@"Nothing created");
                                     }
                                     
                                 }
                                 
                                 else
                                 {
                                     NSLog(@"Error Details %@",error.description);
                                 }
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}


-(void)loadItemsForeSquare :(NSDictionary *)nearByData :(int)count
{
    
    NSDictionary *location;
    NSDictionary *contact;
    NSDictionary *categories;
    
    ShoppingObject *SHOP = [[ShoppingObject alloc]init];
    
    SHOP.name = nearByData[@"name"];
    SHOP.icon_url = nearByData[@"icon"];
    SHOP.place_id = nearByData[@"id"];
    SHOP.delegate = self.delegate;
    SHOP.api_Type = @"FS";

    if([nearByData valueForKey:@"contact"])
    {
        contact = [nearByData valueForKey:@"contact"];
        
        SHOP.phone = contact[@"phone"];
        
    }
    
    if([nearByData valueForKey:@"location"])
    {
        location = [nearByData valueForKey:@"location"];
        
        SHOP.latitude =[ location[@"lat"] doubleValue ];
        SHOP.longitude =[ location[@"lng" ] doubleValue];
        SHOP.formattedAddress = location[@"formattedAddress"];
        SHOP.address = [[NSMutableString alloc]initWithString:@""];
        
        for (NSString *add in SHOP.formattedAddress) {
            [SHOP.address appendString:add];
            [SHOP.address appendString:@". "];
            
        }
        if (SHOP.address==NULL) {
            SHOP.address = location[@"address"];
        }
        
    }
    if([nearByData valueForKey:@"categories"])
    {
        
        categories = [nearByData valueForKey:@"categories"];
        
        SHOP.types = [[NSMutableArray alloc]init];
        
        for(NSDictionary *category in categories)
        {
            [SHOP.types addObject:category];
            
            
        }
        
        
        NSDictionary *category = (NSDictionary *)[SHOP.types firstObject];
        
        SHOP.Dine_type = category[@"name"];
        
        
    }
    
    SHOP.location = [[CLLocation alloc]initWithLatitude:_loc_latitude longitude:_loc_longitude];
    
    SHOP.destLocation = [[CLLocation alloc]initWithLatitude:SHOP.latitude  longitude:SHOP.longitude];
    
    SHOP.distance = [SHOP.destLocation distanceFromLocation:SHOP.location];
    
    
    
    int distance = floorf(SHOP.distance/1000);
    
    if (distance < 1) {
        
        SHOP.place_distance = [NSString stringWithFormat:@"%d m",(int)SHOP.distance];
    }
    
    else
    {
        SHOP.place_distance = [NSString stringWithFormat:@"%.2f km",SHOP.distance/1000];
    }
    
    
    SHOP.provider_icon = [UIImage imageNamed:@"Foursquare.png"];
    
    if (self.delegate)
    {
        [self.delegate  shoppingDownloaded:SHOP :count];
    }
    
    
}


- (void)downloadItemsForeSquareWithId:(NSString *)venueID
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
    NSString *url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@&v=20160626",venueID,app.foursquareClientID,app.foursquareClientSecret];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 
                                 // 4: Handle response here
                                 NSLog(@"Response Details %@",response);
                                 
                                 int count = 0;
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                     
                                     // NSLog(@"JSON Details %@",jsonArray);
                                     
                                     //Get number of downloaded results
                                     NSDictionary *response = [jsonArray valueForKey:@"response"];
                                     NSDictionary *venue = [response valueForKey:@"venue"];
                                     
                                     count = (int)venue.count;
                                     
                                     
                                     if (count >0)
                                     {
                                         
                                         [self loadItemsForeSquareWithId:venue :count];
                                         
                                         
                                     }
                                     
                                     else
                                     {
                                         NSLog(@"Nothing created");
                                     }
                                     
                                 }
                                 
                                 else
                                 {
                                     NSLog(@"Error Details %@",error.description);
                                 }
                                 
                             }];
        
        // 3
        [self.downloadTask resume];
        
        
    }
    
    
    
}

-(void)loadItemsForeSquareWithId :(NSDictionary *)nearByData :(int)count
{
    
    
    self.canonicalURL = nearByData[@"canonicalUrl"];
    
    if (self.delegate)
    {
        NSLog(@"Sending item to controller");
        [self.delegate  shoppingWithIdDownloaded:self];
    }
    
    
}



@end
