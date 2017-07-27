//
//  PlaceObject.m
//  
//
//  Created by Samuel on 10/30/15.
//
//

#import "PlaceObject.h"

@implementation PlaceObject

- (id)initWithState:(NSString *)state image:(NSString *)stateImage code:(NSString *)stateCode
{
    
    PlaceObject *PO = [[PlaceObject alloc]init];
    
    PO.stateCode = stateCode;
    PO.state = state;
    PO.stateImage = stateImage;
    
    
    return PO;
    
    
}

- (id)initWithCountries:(NSString *)country_Code CountryName:(NSString *)country_Name DialingCode:(NSString *)dialing_Code CountryImage:(NSString *)country_Image
{
    
    PlaceObject *PO = [[PlaceObject alloc]init];
    
    PO.country_Code = country_Code;
    PO.country_Name = country_Name;
    PO.dialing_Code = dialing_Code;
    PO.country_Image = country_Image;

    
    return PO;
    
    
}

- (id)initWithDbResponse:(NSString *)status Message:(NSString *)message
{
    
    PlaceObject *PO = [[PlaceObject alloc]init];
    
    PO.dbstatus = status;
    PO.dbmessage = message;

    
    
    return PO;
    
    
}

-(void)getDirectionsFromCoordinate:(CLLocationCoordinate2D)coordinate TO_Coordinate:(CLLocationCoordinate2D)destCoordinate
{
    
    NSString *googleMapUrlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f",coordinate.latitude,coordinate.longitude, destCoordinate.latitude, destCoordinate.longitude];
    NSURL *googleMapURL = [NSURL URLWithString:googleMapUrlString];
    
    NSString* appleMapUrlString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",coordinate.latitude,coordinate.longitude, destCoordinate.latitude, destCoordinate.longitude];
    NSURL *appleMapURL= [NSURL URLWithString:appleMapUrlString];
    
    NSURL* googleURL = [NSURL URLWithString:@"comgooglemaps://"];
    
    
    if ([[UIApplication sharedApplication] canOpenURL:googleURL])
    {
        [[UIApplication sharedApplication] openURL:googleMapURL options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:appleMapURL options:@{} completionHandler:nil];
    }

}

-(void)setPickUpCoordinate:(CLLocationCoordinate2D)coordinate DropOffCoordinate:(CLLocationCoordinate2D)destCoordinate
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString *pickUpAddress = [[self getPlaceAddressForLatitude:coordinate.latitude Longitude:coordinate.longitude] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *destinationAddress = [[self getPlaceAddressForLatitude:destCoordinate.latitude Longitude:destCoordinate.longitude] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *uberAppString = [NSString stringWithFormat:@"uber://?client_id=%@&action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&pickup[formatted_address]=%@&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[formatted_address]=%@&product_id=a1111c8c-c720-46c3-8534-2fcdd730040d",app.uberClientID,coordinate.latitude,coordinate.longitude,pickUpAddress,destCoordinate.latitude, destCoordinate.longitude,destinationAddress];
    NSURL* uberAppURL = [NSURL URLWithString:uberAppString];
    
    NSString *uberWebString = [NSString stringWithFormat:@"https://m.uber.com/ul/?client_id=%@&action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&pickup[formatted_address]=%@&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[formatted_address]=%@&product_id=a1111c8c-c720-46c3-8534-2fcdd730040d",app.uberClientID,coordinate.latitude,coordinate.longitude,pickUpAddress,destCoordinate.latitude, destCoordinate.longitude,destinationAddress];
    NSURL* uberWebURL = [NSURL URLWithString:uberWebString];
    
    NSURL* uberURL = [NSURL URLWithString:@"uber://"];
    NSURL* appStoreURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/uber/id368677368?mt=8"];
    
    if ([[UIApplication sharedApplication] canOpenURL:uberURL])
    {
        [[UIApplication sharedApplication] openURL:uberAppURL options:@{} completionHandler:nil];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:uberWebURL])
    {
        [[UIApplication sharedApplication] openURL:uberWebURL options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
    }
    
}

-(NSString *)getPlaceAddressForLatitude:(CGFloat)lat Longitude:(CGFloat)lng
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=%@",lat,lng,appDelegate.googleServiceKey];
    NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSError *error;
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:downloadedData options:NSJSONReadingAllowFragments error:&error];
    NSArray *result = jsonArray [@"results"];
    NSDictionary *locAddress = [result firstObject];
    
    
    return locAddress[@"formatted_address"];
    
}

-(void)downloadImages:(NSString *)imgURL :(int)imgNum :(NSString *)name :(NSInteger)imgIndex
{
    
    NSURL *url = [NSURL URLWithString:imgURL];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *imageName = [[NSString alloc]initWithFormat:@"%lu%d",(unsigned long)name.hash,imgNum];
    
    NSString *imgageDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
    
    BOOL isDirectory;
    
    //check if image directory has been created
    if (![fileManager fileExistsAtPath:imgageDir isDirectory:&isDirectory] || !isDirectory)
    {
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [fileManager createDirectoryAtPath:imgageDir
           withIntermediateDirectories:YES
                            attributes:attr
                                 error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }

    NSString *imagePath = [imgageDir stringByAppendingPathComponent:imageName];
    

    //check is image already downloaded to phone
    if ([fileManager fileExistsAtPath:imagePath])
    {
        NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
        
        if (self.delegate) {
            
            [self.delegate imagesDownloaded:imgData :imgIndex];
        }
        

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        dispatch_async(queue, ^(void){
            

            self.downloadPhotoTask = [[NSURLSession sharedSession]
                                      dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          if (data) {
                                              
                                              if (imgData.hash == data.hash) {
                                                  
                                                  NSLog(@"image has not changed");
                                              }
                                              else
                                              {
                                                  NSLog(@"image has changed");
                                                  
                                                  if (self.delegate) {
                                                      
                                                      [self.delegate imagesDownloaded:data :imgIndex];
                                                  }
                                                  
                                                  [data writeToFile:imagePath atomically:YES];
                                                  
                                              }
                                          }
                                          else
                                          {
                                              NSLog(@"image Data is NULL");
                                              
                                          }
                                      }];

    
            
        });
        
        
    }

    else
    {
        if([CheckInternet isInternetConnectionAvailable:NULL])
        {

            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            
            dispatch_async(queue, ^(void){
                
                
                self.downloadPhotoTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              if (data) {
                                                  
                                                  self.img = data;
                                                  
                                                  if (self.delegate)
                                                  {
                                                      [self.delegate imagesDownloaded:self.img :imgIndex];
                                                  }
                                                  if (imgNum == 0) {
                                                      
                                                      [self.img writeToFile:imagePath atomically:YES];

                                                  }
                                              }
                                              else
                                              {
                                                  NSLog(@"image Data is NULL");
                                                  
                                              }
                                          }];
                
                [self.downloadPhotoTask resume];
            });
        
            
        }
        
    }
    
    
    
    
}


-(void)deleteImages:(int)imgNum :(NSString *)name
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *imageName = [[NSString alloc]initWithFormat:@"%@%d.png",name,imgNum];
    
    NSString *imgageDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
   
    NSString *imagePath = [imgageDir stringByAppendingPathComponent:imageName];
    
    //check is image already downloaded to phone
    
    if ([fileManager fileExistsAtPath:imagePath])
    {
        NSError *error = nil;
        [fileManager removeItemAtPath:imagePath error:&error];
        
    }
    
    
}


@end
