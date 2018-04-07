//
//  LoginViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BottomBarViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIImageView+WebCache.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,AppFunctionApiDelegate,MFMailComposeViewControllerDelegate>
{
    AppFunctions *appFunc;
    int apiType;
    float loadingDivision;
}
@property (weak, nonatomic) IBOutlet UIImageView *advisorLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgBorder;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLoginSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNotifyingStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgLoadingBar;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
- (IBAction)btnNewUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNewUser;
@property (weak, nonatomic) IBOutlet UIView *forgetPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *forgetPasswordMailTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetpasswordBackBtn;

@end

