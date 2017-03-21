//
//  SettingsDetailsController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 06/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "SettingsDetailsController.h"

@interface SettingsDetailsController ()

@end

@implementation SettingsDetailsController
{
    NSString *email;
    NSString *password;
    NSString *fName;
    NSString *lName;
    NSString *dialingCode;
    NSString *number;
    NSString *numberWithCode;
    NSString *countryCode;
    
    NSString *updatedPass;
    NSString *currentPass;

    BOOL doneFName;
    BOOL doneLName;
    BOOL doneNumber;
    BOOL donePassword;
    BOOL doneRetypePass;
    BOOL isUpdated;

    BOOL isLogin;
    
    UITextField* activeTextField;
    UIColor *errorColor;
    UIColor *bgColor;
    CGRect editBtFrame;
    UITextField *confirmPassTXT;
    
    BOOL keyboardIsShown;
    double kTabBarHeight;
    
    AppDelegate *app;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    bgColor = self.userSettingView.backgroundColor;
    editBtFrame = self.editBt.frame;
    
    isLogin = false;
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    if(self.isUserSettings)
    {
        [self setUpUserSettingsView];
    }
    else
    {
        [self setUpCountrySettingsView];
    }
    
}

-(void)setDefaults
{
    
    
    countryCode = app.userCountry[@"CountryCode"];
    fName = app.userDetails[@"FirstName"];
    lName = app.userDetails[@"LastName"];
    dialingCode = app.userCountry[@"DialingCode"];
    password = NULL;
    updatedPass = NULL;
    currentPass = NULL;
    
    NSMutableString *num;
    @try
    {
        num = [[NSMutableString alloc]init];
        [num setString:app.userDetails[@"Phone"]];
        [num deleteCharactersInRange:[num rangeOfString:dialingCode]];
        [num deleteCharactersInRange:[num rangeOfString:@" "]];
        
    }
    @catch (NSException *exception) {
        
        num = [[NSMutableString alloc]init];
        [num setString:app.userDetails[@"Phone"]];
        num = (NSMutableString *)[num stringByReplacingOccurrencesOfString:dialingCode withString:@""];
        
    }
    
    number = [app.userDetails[@"CountryCode"] isEqualToString:app.userCountry[@"CountryCode"]]?num:NULL;
    numberWithCode = [NSString stringWithFormat:@"%@%@",dialingCode,number];
    
    email = app.userDetails[@"Email"];
    
    doneFName = true;
    doneLName = true;
    donePassword = true;
    doneRetypePass = true;
    doneNumber = true;
    isUpdated = false;
    
}
-(void)setUpUserSettingsView
{
   
    [self setDefaults];
    
    self.firstnameTXT.delegate = self;
    [self.firstnameTXT.layer setCornerRadius:15.0f];
    [self.firstnameTXT.layer setMasksToBounds:YES];
    self.firstnameTXT.text = fName;
    [self.firstnameTXT setEnabled:false];

    self.lastnameTXT.delegate = self;
    [self.lastnameTXT.layer setCornerRadius:15.0f];
    [self.lastnameTXT.layer setMasksToBounds:YES];
    self.lastnameTXT.text = lName;
    [self.lastnameTXT setEnabled:false];

    
    [self.phoneExtTXT.layer setCornerRadius:15.0f];
    [self.phoneExtTXT.layer setMasksToBounds:YES];
    self.phoneExtTXT.text = dialingCode;
 
    self.phoneTXT.delegate = self;
    [self.phoneTXT.layer setCornerRadius:15.0f];
    [self.phoneTXT.layer setMasksToBounds:YES];
    self.phoneTXT.text = number;
    [self.phoneTXT addTarget:self action:@selector(validatePhoneNumber) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTXT setEnabled:false];
    
    self.passwordTXT.delegate = self;
    [self.passwordTXT.layer setCornerRadius:15.0f];
    [self.passwordTXT.layer setMasksToBounds:YES];
    [self.passwordTXT addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventEditingChanged];
    self.passwordTXT.text = NULL;
    [self.passwordTXT setEnabled:false];

    self.retypePassTXT.delegate = self;
    [self.retypePassTXT.layer setCornerRadius:15.0f];
    [self.retypePassTXT.layer setMasksToBounds:YES];
    [self.retypePassTXT addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventEditingChanged];
    self.retypePassTXT.text = NULL;
    [self.retypePassTXT setEnabled:false];

    [self.userImage.layer setCornerRadius:self.userImage.frame.size.height/2];
    [self.userImage.layer setMasksToBounds:YES];
    self.userImage.image  = app.userImage!=NULL ? [UIImage imageWithData:app.userImage]:[UIImage imageNamed:@"user_male_circle.png"];
    
    if (app.userImage != NULL) {
        
        [self.photoButton setTitle:@"Change" forState:UIControlStateNormal];
    }
    
    [self.photoButton.layer setCornerRadius:5.0f];
    [self.photoButton.layer setMasksToBounds:YES];
    self.photoButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.photoButton.layer.shadowOpacity = .6;
    self.photoButton.layer.shadowRadius = 3.f;
    self.photoButton.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self.doneBT.layer setCornerRadius:15.0f];
    [self.doneBT.layer setMasksToBounds:YES];
    [self.doneBT setEnabled:NO];
    
    self.userSettingView.frame = self.view.frame;
    [self.view addSubview:self.userSettingView];
    
    errorColor = [UIColor colorWithRed:.8 green:.1 blue:0 alpha:.5];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    /* */
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

