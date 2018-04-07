//
//  ProfileViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 22/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;
- (IBAction)btnLogOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end
