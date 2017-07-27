//
//  DistanceMatrixObject.m
//  VisitMi
//
//  Created by Samuel Gabriel on 09/09/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "DistanceMatrixObject.h"

@implementation DistanceMatrixObject



-(void)getDistance: (CGFloat)orignLat OrignLongitude:(CGFloat)orignLng DistinationLatitude:(CGFloat)destinationLat DistinationLongitude:(CGFloat)destinationLng Modes:(NSArray *)modes

{
    
    NSLog(@"Get distance initiated");

    NSString *url;

    if (modes.count == 0)
    {
        
        url = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=%f,%f&destinations=%f,%f&key=AIzaSyBcKHpoJ8DjJzuMgyoyAVdiFuVWqDge8AQ",orignLat,orignLng,destinationLat,destinationLng];
        

        
    }
    else
    {
        
        for (NSString *mode in modes)
        {
            
            url = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=%f,%f&destinations=%f,%f&mode=%@&key=AIzaSyBcKHpoJ8DjJzuMgyoyAVdiFuVWqDge8AQ",orignLat,orignLng,destinationLat,destinationLng,mode];
            
            
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
                                             
                                             //NSLog(@"Results Details %@",jsonArray);
                                             
                                             [self loadData:jsonArray Mode:mode];
 
                                             
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

        
        
    }
    
    
    
}


-(void)loadData :(NSDictionary *)data Mode:(NSString *)mode
{
    

    NSArray *rows;
    NSArray *elements;
    NSDictionary *distance;
    NSDictionary *duration;

    DistanceMatrixObject *DM = [[DistanceMatrixObject alloc]init];

    DM.mode = mode;
    
    if([data valueForKey:@"rows"])
    {
        
        rows = data[@"rows"];
        
        for (NSDictionary *row in rows)
        {
            elements = [row valueForKey:@"elements"];
            
            for (NSDictionary *element in elements)
            {
                distance = [element valueForKey:@"distance"];
                
                DM.distance = distance[@"text"];
                
                duration = [element valueForKey:@"duration"];
                
                DM.duration = duration[@"text"];
                
                NSLog(@"Distance Details %@",DM.mode);
                NSLog(@"Distance Details %@",DM.distance);
                NSLog(@"Duration Details %@",DM.duration);

                
            }
            

        }
        
    }

    
}



@end
