//
//  BookmarkTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 08/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemType;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIView *tabView;

@end
