//
//  CheckInternet.h
//  VisitMi
//
//  Created by Samuel Gabriel on 27/01/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface CheckInternet : NSObject

+ (BOOL) isInternetConnectionAvailable:(NSString *)URL;

@end
