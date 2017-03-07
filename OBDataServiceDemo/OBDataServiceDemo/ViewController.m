//
//  ViewController.m
//  OBDataServiceDemo
//
//  Created by obally on 17/3/7.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "ViewController.h"
#import "OBDataService.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OBDataService requestWithURL:@"https://github.com" params:nil httpMethod:@"GET" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionblock:^(id  _Nonnull result) {
        
    } failedBlock:^(id  _Nonnull error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
