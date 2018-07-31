//
//  HomeViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 06/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

BOOL revealActivated;
BOOL autocompleteShowing;
BOOL autocompleteSelected;

UITextField *activeTextField;
AppDelegate *app;
FlightObject *FOB;
UIActivityIndicatorView *loading;

NSString *orign;
NSString *destination;
NSString *departDate;
NSString *returnDate;
BOOL isOneWay;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    revealActivated = NO;
   
    self.homeImage.image = NULL;
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    NSString *urlStr = [NSString stringWithFormat:@"%@images/%@",app.serverAddress,app.userCountry[@"CountryImage"]];

    PlaceObject *PO = [[PlaceObject alloc]init];
    PO.delegate = self;
    [PO downloadImages:urlStr :0 :app.userCountry[@"CountryName"] :0];
    
    
    
    
    [self setUpFlightOptView];
   
    //NearBy Button design
    [self.nearByButton.layer setCornerRadius:self.nearByButton.frame.size.height/2];
    [self.nearByButton.layer setMasksToBounds:YES];
    
    self.nearByButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.nearByButton.layer.shadowOpacity = 1.0f;
    self.nearByButton.layer.shadowRadius = 4;
    self.nearByButton.layer.shadowOffset = CGSizeMake(0, 0);

    //SidebarButton design
    self.sidebarButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.sidebarButton.layer.shadowOpacity = 1.0f;
    self.sidebarButton.layer.shadowRadius = 4;
    self.sidebarButton.layer.shadowOffset = CGSizeMake(0, 0);

    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    
    _menuData = [[NSArray alloc]initWithObjects:@"Attractions",@"Tours & Activities",@"Lodging",@"Dining",@"Shopping",@"Flight", nil];
    
    _menuIMG = [[NSArray alloc]initWithObjects:@"monument.png",@"to_do.png",@"3_star_hotel.png",@"restaurant2.png",@"shopping_cart_loaded.png",@"airport.png", nil];
    
    
    self.homeTableView.estimatedRowHeight = 60.f;
    self.homeTableView.rowHeight = 60.f;
    [self.homeTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        revealViewController.delegate = self;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

-(void)setUpFlightOptView
{
    
    self.flightOptView.frame = self.view.frame;
    
    //flightOptSubView Shadow
    self.flightOptSubView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.flightOptSubView.layer.shadowOpacity = .6;
    self.flightOptSubView.layer.shadowRadius = 5.f;
    self.flightOptSubView.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self.doneBt.layer setMasksToBounds:YES];
    [self.doneBt.layer setCornerRadius:5];

    self.orignTXT.delegate = self;
    self.destinationTXT.delegate = self;
    
    
    self.autoCompTableView.delegate = self;
    self.autoCompTableView.dataSource = self;
    CGRect frame = self.autoCompTableView.frame;
    frame.size.width = self.orignTXT.frame.size.width;
    self.autoCompTableView.frame = frame;
    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    
    loading.center = self.autoCompTableView.center;
    [self.autoCompTableView setBackgroundView:loading];
    [self.autoCompTableView setHidden:YES];
    [self.flightOptSubView insertSubview:self.autoCompTableView aboveSubview:self.flightOptSubView];
    
    [self.orignTXT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.destinationTXT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
   
    NSDate *today_date= [NSDate date];
    
    NSDate *tommorow_date= [NSDate dateWithTimeIntervalSinceNow:86400];
    
    self.departDate.minimumDate = today_date;
    self.departDate.date = today_date;
    self.returnDate.minimumDate = today_date;
    self.returnDate.date = tommorow_date;
    
    FOB = [FlightObject new];
    
    
    
}

-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    app.countryImage = imageDATA;
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self updateCountryImage];

                       
                   });

    
}

-(void)updateCountryImage
{
    NSLog(@"Country Image loaded");
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (app.countryImage) {
        
        self.homeImage.image = [UIImage imageWithData:app.countryImage];

    }
    else
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@images/%@",app.serverAddress,app.userCountry[@"CountryImage"]];

        PlaceObject *PO = [[PlaceObject alloc]init];
        PO.delegate = self;
        [PO downloadImages:urlStr :0 :app.userCountry[@"CountryName"] :0];
        
        
        
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint =[touch locationInView:self.view];

    
    if (!CGRectContainsPoint(self.flightOptSubView.frame, touchPoint)) {
        
        if (!autocompleteShowing) {
            
            [self.flightOptView removeWithZoomOutAnimation:.1 option:UIViewAnimationOptionCurveEaseOut];
        }
        else
        {
            [self textFieldDidEndEditing:activeTextField];
            
        }
        
    }
    
    else if (!CGRectContainsPoint(self.autoCompTableView.frame, touchPoint)) {
        
        if (autocompleteShowing) {
            
            [self textFieldDidEndEditing:activeTextField];
        }
        
    }
    
    
}

