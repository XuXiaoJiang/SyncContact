//
//  AppDelegate.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "AppDelegate.h"
#import "SCDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[SCDataManager mainContext] save:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SCDataManager mainContext] save:nil];
}

@end
