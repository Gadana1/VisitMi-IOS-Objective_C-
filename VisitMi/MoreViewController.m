//
//  MoreViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 13/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the attributes
    const CGFloat subattrfontSize = 30;
    const CGFloat attrfontSize = 17;

    NSShadow *textShadow = [[NSShadow alloc]init];
    textShadow.shadowColor = [UIColor grayColor];
    textShadow.shadowOffset = CGSizeMake(2, 0);
    textShadow.shadowBlurRadius = .4;
    
    NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont systemFontOfSize:attrfontSize]

                            };
    NSDictionary *subAttrs = @{
                               
                               NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:subattrfontSize],
                               NSForegroundColorAttributeName:[UIColor orangeColor],
                               NSShadowAttributeName:textShadow
                               
                               };
    
    const NSRange range = NSMakeRange(0,1);
    
    NSString *text = _detailsText!=nil?_detailsText:@"";
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    [_detailsTextView setAttributedText:attributedText];
    //[self.detailsTextView setText:self.detailsText];

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
