//
//  BookingTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 23/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *bookingDateLB;
@property (strong, nonatomic) IBOutlet UILabel *bookingTitleLB;
@property (strong, nonatomic) IBOutlet UILabel *bookingTypeLB;
@property (strong, nonatomic) IBOutlet UILabel *currencyCodeLB;
@property (strong, nonatomic) IBOutlet UILabel *priceLB;
@property (strong, nonatomic) IBOutlet UIView *tabView;
@property (strong, nonatomic) IBOutlet UILabel *statusLB;

@end
