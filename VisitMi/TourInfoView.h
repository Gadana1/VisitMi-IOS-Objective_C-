//
//  TourOfferView.h
//  VisitMi
//
//  Created by Samuel Gabriel on 30/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourInfoDetailsView.h"
#import "MapViewController.h"

@interface TourInfoView : UITableViewController <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *tittleLB;
@property (weak, nonatomic) IBOutlet UILabel *locationLB;
@property (weak, nonatomic) IBOutlet UILabel *durationLB;
@property (weak, nonatomic) IBOutlet UILabel *startDateLB;
@property (weak, nonatomic) IBOutlet UILabel *endDateLB;
@property (weak, nonatomic) IBOutlet UITextView *descTXT;
@property (weak, nonatomic) IBOutlet UITextView *moreInfoTXT;
@property (weak, nonatomic) IBOutlet UIButton *locationBT;


@property (strong, nonatomic) NSString *itemTitle;
@property (strong, nonatomic) NSString *tourDesc;
@property (strong, nonatomic) NSString *highlights;
@property (strong, nonatomic) NSString *terms;
@property (strong, nonatomic) NSString *knowb4Book;

@end
