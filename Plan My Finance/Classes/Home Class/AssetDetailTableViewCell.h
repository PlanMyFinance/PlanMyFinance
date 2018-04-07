//
//  AssetDetailTableViewCell.h
//  IFA
//
//  Created by Raviraj Jadeja on 16/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountInvested;
@property (weak, nonatomic) IBOutlet UILabel *lblGainLoss;
@property (weak, nonatomic) IBOutlet UILabel *lblReturn;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpDown;
@property (weak, nonatomic) IBOutlet UILabel *lblReturnText;

@end
