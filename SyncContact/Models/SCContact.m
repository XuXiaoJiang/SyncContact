//
//  SCContact.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "SCContact.h"
#import "SCContactManager.h"

@implementation SCContact

@dynamic contactID;
@dynamic firstName;
@dynamic middleName;
@dynamic lastName;
@dynamic phoneNumbers;

+ (instancetype)createNewObjectWithDictionary:(NSDictionary *)dict
{
    SCContact *contact = [[SCContact class] createNewObject];
    [contact updateWithDictionary:dict];
    return contact;
}

- (void)updateWithDictionary:(NSDictionary *)dict
{
    self.firstName = dict[@"firstName"];
    self.middleName = dict[@"middleName"];
    self.lastName = dict[@"lastName"];
    self.contactID = dict[@"contactID"];
    self.phoneNumbers = dict[@"phoneNumbers"];
}

- (BOOL)isEqualToContact:(SCContact *)contact
{
    if (![self.contactID isEqualToNumber:contact.contactID]){
        return NO;
    }
    if (![self.phoneNumbers isEqualToArray:contact.phoneNumbers]){
        return NO;
    }
    return YES;
}

- (BOOL)isEqualToDictionary:(NSDictionary *)dict
{
    if (self.firstName == dict[@"firstName"]) ;
    else if (![self.firstName isEqualToString:dict[@"firstName"]]) return NO;
    if (self.middleName == dict[@"middleName"]) ;
    else if (![self.middleName isEqualToString:dict[@"middleName"]]) return NO;
    if (self.lastName == dict[@"lastName"]) ;
    else if (![self.lastName isEqualToString:dict[@"lastName"]]) return NO;
    if (self.phoneNumbers == dict[@"phoneNumbers"]) ;
    else if (![self.phoneNumbers isEqualToArray:dict[@"phoneNumbers"]]) return NO;
    return YES;
}

- (NSString *)description
{
    NSMutableString *des = [NSMutableString string];
    if ([SCContactManager showFirstNameFirst]){
        if (self.firstName) [des appendString:self.firstName];
        if (self.middleName) [des appendString:self.middleName];
        if (self.lastName) [des appendString:self.lastName];
    }else {
        if (self.lastName) [des appendString:self.lastName];
        if (self.middleName) [des appendString:self.middleName];
        if (self.firstName) [des appendString:self.firstName];
    }
    [des appendString:@" :\n"];
    for (NSString *number in self.phoneNumbers){
        [des appendFormat:@"%@\n", number];
    }
    return des;
}

+ (NSString *)descriptionForDictionary:(NSDictionary *)dict
{
    NSString *firstName = dict[@"firstName"];
    NSString *middleName = dict[@"middleName"];
    NSString *lastName = dict[@"lastName"];
    NSArray *phones = dict[@"phoneNumbers"];
    NSMutableString *des = [NSMutableString string];
    if ([SCContactManager showFirstNameFirst]){
        if (firstName) [des appendString:firstName];
        if (middleName) [des appendString:middleName];
        if (lastName) [des appendString:lastName];
    }else {
        if (lastName) [des appendString:lastName];
        if (middleName) [des appendString:middleName];
        if (firstName) [des appendString:firstName];
    }
    [des appendString:@" :\n"];
    for (NSString *number in phones){
        [des appendFormat:@"%@\n", number];
    }
    return des;
}

@end
