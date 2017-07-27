//
//  TourViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 26/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TourViewController.h"

@interface TourViewController ()

@end

@implementation TourViewController

CGFloat tableViewContentHieight;
CGSize scrollContentSize;
NSInteger selectedTab;
UIActivityIndicatorView *loading ;

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.title = self.tourTitle;
    self.detailsScrollView.delegate =self;
    
    self.infoView = [self.storyboard instantiateViewControllerWithIdentifier:@"infoView"];

    [self addChildViewController:self.infoView];
    [self.infoView didMoveToParentViewController:self];
    
    [self.detailsScrollView layoutIfNeeded];
    [self.detailsContainer layoutIfNeeded];

    self.availTableView.delegate = self;
    self.availTableView.dataSource = self;
    
    self.availTableView.rowHeight = 50.0f;
    
    [self.bookButton setHidden:YES];
    [self.bookButton setEnabled:NO];

    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    [loading setHidesWhenStopped:YES];
    [self.view setUserInteractionEnabled:FALSE];
    
    loading.frame = self.view.frame;
    [loading setBackgroundColor:[UIColor whiteColor]];
    loading.center = self.view.center;
    [self.view addSubview:loading];
    

    //Select default tab
    selectedTab = 0;
    
    //SetUp info TableView
    [self setUpInfoView];
    
    //Add Action to faveorite Button
    [self.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];

    //TabView Shadow
    self.tabView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tabView.layer.shadowOpacity = .5;
    self.tabView.layer.shadowRadius = 3.f;
  
    //Book Button Shadow
    self.bookButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.bookButton.layer.shadowOpacity = .5;
    self.bookButton.layer.shadowRadius = 3.f;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Assign colour to favourite button based on favourite availability
    if([self checkIfFavrouite])
    {
        
        [self.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
        
    }
    
    else
    {
        
        [self.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^(void){
     
        //Set Selected Tab
        
        if (selectedTab == 0) {
            
            //SetUp Info TableView
            [self showSelectedBT:self.info];
            [self setUpInfoView];
        }
        else if (selectedTab == 1) {
            
            //SetUp Offers TableView
            [self showSelectedBT:self.avail];
            [self setUpAvailView];
            
        }
                
    });
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.availTableView.rowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.availabilities count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"availCell"];
    TourObject *TO = (TourObject *)[self.availabilities objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", TO.displayDate,TO.valueDate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.availTableView)
    {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        if([self.bookButton isHidden])
        {
            [self.bookButton fadeInObject:self.bookButton  duration:.1 option:UIViewAnimationOptionCurveEaseIn];
            [self.bookButton setEnabled:YES];

        }
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];

}

//Tour Delegate
-(void)tourItemsDownloadedWithId:(id)tourOBJ
{
    
    self.TO = (TourObject *)tourOBJ;
    
    NSLog(@"Tour Downloaded: %@",self.TO.title);
    self.PO = [[PlaceObject alloc]init];
    self.PO.delegate = self;
   
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^(void){
        
        self.infoView.tittleLB.text = self.TO.title;
        self.infoView.locationLB.text = self.TO.location;
        self.infoView.currencyCodeLB.text = self.TO.currencyCode;
        self.infoView.priceLB.text = [NSString stringWithFormat:@"%.2f",self.TO.priceRange];
        self.infoView.durationLB.text = self.TO.duration;
        self.infoView.startDateLB.text = self.TO.startDate;
        self.infoView.endDateLB.text = self.TO.endDate;
        
        self.infoView.tourDesc = self.TO.desc;
        self.infoView.highlights = self.TO.highlights;
        self.infoView.terms = self.TO.termsAndConditions;
        self.infoView.knowb4Book = self.TO.knowBeforeBook;
        self.infoView.itemTitle = self.TO.title;
        
        self.tourAddress = [self.PO getPlaceAddressForLatitude:self.TO.latitude Longitude:self.TO.longitude];

        [self.infoView.locationBT addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];

        
        if ([self.TO.desc isEqualToString:@""] || self.TO.desc == NULL) {
            
            self.infoView.descTXT.text = self.TO.highlights;
            
            [self.infoView.descTXT setFont:[UIFont systemFontOfSize:15.0f]];
            [self.infoView.descTXT setTextColor:[UIColor darkGrayColor]];

        }
        else
        {
            self.infoView.descTXT.text = self.TO.desc;
            
            [self.infoView.descTXT setFont:[UIFont systemFontOfSize:15.0f]];
            [self.infoView.descTXT setTextColor:[UIColor darkGrayColor]];

        }
        
        if (self.TO.desc == NULL && self.TO.highlights == NULL) {
            
            self.infoView.descTXT.text = @"None";
            
            [self.infoView.descTXT setFont:[UIFont systemFontOfSize:15.0f]];
            [self.infoView.descTXT setTextColor:[UIColor darkGrayColor]];

        }
        
        
        if ([self.TO.termsAndConditions isEqualToString:@""] || self.TO.termsAndConditions == NULL) {
            
            self.infoView.moreInfoTXT.text = self.TO.knowBeforeBook;
            
            [self.infoView.moreInfoTXT setFont:[UIFont systemFontOfSize:15.0f]];
            [self.infoView.moreInfoTXT setTextColor:[UIColor darkGrayColor]];


        }
        else
        {
            self.infoView.moreInfoTXT.text = self.TO.termsAndConditions;
            
            [self.infoView.moreInfoTXT setFont:[UIFont systemFontOfSize:15.0f]];
            [self.infoView.moreInfoTXT setTextColor:[UIColor darkGrayColor]];
            
        }
        
        if (self.TO.termsAndConditions == NULL && self.TO.knowBeforeBook == NULL)
        {
            self.infoView.moreInfoTXT.text = @"None";
            
            [self.infoView.moreInfoTXT setFont:[UIFont systemFontOfSize:15.0f]];
            [self.infoView.moreInfoTXT setTextColor:[UIColor darkGrayColor]];
        }
        
        self.availPriceFooter.text = self.TO.priceFootnote;
        
        [self.infoView.tableView reloadData];
        
        
        [loading stopAnimating];
        [loading removeFromSuperview];
        
        [self.view setUserInteractionEnabled:YES];
        
    });
   
    int countUrl = 0;
    for (NSString *item in self.TO.imageARR)
    {
        [self.PO downloadImages:item :countUrl :self.TO.title :countUrl];
        
        countUrl++;

    }
    
}

