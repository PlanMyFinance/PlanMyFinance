//
//  LoginViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - Defining Enumerator

typedef NS_ENUM(NSInteger, WebServiceType)
{
    WebServiceTypeNone = 0,
    WebServiceTypeLogin = 1,
    WebServiceTypeClientDetail = 2,
    WebServiceTypeAdvisorDetail = 3,
    WebServiceTypeAssetDetail = 4,
    WebServiceTypeLoansDetail = 5,
    WebServiceTypeForgetPassword = 6
};

-(void)viewWillAppear:(BOOL)animated
{
    appFunc = [AppFunctions shared];
    appFunc.delegate = self;
}
- (void)viewDidLoad {

    [_forgetpasswordBackBtn setHidden:YES];
    [_forgetPasswordView setHidden:true];
    [_viewLogin setHidden:false];
    [_btnNewUser setTitleColor:IFAPrimaryColor forState:UIControlStateNormal];
    
    NSString *urlPath = [NSString stringWithFormat:@"https://res.cloudinary.com/futurewise/image/upload/c_scale,h_%.0f,w_%.0f/",_advisorLogo.frame.size.height,_advisorLogo.frame.size.width];
    
    [_advisorLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlPath,@"yourlogohere_o1ud3z.png"]]];
    
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    [_btnSubmit setBackgroundColor:IFASecondaryColor];
    
    [_mainScrollView setContentSize:CGSizeMake(IFAScreenWidth, _mainScrollView.frame.size.height)];
    loadingDivision = IFAScreenWidth/5;
    appFunc = [AppFunctions shared];
    appFunc.delegate = self;
    
    
    apiType = WebServiceTypeNone;
    
    _txtUserName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    _txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    _forgetPasswordMailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"clientId"]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        BottomBarViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"BottomBarViewController"];
//        [self.navigationController pushViewController:previewController animated:NO];
//        _viewLogin.hidden = TRUE;
        _txtUserName.text = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"email"];
        _txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"password"];
        
        _lblNotifyingStatus.hidden = FALSE;
        _imgLoadingBar.hidden = FALSE;
        _imgBorder.hidden = FALSE;
        _lblNotifyingStatus.text = @"Attempt to login...";
        [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, 0, _imgLoadingBar.frame.size.height)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            apiType = WebServiceTypeLogin;
            [appFunc callWebService:@"mm/login/loggedInData" parameters:[NSString stringWithFormat:@"{\"isFaLink\":\"true\",\"emailId\":\"%@\",\"password\":\"%@\"}",_txtUserName.text,_txtPassword.text]];
        });
        
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_txtUserName isFirstResponder]) {
        [_txtPassword becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return TRUE;
}


- (IBAction)btnLoginSubmit:(id)sender {
    [self.view endEditing:TRUE];
    
    if ([appFunc trimString:_txtUserName.text].length == 0) {
        [appFunc showAlert:@"Please enter email." view:self];
    }
    else if ([appFunc trimString:_txtPassword.text].length == 0) {
        [appFunc showAlert:@"Please enter password." view:self];
    }
    /*
    else if ([appFunc validateEmail:_txtUserName.text] == FALSE) {
        [appFunc showAlert:@"Enter a valid email." view:self];
    }
     */
    else {
        _lblNotifyingStatus.hidden = FALSE;
        _imgLoadingBar.hidden = FALSE;
        _imgBorder.hidden = FALSE;
        _lblNotifyingStatus.text = @"Attempt to login...";
        [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, 0, _imgLoadingBar.frame.size.height)];

        BOOL isMail = [appFunc validateEmail:_txtUserName.text];
        NSString *mailParamaters = [NSString stringWithFormat:@"{\"isFaLink\":\"true\",\"emailId\":\"%@\",\"password\":\"%@\"}",_txtUserName.text,_txtPassword.text];
        NSString *userNameParamaters = [NSString stringWithFormat:@"{\"isFaLink\":\"true\",\"userName\":\"%@\",\"password\":\"%@\"}",_txtUserName.text,_txtPassword.text];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            apiType = WebServiceTypeLogin;
            [appFunc callWebService:@"mm/login/loggedInData" parameters:isMail ? mailParamaters : userNameParamaters];
        });
    }
}

