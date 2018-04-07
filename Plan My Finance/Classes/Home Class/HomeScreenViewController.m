//
//  HomeScreenViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController
#pragma mark - Defining Enumerator

typedef NS_ENUM(NSInteger, WebServiceType)
{
    WebServiceTypeCalculatedAsset = 0
};
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}
- (void)viewDidLoad {
    

    
    [_imgDynamicColor setBackgroundColor:IFAPrimaryColor];
    [self.tabBarController.tabBar setTintColor:IFAPrimaryColor];
    [_activityIndicator setColor:IFAPrimaryColor];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
    
    
    appFunc = [AppFunctions shared];
    appFunc.delegate = self;
    
    [self changeValuesInAssetTableView:[[[appFunc fetchObjectsFromDatabaseForEntity:@"IFACalculatedAssets"] valueForKey:@"data"] firstObject]];
    
    NSString *loansArrayString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[[[[appFunc fetchObjectsFromDatabaseForEntity:@"IFALoansDetail"] valueForKey:@"data"] valueForKey:@"loanList"] firstObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSString *assetMutableDictionaryString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[[[appFunc fetchObjectsFromDatabaseForEntity:@"IFAAssetDetail"] valueForKey:@"data"] firstObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSString *clientListArrayString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[[[[appFunc fetchObjectsFromDatabaseForEntity:@"IFAClientDetail"] valueForKey:@"data"] valueForKey:@"clientList"] firstObject] options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSString *parameterStringJsonObject = [NSString stringWithFormat:@"{\"loans\":%@,\"assetDetails\":%@,\"clientList\":%@}",loansArrayString,assetMutableDictionaryString,clientListArrayString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        apiType = WebServiceTypeCalculatedAsset;
        [appFunc callWebService:@"node-utils-platform/assets-calculation/getCalculatedAssetDetailObject" parameters:parameterStringJsonObject];
    });
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float tableViewWidth = tableView.frame.size.width;
    
    UIView *barHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, 10)];
    
    float x = 0;
    for (int i = 0; i<[assetsArray count]; i++) {
        float percentage = [[[assetsArray objectAtIndex:i] valueForKey:@"amount"] floatValue]*100/totalAssetValue;
        float width = tableViewWidth*percentage/100;
        UIImageView *imgObject = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, 10)];
        [imgObject setBackgroundColor:[[assetsArray objectAtIndex:i] valueForKey:@"color"]];
        [barHeaderView addSubview:imgObject];
        x += width;
    }
    
    return barHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    /* // not showing the zero value content
    if ([[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue] > 0) {
        return 44;
    }
    else
        return 0;
     */
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [assetsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AssetTableViewCellIdentifier";
    
    AssetTableViewCell *cell = (AssetTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblTitle setFont:[UIFont systemFontOfSize:[appFunc getFontSize:50.0]]];
        [cell.lblAmount setFont:[UIFont systemFontOfSize:[appFunc getFontSize:50.0]]];
    }
    if (indexPath.row == 0) {
        cell.imgTopBorder.hidden = FALSE;
    }
    else
    {
        cell.imgTopBorder.hidden = TRUE;
    }
    
    cell.lblTitle.text = [[assetsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    if ([[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue] > 0) {
        cell.lblAmount.text = [appFunc convertValue:[[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue]];
    }
    else
    {
        cell.lblAmount.text = @"0";
    }
    [cell.imgColor setBackgroundColor:[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"color"]];
    
//    if ([[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue] > 0) {
//        cell.lblTitle.text = [[assetsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
//        
//        
//        cell.lblAmount.text = [appFunc convertValue:[[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue]];
//        [cell.imgColor setBackgroundColor:[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"color"]];
//    }
//    else
//    {
//        cell.lblTitle.text = @"";
//        
//        
//        cell.lblAmount.text = @"";
//        [cell.imgColor setBackgroundColor:[UIColor clearColor]];
//    }
    cell.layer.masksToBounds = TRUE;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[assetsArray objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue] > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AssetDetailViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"AssetDetailViewController"];
        previewController.assetIndexPath = (int)indexPath.row;
        previewController.assetTitle = [[assetsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 6) {
            previewController.isTappable = TRUE;
        }
        else
            previewController.isTappable = FALSE;
        
        [self.navigationController pushViewController:previewController animated:YES];
    }
    else
    {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:@"No Data To Show." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - WebService Delegate

-(void)webServiceApiResult:(id)result
{
    _activityIndicator.hidden = TRUE;
    if (apiType == WebServiceTypeCalculatedAsset) {
        if (result != nil && result != [NSNull null] && [result valueForKey:@"assetTotalCalculatedObj"] && [result valueForKey:@"assetTotalCalculatedObj"] != nil) {
            [appFunc insertIntoDatabaseWithEntity:@"IFACalculatedAssets" insertObject:result deleteObjects:YES];
            [self changeValuesInAssetTableView:result];
        }
        
    }
}
-(void)changeValuesInAssetTableView:(id)result
{
    if (result != nil && result != [NSNull null]) {
        NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mutual Funds",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.mutualFunds.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:0],@"color", nil];
        NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Stocks",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.stocks.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:1],@"color", nil];
        NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Life Insurance",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.lifeInsurance.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:2],@"color", nil];
        NSDictionary *dict4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"FD/RD",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.fdRd.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:3],@"color", nil];
        NSDictionary *dict5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Real Estate",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.realEstate.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:4],@"color", nil];
        NSDictionary *dict6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Retirement A/c",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.retirementAccount.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:5],@"color", nil];
        NSDictionary *dict7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"PO Schemes",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.postOfficeScheme.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:6],@"color", nil];
        NSDictionary *dict8 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cash & Bank Accounts",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.cashBankAccount.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:7],@"color", nil];
        NSDictionary *dict9 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Gold",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.gold.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:8],@"color", nil];
        NSDictionary *dict10 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Miscellaneous",@"title",[result valueForKeyPath:@"assetTotalCalculatedObj.miscellaneous.currentValue"],@"amount",[appFunc fetchColorBasedOnIndex:9],@"color", nil];
        
        assetsArray = [[NSMutableArray alloc] initWithObjects:dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9,dict10, nil];
        
        totalAssetValue = [[result valueForKeyPath:@"assetGrandTotalCalculatedObj.currentValue"] floatValue];
        
        _lblTotalAssetValue.text = [appFunc convertValue:totalAssetValue];
        [_tblAsset reloadData];
    }
    
}
-(void)noInternetPopUp
{
    _activityIndicator.hidden = TRUE;
    [appFunc showAlert:@"Please check your internet connection or try again later!" view:self];
}


@end
