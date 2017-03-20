//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController
#import "AppDelegate.h"

@interface SVWebViewController : UIViewController <imageDelegate>

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;
-(void)loadWebPage:(NSString *)url;

@property (strong, nonatomic) AppDelegate *appDelegate ;
@property (retain, nonatomic)PlaceObject *PO;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;

@property(strong, nonatomic)UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favBarButton;
@property (strong, nonatomic) IBOutlet UIButton * favButton;

@property (strong, strong) NSString *favoriteFilter;
@property (strong, strong) NSString *favoriteType;
@property (strong, strong) NSString *favoriteImgURL;
@property (strong, strong) NSString *favoriteImgNO;
@property (strong, strong) NSString *favoriteDetails;

@property(nonatomic, assign)BOOL isFavourites;
@property(nonatomic, strong)NSString *destinationPath;

@property (strong, nonatomic) NSMutableArray *theFav;

@end