- (void)locationAction:(id)sender
{
  
    MapViewController *map = [self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
    map.name = self.TO.title;
    map.imgData = [self.imagesData firstObject];
    map.longitude = self.TO.longitude;
    map.latitude = self.TO.latitude;
    map.address = self.tourAddress;
    map.number = self.TO.category;
    
    
    map.navigationItem.title = self.TO.title;
    
    [self.navigationController pushViewController:map animated:YES];
    
}

//Tour Availabilities Delegate
-(void)tourAvailDownloaded:(id)tourOBJ
{
    [self.availabilities addObject:tourOBJ];
    
}

//Image Downladed Delegate
-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    self.imageDownloadCount++;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^(void){
        
        if (imageDATA!=NULL)
        {
            [self.imagesData addObject:imageDATA];
                        
            if (self.tourImageView.image == NULL)
            {
                self.tourImageView.image = [UIImage imageWithData:imageDATA];
                [self.tourImageView fadeInObject:self.tourImageView duration:.2 option:UIViewAnimationOptionCurveEaseIn];
            }
            
        }
        
        if (self.imageDownloadCount == [self.TO.imageARR count]) {
            
            [self.animImageLoading stopAnimating];
            [self.animImageLoading setHidden:YES];
            
        }
        
    });
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"imageSegue"]) {
        
        ImageSiderPageViewController *image = (ImageSiderPageViewController *)[segue destinationViewController];
        image.titleName = self.favoriteName;
        image.imagesData = self.imagesData;
    }
    else if ([segue.identifier isEqualToString:@"bookingSegue"]) {
        
        BookingContainerController *bookingContainer = (BookingContainerController*)[segue destinationViewController];
        bookingContainer.tourID =  self.TO.activityID;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.bookingData = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                        @"tourID":self.TO.activityID,
                                                                        @"currencyCode":self.TO.currencyCode,
                                                                        @"tourTitle":self.TO.title,
                                                                        @"valueDate":[(TourObject *)[self.availabilities objectAtIndex:self.availTableView.indexPathForSelectedRow.row]valueDate]
                                                                        
                                                                        }];

    }

}




//Show selected tab button
-(void)showSelectedBT:(UIButton *)button
{
    
    UIButton *options[] ={
        self.info,
        self.avail,
    };
    
    
    for (int i=0; i < 2; i++) {
        
        if (button == options[i])
        {
            options[i].backgroundColor = self.navigationController.navigationBar.tintColor;
            [options[i].titleLabel setTextColor:[UIColor whiteColor]];
            
        }
        else
        {
            options[i].backgroundColor = [UIColor whiteColor];
            [options[i].titleLabel setTextColor:[UIColor blackColor]];
            
        }
        
    }
}

//set up info view
- (IBAction)infoAction:(id)sender
{
    if (selectedTab != 0) {
        
        [self.bookButton setHidden:YES];
        
        selectedTab = 0;
        [self showSelectedBT:self.info];
        [self.availTableView removeFromSuperview];
        [self setUpInfoView];
       
    }
}