-(void)webServiceApiResult:(id)result
{
    if (result != nil && result != [NSNull null]) {
        if (apiType == WebServiceTypeLogin) {
            if ([result valueForKey:@"loggedInData"] && [result valueForKey:@"loggedInData"] != nil) {
                
                [[NSUserDefaults standardUserDefaults] setValue:_txtUserName.text forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setValue:_txtPassword.text forKey:@"password"];
                
                [[NSUserDefaults standardUserDefaults] setValue:[result valueForKeyPath:@"loggedInData.clientId"] forKey:@"clientId"];
                [[NSUserDefaults standardUserDefaults] setValue:[result valueForKeyPath:@"loggedInData.userId"] forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _lblNotifyingStatus.text = @"Loading account info...";
                
                [appFunc insertIntoDatabaseWithEntity:@"IFALoginDetail" insertObject:[result valueForKey:@"loggedInData"] deleteObjects:YES];
                
                [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, loadingDivision, _imgLoadingBar.frame.size.height)];
                
                //            [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                //
                //            }];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    apiType = WebServiceTypeClientDetail;
                    [appFunc callWebService:@"mm/client/details" parameters:[NSString stringWithFormat:@"{\"clientId\":\"%@\"}",[result valueForKeyPath:@"loggedInData.clientId"]]];
                });
            }
        }
        else if (apiType == WebServiceTypeClientDetail) {
            [appFunc insertIntoDatabaseWithEntity:@"IFAClientDetail" insertObject:result deleteObjects:YES];
            
            _lblNotifyingStatus.text = @"Account detail received...";
            
            [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, loadingDivision*2 , _imgLoadingBar.frame.size.height)];
            
            
            //        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            //
            //        }];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                apiType = WebServiceTypeAdvisorDetail;
                [appFunc callWebService:@"mm/client/adminAdvisor/details" parameters:[NSString stringWithFormat:@"{\"clientId\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"clientId"]]];
            });
            
        }
        else if (apiType == WebServiceTypeAdvisorDetail) {
            
            _lblNotifyingStatus.text = @"Loading assets...";
            
            [appFunc insertIntoDatabaseWithEntity:@"IFAAdvisorDetail" insertObject:result deleteObjects:YES];
            
            [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, loadingDivision*3, _imgLoadingBar.frame.size.height)];
            
            
            //        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            //
            //        }];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                apiType = WebServiceTypeAssetDetail;
                [appFunc callWebService:@"mm/asset/getAsset/all" parameters:[NSString stringWithFormat:@"{\"clientId\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"clientId"]]];
            });
        }
        else if (apiType == WebServiceTypeAssetDetail) {
            
            [appFunc insertIntoDatabaseWithEntity:@"IFAAssetDetail" insertObject:result deleteObjects:YES];
            
            _lblNotifyingStatus.text = @"Assets info received...";
            
            [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, loadingDivision*4, _imgLoadingBar.frame.size.height)];
            
            //        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            //
            //        }];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                apiType = WebServiceTypeLoansDetail;
                [appFunc callWebService:@"mm/loans/retrieve" parameters:[NSString stringWithFormat:@"{\"clientId\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"clientId"]]];
            });
        }
        else if (apiType == WebServiceTypeLoansDetail) {
            
            _lblNotifyingStatus.text = @"Completed...";
            
            [appFunc insertIntoDatabaseWithEntity:@"IFALoansDetail" insertObject:result deleteObjects:YES];
            
            [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, IFAScreenWidth, _imgLoadingBar.frame.size.height)];
            
            [appFunc deleteObjectsFromDatabaseForEntity:@"IFACalculatedAssets"];
            
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goToMainPage) userInfo:nil repeats:NO];
            
            
        } else if (apiType == WebServiceTypeForgetPassword) {
            _lblNotifyingStatus.text = @"Completed...";
            [_viewLogin setHidden:false];
            [_forgetPasswordView setHidden:true];

            [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, IFAScreenWidth, _imgLoadingBar.frame.size.height)];
        }
    }
    else
    {
//        _txtUserName.text = @"";
//        _txtPassword.text = @"";
        _lblNotifyingStatus.text = @"";
        _imgLoadingBar.hidden = TRUE;
        _imgBorder.hidden = TRUE;
        if (apiType == WebServiceTypeLogin) {
                [appFunc showAlert:@"Email ID or Password is incorrect." view:self];
        }
        else
        {
            [appFunc showAlert:@"Something went wrong, please try again!" view:self];
        }
    }
}
-(void)goToMainPage
{
    _txtUserName.text = @"";
    _txtPassword.text = @"";
    _lblNotifyingStatus.text = @"";
    _imgLoadingBar.hidden = TRUE;
    _imgBorder.hidden = TRUE;
    //            _viewLogin.hidden = FALSE;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BottomBarViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"BottomBarViewController"];
    [self.navigationController pushViewController:previewController animated:NO];
}
-(void)noInternetPopUp
{
//    _viewLogin.hidden = FALSE;
    [appFunc showAlert:@"Please check your internet connection or try again later!" view:self];
}

- (IBAction)btnNewUser:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:IFAContact]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didForgetPasswordPressed:(UIButton *)sender {
    [_viewLogin setHidden:true];
    [_forgetPasswordView setHidden:false];
    [_forgetpasswordBackBtn setHidden:false];
}

- (IBAction)didForgetPasswordSubmitButtonPressed:(UIButton *)sender {
    [self.view endEditing:TRUE];

    NSString *mailText = _forgetPasswordMailTextField.text;
    if ([appFunc trimString:mailText].length == 0) {
        [appFunc showAlert:@"Please enter email." view:self];
    }
    else if ([appFunc validateEmail:mailText] == FALSE) {
        [appFunc showAlert:@"Enter a valid email." view:self];
    }
    else {
        _lblNotifyingStatus.hidden = FALSE;
        _imgLoadingBar.hidden = FALSE;
        _imgBorder.hidden = FALSE;
        _lblNotifyingStatus.text = @"Sending Reset Link...";
        [_forgetPasswordView setUserInteractionEnabled:false];
        [_imgLoadingBar setFrame:CGRectMake(0, _imgLoadingBar.frame.origin.y, 0, _imgLoadingBar.frame.size.height)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                apiType = WebServiceTypeForgetPassword;
                [appFunc callWebService:@"mm/user/forgetPassword" parameters:[NSString stringWithFormat:@"{\"emailId\":\"%@\"", mailText]];
        });
    }
}

- (IBAction)forgetpasswordBackBtn:(id)sender {
    
    [_viewLogin setHidden:false];
    [_forgetPasswordView setHidden:false];
    [_forgetpasswordBackBtn setHidden:true];
    
}
@end
