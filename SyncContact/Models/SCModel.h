//
//  SCModel.h
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SCModel : NSManagedObject

#pragma mark - CoreData
+ (instancetype)createNewObject;
+ (void)deleteObject:(SCModel *)object;
+ (void)deleteAllObjects;
+ (NSArray *)all;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)fetchLimit offset:(NSUInteger)fetchOffset batchSize:(NSUInteger)batchSize sortDescriptors:(NSArray *)sortDescriptors relationshipKeyPaths:(NSArray *)relationshipKeyPaths inContext:(NSManagedObjectContext *)context;

@end
