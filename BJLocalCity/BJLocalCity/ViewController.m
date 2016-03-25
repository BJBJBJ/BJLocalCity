//
//  ViewController.m
//  BJLocalCity
//
//  Created by zbj-mac on 16/3/18.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "ViewController.h"
#import "BJLocalCity.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:13];
    label.backgroundColor=[UIColor blackColor];
    label.textColor=[UIColor whiteColor];
    label.center=self.view.center;
    [self.view addSubview:label];
    
    /**
     address中的key
     City
     Country
     FormattedAddressLines
     Name
     State
     Street
     SubLocality
     Thoroughfare
     */
    [BJLocalCity startLocalAddressSuccess:^(NSDictionary *address) {
        
        label.text=[NSString stringWithFormat:@"%@",address[@"Thoroughfare"]];
        NSLog(@"成功＝%@",address);
    } failure:^(NSError *failure) {
        NSLog(@"失败＝%@",failure);
    }];
//    [BJLocalCity startLocalCitySuccess:^(NSString *city) {
//        
//        label.text=city;
//        NSLog(@"%@",city);
//    } failure:^(NSError *failure) {
//        NSLog(@"failure");
//    }];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