-(void)setUpInfoView
{
    //set ScrollView ContentSize
    NSInteger rows = [self.infoView tableView:self.infoView.tableView numberOfRowsInSection:0];
    
    tableViewContentHieight = 0;
    for (int i = 0; i < rows ; i++)
    {
        
        tableViewContentHieight += [self.infoView tableView:self.infoView.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    NSLog(@"Tableview content height: %f",tableViewContentHieight);
    
    
    //scrollview contentsize height = scrollview height + (detail container height - infoview tableview content height)
    scrollContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, tableViewContentHieight + self.tabView.bounds.size.height + self.imageButton.bounds.size.height);
    
    
    CGRect containerFrame = self.detailsContainer.frame;
    containerFrame.size = scrollContentSize;
    self.infoView.tableView.frame = containerFrame;
    
    [self.detailsScrollView setContentSize:scrollContentSize];
   // [self.infoView.tableView setContentSize:scrollContentSize];
    
    [self.detailsScrollView addSubviewWithFadeAnimation:self.infoView.tableView duration:.1 option:UIViewAnimationOptionCurveEaseIn];
    
}



//Availability View Action
- (IBAction)availAction:(id)sender {
    
    if (selectedTab != 1) {
        
        
        if ([self.availabilities count] < 1 ) {
            
            [self.bookButton setEnabled:NO];
            [self.bookButton setHidden:YES];
            [self.availHeader setHidden:YES];
            self.availPriceFooter.text = @"Not currently available. Please try again later";
        }
        else
        {
            [self.availHeader setHidden:NO];
            self.availPriceFooter.text = @"";
        }
        
        selectedTab = 1;
        [self showSelectedBT:self.avail];

        [self.infoView.tableView removeFromSuperview];
        [self setUpAvailView];

    }

}

-(void)setUpAvailView
{
    //set ScrollView ContentSize
    NSInteger rows = [self tableView:self.availTableView numberOfRowsInSection:0];
    
    tableViewContentHieight = 0;
    for (int i = 0; i < rows ; i++)
    {
        
        tableViewContentHieight += [self tableView:self.availTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    tableViewContentHieight+=self.availTableView.tableHeaderView.frame.size.height;
    
    NSLog(@"Tableview content height: %f",tableViewContentHieight);
    
    //scrollview contentsize height = scrollview height + (detail container height - infoview tableview content height)
    scrollContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, tableViewContentHieight + self.tabView.bounds.size.height + self.bookButton.frame.size.height  + self.imageButton.bounds.size.height);

    
    CGRect containerFrame = self.detailsContainer.frame;
    containerFrame.size = scrollContentSize;
    self.availTableView.frame = containerFrame;
    
    [self.detailsScrollView setContentSize:scrollContentSize];
    //[self.availTableView setContentSize:scrollContentSize];
    
    [self.detailsScrollView addSubviewWithFadeAnimation:self.availTableView duration:.1 option:UIViewAnimationOptionCurveEaseIn];
}

//add to Favourite
-(void)addItemToFavorites:(id)sender
{
    if ([self checkIfFavrouite])
    {
        
        NSLog(@" item already a favourite ");
                
        /*
        NSString *FavDeleted = [[NSString alloc]initWithFormat:@"%@ has been removed from favourite",_favoriteName ];
       //Favourite alert
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Favorite Removed"
                                      message:FavDeleted
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        */
        
        NSMutableArray* tmpArray = [self.theFav copy];
        
        for (NSDictionary *favItem in tmpArray) {
            
            if ([_favoriteName isEqualToString:favItem[@"Name"]] && [_favoriteType isEqualToString:favItem[@"Type"]])
            {
                [self.theFav removeObject:favItem];
            }
            
        }
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        [self.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    else
    {
       /* NSString *FavAdded = [[NSString alloc]initWithFormat:@"%@ has been added to favourite",_favoriteName ];
        
        
        //Favourite alert
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Favorite Added"
                                      message:FavAdded
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil]; */
        
        
        //Savve item to favourite
        if (_favoriteImgURL==nil) {
            _favoriteImgURL=@"null";
        }
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        NSMutableDictionary *details = [NSMutableDictionary
                                        dictionaryWithDictionary:@{@"Name":_favoriteName,
                                                                   @"Type":_favoriteType,
                                                                   @"ImgUrl":_favoriteImgURL,
                                                                   @"ImgNO":_favoriteImgNO,
                                                                   @"Details":_favoriteDetails,
                                                                   @"CountryCode":app.userCountry[@"CountryCode"],

                                                                   }];
        
        [_theFav addObject:details];
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        
        //Save Image folder
        [self.PO downloadImages:_favoriteImgURL :[_favoriteImgNO intValue] :_favoriteName :0];
        
        [self.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
        
        
        
    }
    
    
    
}


//Check Favourites
-(BOOL)checkIfFavrouite
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _destinationPath = appDelegate.favoritePath;
    
    self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
    
    if(_destinationPath==NULL)
    {
        
        _destinationPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"favourites"] ofType:@"plist"];
        
        self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
        
    }
    
    NSMutableArray* tmpArray = [self.theFav copy];
    
    for (NSDictionary *favItem in tmpArray) {
        
        if ([_favoriteName isEqualToString:favItem[@"Name"]] && [_favoriteType isEqualToString:favItem[@"Type"]])
        {
            
            NSLog(@"item exist in favourite file");
            
            return true;
            
        }
        
    }
    
    
    NSLog(@"item does not exist in favourite file");
    
    
    return false;
    
}



@end
