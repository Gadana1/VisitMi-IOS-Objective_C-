//
//  ImageSliderPageView.h
//  VisitMi
//
//  Created by Samuel Gabriel on 26/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "AppDelegate.h"

@interface ImageSliderPageView : UIViewController

// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic, strong) NSData *imageData;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end