-(void)setUpCountrySettingsView
{
    self.countryTableView.rowHeight = 60;
    self.countryTableView.delegate = self;
    self.countryTableView.dataSource = self;
    [self.countryTableView registerNib:[UINib nibWithNibName:@"CountryCell" bundle:nil] forCellReuseIdentifier:@"countryCell"];
    
    self.countryTableView.delegate = self;
    self.countryTableView.frame = self.view.frame;
    [self.view addSubview:self.countryTableView];
    
    int i=0;
    for(PlaceObject *PO in app.countries)
    {
        
        //Download Country Flag
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/VisitMi/images/%@.png",app.serverAddress,PO.country_Code];
        
        PO.delegate = self;
        [PO downloadImages:urlStr :0 :PO.country_Code :i];
        
        i++;
    }

    
}

-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(index < [app.countries  count])
    {
        ((PlaceObject *)[app.countries objectAtIndex:index]).img = imageDATA;
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self.countryTableView reloadData];

                   });
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return app.countries.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CountryCell *cCell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    PlaceObject *PO = (PlaceObject *)[app.countries objectAtIndex:indexPath.row];
    
    NSString *displayString = [NSString stringWithFormat:@"%@ (%@)",PO.country_Name,PO.country_Code];
    [cCell.countryLB setBackgroundColor:[UIColor clearColor]];
    [cCell.countryLB setTextColor:[UIColor blackColor]];
    cCell.countryLB.text = displayString;
    
    if ([PO.country_Code isEqualToString:app.userCountry[@"CountryCode"]])
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [cCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    cCell.countryFlag.image =[UIImage imageWithData:PO.img];
    
    return cCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    PlaceObject *PO = (PlaceObject *)[app.countries objectAtIndex:indexPath.row];
    
    NSMutableDictionary *country = [NSMutableDictionary
                                    dictionaryWithDictionary:@{@"CountryCode":PO.country_Code,
                                                               @"CountryName":PO.country_Name,
                                                               @"CountryImage":PO.country_Image,
                                                               @"DialingCode":PO.dialing_Code}];
    
    app.userCountry = country;
    
    
    //Go back
    [self.navigationController popViewControllerAnimated:YES];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    dispatch_async(queue, ^(void){
        
        /*Save County data to file */
        //get directory from app
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = [[NSString alloc]initWithFormat:@"USERCOUNTRY.plist"];
        NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"AppData"];
        
        //check if File directoory has been created
        BOOL isDirectory;
        if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDirectory] || !isDirectory)
        {
            NSError *error = nil;
            NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                             forKey:NSFileProtectionKey];
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
    

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       CGSize scrollContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.userSettingView.bounds.size.height + 50 + ((self.doneBT.frame.origin.y + self.doneBT.frame.size.height) - self.userSettingView.bounds.size.height));
                       
                       [self.userSettingView setContentSize:scrollContentSize];
                       self.userSettingView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                       self.userSettingView.contentOffset = CGPointMake(0, 0);
                       

                   });
    
  
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // do something, like dismiss your view controller, picker, etc., etc.
    [activeTextField resignFirstResponder];
    
}


- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if ([self.navigationController.tabBarController isBeingPresented]) {
        
        kTabBarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    }
    
    else kTabBarHeight = 0;
    
    // resize the scrollview
    CGRect viewFrame = self.userSettingView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.userSettingView.contentOffset = CGPointMake(0,0);

    [UIView commitAnimations];
    
    keyboardIsShown = NO;
    
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    if ([self.navigationController.tabBarController isBeingPresented]) {
        
        kTabBarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    }
    
    else kTabBarHeight = 0;
    
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.userSettingView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.userSettingView.contentOffset = CGPointMake(0, activeTextField.frame.origin.y - keyboardSize.height);
    
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    if(touch.phase == UITouchPhaseBegan) {
        [activeTextField resignFirstResponder];
    }
    NSLog(@"Touch");
    NSLog(@"Time stamp = %f",touch.timestamp);
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
}

-(void)validatePhoneNumber
{
    if ([activeTextField isEqual:self.phoneTXT])
    {
        
        NSString *phoneRegex = @"[0-9]{9,11}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL validate = [phoneTest evaluateWithObject:activeTextField.text];
        
        if (validate)
        {
            [activeTextField setBackgroundColor:[UIColor clearColor]];
            
            doneNumber = true;
            
        }
       
        else
        {
            [activeTextField setBackgroundColor:errorColor];
           
            doneNumber = false;
            
            NSMutableString *editedTXT = [NSMutableString stringWithString:activeTextField.text];
            
            if (activeTextField.text.length > 11)
            {
                
                [editedTXT deleteCharactersInRange:NSMakeRange(editedTXT.length-1, 1)];
                activeTextField.text = editedTXT;
                [self validatePhoneNumber];
            }
        }
        
        
    }
}

-(void)validatePassword
{
    if ([activeTextField isEqual:self.passwordTXT])
    {
        if ([activeTextField.text isEqualToString:@""])
        {
            [self.passwordTXT setBackgroundColor:[UIColor clearColor]];
            donePassword = true;
            
        }

        else if (activeTextField.text.length >= 6)
        {
            [self.passwordTXT setBackgroundColor:[UIColor clearColor]];
            donePassword = true;
            
        }
        
        else
        {
            [self.passwordTXT setBackgroundColor:errorColor];
            donePassword = false;
            
        }
        
    }
    else if ([activeTextField isEqual:self.retypePassTXT])
    {
        if ([activeTextField.text isEqualToString:@""])
        {
            [self.retypePassTXT setBackgroundColor:[UIColor clearColor]];
            doneRetypePass = true;
            
        }
        
        else if (activeTextField.text.length >= 6 && [activeTextField.text isEqualToString:self.passwordTXT.text])
        {
            [self.retypePassTXT setBackgroundColor:[UIColor clearColor]];
            doneRetypePass = true;
            
        }
        
        else
        {
            [self.retypePassTXT setBackgroundColor:errorColor];

            doneRetypePass = false;
            
        }
        
        
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Textfield data = %@",textField.text);
    
    if ([textField isEqual:self.firstnameTXT])
    {
        if (![textField.text isEqualToString:@""])
        {
            doneFName = true;
        }
        else
        {
            textField.text = fName;
            doneFName = true;
        }
        
    }
    else if ([textField isEqual:self.lastnameTXT])
    {
        
        if (![textField.text isEqualToString:@""])
        {
            doneLName = true;
        }
        else
        {
            textField.text = lName;
            doneLName = true;
        }
        
       
    }
    else if ([textField isEqual:self.phoneTXT])
    {
        if ([textField.text isEqualToString:@""])
        {
            [self.phoneTXT setBackgroundColor:[UIColor clearColor]];
            
            textField.text = number;
            
            doneNumber = true;
            
        }
       
    }
    
    [self.doneBT setEnabled:YES];

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


- (IBAction)editAction:(id)sender {
    
    [self.firstnameTXT setEnabled:YES];
    [self.lastnameTXT setEnabled:YES];
    [self.phoneTXT setEnabled:YES];
    [self.passwordTXT setEnabled:YES];
    [self.retypePassTXT setEnabled:YES];

    [self.editBt moveTo:self.doneBT.frame.origin duration:.2 option:UIViewAnimationOptionCurveLinear];
    [self.editBt fadeOutObject:self.editBt duration:.1 option:UIViewAnimationOptionCurveEaseOut];
    [self.doneBT fadeInObject:self.doneBT duration:.2 option:UIViewAnimationOptionCurveEaseIn];

    [self.userSettingView setBackgroundColor:[UIColor whiteColor]];

}



- (IBAction)photeBTAction:(id)sender {
    
    [sender popObject:.2 option:UIViewAnimationOptionCurveEaseInOut];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusNotDetermined)
    {
        // Request photo authorization
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                [self getImageFromLibrary];
            }
        
        }];
    }
    else if (status == PHAuthorizationStatusAuthorized) {

        [self getImageFromLibrary];
    
    }
    
}
-(void)getImageFromLibrary
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
    
    // Check if image access is authorized
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate =self;
        [self.navigationController presentViewController:imagePicker animated:true completion:nil];
        
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self.navigationController presentViewController:imagePicker animated:true completion:nil];
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Camera not availaible!!"
                                      message:@"Camera is either being used by other applications or this application hassn't be authourized to use the camera"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [alert addAction:ok];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info

