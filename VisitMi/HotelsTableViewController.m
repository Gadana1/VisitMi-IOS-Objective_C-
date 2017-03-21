//
//  HotelsTableViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 01/02/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "HotelsTableViewController.h"

@interface HotelsTableViewController ()

@end

@implementation HotelsTableViewController

NSString *name;
NSArray* tmpArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    
    self.automaticallyAdjustsScrollViewInsets = YES;

    self.scopes = [NSMutableArray arrayWithObjects:@"Price",@"Distance",@"Star Ratings", nil];

    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.estimatedRowHeight = 170.f;
    self.tableView.rowHeight = 170;
    [self.tableView registerNib:[UINib nibWithNibName:@"HotelTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotelCell"];
    
    _spinner.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-20,([UIScreen mainScreen].bounds.size.height/2)-84, 40.0, 40.0);
    [self.tableView setBackgroundView:_spinner];

    //mainHeaderView Shadow
    self.mainHeaderView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.mainHeaderView.layer.shadowOpacity = .4;
    self.mainHeaderView.layer.shadowRadius = 3.f;
    self.mainHeaderView.layer.shadowOffset = CGSizeMake(0, -2);
    CGRect leftShaddowBounds = CGRectMake(self.mainHeaderView.bounds.origin.x, self.mainHeaderView.bounds.origin.y, self.mainHeaderView.bounds.size.width,self.mainHeaderView.bounds.size.height);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:leftShaddowBounds];
    self.mainHeaderView.layer.shadowPath = shadowPath.CGPath;
    
    
    //Set up alert
    _alert=   [UIAlertController
               alertControllerWithTitle:@"NO HOTELS FOUND!"
               message:nil
               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* retry = [UIAlertAction
                            actionWithTitle:@"Retry"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [_alert dismissViewControllerAnimated:YES completion:nil];
                                
                                if ([self.spinner isHidden]) {
                                    
                                    [self.spinner setHidden:NO];
                                    [self.spinner startAnimating];
                                }
                                
                                [self performSelector:@selector(checkHotelCount) withObject:nil afterDelay:3];
                                [self.tableView reloadData];
                                
                            }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"close"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [_alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.spinner stopAnimating];
                                 [self.spinner setHidden:YES];
                             }];
    
    [_alert addAction:retry];
    [_alert addAction:cancel];
    
    
    //Refresh Control Settings
    CGFloat yPosition = self.mainHeaderView.frame.origin.y + self.mainHeaderView.frame.size.height + 100;
    CGFloat xPosition = self.navigationController.navigationBar.frame.size.width/2;
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(xPosition,yPosition, 50, 50)];
    [self.refreshControl addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.backgroundView = self.refreshControl;
    
    
    [self checkHotelCount];

}

