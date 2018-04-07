//
//  AboutViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 22/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "AboutViewController.h"
#import "UIImageView+WebCache.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    
    id assetMutableDictionary = [[AppFunctions shared] fetchObjectsFromDatabaseForEntity:@"IFAAdvisorDetail"];
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"profileLogo"]) {
        NSString *urlPath = [NSString stringWithFormat:@"https://res.cloudinary.com/futurewise/image/upload/c_scale,h_%.0f,w_%.0f/",_imgAdvisor.frame.size.height,_imgAdvisor.frame.size.width];
        [_imgAdvisor sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlPath,[[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"profileLogo"]]]];
    }
    
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"fullName"]) {
        [_lblAdvisorName setTitle:[[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"fullName"] forState:UIControlStateNormal];
    }
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"emailId"]) {
        _lblEmail.text = [[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"emailId"];
    }
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"website"]) {
        _lblWebsite.text = [[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"website"];
    }
    
    if ([[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"mobileNo"]) {
        _lblPhone.text = [NSString stringWithFormat:@"%@",[[[assetMutableDictionary firstObject] valueForKey:@"data"] valueForKey:@"mobileNo"]];
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

@end
