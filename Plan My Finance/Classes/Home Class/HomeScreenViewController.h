//
//  HomeScreenViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetDetailViewController.h"
#import "AssetTableViewCell.h"


@interface HomeScreenViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,AppFunctionApiDelegate,UIGestureRecognizerDelegate>
{
    AppFunctions *appFunc;
    int apiType;
    NSMutableArray *assetsArray;
    float totalAssetValue;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAssetValue;
@property (weak, nonatomic) IBOutlet UITableView *tblAsset;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
