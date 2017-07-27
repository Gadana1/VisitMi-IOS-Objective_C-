//
//  AppDelegate.m
//  VisitMi
//
//  Created by Samuel on 10/18/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

NSString *name;
NSString *desc;
NSString *address;
NSString *number;
NSString *state ;
NSString *int_type;
NSString *img1_url;
NSString *img2_url;
NSString *img3_url;
NSString *img4_url;
NSString *img5_url;
double longitude =0;
double latitude =0;
PlaceObject *visitmiObj;
NSMutableArray *myPlaces;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.infoDict = [[NSBundle mainBundle] infoDictionary];
    self.serverAddress = self.infoDict[@"ServerAddress"];
    
  
    //Load data from database
    DBConnect *conn = [[DBConnect alloc]init];
    [conn GetAppData];
    
        
    //Define Global settings
    [self defineGlobalSettings];
    
    //initialize seesion variables array
    self.sessions = [[NSMutableArray alloc] init];
    
    // Setup Favourites
    {
        self.favoriteName = @"favourites.plist";
        
        // Get the path to the documents directory and append the databaseName
        NSArray *documentPaths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDir2 = [documentPaths2 objectAtIndex:0];
        
        self.favoritePath = [documentsDir2 stringByAppendingPathComponent:self.favoriteName];
        
        
        // Check if favourite file exists in device
        [self checkAndCreateFavouritesFile];
        
        NSLog(@"%@",documentsDir2);
        

    }
    
   
    //So that app would reload User bookings from database
    self.bookingUpdated =  false;
    
    
    
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
        NSLog(@"User already Logged in");
        [conn GetCountries];

        self.userDetails = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        [self performSelectorOnMainThread:@selector(verifyUser) withObject:nil waitUntilDone:YES];
        
        /*Get Country data from file */
        //get directory from app
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = [[NSString alloc]initWithFormat:@"USERCOUNTRY.plist"];
        NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"];
        
        //specify file path
        NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
        
        BOOL fileExist =  [fileManager fileExistsAtPath:filePath];
        if (fileExist)
        {
            self.userCountry = [NSDictionary dictionaryWithContentsOfFile:filePath];
            
        }
        
        

    }
    else
    {
        NSLog(@"User not Logged in");

        self.storyboardID = @"startUpNavController";
        
        //Set Up Initial View Controller
        UIViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.storyboardID];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initViewController;
        [self.window makeKeyAndVisible];
        
        
        
    }
    
   
    return YES;
}


-(void)verifyUser
{
    DBConnect *conn = [[DBConnect alloc]init];
    
    [conn VerifyUser:self.userDetails[@"Email"] Session:self.userDetails[@"SessionID"] CallBack:^(id placeObject)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^(void)
                        {
                            
                            PlaceObject *PO = (PlaceObject *)placeObject;
                            
                            
                            if ([PO.dbstatus isEqualToString:@"success"])
                            {
                                
                                //get Image from storage
                                //get directory from app
                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"];
                                NSString *imageName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.png"];
                                
                                NSString *imagePath = [fileDir stringByAppendingPathComponent:imageName];
                                
                                BOOL imageExist =  [fileManager fileExistsAtPath:imagePath];
                                if (imageExist)
                                {
                                    self.userImage = [NSData dataWithContentsOfFile:imagePath];
                                    
                                }
                                
                                //Home Page
                                self.storyboardID = @"revealHomeView";
                                NSLog(@"%@",PO.dbmessage);
                            }
                            else
                            {
                                self.storyboardID = @"startUpNavController";
                                NSLog(@"%@",PO.dbmessage);
                                [conn LogOutUser:self.userDetails[@"Email"] SessionID:self.userDetails[@"SessionID"]];
                                
                            }
                            
                            //Set Up Initial View Controller
                            UIViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.storyboardID];
                            
                            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                            self.window.rootViewController = initViewController;
                            [self.window makeKeyAndVisible];
                            
                            
                            
                            
                        });
         
         
     }];
    
}

-(void)defineGlobalSettings
{
    UINavigationController *startUpNav = [self.storyboard instantiateViewControllerWithIdentifier:@"startUpNavController"];
    // Define some colors.
    UIColor *darkGray = [UIColor darkGrayColor];
    //IColor *white = [UIColor whiteColor];
    UIColor *barTint = startUpNav.navigationBar.barTintColor;
    UIColor *tint = startUpNav.navigationBar.tintColor;
    
    
    // Navigation bar background.
    [[UINavigationBar appearance] setBarTintColor:barTint];
    [[UINavigationBar appearance] setTintColor:tint];
    
    
    //PageControl
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:tint];
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor grayColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];
    
    
    // Color of the in-progress spinner.
    [[UIActivityIndicatorView appearance] setColor:darkGray];
    
    // To style the two image icons in the search bar (the magnifying glass
    // icon and the 'clear text' icon), replace them with different images.
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"custom_clear_x_high"]
                      forSearchBarIcon:UISearchBarIconClear
                                 state:UIControlStateHighlighted];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"custom_clear_x"]
                      forSearchBarIcon:UISearchBarIconClear
                                 state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"custom_search"]
                      forSearchBarIcon:UISearchBarIconSearch
                                 state:UIControlStateNormal];
    [[UISearchBar appearance] setBackgroundColor:barTint];
    [[UISearchBar appearance] setTintColor:tint];
    [[UISearchBar appearance] setBarTintColor:barTint];

    [[UISearchBar appearance] setTranslucent:YES];
    [[UISearchBar appearance] setSearchBarStyle:UISearchBarStyleMinimal];
    
    
    //customise Table view
    UIImageView *bgIMG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vmBG.jpg"]];
    [bgIMG setAlpha:.5f];
    //[[UITableView appearance] setBackgroundView:bgIMG];
    
    [[UITableViewCell appearance] setTintColor:tint];

    [[UIRefreshControl appearance] setTintColor:tint];
    [[UIActivityIndicatorView appearance] setColor:tint];
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
}


-(void)checkAndCreateFavouritesFile {

    BOOL success2;
    
    // Create a FileManager object, we will use this to check the status
    // of the favourite file and to copy it over if required
    NSError *error;

    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    success2 = [fileManager fileExistsAtPath:self.favoritePath];

    NSString *favouritePathFromApp = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:self.favoriteName];
    
    //Copy the favourite file from the package to the users filesystem
    
    if(success2) return;
    
    if(!success2)
    {

        [fileManager copyItemAtPath:favouritePathFromApp toPath:self.favoritePath error:&error];
    }
    
}

-(UIImage *)qrCodeWith:(NSString *)stringValue ImageSize:(CGSize)size
{
    
    NSData *data = [stringValue dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = filter.outputImage;
    CGSize imageSize = qrImage.extent.size;
    CGFloat widthRatio = size.width/imageSize.width;
    CGFloat heightRatio = size.height/imageSize.height;
    
    return [self nonInterpolatedImageWithImage:qrImage DX:widthRatio DY:heightRatio];
}

-(UIImage *)nonInterpolatedImageWithImage:(CIImage *)ciImage DX:(CGFloat)dx DY:(CGFloat)dy
{
    
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
    CGSize size = CGSizeMake(ciImage.extent.size.width * dx, ciImage.extent.size.height * dy);
    UIGraphicsBeginImageContextWithOptions(size, true, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(context, 0);
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    
    //now get the image from the context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //NSData *imgData = UIImagePNGRepresentation(image);
    
    return image;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





/*-(NSString *)getBookName{
    
    return self.bookName;
}*/





















@end
