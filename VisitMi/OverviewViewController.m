//
//  OverviewViewController.m
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "OverviewViewController.h"

@interface OverviewViewController ()

@end


@implementation OverviewViewController

{
    UIView *selectedView;
    UIButton *selectedButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    self.descTV.text=  self.desc;
    self.numLB.text = self.phoneNumber;
    self.addressLB.text = self.address;
    
    self.scrollView.delegate = self;
    self.descTV.delegate = self;
    
    self.tourTableView.delegate = self;
    self.tourTableView.dataSource = self;
    
    self.tourTableView.estimatedRowHeight = 215.f;
    self.tourTableView.rowHeight = 215;
    [self.tourTableView registerNib:[UINib nibWithNibName:@"TourTableViewCell" bundle:nil] forCellReuseIdentifier:@"tourCell"];
    
    //load spinnerview to tableview
    self.spinnerView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    CGFloat yPosition = self.tourTableView.frame.size.height/2 - (self.spinnerView.frame.size.height/2);
    CGFloat xPosition = self.tourTableView.frame.size.width/2 - (self.spinnerView.frame.size.width/2);
    self.spinnerView.frame = CGRectMake(xPosition, yPosition, 40, 40);
    [self.spinnerView setHidden:NO];
    [self.spinnerView startAnimating];
    [self.tourTableView setBackgroundView:self.spinnerView];
    
    //initiate img count to 0
    _x = 0;
    _imageCount = 0;
    
  
    //Add Image Scrollview to container
    CGRect containerFrame = self.imageContainerView.frame;
    containerFrame.origin = CGPointMake(0, 0);
    self.scrollView.frame = containerFrame;
    [self.imageContainerView addSubview:_scrollView];
    
    
    //TabView Shadow
    self.tabView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tabView.layer.shadowOpacity = .5;
    self.tabView.layer.shadowRadius = 4.f;
    
    //Circular Corner radius
    [self.leftImg.layer setCornerRadius:self.leftImg.frame.size.height/2];
    [self.leftImg.layer setMasksToBounds:YES];
    self.leftImg.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.leftImg.layer.shadowOpacity = 1.0f;
    self.leftImg.layer.shadowRadius = 3;
    
    [self.rightImg.layer setCornerRadius:self.rightImg.frame.size.height/2];
    [self.rightImg.layer setMasksToBounds:YES];
    self.rightImg.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.rightImg.layer.shadowOpacity = .5;
    self.rightImg.layer.shadowRadius = 3;
    
        
    [self.tourCountLB.layer setCornerRadius:7.5f];
    [self.tourCountLB.layer setMasksToBounds:YES];
    self.tourCountLB.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tourCountLB.layer.shadowOpacity = .5;
    self.tourCountLB.layer.shadowRadius = 3;
    
    
    
    //1
    self.pageImages = [[NSMutableArray alloc]init];
    
    // 2
    
    self.pageControl.currentPage = 0;
    //self.pageControl.numberOfPages = pageCount;
    
    
    self.scrollView.pagingEnabled=YES;
    [self.scrollView sizeToFit];
    
    
    
    PlaceObject *PO = [[PlaceObject alloc]init];
    PO.delegate = self;
    
    
    //Download and save images
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int count = 0;

        for (NSString *url in self.imageURLARR)
        {
            
            [PO downloadImages:url :count :self.name :count];
            
            
            count++;
        }

    });
    
    self.descTV.scrollsToTop = YES;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return _presentCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tourCell = [tableView dequeueReusableCellWithIdentifier:@"tourCell" forIndexPath:indexPath];
    [self.tourCell sizeToFit];
    
    self.TO= (TourObject *)[self.tourItems objectAtIndex:indexPath.row];
    
    self.tourCell.nameLB.text = self.TO.title;
    self.tourCell.durationLB.text = self.TO.duration;
    self.tourCell.currencyLB.text = self.TO.currencyCode;
    self.tourCell.priceLB.text = [NSString stringWithFormat:@"%.2f",self.TO.priceRange];
    self.tourCell.activityIMG.image = [UIImage imageWithData:self.TO.thumbnailData];
    
    
    self.tourCell.favButton.tag = indexPath.row;
    [self.tourCell.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];

    
    //Assign colour to favourite button based on favourite availability
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   // dispatch_async(queue, ^(void){
        
        if([self checkIfFavrouite:indexPath.row])
        {
            
            [self.tourCell.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
            
        }
        
        else
        {
            
            [self.tourCell.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
            
        }
        
        
        

        
  //  });
    
   
    return self.tourCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    TourViewController *tours = [self.storyboard instantiateViewControllerWithIdentifier:@"tourView"];
    
    self.TO = (TourObject *)[self.tourItems objectAtIndex:indexPath.row];

    tours.title = self.TO.title;
    tours.imageDownloadCount = 0;
    tours.favoriteType = @"Tours & Activities";
    tours.favoriteImgURL = self.TO.thumbnailURL;
    tours.favoriteName =  self.TO.title;
    tours.favoriteImgNO = @"0";
    tours.favoriteDetails = self.TO.activityID;
    
    tours.imagesData = [[NSMutableArray alloc]init];
    tours.availabilities = [[NSMutableArray alloc]init];
    
    DBConnect *conn = [[DBConnect alloc]init];
    conn.delegate = tours;
    [conn GetTourWithID:self.TO.activityID CountryCode:appDelegate.userCountry[@"CountryCode"]];
    
    [conn GetTourAvailabilities:self.TO.activityID CountryCode:appDelegate.userCountry[@"CountryCode"]];
    
    [self.navigationController pushViewController:tours animated:YES];
    
}

-(void)updateTableData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        _presentCount = self.tourItems.count;
       
        if (_presentCount!= 0 && _count != _presentCount)
        {
            [self.tourTableView beginUpdates];
            
            self.indexPaths = [[NSMutableArray alloc] init];
            
            
            for (NSUInteger i = _count; i < _presentCount; i++)
            {
                [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.tourTableView insertRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationTop];
            
            [self.tourTableView endUpdates];
            
            _count = _presentCount;
            
            self.tourCountLB.text = [NSString stringWithFormat:@"%d", self.tourCount];

            [self updateTableData];            
            
            
        }
        else if (self.tourItems.count == 0 && self.tourCount!=0)
        {
            [self updateTableData];
            
        }
        else  if (_presentCount== self.tourCount)
        {
            self.tourCountLB.text = [NSString stringWithFormat:@"%d", self.tourCount];
            
            [_spinnerView stopAnimating];
            [self.spinnerView setHidden:YES];
            [self.tourTableView reloadData];

        }
        else if(_presentCount==self.count && _presentCount !=self.tourCount)
        {
            [self updateTableData];
        }
        else if (self.tourCount==0)
        {
            [self.tourTableView setBackgroundView:self.backgroundView];
            
        }
        
       
        
    });

}