-(void)checkHotelCount
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(!_isSorted)
        {
            _presentCount = self.hotelsItems.count;
            
            if(self.hotelTotal==0)
            {
                
                [self presentViewController:_alert animated:YES completion:nil];
                
                
            }
            
            else if (_presentCount!= 0 && self.hotelCount != _presentCount)
            {
                
                
                self.indexPaths = [[NSMutableArray alloc] init];
                
                [self.tableView beginUpdates];
                
                
                for (NSUInteger i = self.hotelCount; i < _presentCount; i++)
                {
                    [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                
                [self.tableView insertRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
                [self.tableView endUpdates];
                
                self.hotelCount = _presentCount;
                
                [self performSelector:@selector(checkHotelCount) withObject:nil afterDelay:1];
                
                NSLog(@"Hotel items recieved");
                
                
            }
            
            else if(self.hotelCount==0)
            {
                [self checkHotelCount];
                
            }
            
            else if(_presentCount==self.hotelTotal)
            {
                
                [self.spinner stopAnimating];
                [self.spinner setHidden:YES];
                
                NSString *badge = [[NSString alloc]initWithFormat:@"%lu",_presentCount];
                self.tabBarItem.badgeValue =badge;
                
                [self.tableView reloadData];
                
                NSLog(@"Hotel download finish");
                
            }
            
            else if(_presentCount==self.hotelCount && _presentCount !=self.hotelTotal)
            {
                [self checkHotelCount];
            }
            
            
            
        }
        
        else
        {
            _presentCount = self.sortHotel.count;
            
            if(self.hotelTotal==0)
            {
                
                [self presentViewController:_alert animated:YES completion:nil];
                
            }
            
            else if (_presentCount!= 0 && self.sortedCount != _presentCount)
            {
                
                
                self.indexPaths = [[NSMutableArray alloc] init];
                
                [self.tableView beginUpdates];
                
                
                for (NSUInteger i = self.sortedCount; i < _presentCount; i++)
                {
                    [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                
                [self.tableView insertRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
                [self.tableView endUpdates];
                
                self.sortedCount = _presentCount;
                
                [self checkHotelCount];
                
                NSLog(@"Hotel items sorted");
                
                
            }
            else if (self.sortedCount == _presentCount)
            {
                [self checkHotelCount];
            }
            
        }
        
        
    });
    
    
}

- (IBAction)optionAcc:(id)sender {
    if (self.scopes.count > 0) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Sort by :"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        
        for (int i = 0; i < self.scopes.count; i++) {
            
            UIAlertAction* interest = [UIAlertAction
                                       actionWithTitle:[self.scopes objectAtIndex:i]
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           if ([[self.scopes objectAtIndex:i] isEqualToString:@"Distance"]) {
                                               
                                               if (!_isSorted)
                                               {
                                                   NSArray *sortedLocations = [_hotelsItems sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:H1.distance] compare:[NSNumber numberWithDouble:H2.distance]];
                                                   }];
                                                   
                                                   self.hotelsItems = [NSMutableArray arrayWithArray:sortedLocations];
                                                   

                                               }
                                               else
                                               {
                                                   NSArray *sortedLocations = [_sortHotel sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:H1.distance] compare:[NSNumber numberWithDouble:H2.distance]];
                                                   }];
                                                   
                                                   self.sortHotel = [NSMutableArray arrayWithArray:sortedLocations];
                                                   

                                               }
                                              
                                               [self.tableView reloadData];
                                               
                                           }
                                           else if ([[self.scopes objectAtIndex:i] isEqualToString:@"Price"]) {
                                               
                                               if (!_isSorted)
                                               {
                                                   NSArray *sortedLocations = [_hotelsItems sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:H1.lowRate] compare:[NSNumber numberWithDouble:H2.lowRate]];
                                                   }];
                                                   
                                                   self.hotelsItems = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                               }
                                               else
                                               {
                                                   NSArray *sortedLocations = [_sortHotel sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:H1.lowRate] compare:[NSNumber numberWithDouble:H2.lowRate]];
                                                   }];
                                                   
                                                   self.sortHotel = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                               }
                                               
                                               [self.tableView reloadData];
                                               
                                           }
                                           else if ([[self.scopes objectAtIndex:i] isEqualToString:@"Star Ratings"]) {
                                               
                                               if (!_isSorted)
                                               {
                                                   NSArray *sortedLocations = [_hotelsItems sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:[H1.starRating doubleValue]] compare:[NSNumber numberWithDouble:[H2.starRating doubleValue]]];
                                                   }];
                                                   
                                                   self.hotelsItems = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                               }
                                               else
                                               {
                                                   NSArray *sortedLocations = [_sortHotel sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:[H1.starRating doubleValue]] compare:[NSNumber numberWithDouble:[H2.starRating doubleValue]]];
                                                   }];
                                                   
                                                   self.sortHotel = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                               }
                                               
                                               [self.tableView reloadData];
                                               
                                           }
                                           
                                           
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            [alert addAction:interest];
            
            
        }
        
        UIAlertAction* close = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        [alert addAction:close];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


