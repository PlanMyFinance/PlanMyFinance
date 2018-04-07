//
//  AssetDetailViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 16/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetDetailTableViewCell.h"
#import "AssetDetailSimpleTableViewCell.h"
#import "TransactionsViewController.h"
#import "AssetTransactionDetailViewController.h"
@interface AssetDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,AppFunctionApiDelegate,TransactionViewControllerDelegate>
{
    
    int apiType;
    id clientDetail;
    AppFunctions *appFunc;
    NSMutableArray *assetsArray;
    NSMutableArray *assetsTempArray;
    int selectedSectionIndex;
    id assetDetailObject;
    CGPoint lblReturnX;
    NSNumberFormatter *numberFormatter;
    NSMutableDictionary *stockDict;
    NSString *selectedMember;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;
- (IBAction)btnMembers:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMembers;
- (IBAction)btnBack:(id)sender;
@property (assign, nonatomic) BOOL isTappable;
@property (strong, nonatomic) NSString *assetTitle;
@property (assign, nonatomic) int assetIndexPath;
@property (weak, nonatomic) IBOutlet UITableView *tblAssets;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetCurrentValue;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetGainLoss;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetAmountInvested;
@property (weak, nonatomic) IBOutlet UILabel *lblAssetReturns;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpDownMain;
@property (weak, nonatomic) IBOutlet UIView *viewAssetHeader;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
