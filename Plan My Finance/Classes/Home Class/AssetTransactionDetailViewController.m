//
//  AssetTransactionDetailViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 16/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "AssetTransactionDetailViewController.h"

@interface AssetTransactionDetailViewController ()

@end
typedef NS_ENUM(NSInteger, WebServiceType)
{
    WebServiceTypeGetMutualFunds = 0,
    WebServiceTypeGetStocks = 1
};
@implementation AssetTransactionDetailViewController
@synthesize assetsArray,checkMS,dividendAmount;

- (void)viewDidLoad {
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    [_lblAssetCurrentValue setTextColor:IFAPrimaryColor];
    if (checkMS == TRUE) {
        _lblAssetTitle.text = @"MF TRANSACTIONS";
        mfArray = [[NSMutableArray alloc] initWithArray:[[[assetsArray valueForKey:@"mutualFundTransactions"] reverseObjectEnumerator] allObjects]];
        
        
        
    }
    else
    {
        _lblAssetTitle.text = @"STOCK TRANSACTIONS";
        
    }
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"INR"];
    [numberFormatter setMaximumFractionDigits:0];
    
    
    appFunc = [AppFunctions shared];

    
    clientDetail = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFAClientDetail"] valueForKey:@"data"] firstObject];
    
    
    _viewAssetHeader.layer.borderWidth = 1.0;
    _viewAssetHeader.layer.borderColor = IFAGreyColor.CGColor;
    
    
    float assetCurrentValueFloat,assetInvestedValueFloat,diffBetweenValue;
    
    NSString *xirrValue;
    
    if ([assetsArray valueForKeyPath:@"schemeName"]) {
        _lblAssetCurrentValue.text = [assetsArray valueForKeyPath:@"schemeName"];
    }
    else
        _lblAssetCurrentValue.text = @"-";
    
    
    if ([[assetsArray valueForKeyPath:@"calculated.currentValue"] isKindOfClass:[NSNull class]]) {
        assetCurrentValueFloat = 0;
    }
    else
    {
        assetCurrentValueFloat = [[assetsArray valueForKeyPath:@"calculated.currentValue"] floatValue];
    }
    
    if (checkMS == TRUE) {
        xirrValue = [NSString stringWithFormat:@"%@",[assetsArray valueForKeyPath:@"calculated.xirr"]];
    }
    else
        xirrValue = [NSString stringWithFormat:@"%@",[assetsArray valueForKeyPath:@"calculated.unrealizedGainLossPercent"]];
    
    if (checkMS == TRUE) {
        _lblCurrentValue.hidden = TRUE;
        
        
        if ([[assetsArray valueForKeyPath:@"calculated.amountInvested"] isKindOfClass:[NSNull class]]) {
            assetInvestedValueFloat = 0;
        }
        else
        {
            assetInvestedValueFloat = [[assetsArray valueForKeyPath:@"calculated.amountInvested"] floatValue];
        }
        

    }
    else
    {
        [_lblAssetCurrentValue setFrame:CGRectMake(_lblAssetCurrentValue.frame.origin.x, _lblAssetCurrentValue.frame.origin.y, _lblAssetCurrentValue.frame.size.width, _lblAssetCurrentValue.frame.size.height/2)];
        if ([[assetsArray valueForKeyPath:@"calculated.amountInvested"] isKindOfClass:[NSNull class]]) {
            assetInvestedValueFloat = 0;
        }
        else
        {
            assetInvestedValueFloat = [[assetsArray valueForKeyPath:@"calculated.totalCost"] floatValue];
        }
    }
    
    diffBetweenValue = assetCurrentValueFloat-assetInvestedValueFloat;
    
    
    NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:assetCurrentValueFloat];
    NSNumber *assetInvestedValueNumber = [NSNumber numberWithFloat:assetInvestedValueFloat];
    
    NSNumber *assetGainLossValueNumber = [NSNumber numberWithFloat:fabsf(diffBetweenValue)];
    
    if (diffBetweenValue < 0) {
        [_lblAssetGainLoss setTextColor:IFARedColor];
        [_lblAssetReturns setBackgroundColor:IFARedColor];
        [_imgUpDownMain setImage:[UIImage imageNamed:@"arrow_down.png"]];
    }
    
    
    NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
    NSString *totalInvestedValueString = [numberFormatter stringFromNumber:assetInvestedValueNumber];
    NSString *totalGainLossValueString = [numberFormatter stringFromNumber:assetGainLossValueNumber];
    
    if (checkMS == FALSE) {
        _lblAssetCurrentValue.text = assetCurrentValueString;
    }
    
    _lblAssetAmountInvested.text = totalInvestedValueString;
    _lblAssetGainLoss.text = totalGainLossValueString;
    
    if (xirrValue.length > 0 && [xirrValue floatValue] > 0) {
        _lblAssetReturns.text = [NSString stringWithFormat:@"     %.2f%%",[xirrValue floatValue]];
    }
    else
    {
        _lblAssetReturns.text = [NSString stringWithFormat:@"     %.2f%%",fabs(100-(assetCurrentValueFloat * 100 / assetInvestedValueFloat))];
    }
    
    CGPoint centerAssetPoint = _lblAssetReturns.center;
    CGRect rectAssetReturn = _lblAssetReturns.frame;
    
    [_lblAssetReturns sizeToFit];
    [_lblAssetReturns setFrame:CGRectMake(centerAssetPoint.x-_lblAssetReturns.frame.size.width/2-10, rectAssetReturn.origin.y, _lblAssetReturns.frame.size.width+10, rectAssetReturn.size.height)];
    
    [_imgUpDownMain setFrame:CGRectMake(_lblAssetReturns.frame.origin.x+2, _imgUpDownMain.frame.origin.y, _imgUpDownMain.frame.size.width, _imgUpDownMain.frame.size.height)];
    
    [_tblAssets reloadData];
    
    if (checkMS == TRUE) {
        UIImageView *imgViewBorder = [[UIImageView alloc] initWithFrame:CGRectMake(0, _viewAssetHeader.frame.size.height, _viewAssetHeader.frame.size.width, 1)];
        [imgViewBorder setBackgroundColor:IFAGreyColor];
        [_viewAssetHeader addSubview:imgViewBorder];
        
        UILabel *lblDividend = [[UILabel alloc] initWithFrame:CGRectMake(10, imgViewBorder.frame.origin.y, _viewAssetHeader.frame.size.width-120, 40)];
        lblDividend.text = @"Dividend Earned";
        lblDividend.font = [UIFont systemFontOfSize:[appFunc getFontSize:45.0]];
        [_viewAssetHeader addSubview:lblDividend];
        
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:dividendAmount];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        
        lblDividendAmount = [[UILabel alloc] initWithFrame:CGRectMake(_viewAssetHeader.frame.size.width-100, imgViewBorder.frame.origin.y, 90, 40)];
        lblDividendAmount.textAlignment = NSTextAlignmentRight;
        [lblDividendAmount setText:assetCurrentValueString];
        lblDividendAmount.font = [UIFont systemFontOfSize:[appFunc getFontSize:45.0]];
        [_viewAssetHeader addSubview:lblDividendAmount];
        
        [_viewAssetHeader setFrame:CGRectMake(_viewAssetHeader.frame.origin.x, _viewAssetHeader.frame.origin.y, _viewAssetHeader.frame.size.width, _viewAssetHeader.frame.size.height+40)];
        [_tblAssets setFrame:CGRectMake(_tblAssets.frame.origin.x, _tblAssets.frame.origin.y+40, _tblAssets.frame.size.width, _tblAssets.frame.size.height-40)];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (checkMS == TRUE) {
        return [mfArray count];
    }
    else
        return [[assetsArray valueForKey:@"stockTransactions"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *simpleTableIdentifier = @"AssetTransactionDetailTableViewCellIdentifier";
    AssetTransactionDetailTableViewCell *cell = (AssetTransactionDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetTransactionDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.row == 0) {
        cell.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1.0;
    }
    
    if (checkMS == TRUE) {
        cell.lblTransaction.text = [NSString stringWithFormat:@"%@",[[mfArray objectAtIndex:indexPath.row] valueForKey:@"fwTransactionType"]];
        cell.lblDate.text = [NSString stringWithFormat:@"%@",[appFunc convertingDateFormat:[[mfArray objectAtIndex:indexPath.row] valueForKey:@"transactionDate"]]];
        cell.lblAmount.text = [NSString stringWithFormat:@"%@",[appFunc convertValue:[[[mfArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue]]];
        cell.lblUnits.text = [NSString stringWithFormat:@"Units : %.0f NAV : %.2f",[[[mfArray objectAtIndex:indexPath.row] valueForKey:@"units"] floatValue],[[[mfArray objectAtIndex:indexPath.row] valueForKey:@"purchasePrice"] floatValue]];
        
        if ([assetsArray valueForKeyPath:@"familyMemberId"]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([[mfArray objectAtIndex:indexPath.row] valueForKeyPath:@"folioNo"]) {
                
                [array addObject:[[mfArray objectAtIndex:indexPath.row] valueForKeyPath:@"folioNo"]];
            }
            [array addObject:[self getClientName:[NSString stringWithFormat:@"%@",[assetsArray  valueForKeyPath:@"familyMemberId"]]]];
            cell.lblName.text = [array componentsJoinedByString:@", "];
        }
        else
            cell.lblName.text = @"-";
    }
    else
    {
        
        cell.lblTransaction.text = [NSString stringWithFormat:@"%@ - %@",[[[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.transacionType"],[appFunc convertingDateFormat:[[[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row] valueForKey:@"tradeDate"]]];
        
        cell.lblDate.text = [NSString stringWithFormat:@"%@",[appFunc convertingDateFormat:[[[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row] valueForKey:@"tradeDate"]]];
        
        cell.lblAmount.text = [NSString stringWithFormat:@"%@",[appFunc convertValue:[[[[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.amount"] floatValue]]];
        
        cell.lblUnits.text = [NSString stringWithFormat:@"Units : %.2f",[[[[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.quantity"] floatValue]];
        
        cell.lblName.text = [NSString stringWithFormat:@"Rate : %@",[appFunc convertValue:[[[[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row] valueForKeyPath:@"tradePrice"] floatValue]]];

    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TransactionsViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"TransactionsViewController"];
    if (checkMS == TRUE) {
        
        previewController.checkMS = @"1";
        previewController.description = @"Mutual Funds";
        previewController.navValue = [NSString stringWithFormat:@"%.2f",[[[mfArray objectAtIndex:indexPath.row] valueForKey:@"purchasePrice"] floatValue]];
        previewController.transactionDetail = [mfArray objectAtIndex:indexPath.row];
    }
    else
    {
        previewController.checkMS = @"2";
        previewController.description = @"Stocks";
        previewController.transactionDetail = [[assetsArray valueForKey:@"stockTransactions"] objectAtIndex:indexPath.row];
    }
    
    
    [self.navigationController pushViewController:previewController animated:YES];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - WebService Delegate


-(NSString *)getClientName:(NSString *)clientID
{
    for (int i = 0; i< [[[[clientDetail valueForKeyPath:@"clientList"] objectAtIndex:0] valueForKey:@"familyMembers"] count]; i++) {
        if ([[NSString stringWithFormat:@"%@",[[[[[clientDetail valueForKeyPath:@"clientList"] objectAtIndex:0] valueForKey:@"familyMembers"] objectAtIndex:i] valueForKey:@"familyMemberId"]] isEqualToString:clientID]) {
            clientID = [[[[[clientDetail valueForKeyPath:@"clientList"] objectAtIndex:0] valueForKey:@"familyMembers"] objectAtIndex:i] valueForKey:@"fullName"];
            break;
        }
    }
    return clientID;
}

-(void)noInternetPopUp
{
    [appFunc showAlert:@"Please check your internet connection or try again later!" view:self];
}

@end
