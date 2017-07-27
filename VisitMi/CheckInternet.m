//
//  CheckInternet.m
//  VisitMi
//
//  Created by Samuel Gabriel on 27/01/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "CheckInternet.h"

@implementation CheckInternet
NSString *remoteHostName;



- (id)init
{
    self = [super init];
    if (self != nil)
    {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        remoteHostName = @"www.google.com";
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        
        self.wifiReachability = [Reachability reachabilityForLocalWiFi];
        [self.wifiReachability startNotifier];
    }
    return self;
}


+ (BOOL) isInternetConnectionAvailable:(NSString *)URL
{
    NetworkStatus netStatus;
    CheckInternet *check = [CheckInternet new];

    BOOL reachable = NO;
    
    if (URL == NULL) {
        
        netStatus = [check.internetReachability currentReachabilityStatus];
        
    }
    else
    {
        remoteHostName = URL;
        netStatus = [check.hostReachability currentReachabilityStatus];

    }
    
    if(netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi)
    {
    
        reachable = YES;
    }
    else
    {
        reachable = NO;
    }
    
    
    return reachable;
   
}

@end
