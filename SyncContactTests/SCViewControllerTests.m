//
//  SCViewControllerTests.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/19/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SCViewController.h"
#import "SCContact.h"
#import "SCContactManager.h"

@interface SCViewController(test)

- (NSString *)consolidateWithContacts:(NSArray *)contacts;

@end

@interface SCViewControllerTests : XCTestCase

@property (nonatomic, strong) SCViewController *vcToTest;
@property (nonatomic, strong) NSArray *oldContacts;
@property (nonatomic, strong) NSMutableArray *currentContacts;
@property (nonatomic, strong) NSNumber *contactID;

@end

@implementation SCViewControllerTests

- (void)setUp
{
    [super setUp];
    self.vcToTest = [[SCViewController alloc] init];
    self.oldContacts = [SCContact all];
    self.currentContacts = [NSMutableArray array];
    NSInteger maxID = 0;
    for (SCContact *contact in self.oldContacts){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (contact.firstName) [dict setObject:contact.firstName forKey:@"firstName"];
        if (contact.middleName) [dict setObject:contact.middleName forKey:@"middleName"];
        if (contact.lastName) [dict setObject:contact.lastName forKey:@"lastName"];
        if (contact.contactID) [dict setObject:contact.contactID forKey:@"contactID"];
        if (contact.phoneNumbers) [dict setObject:contact.phoneNumbers forKey:@"phoneNumbers"];
        [self.currentContacts addObject:dict];
        if ([contact.contactID integerValue] > maxID){
            maxID = [contact.contactID integerValue];
        }
    }
    self.contactID = @(maxID + 1);
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // reset
    [self.vcToTest consolidateWithContacts:self.currentContacts];
    [super tearDown];
}

- (void)testIdentity
{
    NSString *message = [self.vcToTest consolidateWithContacts:self.currentContacts];
    // This is an example of a functional test case.
    XCTAssertEqualObjects(message, @"No changes");
}

- (void)testAdd
{
    NSDictionary *dictToAdd = @{@"firstName" : @"testFrist",
                                @"middleName" : @"testMiddle",
                                @"lastName" : @"testLast",
                                @"contactID" : self.contactID,
                                @"phoneNumbers" : @[@"11111111"]};
    NSString *des = [SCContact descriptionForDictionary:dictToAdd];
    NSMutableArray *addArray = [self.currentContacts mutableCopy];
    [addArray addObject:dictToAdd];
    NSString *message = [self.vcToTest consolidateWithContacts:addArray];
    NSString *correctMessage = [NSString stringWithFormat:@"*** added contacts: ***\n\n%@", des];
    XCTAssertEqualObjects(message, correctMessage);
}

- (void)testDelete
{
    NSDictionary *dictToDelete = self.currentContacts[0];
    NSString *des = [SCContact descriptionForDictionary:dictToDelete];
    NSMutableArray *deleteArray = [self.currentContacts mutableCopy];
    [deleteArray removeObjectAtIndex:0];
    NSString *message = [self.vcToTest consolidateWithContacts:deleteArray];
    NSString *correctMessage = [NSString stringWithFormat:@"\n*** removed contacts: ***\n\n%@", des];
    XCTAssertEqualObjects(message, correctMessage);
}

- (void)testChange
{
    NSDictionary *dictToChange = [self.currentContacts[0] mutableCopy];
    NSString *oldDes = [SCContact descriptionForDictionary:dictToChange];
    NSMutableArray *changedArray = [self.currentContacts mutableCopy];
    [dictToChange setValue:@"test" forKey:@"firstName"];
    [changedArray removeObjectAtIndex:0];
    [changedArray addObject:dictToChange];
    NSString *changedDes = [SCContact descriptionForDictionary:dictToChange];
    NSString *message = [self.vcToTest consolidateWithContacts:changedArray];
    NSString *correctMessage = [NSString stringWithFormat:@"\n*** changed contacts: **\n\n%@---change to:---\n%@\n", oldDes, changedDes];
    XCTAssertEqualObjects(message, correctMessage);
}

@end
