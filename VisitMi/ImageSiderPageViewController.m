//
//  ImageSiderPageViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 26/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "ImageSiderPageViewController.h"

@interface ImageSiderPageViewController ()

@end

@implementation ImageSiderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navItem.title = self.titleName;

    [self createPageViewController];
}


- (void)createPageViewController
{
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageController"];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    if([self.imagesData count])
    {
        
        NSArray *startingViewControllers = @[[self itemControllerForIndex:0]];
        [self.pageViewController setViewControllers:startingViewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
        
        
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
    
}


#pragma mark UIPageViewControllerDataSource

//Scroll Back
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    ImageSliderPageView *itemController = (ImageSliderPageView *)viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex:itemController.itemIndex-1];
    }
    
    return nil;
}

//Scroll Forward
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    ImageSliderPageView *itemController = (ImageSliderPageView *)viewController;
    
    if (itemController.itemIndex+1 < [self.imagesData count])
    {
        return [self itemControllerForIndex:itemController.itemIndex+1];
        
    }
    
    return nil;
}

- (ImageSliderPageView *)itemControllerForIndex:(NSUInteger)itemIndex
{
    if (itemIndex < [self.imagesData count])
    {
        ImageSliderPageView *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier:@"imageView"];
        pageItemController.itemIndex = itemIndex;
        pageItemController.imageData = [self.imagesData objectAtIndex:itemIndex];
        
        return pageItemController;
    }
    
    return nil;
}

#pragma mark Page Indicator

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.imagesData count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Additions

- (NSUInteger)currentControllerIndex
{
    ImageSliderPageView *pageItemController = (ImageSliderPageView *) [self currentController];
    
    if (pageItemController)
    {
        
        return pageItemController.itemIndex;
    }
    
    return -1;
}

- (UIViewController *)currentController
{
    if ([self.pageViewController.viewControllers count])
    {
        return self.pageViewController.viewControllers[0];
    }
    
    return nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
