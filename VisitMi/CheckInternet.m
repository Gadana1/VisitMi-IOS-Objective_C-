//
//  CheckInternet.m
//  VisitMi
//
//  Created by Samuel Gabriel on 27/01/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "CheckInternet.h"

@implementation CheckInternet






+ (BOOL) isInternetConnectionAvailable:(NSString *)URL
{
    
    Reachability *internet;
    
    if(URL==NULL){
        
        internet= [Reachability reachabilityWithHostName:@"http://www.google.com"];
        
    }
    else
    {
        
        internet= [Reachability reachabilityWithHostName:URL];
        
    }
    
    NetworkStatus netStatus = [internet currentReachabilityStatus];
        
    bool netConnection = false;
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Internet Access Not Available");
            
            netConnection = false;
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = true;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = true;
            break;
        }
    
    }
    return netConnection;
}

@end
