//
//  ContactViewController.m
//  IFA
//
//  Created by Raviraj Jadeja on 23/08/17.
//  Copyright © 2017 Raviraj Jadeja. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
-(void)viewWillAppear:(BOOL)animated
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:IFAContact]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];
    }
}
- (void)viewDidLoad {
    // From within your active view controller
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
