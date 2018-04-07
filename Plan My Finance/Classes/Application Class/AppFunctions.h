//
//  AppFunctions.h
//  IFA
//
//  Created by Raviraj Jadeja on 15/07/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@protocol AppFunctionApiDelegate <NSObject>
-(void)webServiceApiResult:(id)result;
-(void)noInternetPopUp;
@end

@interface AppFunctions : NSObject

@property (nonatomic, weak) id<AppFunctionApiDelegate>delegate;

+(AppFunctions *)shared;

#pragma mark FontSize

-(float)getFontSize:(float)fontSize;

#pragma mark - Document Directory Path

- (NSString *)applicationDocumentsDirectory;

#pragma mark - Internet Connectivity

-(BOOL)hasConnectivity;

#pragma mark - Functions

//Convert value
-(NSString *)convertValue:(float)value;

//Convert Date
-(NSString *)convertingDateFormat:(NSString *)dateString;

//Trim the string from both ends
-(NSString *)trimString:(NSString *)string;

//Validate Email address
-(BOOL) validateEmail: (NSString *) emailString;

//Show alert globally
-(void)showAlert:(NSString *)message view:(UIViewController *)view;


//Calling Webservice
-(void)callWebService:(NSString *)apiName parameters:(NSString *)parameters;

#pragma mark - Database Functions

-(void)insertIntoDatabaseWithEntity:(NSString *)entityName insertObject:(NSDictionary *)insertObject deleteObjects:(BOOL)deleteObjects;
-(id)fetchObjectsFromDatabaseForEntity:(NSString *)entityName;
-(void)deleteObjectsFromDatabaseForEntity:(NSString *)entityName;
#pragma mark - Fetch Colors
-(UIColor *)fetchColorBasedOnIndex:(int)colorIndex;
@end
