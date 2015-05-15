//
//  SCContactManager.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "SCContactManager.h"
#import <AddressBook/AddressBook.h>
#import "NSString+MD5.h"

@implementation SCContactManager

+ (BOOL)showFirstNameFirst
{
    ABPersonSortOrdering sortOrder = ABPersonGetSortOrdering();
    return sortOrder == kABPersonSortByFirstName;
}

+ (void)checkPremission:(void (^)(BOOL))completion
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined){
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (completion) {
                completion(granted);
            }
            CFRelease(addressBook);
        });
    }else if (completion){
        completion(status == kABAuthorizationStatusAuthorized);
    }
}

+ (void)importContactsWithCompletion:(void (^)(BOOL success, NSArray *contacts))completion
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        if (completion) completion(NO, nil);
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error || !granted) {
            if (completion) completion(NO, nil);
        }else {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
            NSMutableArray *contacts = [NSMutableArray array];
            for (int i = 0; i < nPeople; i++) {
                // Get the next address book record.
                ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
                NSMutableDictionary *contact = [NSMutableDictionary dictionary];
                
                ABRecordID recordID = ABRecordGetRecordID(record);
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                NSString *middleName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
                NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
                
                ABMultiValueRef numberMultiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
                NSArray *numberArray = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(numberMultiValue);
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
                numberArray = [numberArray sortedArrayUsingDescriptors:@[descriptor]];
                
                if (firstName) [contact setObject:firstName forKey:@"firstName"];
                if (middleName) [contact setObject:middleName forKey:@"middleName"];
                if (lastName) [contact setObject:lastName forKey:@"lastName"];
                if (numberArray) [contact setObject:numberArray forKey:@"phoneNumbers"];
                NSNumber *contactID = @(recordID);
                if (contactID) [contact setObject:contactID forKey:@"contactID"];
                [contacts addObject:contact];
            }
            if (completion) completion(YES, contacts);
        }
        CFRelease(addressBook);
    });
}

@end
