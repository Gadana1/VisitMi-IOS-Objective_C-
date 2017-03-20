//
//  OverviewViewController.h
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInternet.h"
#import "PlaceObject.h"
#import "TourObject.h"
#import "UIViewAnimation.h"
#import "TourTableViewCell.h"
#import "TourViewController.h"

@interface OverviewViewController : UIViewController<UITabBarControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource, imageDelegate>


@property (strong, nonatomic) TourObject *TO;

@property (weak, nonatomic) TourTableViewCell *tourCell;

@property (nonatomic, strong) NSMutableArray *tourItems;
@property (assign, nonatomic) int tourCount;


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *address;

@property (assign, nonatomic) NSUInteger x;
@property (assign, nonatomic) NSUInteger imageCount;

@property (nonatomic, strong) NSArray *imageURLARR;


@property (strong, nonatomic) NSData *img1;
@property (strong, nonatomic) NSData *img2;
@property (strong, nonatomic) NSData *img3;

@property (strong, nonatomic) NSData *downloadedIMG;

@property (weak, nonatomic)  UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UIView *contentsView;

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@property (weak, nonatomic) IBOutlet UITextView *descTV;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;


@property (weak, nonatomic) IBOutlet UIButton *infoBT;
@property (weak, nonatomic) IBOutlet UIButton *contactBT;
@property (weak, nonatomic) IBOutlet UIButton *toursBT;
@property (weak, nonatomic) IBOutlet UILabel *tourCountLB;

@property (weak, nonatomic) IBOutlet UIView *referenceView;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIView *tabView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIView *toursView;

@property (weak, nonatomic) IBOutlet UITableView *tourTableView;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UITextView *addressLB;

//Updating table
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerView;
@property(strong,nonatomic)NSMutableArray *indexPaths;
@property(assign,nonatomic)NSUInteger count;
@property(assign,nonatomic)NSUInteger presentCount;

//BackgroundView
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImage;
@property (weak, nonatomic) IBOutlet UILabel *notifyText;

//Tour favourites
@property(nonatomic, assign)BOOL isFavourites;
@property(nonatomic, strong)NSString *destinationPath;

@property (strong, nonatomic) NSMutableArray *theFav;


- (void)loadVisiblePages;
- (IBAction)infoBTAction:(id)sender;
- (IBAction)contactBTAction:(id)sender;
- (IBAction)toursBTAction:(id)sender;

- (IBAction)callAction:(id)sender;

-(void)loadTourImages: (NSData *)imageDATA :(NSInteger)index;

-(void)updateTableData;


@end