//Update Table when Refresh is trigerred
-(void)update:(id)sender
{
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1];
}
-(void)updateTable
{
    
    //[self checkHotelCount];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _presentCount;
        
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     _cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    [_cell sizeToFit];

    
    if (!self.isSorted)
    {
        
        tmpArray = [self.hotelsItems copy];
        
        self.HO = (HotelObject *)[tmpArray objectAtIndex:indexPath.row];

    }
    else
    {
        tmpArray = [self.sortHotel copy];

        self.HO = (HotelObject *)[tmpArray objectAtIndex:indexPath.row];

    }
    
    if (self.hotelsItems.count>0 || self.sortHotel.count>0) {
        
        _cell.nameLB.text = self.HO.name;
        _cell.cityLB.text = self.HO.city;
        
        _cell.hotelthumbnail.backgroundColor = [UIColor clearColor];
        //Customize Image view
        if (self.HO.thumbnailData !=NULL) {
            
            _cell.hotelthumbnail.contentMode = UIViewContentModeScaleToFill;
            [_cell.hotelthumbnail setImage:[UIImage imageWithData:self.HO.thumbnailData]];
            if(_cell.hotelthumbnail.image==NULL)
            {
                _cell.hotelthumbnail.contentMode = UIViewContentModeScaleAspectFit;
                [_cell.hotelthumbnail setImage:[UIImage imageNamed:@"image_file.png"]];
                
            }
            
        }
        
        
        [_cell.taxiImg setHidden:YES];
        [_cell.taxiBT setHidden:YES];
        
        [_cell.mapImg setImage:[UIImage imageNamed:@"center_direction.png"]];
        [_cell.mapBt setTitle:@"Location" forState:UIControlStateNormal];
    
        _cell.currencyCode.text = self.HO.rateCurrencyCode;
        _cell.price.text = [NSString stringWithFormat:@"%.2f",self.HO.lowRate];
    
        _cell.distanceLB.text = self.HO.place_distance;

        double rating = [self.HO.starRating doubleValue];
        
        if (rating == 1) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"1star.png"]];
            
        }
        if (rating >= 1.5) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"1.5star.png"]];
            
        }
        if (rating >= 2) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"2star.png"]];
            
        }
        if (rating >= 2.5) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"2.5star.png"]];
            
        }
        if (rating >= 3) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"3star.png"]];
            
        }
        if (rating >= 3.5) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"3.5star.png"]];
            
        }
        if(rating >= 4) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"4star.png"]];
            
        }
        if(rating >= 4.5) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"4.5star.png"]];
            
        }
        if(rating >= 5) {
            
            [_cell.ratingIMG setImage:[UIImage imageNamed:@"5star.png"]];
            
        }
        
        _cell.bookBT.tag =indexPath.row;
        [_cell.bookBT addTarget:self action:@selector(openWebView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cell.locationBT setTag:indexPath.row];
        [self.cell.locationBT addTarget:self action:@selector(openMapView:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
    
    return _cell;
}


-(void)openMapView: (UIButton *)sender
{
    NSLog(@"Loc button tapped Index %ld",sender.tag);
    
    NSUInteger row = sender.tag;
    
    if (!self.isSorted)
    {
        
        
        self.HO = (HotelObject *)[self.hotelsItems objectAtIndex:row];
        
    }
    else
    {
        
        self.HO = (HotelObject *)[self.sortHotel objectAtIndex:row];
        
    }

    if (self.delegate) {
        
        [self.delegate showMapViewFromHotel];
    }
    
    if (self.delegateForMap) {
        
        [self.delegateForMap selectHotelMarker:self.HO.name];
    }
    
    
    
}


-(void)openWebView: (UIButton *)sender
{
    
    NSLog(@"button tapped Index %ld",sender.tag);
    
    NSUInteger row = sender.tag;
    
    if (!self.isSorted)
    {
        
        
        self.HO = (HotelObject *)[self.hotelsItems objectAtIndex:row];
        
    }
    else
    {
         
        self.HO = (HotelObject *)[self.sortHotel objectAtIndex:row];
        
    }
    self.svwWebView = [[SVWebViewController alloc]init];
    
    self.svwWebView.favoriteFilter = self.HO.name;
    self.svwWebView.favoriteType = @"Lodging";
    self.svwWebView.favoriteImgURL = self.HO.thumbnailURL;
    self.svwWebView.favoriteImgNO = @"1";
    self.svwWebView.title = self.HO.name;
    [self.svwWebView loadWebPage:self.HO.detailURL];
    self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self.navigationController pushViewController:self.svwWebView animated:YES];
    
    
}


-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    
    self.HO = (HotelObject *)[self.hotelsItems objectAtIndex:index];
    self.HO.thumbnailData = imageDATA;
    
    [self.tableView reloadData];
}

