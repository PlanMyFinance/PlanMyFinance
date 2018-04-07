//
//  AssetDetailViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 16/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "AssetDetailViewController.h"

@interface AssetDetailViewController ()

@end
typedef NS_ENUM(NSInteger, WebServiceType)
{
    WebServiceTypeGetMutualFunds = 0,
    WebServiceTypeGetStocks = 1,
    WebServiceTypeCalculatedAsset = 2
};
@implementation AssetDetailViewController
@synthesize assetIndexPath,isTappable,assetTitle;

- (void)viewDidLoad {
    
    lblReturnX = _lblAssetReturns.center;
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    [_lblAssetCurrentValue setTextColor:IFAPrimaryColor];
    [_activityIndicator setColor:IFAPrimaryColor];
    assetsTempArray = [[NSMutableArray alloc] init];
    selectedMember = @"0";
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"INR"];
    [numberFormatter setMaximumFractionDigits:0];
    
    
    
    _lblAssetTitle.text = [assetTitle uppercaseString];
    
    appFunc = [AppFunctions shared];
    appFunc.delegate = self;
    
    clientDetail = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFAClientDetail"] valueForKey:@"data"] firstObject];
    
    assetDetailObject = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
    
    
    selectedSectionIndex = -1;
    
    _viewAssetHeader.layer.borderWidth = 1.0;
    _viewAssetHeader.layer.borderColor = IFAGreyColor.CGColor;
    
    _activityIndicator.hidden = TRUE;
    float assetCurrentValueFloat,assetInvestedValueFloat,diffBetweenValue;
    
    NSString *xirrValue;
    //Mutual Funds
    if (assetIndexPath == 0) {
        _activityIndicator.hidden = FALSE;
        _btnMembers.hidden = FALSE;
        //https://www.my-planner.in/mm/asset/getAsset/mutualFund/transactionsNonZeroFolios
    
        NSMutableArray *stockArray = [[NSMutableArray alloc] init];
        
        stockArray = [assetDetailObject valueForKeyPath:@"assetDetails.mutualFund"];
        
        assetsArray = [[NSMutableArray alloc] initWithArray:[self groupSameSubCategories:[assetDetailObject valueForKeyPath:@"assetDetails.mutualFund"]]];
        
        for (int i = 0; i<[stockArray count]; i++) {
            if ([[stockArray objectAtIndex:i] valueForKey:@"assetMappingList"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"assetMappingList"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"assetMutualFundTransactionTypeMasterId"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"assetMutualFundTransactionTypeMasterId"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"assetPercentageAllocationList"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"assetPercentageAllocationList"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"isSip"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"isSip"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"manual"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"manual"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"summarize"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"summarize"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"trxnLoader"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"trxnLoader"];
            }
            
            if ([[stockArray objectAtIndex:i] valueForKey:@"assetAdviceValueType"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"assetAdviceValueType"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"calculatedAdvice"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"calculatedAdvice"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"_meta"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"_meta"];
            }
            [[stockArray objectAtIndex:i] setObject:@[] forKey:@"mutualFundTransactions"];
        }
        
        NSLog(@"STOCK - %@",stockArray);
        
        NSString *mfString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:stockArray options:0 error:nil] encoding:NSUTF8StringEncoding];
        NSString *parameterStringJsonObject = [NSString stringWithFormat:@"{\"mutualFund\":%@}",mfString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            apiType = WebServiceTypeGetMutualFunds;
            [appFunc callWebService:@"mm/asset/getAsset/mutualFund/transactionsNonZeroFolios" parameters:parameterStringJsonObject];
        });
        
        if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.currentValue"] isKindOfClass:[NSNull class]]) {
            assetCurrentValueFloat = 0;
        }
        else
        {
            assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.currentValue"] floatValue];
        }
        
        if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.amountInvested"] isKindOfClass:[NSNull class]]) {
            assetInvestedValueFloat = 0;
        }
        else
        {
            assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.amountInvested"] floatValue];
        }
        
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.calculated.totalXirrFamilyMemberLevel"]];
        
        
        
    }
    //Stocks
    else if (assetIndexPath == 1) {
        _activityIndicator.hidden = FALSE;
        NSMutableArray *stockArray = [[NSMutableArray alloc] init];
        stockArray = [assetDetailObject valueForKeyPath:@"assetDetails.stock"];
        for (int i = 0; i<[stockArray count]; i++) {
            if ([[stockArray objectAtIndex:i] valueForKey:@"calculated"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"calculated"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"calculatedAdvice"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"calculatedAdvice"];
            }
            if ([[stockArray objectAtIndex:i] valueForKey:@"assetAdviceValueType"]) {
                [[stockArray objectAtIndex:i] removeObjectForKey:@"assetAdviceValueType"];
            }
        }
        NSString *stockString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:stockArray options:0 error:nil] encoding:NSUTF8StringEncoding];
        NSString *parameterStringJsonObject = [NSString stringWithFormat:@"{\"stock\":%@}",stockString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            apiType = WebServiceTypeGetStocks;
            [appFunc callWebService:@"mm/asset/getAsset/stock/transactions" parameters:parameterStringJsonObject];
        });
        
        
        
        
        if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.currentValue"] isKindOfClass:[NSNull class]]) {
            assetCurrentValueFloat = 0;
        }
        else
        {
            assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.currentValue"] floatValue];
        }
    
        if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.amountInvested"] isKindOfClass:[NSNull class]]) {
            assetInvestedValueFloat = 0;
        }
        else
        {
            assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.amountInvested"] floatValue];
        }
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.xirr"]];
        
        
        
        
    }
    //Life Insurance
    else if (assetIndexPath == 2) {
        
        assetsArray = [[NSMutableArray alloc] initWithArray:[assetDetailObject valueForKeyPath:@"assetDetails.lifeInsurance"]];
        
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.lifeInsurance.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.lifeInsurance.amountInvested"] floatValue];
        
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.lifeInsurance.xirr"]];
        
    }
    // FD/RD
    else if (assetIndexPath == 3) {
        float bankFDTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.bankFixedDeposit"] count]; i++) {
            bankFDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.bankFixedDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float companyFDTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.companyFixedDeposit"] count]; i++) {
            companyFDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.companyFixedDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
//        float postOfficeFDTotal = 0;
//        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.postOfficeFixedDeposit"] count]; i++) {
//            postOfficeFDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.postOfficeFixedDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
//        }
        
        float fixedIncomeBondTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.fixedIncomeBonds"] count]; i++) {
            fixedIncomeBondTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.fixedIncomeBonds"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float bankRDTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.bankRecurringDeposit"] count]; i++) {
            bankRDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.bankRecurringDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
//        float postOfficeRDTotal = 0;
//        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.postOfficeRecurringDeposit"] count]; i++) {
//            postOfficeRDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.postOfficeRecurringDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
//        }
        
        
        NSArray *array = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Bank FD",@"description",[NSString stringWithFormat:@"%f",bankFDTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.bankFixedDeposit"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Company FD",@"description",[NSString stringWithFormat:@"%f",companyFDTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.companyFixedDeposit"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Fixed Income Bonds",@"description",[NSString stringWithFormat:@"%f",fixedIncomeBondTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.fixedIncomeBonds"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Bank RD",@"description",[NSString stringWithFormat:@"%f",bankRDTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.bankRecurringDeposit"],@"detail", nil], nil]];
        
        assetsArray = [[NSMutableArray alloc] initWithArray:array];
        
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.fdRd.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.fdRd.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.fdRd.xirr"]];
        
    }
    //Real Estate
    else if (assetIndexPath == 4) {
        
        assetsArray = [[NSMutableArray alloc] initWithArray:[assetDetailObject valueForKeyPath:@"assetDetails.realEstate"]];
        
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.realEstate.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.realEstate.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.realEstate.xirr"]];
        
    }
    //Retirement Account
    else if (assetIndexPath == 5) {
        assetsArray = [[NSMutableArray alloc] initWithArray:[assetDetailObject valueForKeyPath:@"assetDetails.employeesProvidentFund"]];
        
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.retirementAccount.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.retirementAccount.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.retirementAccount.xirr"]];
        
    }
    // PO Schemes
    else if (assetIndexPath == 6) {
        float PPFTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.publicProvidentFund"] count]; i++) {
            PPFTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.publicProvidentFund"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float NSCTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.nationalSavingsCertificate"] count]; i++) {
            NSCTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.nationalSavingsCertificate"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float KVPTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.kisanVikasPatra"] count]; i++) {
            KVPTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.kisanVikasPatra"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float POMISTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.postOfficeMonthlyIncomeScheme"] count]; i++) {
            POMISTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.postOfficeMonthlyIncomeScheme"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float POFDTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.postOfficeFixedDeposit"] count]; i++) {
            POFDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.postOfficeFixedDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float PORDTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.postOfficeRecurringDeposit"] count]; i++) {
            PORDTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.postOfficeRecurringDeposit"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        float SCSSTotal = 0;
        for (int i = 0; i<[[assetDetailObject valueForKeyPath:@"assetDetails.seniorCitizenSavingsScheme"] count]; i++) {
            SCSSTotal += [[[[assetDetailObject valueForKeyPath:@"assetDetails.seniorCitizenSavingsScheme"] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        
        NSArray *array = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"PPF",@"description",[NSString stringWithFormat:@"%f",PPFTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.publicProvidentFund"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"NSC",@"description",[NSString stringWithFormat:@"%f",NSCTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.nationalSavingsCertificate"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"KVP",@"description",[NSString stringWithFormat:@"%f",KVPTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.kisanVikasPatra"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"POMIS",@"description",[NSString stringWithFormat:@"%f",POMISTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.postOfficeMonthlyIncomeScheme"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"POFD",@"description",[NSString stringWithFormat:@"%f",POFDTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.postOfficeFixedDeposit"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"PORD",@"description",[NSString stringWithFormat:@"%f",PORDTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.postOfficeRecurringDeposit"],@"detail", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"SCSS",@"description",[NSString stringWithFormat:@"%f",SCSSTotal],@"amount",[assetDetailObject valueForKeyPath:@"assetDetails.seniorCitizenSavingsScheme"],@"detail", nil], nil]];
        
        assetsArray = [[NSMutableArray alloc] initWithArray:array];
        
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.postOfficeScheme.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.postOfficeScheme.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.postOfficeScheme.xirr"]];
        
    }
    //Cash & Bank Account
    else if (assetIndexPath == 7) {
        
        NSArray *array = [[NSMutableArray alloc] initWithArray:[[assetDetailObject valueForKeyPath:@"assetDetails.cashInHand"] arrayByAddingObjectsFromArray:[assetDetailObject valueForKeyPath:@"assetDetails.bankAccount"]]];
        assetsArray = [[NSMutableArray alloc] initWithArray:array];
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.cashBankAccount.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.cashBankAccount.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.cashBankAccount.xirr"]];
        
    }
    //Gold
    else if (assetIndexPath == 8) {
        assetsArray = [[NSMutableArray alloc] initWithArray:[assetDetailObject valueForKeyPath:@"assetDetails.gold"]];
        
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.gold.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.gold.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.gold.xirr"]];
        
    }
    //Miscellaneous
    else if (assetIndexPath == 9) {
        assetsArray = [[NSMutableArray alloc] initWithArray:[assetDetailObject valueForKeyPath:@"assetDetails.otherAssets"]];
        assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.miscellaneous.currentValue"] floatValue];
        assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.miscellaneous.amountInvested"] floatValue];
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.miscellaneous.xirr"]];
    }
    else
    {
        
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
    
    
    _lblAssetCurrentValue.text = assetCurrentValueString;
    _lblAssetAmountInvested.text = totalInvestedValueString;
    _lblAssetGainLoss.text = totalGainLossValueString;
    if (assetIndexPath == 2 || assetIndexPath == 4 || assetIndexPath == 7 || assetIndexPath == 8 || assetIndexPath == 9) {
        _imgUpDownMain.hidden = TRUE;
        [_lblAssetReturns setText:@"-"];
        [_lblAssetReturns setBackgroundColor:[UIColor clearColor]];
        [_lblAssetReturns setTextColor:[UIColor blackColor]];
    }
    else
    {
        if (xirrValue.length > 0 && [xirrValue floatValue] > 0) {
            _lblAssetReturns.text = [NSString stringWithFormat:@"     %.2f%%",[xirrValue floatValue]];
        }
        else
        {
            _lblAssetReturns.text = [NSString stringWithFormat:@"     %.2f%%",fabs(100-(assetCurrentValueFloat * 100 / assetInvestedValueFloat))];
        }
    }
    
    
    
    
    CGPoint centerAssetPoint = _lblAssetReturns.center;
    CGRect rectAssetReturn = _lblAssetReturns.frame;
    
    [_lblAssetReturns sizeToFit];
    [_lblAssetReturns setFrame:CGRectMake(centerAssetPoint.x-_lblAssetReturns.frame.size.width/2-10, rectAssetReturn.origin.y, _lblAssetReturns.frame.size.width+10, rectAssetReturn.size.height)];
    
    [_imgUpDownMain setFrame:CGRectMake(_lblAssetReturns.frame.origin.x+2, _imgUpDownMain.frame.origin.y, _imgUpDownMain.frame.size.width, _imgUpDownMain.frame.size.height)];
    
    [_tblAssets reloadData];
    
    
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
    return [assetsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BOOL check = FALSE;
    
    if ((assetIndexPath == 0 || assetIndexPath == 1 ) && [[assetsArray objectAtIndex:section] count] > 0) {
        if (assetIndexPath == 0) {
            if ([[[[assetsArray objectAtIndex:section] firstObject] valueForKeyPath:@"calculated.currentValue"] floatValue] > 0) {
                check = TRUE;
            }
        }
        else
        {
            if ([[[[assetsArray objectAtIndex:section] firstObject] valueForKeyPath:@"currentValue"] floatValue] > 0) {
                check = TRUE;
            }
            
        }
        
    }
    else if ((( assetIndexPath == 2 || assetIndexPath == 4 || assetIndexPath == 5 || assetIndexPath == 7 || assetIndexPath == 8 || assetIndexPath == 9 ) )){ //&& [[[assetsArray objectAtIndex:section] valueForKeyPath:@"calculated.currentValue"] floatValue] > 0)) {
        check = TRUE;
        
    }
    else if ((assetIndexPath == 3 || assetIndexPath == 6) && [[[assetsArray objectAtIndex:section] valueForKeyPath:@"amount"] floatValue] > 0) {
        check = TRUE;
    }
    if (check == TRUE) {
        return 44;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (assetIndexPath == 0 || assetIndexPath == 1 ) {
        if ([[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] floatValue] > 0) {
            return 110;
        }
    }
    else if ([[[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] floatValue] > 0) {
        if (assetIndexPath == 3 || assetIndexPath == 6) {
            return 44;
        }
        return 110;
    }
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *barHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, isTappable?tableView.frame.size.width-95:tableView.frame.size.width-85, 44)];
    [lblTitle setFont:[UIFont systemFontOfSize:[appFunc getFontSize:45.0]]];
    [barHeaderView addSubview:lblTitle];
    
    
    UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(isTappable?tableView.frame.size.width - 85:tableView.frame.size.width - 75, 0, 65, 44)];
    [lblAmount setTextAlignment:NSTextAlignmentRight];
    [lblAmount setFont:[UIFont systemFontOfSize:[appFunc getFontSize:45.0]]];
    [barHeaderView addSubview:lblAmount];
    
    UIImageView *imgLeftBorder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
    [imgLeftBorder setBackgroundColor:IFAGreyColor];
    [barHeaderView addSubview:imgLeftBorder];
    
    UIImageView *imgRightBorder = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-1, 0, 1, 44)];
    [imgRightBorder setBackgroundColor:IFAGreyColor];
    [barHeaderView addSubview:imgRightBorder];
    
    if (section == 0 || [[assetsArray objectAtIndex:section] count] == 1) {
        UIImageView *imgTopBorder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        [imgTopBorder setBackgroundColor:IFAGreyColor];
        [barHeaderView addSubview:imgTopBorder];
    }
    
    UIImageView *imgBottomBorder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, tableView.frame.size.width, 1)];
    [imgBottomBorder setBackgroundColor:IFAGreyColor];
    [barHeaderView addSubview:imgBottomBorder];
    
    UIImageView *imgCornerArrow = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-17, 18, 12, 8)];
    [imgCornerArrow setBackgroundColor:[UIColor clearColor]];
    [barHeaderView addSubview:imgCornerArrow];
    
    
    UIButton *btnTapHeaderSectionView = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTapHeaderSectionView.tag = 1000+section;
    [btnTapHeaderSectionView addTarget:self action:@selector(btnTapHeaderSectionView:) forControlEvents:UIControlEventTouchUpInside];
    btnTapHeaderSectionView.frame = barHeaderView.frame;
    [barHeaderView addSubview:btnTapHeaderSectionView];
    
    if (selectedSectionIndex == section) {
        [barHeaderView setBackgroundColor:IFAPrimaryColor];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblAmount setTextColor:[UIColor whiteColor]];
        [imgCornerArrow setImage:[UIImage imageNamed:@"arrow_grey_up.png"]];
    }
    else
    {
        [barHeaderView setBackgroundColor:[UIColor whiteColor]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblAmount setTextColor:[UIColor blackColor]];
        [imgCornerArrow setImage:[UIImage imageNamed:@"arrow_grey_down.png"]];
    }
    
    if (isTappable == FALSE) {
        imgCornerArrow.hidden = TRUE;
    }
    
    if (assetIndexPath == 0 || assetIndexPath == 1 ) {
        float value=0;
        for (int i = 0; i< [[assetsArray objectAtIndex:section] count]; i++) {
            value+=[[[[assetsArray objectAtIndex:section] objectAtIndex:i] valueForKeyPath:@"calculated.currentValue"] floatValue];
        }
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:value];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        if (assetIndexPath == 0) {
            
            

            [lblTitle setText:[[[assetsArray objectAtIndex:section] firstObject] valueForKeyPath:@"mutualFundSubCategory"]];
            
        }
        else
        {
            
            
            [lblTitle setText:[[[assetsArray objectAtIndex:section] firstObject] valueForKeyPath:@"stockCategory"]];
            
        }
        [lblAmount setText:assetCurrentValueString];
    }
    else if (assetIndexPath == 2) {
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:[[[assetsArray objectAtIndex:section] valueForKeyPath:@"calculated.currentValue"] floatValue]];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        [lblTitle setText:[[assetsArray objectAtIndex:section] valueForKeyPath:@"policy.lifeInsurancePolicyName"]];
        [lblAmount setText:assetCurrentValueString];
        
    }
    else if (assetIndexPath == 3 || assetIndexPath == 6) {
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:[[[assetsArray objectAtIndex:section] valueForKeyPath:@"amount"] floatValue]];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        [lblTitle setText:[[assetsArray objectAtIndex:section] valueForKey:@"description"]];
        [lblAmount setText:assetCurrentValueString];
        
    }
    else if (assetIndexPath == 4 || assetIndexPath == 5 || assetIndexPath == 7 || assetIndexPath == 8) {
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:[[[assetsArray objectAtIndex:section] valueForKeyPath:@"calculated.currentValue"] floatValue]];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        [lblTitle setText:[[assetsArray objectAtIndex:section] valueForKey:@"description"]];
        [lblAmount setText:assetCurrentValueString];
        
    }
    else if (assetIndexPath == 9) {
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:[[[assetsArray objectAtIndex:section] valueForKeyPath:@"calculated.currentValue"] floatValue]];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        [lblTitle setText:[[assetsArray objectAtIndex:section] valueForKey:@"assetDescription"]];
        [lblAmount setText:assetCurrentValueString];
    }
    else
    {
        
    }
    [lblAmount sizeToFit];
    [lblTitle setFrame:CGRectMake(lblTitle.frame.origin.x, lblTitle.frame.origin.y, tableView.frame.size.width-lblTitle.frame.origin.x-lblAmount.frame.size.width-(isTappable?20:10), lblTitle.frame.size.height)];
    [lblAmount setFrame:CGRectMake(lblTitle.frame.origin.x+lblTitle.frame.size.width, lblTitle.frame.origin.y, lblAmount.frame.size.width, lblTitle.frame.size.height)];
    
    
    return barHeaderView;
}
-(void)btnTapHeaderSectionView:(UIButton *)sender
{
    if (isTappable == TRUE) {
        if (selectedSectionIndex == sender.tag - 1000) {
            selectedSectionIndex = -1;
        }
        else
        {
            selectedSectionIndex = (int)sender.tag - 1000;
        }
        [_tblAssets reloadData];
    }
    else
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TransactionsViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"TransactionsViewController"];
        previewController.assetIndexPath = (int)sender.tag - 1000;
        previewController.mainIndexPath = assetIndexPath;
        if (assetIndexPath == 2) {
            if ([[[assetsArray objectAtIndex:sender.tag - 1000] valueForKeyPath:@"policy.lifeInsurancePolicyName"] length] > 0) {
                previewController.description = [[assetsArray objectAtIndex:sender.tag - 1000] valueForKeyPath:@"policy.lifeInsurancePolicyName"];
            }
            else
                previewController.description = _lblAssetTitle.text;
            
        }
        else if ( assetIndexPath == 4 || assetIndexPath == 5 || assetIndexPath == 7 || assetIndexPath == 8) {
            if ([[[assetsArray objectAtIndex:sender.tag - 1000] valueForKey:@"description"] length] > 0) {
                previewController.description = [[assetsArray objectAtIndex:sender.tag - 1000] valueForKey:@"description"];
            }
            else
                previewController.description = _lblAssetTitle.text;
        }
        else if (assetIndexPath == 9) {
            if ([[[assetsArray objectAtIndex:sender.tag - 1000] valueForKey:@"assetDescription"] length] > 0) {
                previewController.description = [[assetsArray objectAtIndex:sender.tag - 1000] valueForKey:@"assetDescription"];
            }
            else
                previewController.description = _lblAssetTitle.text;
            
        }
        else
        {
            previewController.description = @"";
        }

        [self.navigationController pushViewController:previewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedSectionIndex == section && isTappable == TRUE) {
        if (assetIndexPath == 0 || assetIndexPath == 1 ) {
            return [[assetsArray objectAtIndex:section] count];
        }
        else
            return [[[assetsArray objectAtIndex:section] valueForKey:@"detail"]count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (assetIndexPath == 3 || assetIndexPath == 6) {
        static NSString *simpleTableIdentifier = @"AssetDetailSimpleTableViewCellIdentifier";
        AssetDetailSimpleTableViewCell *cell = (AssetDetailSimpleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetDetailSimpleTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblTitle setFont:[UIFont systemFontOfSize:[appFunc getFontSize:45.0]]];
            [cell.lblAmount setFont:[UIFont systemFontOfSize:[appFunc getFontSize:45.0]]];
        }
        
        if ([[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"description"]) {
            cell.lblTitle.text = [[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"description"];
        }
        else if ([[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"bondName"]) {
            cell.lblTitle.text = [[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"bondName"];
        }
        else
            cell.lblTitle.text = @"";
        
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:[[[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] floatValue]];
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        
        cell.lblAmount.text = assetCurrentValueString;
        
        return cell;
    }
    else
    {
        
        float assetCurrentValueFloat,assetInvestedValueFloat,diffBetweenValue;
        
        NSString *xirrValue;
        
        
        
        
         static NSString *simpleTableIdentifier = @"AssetDetailTableViewCellIdentifier";
        AssetDetailTableViewCell *cell = (AssetDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetDetailTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if ([[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"familyMemberId"]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"folioNo"]) {
                
                [array addObject:[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"folioNo"]];
            }
            [array addObject:[self getClientName:[NSString stringWithFormat:@"%@",[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"familyMemberId"]]]];
            cell.lblName.text = [array componentsJoinedByString:@", "];
        }
        else
            cell.lblName.text = @"-";
        
        if (assetIndexPath == 0) {
            if ([[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"schemeName"]) {
                cell.lblTitle.text = [[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"schemeName"];
            }
            else
                cell.lblTitle.text = @"-";
            
            
            
            
            
            if ([[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] isKindOfClass:[NSNull class]]) {
                assetCurrentValueFloat = 0;
            }
            else
            {
                assetCurrentValueFloat = [[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] floatValue];
            }
            
            if ([[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.amountInvested"] isKindOfClass:[NSNull class]]) {
                assetInvestedValueFloat = 0;
            }
            else
            {
                assetInvestedValueFloat = [[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.amountInvested"] floatValue];
            }
            
            xirrValue = [NSString stringWithFormat:@"%@",[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.xirr"]];
            

        }
        else
        {
            if ([[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"scripName"]) {
                cell.lblTitle.text = [[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"scripName"];
            }
            else
                cell.lblTitle.text = @"-";
            
            
            
            
            
            if ([[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] isKindOfClass:[NSNull class]]) {
                assetCurrentValueFloat = 0;
            }
            else
            {
                assetCurrentValueFloat = [[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.currentValue"] floatValue];
            }
            
            if ([[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"totalCost"] isKindOfClass:[NSNull class]]) {
                assetInvestedValueFloat = 0;
            }
            else
            {
                assetInvestedValueFloat = [[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"totalCost"] floatValue];
            }
            
            xirrValue = [NSString stringWithFormat:@"%@",[[[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKeyPath:@"calculated.unrealizedGainLossPercent"]];
            

        }
        
        
        
        
        diffBetweenValue = assetCurrentValueFloat-assetInvestedValueFloat;
        
        
        NSNumber *assetCurrentValueNumber = [NSNumber numberWithFloat:assetCurrentValueFloat];
        NSNumber *assetInvestedValueNumber = [NSNumber numberWithFloat:assetInvestedValueFloat];
        
        NSNumber *assetGainLossValueNumber = [NSNumber numberWithFloat:fabsf(diffBetweenValue)];
        if (diffBetweenValue < 0) {
            [cell.lblGainLoss setTextColor:IFARedColor];
            [cell.lblReturn setBackgroundColor:IFARedColor];
            [cell.imgUpDown setImage:[UIImage imageNamed:@"arrow_down.png"]];
        }
        
        
        NSString *assetCurrentValueString = [numberFormatter stringFromNumber:assetCurrentValueNumber];
        NSString *totalInvestedValueString = [numberFormatter stringFromNumber:assetInvestedValueNumber];
        NSString *totalGainLossValueString = [numberFormatter stringFromNumber:assetGainLossValueNumber];
        
        
        cell.lblAmount.text = assetCurrentValueString;
        cell.lblAmountInvested.text = totalInvestedValueString;
        cell.lblGainLoss.text = totalGainLossValueString;
        
        if (xirrValue.length > 0 && [xirrValue floatValue] > 0) {
            cell.lblReturn.text = [NSString stringWithFormat:@"     %.2f%%",[xirrValue floatValue]];
        }
        else
        {
            cell.lblReturn.text = [NSString stringWithFormat:@"     %.2f%%",fabs(100-(assetCurrentValueFloat * 100 / assetInvestedValueFloat))];
        }
        
        CGPoint centerAssetPoint = cell.lblReturn.center;
        CGRect rectAssetReturn = cell.lblReturn.frame;
        
        [cell.lblReturn sizeToFit];
        [cell.lblReturn setFrame:CGRectMake(cell.frame.size.width-cell.lblReturn.frame.size.width-16, rectAssetReturn.origin.y, cell.lblReturn.frame.size.width+10, rectAssetReturn.size.height)];
        
        [cell.imgUpDown setFrame:CGRectMake(cell.lblReturn.frame.origin.x+2, cell.imgUpDown.frame.origin.y, cell.imgUpDown.frame.size.width, cell.imgUpDown.frame.size.height)];
    
        
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (assetIndexPath == 0 || assetIndexPath == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AssetTransactionDetailViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"AssetTransactionDetailViewController"];
        previewController.assetsArray = [[assetsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        previewController.checkMS = assetIndexPath == 0? TRUE:FALSE;
        if (assetIndexPath == 0) {
            previewController.dividendAmount = [[assetDetailObject valueForKeyPath:@"assetDetails.mutualFund.dividendTillToday"] isKindOfClass:[NSArray class]]?[[[assetDetailObject valueForKeyPath:@"assetDetails.mutualFund.dividendTillToday"] firstObject] floatValue]:[[assetDetailObject valueForKeyPath:@"assetDetails.mutualFund.dividendTillToday"] floatValue];
            
        }
        [self.navigationController pushViewController:previewController animated:YES];
    }
    else if (assetIndexPath == 3 || assetIndexPath == 6) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TransactionsViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"TransactionsViewController"];
        previewController.assetIndexPath = (int)indexPath.section;
        previewController.mainIndexPath = assetIndexPath;
        previewController.assetSubIndexPath = (int)indexPath.row;
        if (assetIndexPath == 3 || assetIndexPath == 6) {
            if (assetIndexPath == 3) {
                previewController.description = [[[[assetsArray objectAtIndex:indexPath.section] valueForKey:@"detail"] objectAtIndex:indexPath.row] valueForKeyPath:@"description"];
            }
            else
                previewController.description = [[assetsArray objectAtIndex:indexPath.section] valueForKey:@"description"];
        }
        else
            previewController.description = @"";
        [self.navigationController pushViewController:previewController animated:YES];
    }
    
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - WebService Delegate

-(void)webServiceApiResult:(id)result
{
    
    if (apiType == WebServiceTypeGetStocks) {
        if (result != nil && result != [NSNull null]) {
            id assetMutableDictionary = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
            [assetMutableDictionary setValue:result forKeyPath:@"stock"];
            
            NSString *loansArrayString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[[[[appFunc fetchObjectsFromDatabaseForEntity:@"IFALoansDetail"] valueForKey:@"data"] valueForKey:@"loanList"] firstObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
            NSString *assetMutableDictionaryString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:assetMutableDictionary options:0 error:nil] encoding:NSUTF8StringEncoding];
            NSString *clientListArrayString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[[[[appFunc fetchObjectsFromDatabaseForEntity:@"IFAClientDetail"] valueForKey:@"data"] valueForKey:@"clientList"] firstObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
            NSString *parameterStringJsonObject = [NSString stringWithFormat:@"{\"loans\":%@,\"assetDetails\":%@,\"clientList\":%@}",loansArrayString,assetMutableDictionaryString,clientListArrayString];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                apiType = WebServiceTypeCalculatedAsset;
                [appFunc callWebService:@"node-utils-platform/assets-calculation/getCalculatedAssetDetailObject" parameters:parameterStringJsonObject];
            });
            
        }
        else
        {
            assetDetailObject = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
            
            NSMutableArray *newArray = [self groupStockSameSubCategories:[assetDetailObject valueForKeyPath:@"assetDetails.stock"]];
            assetsArray = [[NSMutableArray alloc] initWithArray:newArray];
            
            [_tblAssets reloadData];
            
            _activityIndicator.hidden = TRUE;
        }
    }
    else if (apiType == WebServiceTypeGetMutualFunds)
    {
        _activityIndicator.hidden = TRUE;
        if (result != nil && result != [NSNull null]) {
            id assetDetailObjectTemp = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
            [assetDetailObjectTemp setValue:result forKeyPath:@"assetDetails.mutualFund"];
           
            [appFunc insertIntoDatabaseWithEntity:@"IFACalculatedAssets" insertObject:assetDetailObjectTemp deleteObjects:YES];
            
            assetDetailObject = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
            
            assetsArray = [[NSMutableArray alloc] initWithArray:[self groupSameSubCategories:[assetDetailObject valueForKeyPath:@"assetDetails.mutualFund"]]];
            [_tblAssets reloadData];
            
            

        }
        else
            _activityIndicator.hidden = TRUE;
    }
    else if(apiType == WebServiceTypeCalculatedAsset)
    {
        _activityIndicator.hidden = TRUE;
        if (result != nil && result != [NSNull null]) {
//            [appFunc insertIntoDatabaseWithEntity:@"IFACalculatedAssets" insertObject:result deleteObjects:YES];
            
            id assetDetailObjectTemp = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
            [assetDetailObjectTemp setValue:[result valueForKeyPath:@"assetTotalCalculatedObj.stocks"] forKeyPath:@"assetTotalCalculatedObj.stocks"];
            [assetDetailObjectTemp setValue:[result valueForKeyPath:@"assetDetails.stock"] forKeyPath:@"assetDetails.stock"];
            
            [appFunc insertIntoDatabaseWithEntity:@"IFACalculatedAssets" insertObject:assetDetailObjectTemp deleteObjects:YES];
            
            assetDetailObject = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
            
            NSError *error;
            if (![IFAAppDelegate.context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
            
            
            float assetCurrentValueFloat,assetInvestedValueFloat,diffBetweenValue;
            
            NSString *xirrValue;
            
            if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.currentValue"] isKindOfClass:[NSNull class]]) {
                assetCurrentValueFloat = 0;
            }
            else
            {
                assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.currentValue"] floatValue];
            }
            
            if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.amountInvested"] isKindOfClass:[NSNull class]]) {
                assetInvestedValueFloat = 0;
            }
            else
            {
                assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.amountInvested"] floatValue];
            }
            
            xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.stocks.xirr"]];
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
            
            
            _lblAssetCurrentValue.text = assetCurrentValueString;
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
            
            
            
            NSMutableArray *newArray = [self groupStockSameSubCategories:[assetDetailObject valueForKeyPath:@"assetDetails.stock"]];
            assetsArray = [[NSMutableArray alloc] initWithArray:newArray];
            
            
            
            [_tblAssets reloadData];
        }
        else
            _activityIndicator.hidden = TRUE;
        
        
    }
}

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
-(NSMutableArray *)groupSameSubCategories:(id)result
{
    NSMutableDictionary *grouped = [NSMutableDictionary dictionaryWithCapacity:[result count]];
    for (NSDictionary *dict in result) {
        id key = [dict valueForKey:@"mutualFundSubCategory"];
        
        NSMutableArray *tmp = [grouped objectForKey:key];
        if (tmp == nil) {
            tmp = [[NSMutableArray alloc] init];
            [grouped setObject:tmp forKey:key];
        }
        [tmp addObject:dict];
    }
    NSArray * sortedKeys = [[grouped allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    NSArray * objects = [grouped objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    NSMutableArray *arraySorted = [NSMutableArray arrayWithArray:objects];
    return arraySorted;
}
-(NSMutableArray *)groupStockSameSubCategories:(id)result
{
    NSMutableDictionary *grouped = [NSMutableDictionary dictionaryWithCapacity:[result count]];
    for (NSDictionary *dict in result) {
        id key = [dict valueForKey:@"stockCategory"];
        
        NSMutableArray *tmp = [grouped objectForKey:key];
        if (tmp == nil) {
            tmp = [[NSMutableArray alloc] init];
            [grouped setObject:tmp forKey:key];
        }
        [tmp addObject:dict];
    }
    NSArray * sortedKeys = [[grouped allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    NSArray * objects = [grouped objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    NSMutableArray *arraySorted = [NSMutableArray arrayWithArray:objects];
    return arraySorted;
}
-(void)noInternetPopUp
{
    _activityIndicator.hidden = TRUE;
    [appFunc showAlert:@"Please check your internet connection or try again later!" view:self];
}
- (IBAction)btnMembers:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TransactionsViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"TransactionsViewController"];
    previewController.delegate = self;
    previewController.showMembers = TRUE;
    [self.navigationController pushViewController:previewController animated:YES];
}
-(void)getFilterDetail:(id)filterDetail
{
    float assetCurrentValueFloat=0,assetInvestedValueFloat=0,diffBetweenValue=0;
    NSString *xirrValue = @"0";
    
    selectedMember = [NSString stringWithFormat:@"%@",filterDetail];
    assetsArray = [[NSMutableArray alloc] initWithArray:[self groupSameSubCategories:[assetDetailObject valueForKeyPath:@"assetDetails.mutualFund"]]];
    if ([selectedMember intValue] > 0) {
        for (int i = 0; i<[assetsArray count]; i++) {
            for (int j=0; j<[[assetsArray objectAtIndex:i] count]; j++) {
                NSString *selectedMemberData = [NSString stringWithFormat:@"%@",[[[assetsArray objectAtIndex:i] objectAtIndex:j] valueForKeyPath:@"familyMemberId"]];
                if (![selectedMemberData isEqualToString:selectedMember]) {
                    [[assetsArray objectAtIndex:i] removeObjectAtIndex:j];
                    j-=1;
                }
            }
            if ([[assetsArray objectAtIndex:i] count] == 0) {
                [assetsArray removeObjectAtIndex:i];
                i-=1;
            }
        }
        for (int i = 0; i<[assetsArray count]; i++) {
            for (int j=0; j<[[assetsArray objectAtIndex:i] count]; j++) {
                if (![[[[assetsArray objectAtIndex:i] objectAtIndex:j] valueForKeyPath:@"calculated.currentValue"] isKindOfClass:[NSNull class]]) {
                    assetCurrentValueFloat += [[[[assetsArray objectAtIndex:i] objectAtIndex:j] valueForKeyPath:@"calculated.currentValue"] floatValue];
                }
                
                if (![[[[assetsArray objectAtIndex:i] objectAtIndex:j] valueForKeyPath:@"calculated.amountInvested"] isKindOfClass:[NSNull class]]) {
                    assetInvestedValueFloat += [[[[assetsArray objectAtIndex:i] objectAtIndex:j] valueForKeyPath:@"calculated.amountInvested"] floatValue];
                }
            }
        }
    }
    else
    {
        
        if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.currentValue"] isKindOfClass:[NSNull class]]) {
            assetCurrentValueFloat = 0;
        }
        else
        {
            assetCurrentValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.currentValue"] floatValue];
        }
        
        if ([[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.amountInvested"] isKindOfClass:[NSNull class]]) {
            assetInvestedValueFloat = 0;
        }
        else
        {
            assetInvestedValueFloat = [[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.amountInvested"] floatValue];
        }
        
        xirrValue = [NSString stringWithFormat:@"%@",[assetDetailObject valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.xirr"]];
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
    
    
    _lblAssetCurrentValue.text = assetCurrentValueString;
    _lblAssetAmountInvested.text = totalInvestedValueString;
    _lblAssetGainLoss.text = totalGainLossValueString;
    
    if (xirrValue.length > 0 && [xirrValue floatValue] > 0) {
        _lblAssetReturns.text = [NSString stringWithFormat:@"     %.2f%%",[xirrValue floatValue]];
    }
    else
    {
        _lblAssetReturns.text = [NSString stringWithFormat:@"     %.2f%%",fabs(100-(assetCurrentValueFloat * 100 / assetInvestedValueFloat))];
    }
    
    
    CGRect rectAssetReturn = _lblAssetReturns.frame;
    
    [_lblAssetReturns sizeToFit];
    [_lblAssetReturns setFrame:CGRectMake(lblReturnX.x-_lblAssetReturns.frame.size.width/2-10, rectAssetReturn.origin.y, _lblAssetReturns.frame.size.width+10, rectAssetReturn.size.height)];
    
    [_imgUpDownMain setFrame:CGRectMake(_lblAssetReturns.frame.origin.x+2, _imgUpDownMain.frame.origin.y, _imgUpDownMain.frame.size.width, _imgUpDownMain.frame.size.height)];
    

    [_tblAssets reloadData];
}
@end
