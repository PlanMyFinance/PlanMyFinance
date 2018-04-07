//
//  TransactionsViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 05/08/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "TransactionsViewController.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController
@synthesize assetIndexPath,mainIndexPath,assetSubIndexPath,showMembers,delegate,checkMS,navValue,transactionDetail,description;
- (void)viewDidLoad {
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    
    appFunc = [AppFunctions shared];
    
    assetDetailObject = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject];
    
    clientDetail = [[[appFunc fetchObjectsFromDatabaseForEntity:@"IFAClientDetail"] valueForKey:@"data"] firstObject];
    if (checkMS == nil) {
        if (showMembers == FALSE) {
            if (mainIndexPath == 2) {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.lifeInsurance"] objectAtIndex:assetIndexPath]];
                
                //    _lblTitle.text = [self showEmptyField:@"policy.lifeInsurancePolicyName"];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Policy Number",@"Current Value",@"Commencement Date",@"Sum Assured",@"Policy Term",@"Policy Paying Term",@"Nominee Name",@"Premium Amount",@"Premium Frequency", nil];
                
                
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"policyNumber"]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertValue:[[self showEmptyField:@"sumAssured"] floatValue]],[self getTenure:[self showEmptyField:@"policyTerm"]?[[self showEmptyField:@"policyTerm"] intValue]:0 month:0 day:0],[self getTenure:[self showEmptyField:@"policyPpt"]?[[self showEmptyField:@"policyPpt"] intValue]:0 month:0 day:0],[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"nomineeFamilyMemberId"]]],[appFunc convertValue:[[self showEmptyField:@"premiumAmount"] floatValue]],([[self showEmptyField:@"premiumFrequency"] floatValue] > 0)?[NSString stringWithFormat:@"%@",[self premiumFrequencyField:@"premiumFrequency"]]:@"Single Premium", nil];
            }
            else if(mainIndexPath == 3 && (assetIndexPath == 0 || assetIndexPath == 1))
            {
                if (assetIndexPath == 0) {
                    mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.bankFixedDeposit"] objectAtIndex:assetSubIndexPath]];
                }
                else
                    mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.companyFixedDeposit"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Commencement Date",@"Maturity Date",@"Tenure",@"Tenure Remaining",@"Maturity Amount",@"FD Number",@"Type",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self getTenure:[self showEmptyField:@"tenureYears"]?[[self showEmptyField:@"tenureYears"] intValue]:0 month:[self showEmptyField:@"tenureMonths"]?[[self showEmptyField:@"tenureMonths"] intValue]:0 day:[self showEmptyField:@"tenureDays"]?[[self showEmptyField:@"tenureDays"] intValue]:0],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"fdNumber"]],(assetIndexPath == 0)?@"Bank Fixed Deposit":@"Company Fixed Deposit",[[self showEmptyField:@"description"] length]>0?[self showEmptyField:@"description"]:([NSString stringWithFormat:@"%@",[self showEmptyField:@"fdNumber"]].floatValue > 0)?[NSString stringWithFormat:@"FD | %@",[self showEmptyField:@"fdNumber"]]:@"FD", nil];
            }
            else if(mainIndexPath == 3 && assetIndexPath == 2)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.fixedIncomeBonds"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Commencement Date",@"Maturity Date",@"Maturity Amount",@"Type",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[self showEmptyField:@"type"],[self showEmptyField:@"bondDescription"], nil];
            }
            else if(mainIndexPath == 3 && assetIndexPath == 3)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.bankRecurringDeposit"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Amount Invested",@"Commencement Date",@"Maturity Date",@"Tenure",@"Tenure Remaining",@"Monthly Deposit",@"Rate",@"RD Number",@"Type",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.amountInvested"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self getTenure:[self showEmptyField:@"tenureYears"]?[[self showEmptyField:@"tenureYears"] intValue]:0 month:[self showEmptyField:@"tenureMonths"]?[[self showEmptyField:@"tenureMonths"] intValue]:0 day:[self showEmptyField:@"tenureDays"]?[[self showEmptyField:@"tenureDays"] intValue]:0],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertValue:[[self showEmptyField:@"monthlyDeposit"] floatValue]],[NSString stringWithFormat:@"%@%%",[self showEmptyField:@"interestRate"]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"rdNumber"]],@"Bank Recurring Deposit",[self showEmptyField:@"description"], nil];
            }
            else if(mainIndexPath == 4)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.realEstate"] objectAtIndex:assetIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Type",@"Owner",@"Purchase Year",@"Purchase Value",@"Market Value*",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",[self showEmptyField:@"type"]],[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"purchaseYear"]],[appFunc convertValue:[[self showEmptyField:@"purchaseValue"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"marketValue"] floatValue]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"description"]], nil];
            }
            else if(mainIndexPath == 5)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.employeesProvidentFund"] objectAtIndex:assetIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current EPF Balance",@"Balance as on",@"Employee's Monthly Contribution",@"Employer's Monthly Contribution",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"balanceAsOn"]],[appFunc convertValue:[[self showEmptyField:@"employeesMonthlyContribution"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"employersMonthlyContribution"] floatValue]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"description"]], nil];
            }
            
            
            
            
            
            
            else if(mainIndexPath == 6 && assetIndexPath == 0)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.publicProvidentFund"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Balance",@"Rate",@"Balance Mentioned",@"Balance as on",@"Tenure Remaining",@"Balance Mentioned",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[NSString stringWithFormat:@"%.2f%%",[[self showEmptyField:@"calculated.rate"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.amountInvested"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"balanceAsOn"]],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertValue:[[self showEmptyField:@"annualContribution"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"maturityDate"]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"description"]], nil];
            }
            else if(mainIndexPath == 6 && assetIndexPath == 1)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.nationalSavingsCertificate"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Rate",@"Amount Invested",@"Maturity Value",@"Tenure",@"Tenure Remaining",@"Commencement Date",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[NSString stringWithFormat:@"%.2f%%",[[self showEmptyField:@"calculated.rate"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"amountInvested"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[self getTenure:[self showEmptyField:@"tenureYears"]?[[self showEmptyField:@"tenureYears"] intValue]:0 month:[self showEmptyField:@"tenureMonths"]?[[self showEmptyField:@"tenureMonths"] intValue]:0 day:[self showEmptyField:@"tenureDays"]?[[self showEmptyField:@"tenureDays"] intValue]:0],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self showEmptyField:@"description"], nil];
            }
            else if(mainIndexPath == 6 && assetIndexPath == 2)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.kisanVikasPatra"] objectAtIndex:assetSubIndexPath]];
                
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Rate",@"Amount Invested",@"Maturity Value",@"Tenure Remaining",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[NSString stringWithFormat:@"%.2f%%",[[self showEmptyField:@"calculated.rate"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"amountInvested"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self showEmptyField:@"description"], nil];
                
                
                
                
                
            }
            else if (mainIndexPath == 6 && assetIndexPath == 3) {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.postOfficeMonthlyIncomeScheme"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Rate",@"Amount Invested",@"Maturity Value",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[NSString stringWithFormat:@"%.2f%%",[[self showEmptyField:@"calculated.rate"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"amountInvested"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self showEmptyField:@"description"], nil];
            }
            else if(mainIndexPath == 6 && assetIndexPath == 4)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.fixedDeposit.postOfficeFixedDeposit"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Amount Invested",@"Maturity Value",@"FD Number",@"Tenure",@"Tenure Remaining",@"Commencement Date",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"amountInvested"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"fdNumber"]],[self getTenure:[self showEmptyField:@"tenureYears"]?[[self showEmptyField:@"tenureYears"] intValue]:0 month:[self showEmptyField:@"tenureMonths"]?[[self showEmptyField:@"tenureMonths"] intValue]:0 day:[self showEmptyField:@"tenureDays"]?[[self showEmptyField:@"tenureDays"] intValue]:0],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self showEmptyField:@"description"], nil];
            }
            else if(mainIndexPath == 6 && assetIndexPath == 5)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.recurringDeposit.postOfficeRecurringDeposit"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Tenure",@"RD Number",@"Tenure Remaining",@"Commencement Date",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[self getTenure:[self showEmptyField:@"tenureYears"]?[[self showEmptyField:@"tenureYears"] intValue]:0 month:[self showEmptyField:@"tenureMonths"]?[[self showEmptyField:@"tenureMonths"] intValue]:0 day:[self showEmptyField:@"tenureDays"]?[[self showEmptyField:@"tenureDays"] intValue]:0],[NSString stringWithFormat:@"%@",[self showEmptyField:@"rdNumber"]],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self showEmptyField:@"description"], nil];
            }
            else if(mainIndexPath == 6 && assetIndexPath == 6)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.seniorCitizenSavingsScheme"] objectAtIndex:assetSubIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Current Value",@"Rate",@"Amount Invested",@"Maturity Value",@"Tenure Remaining",@"Commencement Date",@"Maturity Date",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"calculated.currentValue"] floatValue]],[NSString stringWithFormat:@"%.2f%%",[[self showEmptyField:@"calculated.rate"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"amountInvested"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"calculated.maturityValue"] floatValue]],[self getTenureRemaining:[self showEmptyField:@"calculated.tenureRemaining"]?[[self showEmptyField:@"calculated.tenureRemaining"] intValue]:0],[appFunc convertingDateFormat:[self showEmptyField:@"commencementDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"calculated.maturityDate"]],[self showEmptyField:@"description"], nil];
            }
            
            else if(mainIndexPath == 7)
            {
                NSArray *array = [[NSMutableArray alloc] initWithArray:[[assetDetailObject valueForKeyPath:@"assetDetails.cashInHand"] arrayByAddingObjectsFromArray:[assetDetailObject valueForKeyPath:@"assetDetails.bankAccount"]]];
                if ([[assetDetailObject valueForKeyPath:@"assetDetails.cashInHand"] count] != 0 && assetIndexPath < [[assetDetailObject valueForKeyPath:@"assetDetails.cashInHand"] count]) {
                    
                    
                    mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[array objectAtIndex:assetIndexPath]];
                    
                    titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Advice Created Date",@"Advice Last Modified Date",@"Approx. Balance",@"Description", nil];
                    
                    valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertingDateFormat:[self showEmptyField:@"assetAdvice.adviceCreatedDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"assetAdvice.adviceLastModifiedDate"]],[appFunc convertValue:[[self showEmptyField:@"approximateCashValue"] floatValue]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"description"]], nil];
                }
                else
                {
                    mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[array objectAtIndex:assetIndexPath]];
                    
                    titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Account Type",@"Advice Created Date",@"Advice Last Modified Date",@"Current Balance",@"Description", nil];
                    
                    valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"type"]],[appFunc convertingDateFormat:[self showEmptyField:@"assetAdvice.adviceCreatedDate"]],[appFunc convertingDateFormat:[self showEmptyField:@"assetAdvice.adviceLastModifiedDate"]],[appFunc convertValue:[[self showEmptyField:@"currentBalance"] floatValue]],[NSString stringWithFormat:@"%@",[self showEmptyField:@"description"]], nil];
                }
                
            }
            else if(mainIndexPath == 8)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.gold"] objectAtIndex:assetIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Approx. Purchase Value",@"Approx. Current Value",@"Approx. Yearly Investment",@"Description", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"approxPurchaseValue"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"approxCurrentValue"] floatValue]],@"-",[NSString stringWithFormat:@"%@",[self showEmptyField:@"description"]], nil];
            }
            else if(mainIndexPath == 9)
            {
                mainDictionaryForTransaction = [[NSDictionary alloc] initWithDictionary:[[assetDetailObject valueForKeyPath:@"assetDetails.otherAssets"] objectAtIndex:assetIndexPath]];
                
                titleForRow = [[NSMutableArray alloc] initWithObjects:@"Owner",@"Purchase Value",@"Current Value",@"Modified Date",@"Growth Rate", nil];
                
                valueForRow = [[NSMutableArray alloc] initWithObjects:[self getClientName:[NSString stringWithFormat:@"%@",[self showEmptyField:@"owner"]]],[appFunc convertValue:[[self showEmptyField:@"purchaseValue"] floatValue]],[appFunc convertValue:[[self showEmptyField:@"currentValue"] floatValue]],[appFunc convertingDateFormat:[self showEmptyField:@"currentValueModifiedDate"]],[NSString stringWithFormat:@"%@%%",[self showEmptyField:@"growthRate"]], nil];
            }
            
            
            valueForRow =  [self removeNullValues:valueForRow];
        }
        else
        {
            _lblTitle.text = @"MEMBERS";
            titleForRow = [[NSMutableArray alloc] init];
            for (int i = 0; i< [[[[clientDetail valueForKeyPath:@"clientList"] objectAtIndex:0] valueForKey:@"familyMembers"] count]; i++) {
                [titleForRow addObject:[NSString stringWithFormat:@"%@",[[[[[clientDetail valueForKeyPath:@"clientList"] objectAtIndex:0] valueForKey:@"familyMembers"] objectAtIndex:i] valueForKey:@"familyMemberId"]]];
            }
        }
    }
    else
    {
        _lblTitle.text = @"TRANSACTION DETAIL";
        
        if ([checkMS isEqualToString:@"1"]) {
            titleForRow = [[NSMutableArray alloc] initWithObjects:@"Transaction Date",@"Transaction Type",@"Unit",@"NAV",@"Amount", nil];
            valueForRow = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",[appFunc convertingDateFormat:[transactionDetail valueForKey:@"transactionDate"]]],[NSString stringWithFormat:@"%@",[transactionDetail valueForKey:@"fwTransactionType"]],[[NSString stringWithFormat:@"%@",[appFunc convertValue:[[transactionDetail valueForKey:@"units"] floatValue]]] substringFromIndex:1],navValue,[NSString stringWithFormat:@"%@",[appFunc convertValue:[[transactionDetail valueForKey:@"amount"] floatValue]]], nil];
        }
        else
        {
            titleForRow = [[NSMutableArray alloc] initWithObjects:@"Transaction Date",@"Transaction Type",@"Trade Price",@"Transaction Amount",@"Quantity", nil];
            
            
            valueForRow = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",[appFunc convertingDateFormat:[transactionDetail valueForKey:@"tradeDate"]]],[NSString stringWithFormat:@"%@",[transactionDetail valueForKeyPath:@"calculated.transacionType"]],[NSString stringWithFormat:@"%@",[appFunc convertValue:[[transactionDetail valueForKeyPath:@"tradePrice"] floatValue]]],[NSString stringWithFormat:@"%@",[appFunc convertValue:[[transactionDetail valueForKeyPath:@"calculated.amount"] floatValue]]],[NSString stringWithFormat:@"%.2f",[[transactionDetail valueForKeyPath:@"calculated.quantity"] floatValue]], nil];
        }
    }
    
    [_tblTransaction reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
-(NSString *)getTenure:(int)year month:(int)month day:(int)day
{
    NSMutableArray *arrDate = [[NSMutableArray alloc] init];
    if (year > 0 && (month > 0 || day > 0)) {
        if (year > 0) {
            [arrDate addObject:[NSString stringWithFormat:@"%d Y",year]];
        }
        if (month > 0) {
            [arrDate addObject:[NSString stringWithFormat:@"%d M",month]];
        }
        if (day > 0) {
            [arrDate addObject:[NSString stringWithFormat:@"%d D",day]];
        }
    }
    else if(year > 0)
    {
        [arrDate addObject:[NSString stringWithFormat:@"%d %@",year,year==1?@"Year":@"Years"]];
    }
    else if(month > 0)
    {
        [arrDate addObject:[NSString stringWithFormat:@"%d %@",month,month==1?@"Month":@"Months"]];
    }
    else if(day > 0)
    {
        [arrDate addObject:[NSString stringWithFormat:@"%d %@",day,day==1?@"Day":@"Days"]];
    }
    else
    {
        return @"-";
    }
    return [arrDate componentsJoinedByString:@", "];
}
-(NSString *)getTenureRemaining:(int)month
{
    int year = 0;
    if (month > 12) {
        year = month / 12;
        month = month % 12;
    }
    return [self getTenure:year month:month day:0];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleForRow count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AssetDetailSimpleTableViewCellIdentifier";
    
    AssetDetailSimpleTableViewCell *cell = (AssetDetailSimpleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetDetailSimpleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.lblTitle setFont:[UIFont systemFontOfSize:[appFunc getFontSize:45.0]]];
        [cell.lblAmount setFont:[UIFont systemFontOfSize:[appFunc getFontSize:45.0]]];
    }
    if (showMembers == TRUE) {
        cell.lblTitle.text = [self getClientName:[titleForRow objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.lblTitle.text = [titleForRow objectAtIndex:indexPath.row];
    }
//    [cell.lblTitle setFrame:CGRectMake(10, cell.lblTitle.frame.origin.y, tableView.frame.size.width*.70, cell.lblTitle.frame.size.height)];
    cell.lblTitle.numberOfLines = 1;
//    [cell.lblTitle sizeToFit];
//    [cell.lblTitle setFrame:CGRectMake(10, 0, cell.lblTitle.frame.size.width+30, cell.lblAmount.frame.size.height)];
    if (showMembers == FALSE) {
//        [cell.lblAmount setFrame:CGRectMake(cell.lblTitle.frame.size.width+20, cell.lblAmount.frame.origin.y, tableView.frame.size.width-cell.lblTitle.frame.size.width, cell.lblAmount.frame.size.height)];
        cell.lblAmount.text = [valueForRow objectAtIndex:indexPath.row];
        
//        cell.lblAmount.textAlignment = NSTextAlignmentRight;
        [cell.lblAmount sizeToFit];
        
        [cell.lblTitle setFrame:CGRectMake(cell.lblTitle.frame.origin.x, cell.lblTitle.frame.origin.y, cell.frame.size.width-cell.lblTitle.frame.origin.x-cell.lblAmount.frame.size.width-10, cell.lblTitle.frame.size.height)];
        
        [cell.lblAmount setFrame:CGRectMake(cell.frame.size.width-cell.lblAmount.frame.size.width-10, cell.lblTitle.frame.origin.y, cell.lblAmount.frame.size.width, cell.lblTitle.frame.size.height)];
    }
    
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (showMembers == TRUE) {
        [self sendSortedID:[titleForRow objectAtIndex:indexPath.row]];
    }
}
-(NSString *)showEmptyField:(NSString *)value
{
    if ([value isEqualToString:@"description"]) {
        if ([mainDictionaryForTransaction valueForKeyPath:value] && [[mainDictionaryForTransaction valueForKeyPath:value] length] > 0) {
            return [mainDictionaryForTransaction valueForKeyPath:value];
        }
        else
        {
            return description;
        }
    }
    else if ([mainDictionaryForTransaction valueForKeyPath:value]) {
        return [mainDictionaryForTransaction valueForKeyPath:value];
    }
    else
        return @"";
}
-(NSString *)premiumFrequencyField:(NSString *)value
{
    if ([mainDictionaryForTransaction valueForKeyPath:value]) {
        if ([[mainDictionaryForTransaction valueForKeyPath:value] floatValue] == 1) {
            return @"Yearly";
        }
        else if ([[mainDictionaryForTransaction valueForKeyPath:value] floatValue] == 2) {
            return @"Half Yearly";
        }
        else if ([[mainDictionaryForTransaction valueForKeyPath:value] floatValue] == 4) {
            return @"Quarterly";
        }
        else if ([[mainDictionaryForTransaction valueForKeyPath:value] floatValue] > 4) {
            return @"Monthly";
        }
        return [mainDictionaryForTransaction valueForKeyPath:value];
    }
    else
        return @"";
}
-(NSMutableArray *)removeNullValues:(NSMutableArray *)array
{
    for (int i=0; i<[array count]; i++)
    {
        if([array objectAtIndex:i] == (NSString*)[NSNull null] || [array objectAtIndex:i] == [NSNull null] || [array objectAtIndex:i] == nil || [[array objectAtIndex:i] isEqualToString:@"(null)"])
        {
            [array replaceObjectAtIndex:i withObject:@"-"];
        }
    }
    return array;
}
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendSortedID:(NSString *)clientID
{
    [delegate getFilterDetail:clientID];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
