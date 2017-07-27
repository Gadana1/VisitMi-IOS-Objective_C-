//
//  TicketsTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 06/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TicketsTableViewCell.h"

@implementation TicketsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)qtyStepperAction:(id)sender {
    
    self.quantity = self.qtyStepper.value;
    self.ticketQtyTXT.text = [NSString stringWithFormat:@"%lu",(long)self.quantity];
    
    self.newPrice = self.qtyStepper.value * self.finalPrice;
    self.ticketPriceTXT.text = [NSString stringWithFormat:@"%.2f",self.newPrice];
    
}
@end
