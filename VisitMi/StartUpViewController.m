//
//  StartUpViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "StartUpViewController.h"

@interface StartUpViewController ()

@end

@implementation StartUpViewController

UIActivityIndicatorView *loading;

- (void)viewDidLoad {
    [super viewDidLoad];

    _app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    [self.selectCountryTXT setHidden:YES];
    
    //Load data from database
    DBConnect *conn = [[DBConnect alloc]init];
    conn.delegate = self;
    [conn GetCountries];
    
    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    
    loading.center = self.countryTableView.center;
    [self.countryTableView setBackgroundView:loading];
    
    
    self.countryTableView.rowHeight = 60;
    self.countryTableView.delegate = self;
    self.countryTableView.dataSource = self;
    [self.countryTableView registerNib:[UINib nibWithNibName:@"CountryCell" bundle:nil] forCellReuseIdentifier:@"countryCell"];
    
    CGRect tFrame = self.countryTableView.bounds;
    tFrame.size.height = [self.countryTableView rowHeight]*[_app.countries count];
    self.countryTableView.bounds = tFrame;
    
   
}

-(void)countriesDownloaded
{
    
    int i=0;
    for(PlaceObject *PO in _app.countries)
    {
        
        //Download Country Flag
        NSString *urlStr = [NSString stringWithFormat:@"%@images/%@.png",_app.serverAddress,PO.country_Code];
        
        PO.delegate = self;
        [PO downloadImages:urlStr :0 :PO.country_Code :i];
        
        i++;
       
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                
                       //check connection
                       [self checkConnection];
                   });
}
-(void)checkConnection
{
    DBConnect *conn = [[DBConnect alloc]init];

    if(_app.countries.count < 1)
    {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"No Connection !!"
                                      message:@"Can't connect to server at the moment, retry or exit app and try again later"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* retry = [UIAlertAction
                             actionWithTitle:@"Retry"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Load Countries from database
                                 conn.delegate = self;
                                 [conn GetCountries];
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        UIAlertAction* exitApp = [UIAlertAction
                             actionWithTitle:@"Exit"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 exit(0);
                             }];
        
        [alert addAction:retry];

        [alert addAction:exitApp];

        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    else
    {
        if(_app.appData == NULL)
            [conn GetAppData];

        [loading stopAnimating];

        /* Get Login Data from File*/
        //get directory from app
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.plist"];
        NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"];
        NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
        
        //check if login file exists
        BOOL fileExist =  [fileManager fileExistsAtPath:filePath];
        if (fileExist)
        {
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            //Download Country Image
            NSString *urlStr = [NSString stringWithFormat:@"%@images/%@",app.serverAddress,app.userCountry[@"CountryImage"]];
            NSURL *url = [NSURL URLWithString:urlStr];
            app.countryImage = [NSData dataWithContentsOfURL:url];
            
            //Move to Home page
            id home = [self.storyboard instantiateViewControllerWithIdentifier:@"revealHomeView"];
            [self.navigationController showViewController:home sender:nil];
            
            
        }
        else
        {
            [self.selectCountryTXT setHidden:NO];
            [self.countryTableView reloadData];

        }
    }

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_app.countries count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CountryCell *cCell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    PlaceObject *PO = (PlaceObject *)[_app.countries objectAtIndex:indexPath.row];
    
    NSString *displayString = [NSString stringWithFormat:@"%@ (%@)",PO.country_Name,PO.country_Code];
    cCell.countryLB.text = displayString;
    
    cCell.countryFlag.image =[UIImage imageWithData:PO.img];
    
    return cCell;
    
}

-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    _app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(index < [_app.countries  count])
    {
        ((PlaceObject *)[_app.countries objectAtIndex:index]).img = imageDATA;
        
    }
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [_countryTableView reloadData];

                   });
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.loading setHidden:NO];
    [self.loading startAnimating];
    
    WelcomeViewController *welcome = [self.storyboard instantiateViewControllerWithIdentifier:@"welcomeView"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    PlaceObject *PO = (PlaceObject *)[_app.countries objectAtIndex:indexPath.row];
    
    NSMutableDictionary *country = [NSMutableDictionary
                                    dictionaryWithDictionary:@{@"CountryCode":PO.country_Code,
                                                               @"CountryName":PO.country_Name,
                                                               @"CountryImage":PO.country_Image,
                                                               @"DialingCode":PO.dialing_Code}];
    
    app.userCountry = country;

   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    dispatch_async(queue, ^(void){
        
        
        /*Save County data to file */
        //get directory from app
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = [[NSString alloc]initWithFormat:@"USERCOUNTRY.plist"];
        NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"];
        
        //check if File directoory has been created
        BOOL isDirectory;
        if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDirectory] || !isDirectory)
        {
            NSError *error = nil;
            NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
            //create file directory if not already created
            [fileManager createDirectoryAtPath:fileDir
                   withIntermediateDirectories:YES
                                    attributes:attr
                                         error:&error];
            if (error)
                NSLog(@"Error creating directory path: %@", [error localizedDescription]);
        }
        //specify file path
        NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
        //write file to path
        [country writeToFile:filePath atomically:YES];
        
        
    });

    
    [self.loading setHidden:YES];
    [self.loading stopAnimating];
    
    
    //Move to Welcome page
    welcome.countryText = app.userCountry[@"CountryName"];
    [self.navigationController showViewController:welcome sender:nil];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    
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
