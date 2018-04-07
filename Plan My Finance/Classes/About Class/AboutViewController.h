//
//  AboutViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 22/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgAdvisor;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;
@property (weak, nonatomic) IBOutlet UIButton *lblAdvisorName;
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;

@end
