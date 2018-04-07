//
//  AssetTransactionDetailViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 16/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetTransactionDetailTableViewCell.h"
#import "TransactionsViewController.h"
@interface AssetTransactionDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *lblDividendAmount;
    int apiType;
    id clientDetail;
    AppFunctions *appFunc;
    NSNumberFormatter *numberFormatter;
    NSMutableDictionary *stockDict;
    NSMutableArray *mfArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrentValue;
- (IBAction)btnBack:(id)sender;
@property (strong, nonatomic) id assetsArray;
@property (assign, nonatomic) float dividendAmount;
@property (assign, nonatomic) BOOL checkMS;
@property (weak, nonatomic) IBOutlet UITableView *tblAssets;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetCurrentValue;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetGainLoss;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetAmountInvested;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetReturns;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpDownMain;
@property (weak, nonatomic) IBOutlet UIView *viewAssetHeader;
@end
