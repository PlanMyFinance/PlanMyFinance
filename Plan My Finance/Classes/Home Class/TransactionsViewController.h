//
//  TransactionsViewController.h
//  IFA
//
//  Created by Raviraj Jadeja on 05/08/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetDetailSimpleTableViewCell.h"
@protocol TransactionViewControllerDelegate <NSObject>
-(void)getFilterDetail:(id)filterDetail;
@end

@interface TransactionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
     id assetDetailObject;
    AppFunctions *appFunc;
    NSDictionary *mainDictionaryForTransaction;
    NSMutableArray *titleForRow;
    NSMutableArray *valueForRow;
    id clientDetail;
}
@property (nonatomic,weak)id<TransactionViewControllerDelegate> delegate;
- (IBAction)btnBack:(id)sender;
@property (assign, nonatomic) int assetIndexPath;
@property (strong, nonatomic) NSDictionary *transactionDetail;
@property (strong, nonatomic) NSString *checkMS;
@property (strong, nonatomic) NSString *navValue;
@property (strong, nonatomic) NSString *description;
@property (assign, nonatomic) int mainIndexPath;
@property (assign, nonatomic) int assetSubIndexPath;
@property (assign, nonatomic) BOOL showMembers;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblTransaction;
@property (weak, nonatomic) IBOutlet UIImageView *imgDynamicColor;

@end