//add to Favourite
-(void)addItemToFavorites:(UIButton *)sender
{

    PlaceObject *PO = [[PlaceObject alloc]init];
    TourObject *TO= (TourObject *)[self.tourItems objectAtIndex:sender.tag];
    TourTableViewCell *TC = [self.tourTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
    NSLog(@" selected rows BT name = %@ ",TC.nameLB.text);

    if ([self checkIfFavrouite:sender.tag])
    {
        
        
        
        
        NSMutableArray* tmpArray = [self.theFav copy];
        
        for (NSDictionary *favItem in tmpArray) {
            
            if ([TO.activityID isEqualToString:favItem[@"Details"]] && [@"Tours & Activities" isEqualToString:favItem[@"Type"]])
            {
                [self.theFav removeObject:favItem];
               
            }
            
        }
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        [TC.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [TC.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        NSMutableDictionary *details = [NSMutableDictionary
                                        dictionaryWithDictionary:@{@"Name":TO.title,
                                                                   @"Type":@"Tours & Activities",
                                                                   @"ImgUrl":TO.thumbnailURL,
                                                                   @"ImgNO":@"4",
                                                                   @"Details":TO.activityID,
                                                                   @"CountryCode":app.userCountry[@"CountryCode"],
                                                                   }];
        
        [_theFav addObject:details];
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        //Save Image to folder
        [PO downloadImages:TO.thumbnailURL :0 :TO.title :0];
        
        [TC.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [TC.favButton  setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
        
        
        
    }
    
    
    
}


-(BOOL)checkIfFavrouite:(NSInteger)callerIndex
{
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _destinationPath = appDelegate.favoritePath;
    
    self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
    
    TourObject *TO= (TourObject *)[self.tourItems objectAtIndex:callerIndex];


    if(_destinationPath==NULL)
    {
        
        _destinationPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"favourites"] ofType:@"plist"];
        
        self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
        
    }
    
    
    NSMutableArray* tmpArray = [self.theFav copy];
    
    for (NSDictionary *favItem in tmpArray) {
        
        if ([TO.activityID isEqualToString:favItem[@"Details"]] && [@"Tours & Activities" isEqualToString:favItem[@"Type"]])
        {
            
            NSLog(@"item exist in favourite file");
            
            return true;
            
        }
        
    }
    
    
    NSLog(@"item does not exist in favourite file");
    
    
    
    return false;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tourCountLB.text = [NSString stringWithFormat:@"%d", self.tourCount];
    [self.tourCountLB bounce:.5 option:UIViewAnimationOptionCurveEaseIn];
    [self.tourTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //Select Default Tab
        [self infoBTAction:self.infoBT];

    });
    
    
    if (self.delegate) {
        
        [self.delegate toScrollViewAction:self.tourTableView];
    }
    
    [self loadVisiblePages];
    
    // 5
}


-(void)loadVisiblePages
{
    
    CGFloat pageWidth = [[UIScreen mainScreen] bounds].size.width;
    
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page * 0;
    NSInteger lastPage = _imageCount-1;
    
    if (self.pageControl.currentPage == firstPage) {
        
        [self.leftImg fadeOutObject:self.leftImg duration:.1 option:UIViewAnimationOptionCurveEaseOut];
        
    }
    
    else if (self.pageControl.currentPage == lastPage) {
        
        [self.rightImg fadeOutObject:self.rightImg duration:.1 option:UIViewAnimationOptionCurveEaseOut];
        
    }
    
    else
    {
        [self.leftImg setHidden:NO];
        
        [self.rightImg setHidden:NO];
        
    }

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    if (scrollView == self.tourTableView || scrollView == self.descTV)
    {
        if (self.contentsView.contentSize.height > self.contentsView.frame.size.height)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            [self.contentsView setContentOffset:CGPointMake(0,(self.contentsView.contentSize.height - self.contentsView.frame.size.height)) animated:YES];
            
            [UIView commitAnimations];
            
            
        }
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (scrollView == self.scrollView) {
        
        // Load the pages that are now on screen
        [self loadVisiblePages];
    
    }
    else if (scrollView == self.tourTableView)
    {
        
        if (self.delegate) {
            
            [self.delegate toScrollViewAction:self.tourTableView];
        }
    }
   
}

//Tour Image delegate reference Method
-(void)loadTourImages: (NSData *)imageDATA :(NSInteger)index
{
    
    self.TO = (TourObject *)[self.tourItems objectAtIndex:index];
    self.TO.thumbnailData = imageDATA;
    
    [self.tourTableView reloadData];
}

//Attraction Delegate Method
-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index{
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^(void){
        
        //1
        
        if (imageDATA!=NULL)
        {
            //create img view
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(_x, 0,[[UIScreen mainScreen] bounds].size.width, self.scrollView.frame.size.height)];
            
            //add image
            img.image=[UIImage imageWithData:imageDATA];
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            _x =_x+[[UIScreen mainScreen] bounds].size.width;
            
            //addimgviw to img scroll view
            [self.scrollView addSubviewWithZoomInAnimation:img duration:.1f option:UIViewAnimationOptionTransitionFlipFromLeft];
            
            _imageCount++;
            
            
            self.scrollView.contentSize=CGSizeMake(_x, self.scrollView.frame.size.height);
            self.scrollView.contentOffset=CGPointMake(0, 0);
            
            
            // 2
            NSInteger pageCount = _imageCount;
            
            
            self.pageControl.numberOfPages = pageCount;
            
            NSLog(@"Images added");
            
            
        }
      
        
    });
    
    
}


