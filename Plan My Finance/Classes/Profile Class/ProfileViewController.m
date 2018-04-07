//
//  ProfileViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 22/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    [_btnLogout setBackgroundColor:IFASecondaryColor];
    
    id assetMutableDictionary = [[AppFunctions shared] fetchObjectsFromDatabaseForEntity:@"IFALoginDetail"];
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"profileLogo"]) {
        [_imgProfileIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://res.cloudinary.com/futurewise/image/upload/c_scale,h_50,w_200/",[[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"profileLogo"]]]];
    }
    
    _imgProfileIcon.layer.cornerRadius = _imgProfileIcon.frame.size.height/2;
    _imgProfileIcon.layer.masksToBounds = TRUE;
    
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"fullName"]) {
        _lblName.text = [[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"fullName"];
    }
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"emailId"]) {
        _lblEmail.text = [[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"emailId"];
    }
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"mobileNo"]) {
        _lblMobile.text = [NSString stringWithFormat:@"%@",[[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"mobileNo"]];
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)btnLogOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"clientId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[AppFunctions shared] deleteObjectsFromDatabaseForEntity:@"IFAAdvisorDetail"];
    [[AppFunctions shared] deleteObjectsFromDatabaseForEntity:@"IFAAssetDetail"];
    [[AppFunctions shared] deleteObjectsFromDatabaseForEntity:@"IFACalculatedAssets"];
    [[AppFunctions shared] deleteObjectsFromDatabaseForEntity:@"IFAClientDetail"];
    [[AppFunctions shared] deleteObjectsFromDatabaseForEntity:@"IFALoansDetail"];
    [[AppFunctions shared] deleteObjectsFromDatabaseForEntity:@"IFALoginDetail"];

    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
