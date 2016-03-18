//
//  ViewController.m
//  BJLocalCity
//
//  Created by zbj-mac on 16/3/18.
//  Copyright © 2016年 张保金. All rights reserved.
//

#import "ViewController.h"
#import "BJLocalCity.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [BJLocalCity startLocalCitySuccess:^(NSString *city) {
        
        NSLog(@"%@",city);
    } failure:^(NSError *failure) {
        NSLog(@"failure");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