{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       
                       UIImage *image = info[UIImagePickerControllerOriginalImage];
                       NSLog(@"Image %@",info);
                       
                       self.userImage.image = image;
                       NSData *imgData = UIImagePNGRepresentation(image);
                       app.userImage = imgData;
                       
                       if (app.userImage != NULL) {
                           
                           [self.photoButton setTitle:@"Change" forState:UIControlStateNormal];
                       }
                       
                       //Save image to folder
                       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
                       
                       dispatch_async(queue, ^(void){
                           
                           //get directory from app
                           NSFileManager *fileManager = [NSFileManager defaultManager];
                           NSString *fileName = [[NSString alloc]initWithFormat:@"1YDNELPSMISLOGIN1256.png"];
                           NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:@"AppData"];
                           
                           //check if File directoory has been created
                           BOOL isDirectory;
                           if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDirectory] || !isDirectory)
                           {
                               NSError *error = nil;
                               NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                                                forKey:NSFileProtectionKey];
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
                           [app.userImage writeToFile:filePath atomically:YES];
                           
                           
                       });

                       
                       [picker dismissViewControllerAnimated:YES completion:nil];
                   });
    

}

-(void)dbConnResponse:(id)placeObj
{

    //Get Main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PlaceObject *PO = (PlaceObject *)placeObj;
        if ([PO.dbstatus isEqualToString:@"success"]) {
            
            if (!isLogin)
            {
                
                DBConnect *conn = [[DBConnect alloc]init];
                conn.delegate = self;
                
                if (updatedPass==NULL || [updatedPass isEqualToString:@""] || [updatedPass isKindOfClass:[NSNull class]])
                {
                    NSLog(@"Email for login = *%@*",email);
                    NSLog(@"Current Password for login = *%@*",currentPass);
                    
                    [conn LoginUser:email Password:currentPass];
                    
                }
                else
                {
                    
                    NSLog(@"Email for login = *%@*",email);
                    NSLog(@"New password for login = *%@*",updatedPass);
                    
                    [conn LoginUser:email Password:updatedPass];
                    

                }
                
                isLogin = true;
                
            }
            else
            {
                
                [self setUpUserSettingsView];
                
                [self.editBt moveTo:editBtFrame.origin duration:.1 option:UIViewAnimationOptionCurveLinear];
                [self.editBt fadeInObject:self.editBt duration:.1 option:UIViewAnimationOptionCurveEaseOut];
                [self.doneBT fadeOutObject:self.doneBT duration:.2 option:UIViewAnimationOptionCurveEaseIn];
                
                [self.userSettingView setBackgroundColor:bgColor];
                
                [self.view setUserInteractionEnabled:YES];
                [self.loading setHidden:YES];
                [self.loading stopAnimating];
                
            }
            
        }
        else
        {
            //Confirmation alert
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"No Update made"
                                          message:@"incorrect password or no updates"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [self.view setUserInteractionEnabled:YES];
                                     [self.loading setHidden:YES];
                                     [self.loading stopAnimating];
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
        
    });
    
}

