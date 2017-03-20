//
//  ImageSiderPageViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 26/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "ImageSliderPageView.h"

@interface ImageSiderPageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>




@property (nonatomic, strong) NSMutableArray *imagesData;
@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;


@end
