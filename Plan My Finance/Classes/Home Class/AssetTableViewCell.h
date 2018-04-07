//
//  AssetTableViewCell.h
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgColor;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopBorder;

@end