-(void)textFieldDidChange :(UITextField *) textField
{
    if (textField.text.length > 0) {
        
        self.autoComplete = [[NSMutableArray alloc]init];
        [self.autoCompTableView reloadData];
        
        FOB.delegate = self;
        [FOB getAutoCompleteForQuery:textField.text CountryCode:app.userCountry[@"CountryCode"]];
        
        NSLog(@"%@",textField.text);
        
        
        if (!autocompleteShowing) {
            
            
            CGRect frame = self.autoCompTableView.frame;
            frame.origin = CGPointMake(activeTextField.frame.origin.x, activeTextField.frame.origin.y + activeTextField.frame.size.height);
            self.autoCompTableView.frame = frame;
            [self.autoCompTableView fadeInObject:self.autoCompTableView duration:.2 option:UIViewAnimationOptionCurveEaseIn];
            
            autocompleteShowing = true;
            
            
        }

    }
    else
    {
        [self textFieldDidEndEditing:textField];
        
    }

    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    NSLog(@"Started editing");

    if (autocompleteShowing)
    {
        
        [self textFieldDidEndEditing:textField];

    }
    autocompleteShowing = false;
    autocompleteSelected = false;


}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.autoCompTableView fadeOutObject:self.autoCompTableView duration:.2 option:UIViewAnimationOptionCurveEaseOut];
    autocompleteShowing = false;
    
    [textField resignFirstResponder];

    if (!autocompleteSelected) {
        
        textField.text = NULL;
    }

}

//AutoCompleteDelegate
-(void)autoCompleteDownloaded:(id)flightOBJ IsDone:(BOOL)done
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       
                       FOB = (FlightObject *)flightOBJ;
                       [self.autoComplete addObject:FOB];
                       
                       if(done)
                           [_autoCompTableView reloadData];
                       
                   });
    

}




-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    [self.sidebarButton downUnder:.5 option:UIViewAnimationOptionCurveEaseIn];

    if (position == 3)
    {
        [self.homeTableView setUserInteractionEnabled:YES];
    }
    else if (position == 4)
    {
        [self.homeTableView setUserInteractionEnabled:NO];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    orign = NULL;
    destination = NULL;
    self.orignTXT.text = NULL;
    self.destinationTXT.text = NULL;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self updateCountryImage];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.homeTableView)
    {
        return _menuData.count;

    }
    
    else if(tableView == self.autoCompTableView)
    {
        return _autoComplete.count;

    }
    
    return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.homeTableView)
    {
        _hCell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
        _hCell.meneuNameLb.text = [_menuData objectAtIndex:indexPath.row];
        _hCell.meneuimageView.image = [UIImage imageNamed:[_menuIMG objectAtIndex:indexPath.row]];
        
        return _hCell;
    }
  
    else if(tableView == self.autoCompTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"autocompleteCell" forIndexPath:indexPath];
        FlightObject *FOB = (FlightObject *)[self.autoComplete objectAtIndex:indexPath.row];
        cell.textLabel.text = FOB.placeName;
        cell.detailTextLabel.text = FOB.country;
        
        return cell;
    }
    
    return nil;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Table cell seleccted");

    if (tableView == self.homeTableView) {
        
        
        NSString *selected = [_menuData objectAtIndex:indexPath.row];
        
        if ([selected isEqualToString:@"Attractions"] || [selected isEqualToString:@"Tours & Activities"])
        {
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            self.loc_ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseLocation"];
            self.loc_ViewController.item_title = [_menuData objectAtIndex:indexPath.row];
            self.loc_ViewController.locData = [[NSMutableArray alloc]init];
            
            DBConnect *conn = [[DBConnect alloc]init];
            conn.delegate= self.loc_ViewController;
            
            //Download States from DB
            [conn GetStates:app.userCountry[@"CountryCode"] Type:[NSString stringWithFormat:@"%c",[selected characterAtIndex:0]]];
            
            [self.navigationController pushViewController:self.loc_ViewController animated:YES];
            
            
        }
        else if([selected isEqualToString:@"Flight"] )
        {
           
            [self.view addSubviewWithFadeAnimation:self.flightOptView duration:.2 option:UIViewAnimationOptionCurveEaseIn];
            
        }
        else
        {
            self.itemList = [self.storyboard instantiateViewControllerWithIdentifier:@"itemList"];
            self.itemList.displayRegion = [_menuData objectAtIndex:indexPath.row];
            
            if ([selected isEqualToString:@"Lodging"])
            {
                self.itemList.scopes = [NSMutableArray arrayWithObjects:@"Price",@"Distance",@"Star Ratings", nil];
                
            }
            else if ([selected isEqualToString:@"Dining"])
            {
                self.itemList.scopes = [NSMutableArray arrayWithObjects:@"Distance", nil];
                
            }
            else if ([selected isEqualToString:@"Shopping"])
            {
                self.itemList.scopes = [NSMutableArray arrayWithObjects:@"Distance", nil];
                
            }
            
            self.itemList.presentCount = 0;
            self.itemList.count = 0;
            
            [self.navigationController pushViewController:self.itemList animated:YES];
            
        }
    }
    else if(tableView == self.autoCompTableView)
    {
        
        FlightObject *FOB = (FlightObject *)[self.autoComplete objectAtIndex:indexPath.row];
        activeTextField.text = FOB.placeName;
        autocompleteSelected = true;
        
        if (activeTextField == self.orignTXT) {
            
            orign = FOB.placeID;

        }
        else if (activeTextField == self.destinationTXT) {
            
            destination = FOB.placeID;
            
        }
        
        NSLog(@"Place name = %@",FOB.placeName);
        [self textFieldDidEndEditing:activeTextField];

    }
    
    
}