- (IBAction)sortinigAction:(id)sender {
    
    double rating;
    
    if (self.sorting.selectedSegmentIndex==0) {
        
        _hotelCount  = 0;
        _sortedCount = 0;
        _presentCount = 0;
        
        self.sortHotel = [[NSMutableArray alloc]init];
        [self.tableView reloadData];
       
        self.isSorted = false;

        [self checkHotelCount];
        
    }
    else if (self.sorting.selectedSegmentIndex==1) {
        
        _sortedCount = 0;
        _presentCount = 0;

        self.sortHotel = [[NSMutableArray alloc]init];
        [self.tableView reloadData];

        tmpArray = [self.hotelsItems copy];
        
        for (HotelObject *hotelObj in tmpArray )
        {
            rating = [hotelObj.starRating doubleValue];
            
            if(rating==5)
            {
                [self.sortHotel addObject:hotelObj];
            }
        }
        
        self.isSorted = true;
        [self checkHotelCount];
        
    }
    else if (self.sorting.selectedSegmentIndex==2) {

        _sortedCount = 0;
        _presentCount = 0;

        self.sortHotel = [[NSMutableArray alloc]init];
        [self.tableView reloadData];

        tmpArray = [self.hotelsItems copy];
        
        for (HotelObject *hotelObj in tmpArray )
        {
            rating = [hotelObj.starRating doubleValue];
            
            if(rating<=4 && rating>3)
            {
                [self.sortHotel addObject:hotelObj];
            }
        }
        
        self.isSorted = true;
        [self checkHotelCount];
        
    }
    else if (self.sorting.selectedSegmentIndex==3) {

        _sortedCount = 0;
        _presentCount = 0;
        
        self.sortHotel = [[NSMutableArray alloc]init];
        
        [self.tableView reloadData];

        tmpArray = [self.hotelsItems copy];
        
        for (HotelObject *hotelObj in tmpArray )
        {
            rating = [hotelObj.starRating doubleValue];
            
            if(rating<=3 && rating>2)
            {
                [self.sortHotel addObject:hotelObj];
            }
        }
        
        self.isSorted = true;
        [self checkHotelCount];
        
    }
    else if (self.sorting.selectedSegmentIndex==4) {
        
        _sortedCount = 0;
        _presentCount = 0;

        self.sortHotel = [[NSMutableArray alloc]init];
        
        [self.tableView reloadData];

        tmpArray = [self.hotelsItems copy];
        
        for (HotelObject *hotelObj in tmpArray )
        {
            rating = [hotelObj.starRating doubleValue];
            
            if(rating<=2)
            {
                [self.sortHotel addObject:hotelObj];
            }
            
        }
        
        self.isSorted = true;
        [self checkHotelCount];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.delegate) {
        
        [self.delegate hoScrollViewAction:self.tableView];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.tableView scrollRectToVisible:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) animated:YES];

    
}

@end
