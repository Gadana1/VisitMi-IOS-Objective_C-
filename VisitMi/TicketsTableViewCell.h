//
//  TicketsTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 06/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ticketTypeTXT;
@property (strong, nonatomic) IBOutlet UILabel *ticketRestrictTXT;
@property (strong, nonatomic) IBOutlet UILabel *ticketQtyTXT;
@property (strong, nonatomic) IBOutlet UILabel *currencyCodeTXT;
@property (strong, nonatomic) IBOutlet UILabel *ticketPriceTXT;
@property (strong, nonatomic) IBOutlet UIStepper *qtyStepper;

@property (assign, nonatomic)  NSInteger quantity;
@property (assign, nonatomic)  CGFloat newPrice;
@property (assign, nonatomic)  CGFloat finalPrice;

- (IBAction)qtyStepperAction:(id)sender;

@end
