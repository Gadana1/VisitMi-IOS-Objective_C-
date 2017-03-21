//
//  ImageSliderPageView.m
//  VisitMi
//
//  Created by Samuel Gabriel on 26/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "ImageSliderPageView.h"

@interface ImageSliderPageView ()

@end

@implementation ImageSliderPageView

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.imgView setImage:[UIImage imageWithData:self.imageData]];
    CGRect frame = self.imgView.frame;
    frame.size = self.imgView.image.size;
    self.imgView.frame = frame;
    
    NSLog(@"image Height %f",frame.size.height);
    
    //Image Shadow
    self.imgView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imgView.layer.shadowOpacity =.4;
    self.imgView.layer.shadowRadius = 5;
    
    
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
