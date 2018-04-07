//
//  AssetTransactionDetailTableViewCell.h
//  IFA
//
//  Created by Raviraj Jadeja on 16/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTransactionDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblUnits;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTransaction;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
