//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityChrome.h"
#import "SVWebViewControllerActivitySafari.h"
#import "SVWebViewController.h"

@interface SVWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;

@end


@implementation SVWebViewController
 
#pragma mark - Initialization

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
    self.delegate = nil;
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView].delegate = self;
    [self updateToolbarItems];
    
    //check for internet connection
    if(![CheckInternet isInternetConnectionAvailable:NULL]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"NO INTERNET ACCESS!"
                                      message:@"Please check your device connectivity settings"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    
    [self setUpSpinner];
    [self.spinner startAnimating];

    
}

//constructs the spinner
-(void)setUpSpinner
{
    self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-30,([UIScreen mainScreen].bounds.size.height/2)-30, 60.0, 60.0);
    
    self.spinner.color = [UIColor orangeColor];
    [self.webView addSubview:self.spinner];
    
    // Center horizontally
   /* [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:self.spinner
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:0.5
                                                           constant:-30]];
    
    // Center vertically
    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                             toItem:self.spinner
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:0.5
                                                           constant:-30]]; */
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _actionBarButtonItem = nil;
    
    
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];

 
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    
    if (_favoriteFilter == NULL || [_favoriteFilter isEqualToString:@""])
    {
        [self.favButton setHidden:YES];
    }
    else
    {
        
        //Button customiztaion
        self.favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favButton setFrame:CGRectMake(0, 0, 25, 25)];
        [self.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //Assign colour to favourite button based on favourite availability
        if([self checkIfFavrouite])
        {
            
            [self.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
            
        }
        
        else
        {
            
            [self.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
            
        }
        
        self.favBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.favButton];
        self.navigationItem.rightBarButtonItem = self.favBarButton;
        
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (UIWebView*)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerBack"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goBackTapped:)];
        _backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerNext"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goForwardTapped:)];
        _forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem
{
    if (!_refreshBarButtonItem)
    {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem)
    {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem)
    {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250.0f;
        fixedSpace.width = 35.0f;
        
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem,
                          nil];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    
    else {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace,
                          nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
   
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];

    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.spinner setHidden:YES];
    [self.spinner stopAnimating];
    
    if (self.navigationItem.title == nil) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.webView.request.URL ? self.webView.request.URL : self.request.URL;
    if (url != nil) {
        NSArray *activities = @[[SVWebViewControllerActivitySafari new], [SVWebViewControllerActivityChrome new]];
        
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        } else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
#ifdef __IPHONE_8_0
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 &&
                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
                ctrl.sourceView = self.view;
                ctrl.barButtonItem = sender;
            }
#endif
            
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }
}

- (void)doneButtonTapped:(id)sùender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


//load web pagee
-(void)loadWebPage:(NSString *)url
{
    _favoriteDetails = url;
    
    if (url==NULL || [url isEqualToString:@""])
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Unavailable"
                                      message:@"Information not available at the moment please try again later"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popViewControllerAnimated:true];
                             }];
        
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self loadRequest:urlRequest];
        
    }
}

//add to Favourite
-(void)addItemToFavorites:(id)sender
{
    if ([self checkIfFavrouite])
    {
        
        NSLog(@" item already a favourite ");
       
        NSMutableArray* tmpArray = [self.theFav copy];
        
        for (NSDictionary *favItem in tmpArray) {
            
            if ([_favoriteFilter isEqualToString:favItem[@"Name"]] && [_favoriteType isEqualToString:favItem[@"Type"]])
            {
                
                [self.theFav removeObject:favItem];

                self.PO = [[PlaceObject alloc]init];
                [self.PO deleteImages:[favItem[@"ImgNO"] intValue] :favItem[@"Name"]];

            }
            
        }
        
        [self.theFav writeToFile:_destinationPath atomically:YES];

        [self.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        
        if (_favoriteType==nil) {
            _favoriteType=@"Location";
        }
        if (_favoriteImgURL==nil) {
            _favoriteImgURL=@"null";
        }
        if (_favoriteDetails==nil) {
            _favoriteDetails=@"null";
        }
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        NSMutableDictionary *details = [NSMutableDictionary
                                        dictionaryWithDictionary:@{@"Name":_favoriteFilter,
                                                                   @"Type":_favoriteType,
                                                                   @"ImgUrl":_favoriteImgURL,
                                                                   @"ImgNO":_favoriteImgNO,
                                                                   @"Details":_favoriteDetails,
                                                                   @"CountryCode":app.userCountry[@"CountryCode"],

                                                                   }];
        
        [_theFav addObject:details];
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        self.PO = [[PlaceObject alloc]init];
        
        //Save Image folder
        [self.PO downloadImages:_favoriteImgURL :[_favoriteImgNO intValue] :_favoriteFilter :0];
        
        [self.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
        
        
        
    }
    
    
    
}


-(BOOL)checkIfFavrouite
{
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _destinationPath = _appDelegate.favoritePath;
    
    self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
    
    if(_destinationPath==NULL)
    {
        
        _destinationPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"favourites"] ofType:@"plist"];
        
        self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
        
    }
    
    
    NSMutableArray* tmpArray = [self.theFav copy];
    
    for (NSDictionary *favItem in tmpArray) {
        
        if ([_favoriteFilter isEqualToString:favItem[@"Name"]] && [_favoriteType isEqualToString:favItem[@"Type"]])
        {
            
            NSLog(@"item exist in favourite file");
            
            return true;
            
        }
        
    }
    
    
    NSLog(@"item does not exist in favourite file");
    
    
    return false;
    
}

-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    
    NSLog(@"imaged recieved");
 
}

@end
