//
//  TourInfoDetailsView.h
//  VisitMi
//
//  Created by Samuel Gabriel on 01/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TourInfoDetailsView : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (weak, nonatomic) IBOutlet UILabel *item1Label;
@property (weak, nonatomic) IBOutlet UITextView *item1;

@property (weak, nonatomic) IBOutlet UILabel *item2Label;
@property (weak, nonatomic) IBOutlet UITextView *item2;

@property (strong, nonatomic) NSString *navTitle;

@property (strong, nonatomic) NSString *item1Lb;
@property (strong, nonatomic) NSString *item1Txt;
@property (strong, nonatomic) NSString *item2Lb;
@property (strong, nonatomic) NSString *item2Txt;


@end
