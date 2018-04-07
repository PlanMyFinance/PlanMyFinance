//
//  AppFunctions.m
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "AppFunctions.h"

@implementation AppFunctions

+(AppFunctions *)shared
{
    static AppFunctions *af = nil;
    if( af == nil )
    {
        af = [[AppFunctions alloc ]init];
    }
    return af;
}


#pragma mark - Functions
-(NSString *)convertValue:(float)value
{
    NSNumber *totalAssetValueNumber = [NSNumber numberWithDouble:value];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencyCode:@"INR"];
    [nf setMaximumFractionDigits:0];
    NSString *totalAssetValueString = [nf stringFromNumber:totalAssetValueNumber];
    if (value > 0) {
        return totalAssetValueString;
    }
    else
        return @"";
}
-(NSString *)convertingDateFormat:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //// here set format of date which is in your output date (means above str with format)
    
    NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return convertedString;
}
-(NSString *)trimString:(NSString *)string {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    return [string stringByTrimmingCharactersInSet:charSet];
}
-(BOOL) validateEmail: (NSString *) emailString {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}
-(void)showAlert:(NSString *)message view:(UIViewController *)view{
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification!" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [view presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notification!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Web Service Call

-(void)callWebService:(NSString *)apiName parameters:(NSString *)parameters
{
    if ([self hasConnectivity] == TRUE) {
        NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",IFAApiPath,apiName]];
        NSLog(@"Web Service URL : %@",url.absoluteString);
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        if (parameters != nil) {
            NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
            [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [theRequest setValue:msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSError *err1 = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse: nil error: &err1 ];
        NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
        NSError *err = nil;
        id jsonData = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
        [self performSelectorOnMainThread:@selector(webServiceApiResult:) withObject:jsonData waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(noInternetPopUp) withObject:nil waitUntilDone:YES];
    }
}
-(float)getFontSize:(float)fontSize
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return (fontSize * 480) / 1242;
    }
    return (fontSize*IFAScreenWidth)/1242;
}

-(void)webServiceApiResult:(id)result
{
    //NSLog(@"Web Service Response : %@",result);
    [self.delegate webServiceApiResult:result];
}

-(void)noInternetPopUp
{
    [self.delegate noInternetPopUp];
}

#pragma mark - Database Functions

-(void)insertIntoDatabaseWithEntity:(NSString *)entityName insertObject:(NSDictionary *)insertObject deleteObjects:(BOOL)deleteObjects
{
    if (deleteObjects == TRUE) {
        [self deleteObjectsFromDatabaseForEntity:entityName];
    }
    NSManagedObject *contextObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:IFAAppDelegate.context];
    [contextObject setValue:insertObject forKey:@"data"];
    NSError *error = nil;
    if ([IFAAppDelegate.context hasChanges] && ![IFAAppDelegate.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //                        abort();
    }
}
-(id)fetchObjectsFromDatabaseForEntity:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:IFAAppDelegate.context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *items = [IFAAppDelegate.context executeFetchRequest:fetchRequest error:&error];
    return items;
}
-(void)deleteObjectsFromDatabaseForEntity:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:IFAAppDelegate.context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *items = [IFAAppDelegate.context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) {
        [IFAAppDelegate.context deleteObject:managedObject];
    }
}

#pragma mark - Document Directory Path

- (NSString *)applicationDocumentsDirectory
{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
}

#pragma mark - Internet Connectivity

-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if (reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // If target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // If target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs.
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}
-(UIColor *)fetchColorBasedOnIndex:(int)colorIndex
{
    if (colorIndex == 0) {
        return [UIColor colorWithRed:145.0/255.0 green:221.0/255.0 blue:73.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 1) {
        return [UIColor colorWithRed:6.0/255.0 green:198.0/255.0 blue:247.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 2) {
        return [UIColor colorWithRed:246.0/255.0 green:233.0/255.0 blue:35.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 3) {
        return [UIColor colorWithRed:251.0/255.0 green:123.0/255.0 blue:180.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 4) {
        return [UIColor colorWithRed:36.0/255.0 green:204.0/255.0 blue:152.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 5) {
        return [UIColor colorWithRed:254.0/255.0 green:163.0/255.0 blue:74.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 6) {
        return [UIColor colorWithRed:254.0/255.0 green:104.0/255.0 blue:103.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 7) {
        return [UIColor colorWithRed:142.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 8) {
        return [UIColor colorWithRed:192.0/255.0 green:119.0/255.0 blue:87.0/255.0 alpha:1.0];
    }
    else if (colorIndex == 9) {
        return [UIColor colorWithRed:70.0/255.0 green:131.0/255.0 blue:234.0/255.0 alpha:1.0];
    }
    return IFAPrimaryColor;
}
@end
