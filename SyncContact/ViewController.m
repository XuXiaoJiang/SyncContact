//
//  ViewController.m
//  SyncContact
//
//  Created by Xu Xiao Jiang on 5/8/15.
//  Copyright (c) 2015 Xu Xiaojiang. All rights reserved.
//

#import "ViewController.h"
#import "SCContactManager.h"
#import "SCContact.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (SCContact *con in [SCContact all]){
        NSLog(@"%@", con.phoneNumbers);
    }
    for (SCContact *con in [SCContact all]){
        NSLog(@"%@", con);
    }
//    [SCContactManager importContactsWithCompletion:^(BOOL success, NSArray *contacts) {
//        for (NSDictionary *dict in contacts){
//            SCContact *contact = [SCContact createNewObjectWithDictionary:dict];
//            NSLog(@"%@\n", contact);
//        }
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
