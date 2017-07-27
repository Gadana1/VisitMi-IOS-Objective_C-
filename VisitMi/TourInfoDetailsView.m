//
//  TourInfoDetailsView.m
//  VisitMi
//
//  Created by Samuel Gabriel on 01/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TourInfoDetailsView.h"

@interface TourInfoDetailsView ()

@end

@implementation TourInfoDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navItem.title =  self.navTitle;
    
    [self.item1Label.layer setCornerRadius:5.0f];
    [self.item1Label.layer setMasksToBounds:YES];
    
    
    [self.item2Label.layer setCornerRadius:5.0f];
    [self.item2Label.layer setMasksToBounds:YES];
    
    //Load items with data
    self.item1Label.text = self.item1Lb;
    self.item1.text = self.item1Txt;
    self.item1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.item1 layoutIfNeeded];
    
    [self.item1 setFont:[UIFont systemFontOfSize:17.0f]];
    [self.item1 setTextColor:[UIColor darkGrayColor]];
    
    self.item2Label.text = self.item2Lb;
    self.item2.text = self.item2Txt;
    self.item2.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.item2 layoutIfNeeded];

    [self.item2 setFont:[UIFont systemFontOfSize:17.0f]];
    [self.item2 setTextColor:[UIColor darkGrayColor]];
    
 
    
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
