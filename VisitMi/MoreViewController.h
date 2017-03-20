//
//  MoreViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 13/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@property (strong, nonatomic)  NSString *detailsText;

@end