-(BOOL)detailsUpdates
{
    //Check if name or phone number updated
    if ([self.firstnameTXT.text isEqualToString:app.userDetails[@"FirstName"]])
    {
        if ([self.lastnameTXT.text isEqualToString:app.userDetails[@"LastName"]])
        {
            
            if ([[NSString stringWithFormat:@"%@%@",dialingCode,self.phoneTXT.text] isEqualToString:app.userDetails[@"Phone"]])
            {
                isUpdated = false;
                
            }
            else if ([self.passwordTXT.text isEqualToString:self.retypePassTXT.text]) {
                
                NSLog(@" Update Available ");
                
                isUpdated = true;
                
            }
            else isUpdated = false;


            
        }
        else if ([self.passwordTXT.text isEqualToString:self.retypePassTXT.text])
        {
            
            NSLog(@" Update Available ");
            
            isUpdated = true;
            
        }
        else isUpdated = false;


    }
    else if ([self.passwordTXT.text isEqualToString:self.retypePassTXT.text]) {
            
            NSLog(@" Update Available ");
            
            isUpdated = true;
            
    }
   
    
    return isUpdated;
    
}
-(BOOL)passwordUpdates
{
   
    //check if password updated
    if (self.passwordTXT.text==NULL ||
        [self.passwordTXT.text isEqualToString:@""] ||
        [self.passwordTXT.text isKindOfClass:[NSNull class]])
    {
        
       return false;
        
    }
    else
    {
        if ([self.passwordTXT.text isEqualToString:self.retypePassTXT.text]) {
            
            NSLog(@" Update Available ");
            
            return true;
            
        }
        else return false;
        
        
    }
    
    
    return isUpdated;
    
}

- (IBAction)doneAction:(id)sender
{
    [self textFieldDidEndEditing:activeTextField];
    
    //Check if updates have been made
    if ([self detailsUpdates] || [self passwordUpdates])
    {
        
        if (doneFName && doneLName && doneNumber && donePassword && doneRetypePass)
        {
            
            password = self.passwordTXT.text!=NULL || ![self.passwordTXT.text isEqualToString:@""]? self.passwordTXT.text:NULL;
            
            updatedPass = password;
            
            fName = self.firstnameTXT.text;
            lName = self.lastnameTXT.text;
            number = self.phoneTXT.text;
            numberWithCode = [NSString stringWithFormat:@"%@%@",dialingCode,number];
            countryCode = app.userCountry[@"CountryCode"];
            email = app.userDetails[@"Email"];
            
            [self.loading setHidden:NO];
            [self.loading startAnimating];
            
            //Confirmation alert
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Confirm Update"
                                          message:@"Enter account Password to continue"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"password";
                textField.textColor = [UIColor darkGrayColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.secureTextEntry = YES;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                confirmPassTXT = textField;
            }];
            
            
            UIAlertAction* yes = [UIAlertAction
                                  actionWithTitle:@"Done"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      currentPass = confirmPassTXT.text;
                                      NSLog(@"currentP = %@",currentPass);
                                      NSLog(@"currentP lnght = %lu",currentPass.length);
                                      
                                      if (currentPass==NULL || [currentPass isEqualToString:@""] || currentPass.length < 1 || [currentPass isKindOfClass:[NSNull class]])
                                      {
                                          
                                          [confirmPassTXT setBackgroundColor:errorColor];
                                          
                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                          
                                          [self presentViewController:alert animated:YES completion:nil];
                                          
                                      }
                                      else
                                      {
                                          DBConnect *conn = [[DBConnect alloc]init];
                                          conn.delegate = self;
                                          isLogin = false;

                                          [conn UpdateUser:fName SecondName:lName Email:email PhoneNumber:[NSString stringWithFormat:@"%@%@",app.userCountry[@"DialingCode"],number] NewPassword:password CountryCode:countryCode CurrentPassword:currentPass];
                                          
                                          [self.view setUserInteractionEnabled:NO];
                                          
                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      
                                      
                                      
                                  }];
            UIAlertAction* no = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction * action)
                                 {
                                     [_loading stopAnimating];
                                     [_loading setHidden:YES];
                                     
                                     [self.view setUserInteractionEnabled:YES];

                                     [self setDefaults];

                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            
            [alert addAction:yes];
            [alert addAction:no];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
    }
    
    
}



@end
