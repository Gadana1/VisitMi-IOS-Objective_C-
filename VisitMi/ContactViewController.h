//
//  ContactViewController.h
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ContactViewController : UIViewController <UITabBarControllerDelegate>


@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *state;

@property (strong, nonatomic) IBOutlet UIScrollView *contactScrollView;

@property (strong, nonatomic) IBOutlet UITextView *phoneNumberTXT;
@property (strong, nonatomic) IBOutlet UITextView *addressTXT;
@property (strong, nonatomic) IBOutlet UITextView *stateTXT;

@end
