//
//  TicketsViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 06/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TicketsViewController.h"

@interface TicketsViewController ()

@end

@implementation TicketsViewController
UIActivityIndicatorView *loading ;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navItem.title = self.navTitle;
    
    //TabView Shadow
    self.proceedBT.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.proceedBT.layer.shadowOpacity = .5;
    self.proceedBT.layer.shadowRadius = 3.f;

    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    
    loading.center = self.ticketsTableView.center;
    [self.ticketsTableView setBackgroundView:loading];
    
    self.ticketsTableView.delegate = self;
    self.ticketsTableView.dataSource = self;
    self.ticketsTableView.estimatedRowHeight = 90.f;
    self.ticketsTableView.rowHeight = 90.f;
    [self.ticketsTableView registerNib:[UINib nibWithNibName:@"TicketsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticketCell"];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.tickets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketsTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell"];
    TourObject *TO = (TourObject *)[self.tickets objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        tCell.qtyStepper.minimumValue = 1;
    }
    tCell.quantity = tCell.qtyStepper.value;
    tCell.finalPrice = TO.ticketPrice;
    tCell.newPrice = tCell.finalPrice;

    tCell.ticketTypeTXT.text = TO.ticketType;
    tCell.currencyCodeTXT.text = TO.currencyCode;
    tCell.ticketQtyTXT.text = [NSString stringWithFormat:@"%lu",tCell.quantity];
    tCell.ticketPriceTXT.text = [NSString stringWithFormat:@"%.2f",tCell.newPrice];
    [tCell.qtyStepper setContinuous:YES];
    
    return tCell;
}

-(void)tourTicketsDownloaded:(id)tourOBJ
{
    [self.tickets addObject:tourOBJ];

    dispatch_async(dispatch_get_main_queue(), ^(void){
      
        [self.ticketsTableView reloadData];
        [loading stopAnimating];

    });
}

-(void)compileBookingData
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.userDetails = [NSDictionary dictionaryWithContentsOfFile:self.userDetailsFilePath];
    
    [app.bookingData setValue:app.userDetails[@"Email"] forKey:@"email"];
    
    NSMutableString *details = [[NSMutableString alloc]init];
    
    for (int i = 0; i<self.tickets.count; i++) {
        
        TicketsTableViewCell *tCell = [self.ticketsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        self.total += tCell.newPrice;
        
        if (tCell.quantity !=0) {
            
            [details appendFormat:@"%@ = %lu ",tCell.ticketTypeTXT.text,tCell.quantity];
            
        }
        
    }
    
    [app.bookingData setValue:details forKey:@"tourDetails"];
    
    [app.bookingData setValue:[NSString stringWithFormat:@"%.2f",self.total] forKey:@"price"];
    
    NSLog(@"%@",app.bookingData);

}


- (IBAction)proceedAction:(id)sender {
    
    /* Get Login Data from File*/
    //get directory from app
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.plist"];
    NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"AppData"];
    NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
    self.userDetailsFilePath = filePath;
    
    //check if login file exists
    BOOL fileExist =  [fileManager fileExistsAtPath:filePath];
    if (fileExist)
    {
        [self compileBookingData];
        
        if (self.bookingDelegate) {
            
            [self.bookingDelegate displayBooking];
            
        }

    }
    else
    {
        
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        login.delegate = self;
        [self presentViewController:login animated:YES completion:nil];
    }
    
}

-(void)logInSuccessfull
{
    [self compileBookingData];

    if (self.bookingDelegate) {
        
        [self.bookingDelegate displayBooking];
        
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