- (IBAction)nearByAction:(id)sender {
    
    self.itemList = [self.storyboard instantiateViewControllerWithIdentifier:@"itemList"];
    self.itemList.displayRegion = @"Nearby";
    
    self.itemList.presentCount = 0;
    self.itemList.count = 0;
    
    [self.navigationController pushViewController:self.itemList animated:YES];
    

}

- (IBAction)doneBtAction:(id)sender
{
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
   
    departDate = [dateFormatter stringFromDate:self.departDate.date];
    returnDate = [dateFormatter stringFromDate:self.returnDate.date];
    
    if(([orign isEqualToString:@""] || orign==NULL) || ([destination isEqualToString:@""] || destination==NULL))
    {
        return;
        
    }
    else
    {
        NSString *url;
        if (!isOneWay) {
            
            url = [[NSString alloc]initWithFormat:@"http://partners.api.skyscanner.net/apiservices/referral/v1.0/%@/%@/%@/%@/%@/%@/%@?apiKey=%@",app.userCountry[@"CountryCode"],@"USD",@"en-US",orign,destination,departDate,returnDate,[app.skyScannerKey substringWithRange:NSMakeRange(0, 16)]];
        }
        else
        {
            url = [[NSString alloc]initWithFormat:@"http://partners.api.skyscanner.net/apiservices/referral/v1.0/%@/%@/%@/%@/%@/%@?apiKey=%@",app.userCountry[@"CountryCode"],@"USD",@"en-US",orign,destination,departDate,[app.skyScannerKey substringWithRange:NSMakeRange(0, 16)]];
        }
        
        
        NSString *referalUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"URL = %@",referalUrl);
        
        self.svwWebView = [[SVWebViewController alloc]init];
        self.svwWebView.title = @"Flight Search";
        [self.svwWebView loadWebPage:referalUrl];
        
        self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self.navigationController pushViewController:self.svwWebView animated:YES];
        
        [self textFieldDidEndEditing:activeTextField];
        
        [self.flightOptView removeWithZoomOutAnimation:.1 option:UIViewAnimationOptionCurveEaseOut];
    }

}

- (IBAction)flightTypeAction:(id)sender {
    
    if (self.flightTypeOpt.selectedSegmentIndex == 0) {
        
        [self.returnLB setHidden:NO];
        [self.returnImg setHidden:NO];
        [self.returnDate setHidden:NO];
        
        isOneWay = false;

    }
    else if (self.flightTypeOpt.selectedSegmentIndex == 1) {
        
        [self.returnLB setHidden:YES];
        [self.returnImg setHidden:YES];
        [self.returnDate setHidden:YES];
        
        isOneWay = true;
    }
}
@end
