//
//  SCViewController.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "SCViewController.h"
#import "SCDataManager.h"
#import "SCContactManager.h"
#import "SCContact.h"
#import "SVProgressHUD.h"

@interface SCViewController ()<UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *syncButton;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startSyncing];
}

#pragma mark - Helper

- (void)startSyncing
{
    [SCContactManager checkPremission:^(BOOL success) {
        if (success){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.statusLabel.text = @"Syncing is in wait";
                self.syncButton.hidden = YES;
                [SVProgressHUD showWithStatus:@"syncing" maskType:SVProgressHUDMaskTypeBlack];
            }];
            __weak __typeof(self) weakself = self;
            [SCContactManager importContactsWithCompletion:^(BOOL success, NSArray *contacts) {
                NSString *message = [self consolidateWithContacts:contacts];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [SVProgressHUD dismiss];
                    weakself.statusLabel.text = @"Sync is done";
                    weakself.syncButton.hidden = NO;
                    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }];
            }];
        }else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.statusLabel.text = @"permission not granted";
                self.syncButton.hidden = NO;
                [[[UIAlertView alloc] initWithTitle:nil message:@"Please allow this APP to access your addressbook to check changes" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Setting", nil] show];
            }];
        }
    }];
}

- (NSString *)consolidateWithContacts:(NSArray *)contacts
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"contactID" ascending:YES];
    NSArray *oldContacts = [[SCContact all] sortedArrayUsingDescriptors:@[sort]];
    NSArray *currentContacts = [contacts sortedArrayUsingDescriptors:@[sort]];

    // consolidate
    NSMutableArray *added = [NSMutableArray array];
    NSMutableArray *removed = [NSMutableArray array];
    NSMutableArray *changedOld = [NSMutableArray array];
    NSMutableArray *changedNew = [NSMutableArray array];
    NSUInteger oldCounter = 0;
    NSUInteger curCounter = 0;
    while (oldCounter < [oldContacts count] && curCounter < [currentContacts count]) {
        SCContact *contact = oldContacts[oldCounter];
        NSDictionary *dict = currentContacts[curCounter];
        int32_t oldID = [contact.contactID intValue];
        int32_t newID = [dict[@"contactID"] intValue];
        if (oldID > newID){
            [added addObject:dict];
            curCounter ++;
        }else if (oldID < newID){
            [removed addObject:contact];
            oldCounter ++;
        }else if (![contact isEqualToDictionary:dict]){
            [changedNew addObject:dict];
            [changedOld addObject:contact];
            oldCounter ++;
            curCounter ++;
        }else {
            oldCounter ++;
            curCounter ++;
        }
    }
    while (oldCounter < [oldContacts count]) {
        [removed addObject:oldContacts[oldCounter]];
        oldCounter ++;
    }
    while (curCounter < [currentContacts count]) {
        [added addObject:currentContacts[curCounter]];
        curCounter ++;
    }
    
    // construct message
    NSMutableString *message = [NSMutableString string];
    if ([oldContacts count] <= 0 && [currentContacts count] > 0){
        message = [@"syncing done" mutableCopy];
        for (NSDictionary *dict in added){
            [SCContact createNewObjectWithDictionary:dict];
        }
    }else if ([added count] <=0 && [removed count] <= 0 && [changedNew count] <= 0){
        message = [@"No changes" mutableCopy];
    }else {
        if ([added count] > 0){
            [message appendString:@"*** added contacts: ***\n\n"];
            for (NSDictionary *dict in added){
                SCContact *contact = [SCContact createNewObjectWithDictionary:dict];
                [message appendString:[contact description]];
            }
        }
        if ([removed count] > 0){
            [message appendString:@"\n*** removed contacts: ***\n\n"];
            for (SCContact *contact in removed){
                if ([contact isDeleted]){
                    continue;
                }
                [message appendString:[contact description]];
                [SCContact deleteObject:contact];
            }
        }
        if ([changedOld count] >0){
            [message appendString:@"\n*** changed contacts: **\n\n"];
            for (int i = 0 ; i < [changedOld count]; i++){
                SCContact *contact = changedOld[i];
                NSDictionary *dict = changedNew[i];
                [message appendFormat:@"%@---change to:---\n", [contact description]];
                [contact updateWithDictionary:dict];
                [message appendFormat:@"%@\n", [contact description]];
            }
        }
    }
    [[SCDataManager mainContext] save:nil];
    return message;
}

#pragma mark - Actions

- (IBAction)onSync:(UIButton *)button
{
    [self startSyncing];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
