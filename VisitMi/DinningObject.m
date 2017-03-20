//
//  DinningObject.m
//  VisitMi
//
//  Created by Samuel Gabriel on 10/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "DinningObject.h"

@implementation DinningObject

int count;


/*
 Google
 */

//Download items
- (void)downloadItems:(CGFloat)longitude latitude:(CGFloat)latitude
{
    _loc_longitude = longitude;
    _loc_latitude = latitude;
    
    count = 0;
    
    _type = @"restaurant" ;
    
    NSString *url = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankby=distance&type=%@&key=AIzaSyBcKHpoJ8DjJzuMgyoyAVdiFuVWqDge8AQ",_loc_latitude,_loc_longitude,_type];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 // Initialize the data object
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 // Append the newly downloaded data

                                 if (data!=NULL && (!error))
                                 {
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
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
        
        if (!_doneForeSquare)
        {
            _doneForeSquare = true;
            [self downloadItemsForeSquare:longitude latitude:latitude];
            
        }
        if (!_doneZomato)
        {
            _doneZomato = true;
            [self downloadItemsZomato:longitude latitude:latitude];
            
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
    
    DinningObject *DO = [[DinningObject alloc]init];
    DO.name = nearByData[@"name"];
    DO.icon_url = nearByData[@"icon"];
    DO.place_id = nearByData[@"place_id"];
    DO.address = nearByData[@"vicinity"];

    if([nearByData valueForKey:@"geometry"])
    {
        geometry = [nearByData valueForKey:@"geometry"];
        if([geometry valueForKey:@"location"])
        {
            location = [geometry valueForKey:@"location"];
            DO.latitude =[ location[@"lat"] doubleValue ];
            DO.longitude =[ location[@"lng" ] doubleValue];
        }
    }
    if([nearByData valueForKey:@"opening_hours"])
    {
        opening_hours = [nearByData valueForKey:@"opening_hours"];
        DO.open_now = opening_hours[@"open_now"];

    }
    
    if([nearByData valueForKey:@"photos"])
    {
        photos = [nearByData valueForKey:@"photos"];
        for (NSDictionary *photo in photos) {
            DO.photoReference = photo[@"photo_reference"];
        }
    }
    if([nearByData valueForKey:@"types"])
    {
        DO.types = [nearByData valueForKey:@"types"];
        DO.Dine_type = [DO.types firstObject];

    }
    DO.provider_icon = [UIImage imageNamed:@"google.png"];

    DO.location = [[CLLocation alloc]initWithLatitude:_loc_latitude longitude:_loc_longitude];

    DO.destLocation = [[CLLocation alloc]initWithLatitude:DO.latitude  longitude:DO.longitude];
    
    DO.distance = [DO.destLocation distanceFromLocation:DO.location];
    
    
    int distance = floorf(DO.distance/1000);
    
    if (distance < 1) {
        
        DO.place_distance = [NSString stringWithFormat:@"%d m",(int)DO.distance];
    }
    
    else
    {
        DO.place_distance = [NSString stringWithFormat:@"%.2f km",DO.distance/1000];
    }
    
  
    if (self.delegate)
    {
        [self.delegate DinnigsDownloaded:DO :count];
    }
    
}

//download more items
- (void)downloadItemsWithNextPageToken:(NSString *)token
{
    NSString *url = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=%@&key=AIzaSyBcKHpoJ8DjJzuMgyoyAVdiFuVWqDge8AQ",token];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 // 4: Handle response here
                                 
                                 // Initialize the data object
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 // Append the newly downloaded data

                                 if (data!=NULL && (!error))
                                 {
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                                                          
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
    NSString *resturantCatID =@"4d4b7105d754a06374d81259";
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
 
    NSString *formattedAdd = [_state stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"%@,+%@",formattedAdd,_country];
    
    NSString *url;
    
    if (_state!=NULL)
    {
        url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/search?near=%@&limit=100&categoryId=%@&client_id=%@&client_secret=%@&v=20160626",urlAddress,resturantCatID,app.foursquareClientID,app.foursquareClientSecret];

    }
    else
    {
        url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=100&categoryId=%@&client_id=%@&client_secret=%@&v=20160626",latitude,longitude,resturantCatID,app.foursquareClientID,app.foursquareClientSecret];

    }
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    
    if([ CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 
                                 // 4: Handle response here
                                 
                                 // Initialize the data object
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     
                                     // Parse the JSON that came in
                                     
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
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

    DinningObject *DO = [[DinningObject alloc]init];
    
    DO.name = nearByData[@"name"];
    DO.icon_url = nearByData[@"icon"];
    DO.place_id = nearByData[@"id"];
    DO.delegate = self.delegate;
    
    if([nearByData valueForKey:@"contact"])
    {
        contact = [nearByData valueForKey:@"contact"];
        
        DO.phone = contact[@"phone"];
        
    }
    
    if([nearByData valueForKey:@"location"])
    {
        location = [nearByData valueForKey:@"location"];
        
        DO.latitude =[ location[@"lat"] doubleValue ];
        DO.longitude =[ location[@"lng" ] doubleValue];
        DO.formattedAddress = location[@"formattedAddress"];
        DO.address = [[NSMutableString alloc]initWithString:@""];
        
        for (NSString *add in DO.formattedAddress) {
            [DO.address appendString:add];
            [DO.address appendString:@". "];
            
        }
        if (DO.address==NULL) {
            DO.address = location[@"address"];
        }
        
    }
    if([nearByData valueForKey:@"categories"])
    {
        
        categories = [nearByData valueForKey:@"categories"];
        
        DO.types = [[NSMutableArray alloc]init];
        
        for(NSDictionary *category in categories)
        {
            [DO.types addObject:category];
            
            
        }
        
        
        NSDictionary *category = (NSDictionary *)[DO.types firstObject];
        
        DO.Dine_type = category[@"name"];
     

    }
    
    DO.location = [[CLLocation alloc]initWithLatitude:_loc_latitude longitude:_loc_longitude];
    
    DO.destLocation = [[CLLocation alloc]initWithLatitude:DO.latitude  longitude:DO.longitude];
    
    DO.distance = [DO.destLocation distanceFromLocation:DO.location];
    
    
    
    int distance = floorf(DO.distance/1000);
    
    if (distance < 1) {
        
        DO.place_distance = [NSString stringWithFormat:@"%d m",(int)DO.distance];
    }
    
    else
    {
        DO.place_distance = [NSString stringWithFormat:@"%.2f km",DO.distance/1000];
    }
    

    DO.provider_icon = [UIImage imageNamed:@"Foursquare.png"];
    
    if (self.delegate)
    {
        [self.delegate  DinnigsDownloaded:DO :count];
    }
    
    
}


- (void)downloadItemsForeSquareWithId:(NSString *)venueID
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    NSString *url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@&v=20160626",venueID,app.foursquareClientID,app.foursquareClientSecret];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 
                                 // 4: Handle response here
                                 
                                 // Initialize the data object
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 
                                 int count = 0;
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     // Parse the JSON that came in
                                     
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
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
        [self.delegate  DinnigsWithIdDownloaded:self];
    }
    
    
}



/*
 Zomato
 */

-(void)downloadItemsZomato:(CGFloat)longitude latitude:(CGFloat)latitude
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *url = [[NSString alloc]initWithFormat:@"https://developers.zomato.com/api/v2.1/search?count=200&lat=%f&lon=%f&sort=real_distance&order=asc",latitude,longitude];
    
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:jsonFileUrl];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField: @"Accept"];
    [request addValue:app.zomatoKey forHTTPHeaderField: @"user-key"];
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 
                                 // 4: Handle response here
                                 
                                 // Initialize the data object
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     
                                     // Parse the JSON that came in
                                     
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     //NSLog(@"JSON Details %@",jsonArray);
                                     
                                     //Get number of downloaded results
                                     NSDictionary *restaurants = [jsonArray valueForKey:@"restaurants"];
                                     
                                     count += (int)restaurants.count;
                                     
                                     if (restaurants.count >0)
                                     {
                                         
                                         for (NSDictionary *data in restaurants)
                                         {
                                             NSDictionary *restaurant = [data valueForKey:@"restaurant"];

                                             [self loadItemsZomato:restaurant :count];

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

-(void)loadItemsZomato :(NSDictionary *)nearByData :(int)count
{
    
    NSDictionary *location;
    NSDictionary *userRating;

    
    DinningObject *DO = [[DinningObject alloc]init];
    
    DO.name = nearByData[@"name"];
    DO.icon_url = nearByData[@"thumb"];
    DO.place_id = nearByData[@"id"];
    DO.canonicalURL = nearByData[@"url"];
    DO.Dine_type = nearByData[@"cuisines"];
    DO.delegate = self.delegate;
 
    if([nearByData valueForKey:@"location"])
    {
        location = [nearByData valueForKey:@"location"];
        
        DO.latitude =[ location[@"latitude"] doubleValue ];
        DO.longitude =[ location[@"longitude" ] doubleValue];
        DO.address = [[NSMutableString alloc]initWithString:location[@"address"]];
        [DO.address appendString:@", "];
        [DO.address appendString:location[@"locality"]];
        [DO.address appendString:@", "];
        [DO.address appendString:location[@"city"]];
     
    }
    if([nearByData valueForKey:@"user_rating"])
    {
        userRating = [nearByData valueForKey:@"user_rating"];
        
        DO.rating = userRating[@"aggregate_rating"];

    }
    
    DO.location = [[CLLocation alloc]initWithLatitude:_loc_latitude longitude:_loc_longitude];
    
    DO.destLocation = [[CLLocation alloc]initWithLatitude:DO.latitude  longitude:DO.longitude];
    
    DO.distance = [DO.destLocation distanceFromLocation:DO.location];
    
  
    int distance = floorf(DO.distance/1000);
    
    if (distance < 1) {
        
        DO.place_distance = [NSString stringWithFormat:@"%d m",(int)DO.distance];
    }
    
    else
    {
        DO.place_distance = [NSString stringWithFormat:@"%.2f km",DO.distance/1000];
    }

    DO.provider_icon = [UIImage imageNamed:@"zomato.png"];

    if (self.delegate)
    {
        [self.delegate  DinnigsDownloaded:DO :count];
    }
    
    
}





@end
