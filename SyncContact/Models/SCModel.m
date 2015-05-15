//
//  SCModel.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "SCModel.h"
#import "SCDataManager.h"

@implementation SCModel

#pragma mark - Core Data

+ (instancetype)createNewObject
{
    id newObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:[SCDataManager mainContext]];
    return newObject;
}

+ (void)deleteObject:(SCModel *)object
{
    if ([object isKindOfClass:[self class]]){
        [[SCDataManager mainContext] deleteObject:object];
    }
}

+ (void)deleteAllObjects
{
    for (SCModel *object in [self all]){
        [[SCDataManager mainContext] deleteObject:object];
    }
}

+ (NSArray *)all
{
    return [self fetchWithPredicate:nil limit:0 offset:0 batchSize:0 sortDescriptors:nil relationshipKeyPaths:nil inContext:[SCDataManager mainContext]];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
{
    return [self fetchWithPredicate:predicate limit:0 offset:0 batchSize:0 sortDescriptors:nil relationshipKeyPaths:nil inContext:[SCDataManager mainContext]];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)fetchLimit offset:(NSUInteger)fetchOffset batchSize:(NSUInteger)batchSize sortDescriptors:(NSArray *)sortDescriptors relationshipKeyPaths:(NSArray *)relationshipKeyPaths inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    [request setEntity:entity];
    
    [request setPredicate:predicate];
    
    if (fetchLimit > 0)
        [request setFetchLimit:fetchLimit];
    
    if (fetchOffset > 0)
        [request setFetchOffset:fetchOffset];
    
    if (batchSize > 0)
        [request setFetchBatchSize:batchSize];
    
    if ([sortDescriptors count] > 0)
        [request setSortDescriptors:sortDescriptors];
    
    if ([relationshipKeyPaths count] > 0)
        [request setRelationshipKeyPathsForPrefetching:relationshipKeyPaths];
    
    NSArray *fetchedObjects;
    
    fetchedObjects = [context executeFetchRequest:request error:nil];
    return fetchedObjects.count > 0 ? fetchedObjects : nil;
}

@end
