//
//  SCContactManager.h
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCContactManager : NSObject

+ (BOOL)showFirstNameFirst;
+ (void)checkPremission:(void (^)(BOOL success))completion;
+ (void)importContactsWithCompletion:(void (^)(BOOL success, NSArray *contacts))completion;

@end
