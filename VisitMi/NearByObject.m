//
//  NearByObject.m
//  
//
//  Created by Samuel Gabriel on 09/06/2016.
//
//

#import "NearByObject.h"

@implementation NearByObject

- (void)downloadItems:(CGFloat)longitude latitude:(CGFloat)latitude
{
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

 
    NSString *url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&limit=100&radius=12000&client_id=%@&client_secret=%@&v=20160626",latitude,longitude,_appDelegate.foursquareClientID,_appDelegate.foursquareClientSecret];
    
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
                                     
                                     
                                     //Get number of downloaded results
                                     NSDictionary *response = [jsonArray valueForKey:@"response"];
                                     NSDictionary *venues = [response valueForKey:@"venues"];
                                     
                                     count = (int)venues.count;
                                     
                                     
                                     
                                     if (count >0)
                                     {
                                         
                                         for (NSDictionary *data in venues)
                                         {
                                             
                                             [self loadItems:data :count];
                                             
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


-(void)loadItems :(NSDictionary *)nearByData :(int)count
{
    
    NSDictionary *location;
    NSDictionary *contact;
    NSDictionary *categories;
    NSDictionary *icon;
    
    NearByObject *NBO = [[NearByObject alloc]init];

    NBO.name = nearByData[@"name"];
    NBO.icon_url = nearByData[@"icon"];
    NBO.place_id = nearByData[@"id"];
    NBO.delegate = self.delegate;
    
    
    if([nearByData valueForKey:@"contact"])
    {
        contact = [nearByData valueForKey:@"contact"];
    
        self.phone = contact[@"phone"];
     
    }
    
    if([nearByData valueForKey:@"location"])
    {
        location = [nearByData valueForKey:@"location"];
        
        NBO.place_latitude =[ location[@"lat"] doubleValue ];
        NBO.place_longitude =[ location[@"lng" ] doubleValue];
        NBO.formattedAddress = location[@"formattedAddress"];
        
        double distance = floorf([location[@"distance"] integerValue]/1000);
        NBO.distance = distance;
        
        if (distance < 1) {
            
            NBO.place_distance = [NSString stringWithFormat:@"%lu m",[location[@"distance"] integerValue]];
        }
        
        
        else
        {
            NBO.place_distance = [NSString stringWithFormat:@"%.2f km",([location[@"distance"] doubleValue]/1000)];
        }

 
    }
    
    if([nearByData valueForKey:@"categories"])
    {
        
        categories = [nearByData valueForKey:@"categories"];
        NBO.categories = [[NSMutableArray alloc]init];
        
        for(NSDictionary *category in categories)
        {
            [NBO.categories addObject:category];
           

        }
        
        
       NSDictionary *category = (NSDictionary *)[NBO.categories firstObject];

        NBO.cat_name = category[@"name"];
        
        if([category valueForKey:@"icon"])
        {
            icon = [category valueForKey:@"icon"];
            
            NBO.icon_url_tmp = icon[@"prefix"];
            NBO.icon_urlEXT = icon[@"suffix"];
            
        }
     

    }
    
    if (NBO.icon_url_tmp!=NULL) {
        
        int size = 88;
        
        NBO.icon_url = [NSString stringWithFormat:@"%@bg_%d%@",NBO.icon_url_tmp,size,NBO.icon_urlEXT];
        NSURL *imgUrl = [NSURL URLWithString:NBO.icon_url];
        
        NSURLSessionDataTask *downloadImages = [[NSURLSession sharedSession]
                             dataTaskWithURL:imgUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                
                                 NBO.thumbnailData = data;
                                 
                                 if (self.delegate)
                                 {
                                     [self.delegate  nearByDownloaded:NBO :count];
                                 }
                                 
                             }];
        [downloadImages resume];
       
    }


      
    
    
}


- (void)downloadItemsWithId:(NSString *)venueID
{
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *url = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@&v=20160626",venueID,_appDelegate.foursquareClientID,_appDelegate.foursquareClientSecret];

    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    
    if([CheckInternet isInternetConnectionAvailable:NULL])
    {
        
        // Parse the JSON that came in
        self.downloadTask = [[NSURLSession sharedSession]
                             dataTaskWithURL:jsonFileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 
                                 // 4: Handle response here
                                 NSLog(@"Response Details %@",response);
                                 
                                 // Initialize the data object
                                 self._downloadedData = [[NSMutableData alloc] init];
                                 
                                 // Append the newly downloaded data
                                 
                                 
                                 if (data!=NULL && (!error))
                                 {
                                     
                                     [self._downloadedData appendData:data];
                                     
                                     
                                     // Parse the JSON that came in
                                     
                                     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self._downloadedData options:NSJSONReadingAllowFragments error:&error];
                                     
                                     
                                     //Get number of downloaded results
                                     NSDictionary *response = [jsonArray valueForKey:@"response"];
                                     NSDictionary *venue = [response valueForKey:@"venue"];
                                     
                                     
                                     NSLog(@"Venue count %lu",jsonArray.count);
                                     
                                     if (venue != NULL)
                                     {
                                         [self loadItemsWithId:venue];

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

-(void)loadItemsWithId :(NSDictionary *)nearByData
{
    
    
    self.canonicalURL = nearByData[@"canonicalUrl"];

    if (self.delegate)
    {
        NSLog(@"Sending item to controller");
        [self.delegate  nearByWithIdDownloaded:self];
    }
    
    
}

@end
