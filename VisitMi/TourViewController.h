//
//  TourViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 26/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageSiderPageViewController.h"
#import "PlaceObject.h"
#import "TourObject.h"
#import "TourInfoView.h"
#import "BookingContainerController.h"

@interface TourViewController : UIViewController < imageDelegate,dbConnDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TourObject *TO;
@property (nonatomic, strong) PlaceObject *PO;

@property (nonatomic, strong) NSString *tourTitle;
@property (nonatomic, strong) NSString *tourAddress;

@property (nonatomic, strong) NSMutableArray *imagesData;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIImageView *tourImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animImageLoading;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favBarButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@property (weak, nonatomic) IBOutlet UIButton *info;
@property (weak, nonatomic) IBOutlet UIButton *avail;

//custom views
@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (weak, nonatomic) IBOutlet UIView *detailsContainer;
@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) TourInfoView *infoView;
@property (weak, nonatomic) TourInfoDetailsView *infoDetailsView;

@property (weak, nonatomic) IBOutlet UITableView *availTableView;
@property (weak, nonatomic) IBOutlet UILabel *availPriceFooter;
@property (weak, nonatomic) IBOutlet UILabel *availHeader;

//Data elements
@property (strong, strong) NSString *favoriteName;
@property (strong, strong) NSString *favoriteType;
@property (strong, strong) NSString *favoriteImgURL;
@property (strong, strong) NSString *favoriteImgNO;
@property (strong, strong) NSString *favoriteDetails;

@property (strong, nonatomic)NSMutableArray *availabilities;

@property(nonatomic, strong)NSString *destinationPath;
@property (strong, nonatomic) NSMutableArray *theFav;

@property (assign, nonatomic) NSInteger imageDownloadCount;

- (IBAction)infoAction:(id)sender;
- (IBAction)availAction:(id)sender;

@end