-(void)showSelectedBT:(UIButton *)button
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        UIButton *options[] ={
            self.infoBT,
            self.contactBT,
            self.toursBT
        };
        
        
        for (int i=0; i < 3; i++) {
            
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
        
    });
   
    
}
- (IBAction)infoBTAction:(id)sender {
    
    if (selectedButton != (UIButton *)sender) {
        
        [selectedView removeFromSuperview];
        CGRect containerFrame = self.referenceView.frame;
        containerFrame.origin = CGPointMake(0, 0);
        self.infoView.frame = containerFrame;
        selectedView = _infoView;
        selectedButton =_infoBT;
        [self showSelectedBT:selectedButton];
        [self.referenceView addSubviewWithFadeAnimation:selectedView duration:.1 option:UIViewAnimationOptionCurveEaseIn];

    }

}

- (IBAction)contactBTAction:(id)sender {
    
    if (selectedButton != (UIButton *)sender) {
        
        [selectedView removeFromSuperview];
        CGRect containerFrame = self.referenceView.frame;
        containerFrame.origin = CGPointMake(0, 0);
        self.contactView.frame = containerFrame;
        selectedView = _contactView;
        selectedButton =_contactBT;
        [self showSelectedBT:selectedButton];
        [self.referenceView addSubviewWithFadeAnimation:selectedView duration:.1 option:UIViewAnimationOptionCurveEaseIn];
        
        
    }
   
}

- (IBAction)toursBTAction:(id)sender {
    
    if (selectedButton != (UIButton *)sender) {
        
        [selectedView removeFromSuperview];
        CGRect containerFrame = self.referenceView.frame;
        containerFrame.origin = CGPointMake(0, 0);
        self.toursView.frame = containerFrame;
        selectedView = _toursView;
        selectedButton =_toursBT;
        [self showSelectedBT:selectedButton];
        [self.referenceView addSubviewWithFadeAnimation:selectedView duration:.1 option:UIViewAnimationOptionCurveEaseIn];


    }
   
}

- (IBAction)callAction:(id)sender {
    
    NSString *phNo = self.phoneNumber;
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:nil];
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Call facility not available !!"
                                      message:@"please try again later"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     //Select Default Tab
                                     [self contactBTAction:self.contactBT];
                                     
                                 });
                                 

                             }];
        
        [alert addAction:ok];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
            }
    
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
