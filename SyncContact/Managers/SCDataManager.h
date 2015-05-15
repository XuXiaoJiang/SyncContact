//
//  SCDataManager.h
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SCDataManager : NSObject

+ (instancetype)sharedInstance;
+ (NSManagedObjectContext *)mainContext;

@end
