//
//  SCContact.h
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "SCModel.h"

@interface SCContact : SCModel

@property (nonatomic, copy) NSNumber *contactID;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSArray *phoneNumbers;

+ (instancetype)createNewObjectWithDictionary:(NSDictionary *)dict;
- (void)updateWithDictionary:(NSDictionary *)dict;
- (BOOL)isEqualToContact:(SCContact *)contact;
- (BOOL)isEqualToDictionary:(NSDictionary *)dict;

@end
