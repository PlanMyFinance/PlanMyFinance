//
//  AssetTableViewCell.m
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "AssetTableViewCell.h"

@implementation AssetTableViewCell

- (void)awakeFromNib {
    _imgColor.layer.cornerRadius = _imgColor.frame.size.width/2;
    _imgColor.layer.masksToBounds = TRUE;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
