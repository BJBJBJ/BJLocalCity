//
//  BJLocalCity.m
//  BJLocalCity
//
//  Created by zbj-mac on 16/3/18.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "BJLocalCity.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^failureBlock)(NSError*failure);//返回error
typedef void (^localAddressCompletion)(NSDictionary*address);//返回地址字典
typedef void (^localCityCompletion)(NSString*city);//返回城市
@interface BJLocalCity()<CLLocationManagerDelegate>

@property (nonatomic , strong)CLLocationManager *locationManager;
@property(nonatomic,copy)localCityCompletion localCityCompletion;
@property(nonatomic,copy)failureBlock failureBlock;
@property(nonatomic,copy)localAddressCompletion localAddressCompletion;
@end

@implementation BJLocalCity
-(CLLocationManager *)locationManager{
    if (!_locationManager) {
       _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
       _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        CLLocationDistance distance=10.0;
        _locationManager.distanceFilter=distance;
  
    }
    return _locationManager;
}
static BJLocalCity* _instance=nil;
+(BJLocalCity*)bj_shared{
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          _instance = [[BJLocalCity alloc] init];
        });
    }
    return _instance;
}
+(void)bj_startLocalAddressSuccess:(void(^)(NSDictionary*address))localAddressCompletion failure:(void(^)(NSError*failure))failureBlock{
    BJLocalCity *local=[BJLocalCity bj_shared];
    [local bj_startLocation];
    local.localAddressCompletion=localAddressCompletion;
    local.failureBlock=failureBlock;
}

+(void)bj_startLocalCitySuccess:(void(^)(NSString*city))localCityCompletion failure:(void(^)(NSError*failure))failureBlock{
    BJLocalCity *local=[BJLocalCity bj_shared];
    [local bj_startLocation];
    local.localCityCompletion=localCityCompletion;
    local.failureBlock=failureBlock;
}

/** 开始定位*/
-(void)bj_startLocation{
    
    //定位服务不可用
    if (![CLLocationManager locationServicesEnabled]){
        if (self.failureBlock) {
            NSError *error=[NSError errorWithDomain:@"定位服务不可用" code:-1 userInfo:@{@"定位服务":@"无法使用"}];
            self.failureBlock(error);
        }
        return;
    }
    
    //iOS 8.0以下开启定位
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]<8.0){
        //开启定位
       [self.locationManager startUpdatingLocation];
        return;
    }
    //iOS 8.0以上开启定位
    //未确定授权状态
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        //设置授权状态
        [self.locationManager requestAlwaysAuthorization];
        //开启定位
        [self.locationManager startUpdatingLocation];
        
        return;
    }
    //已获取授权 直接开启定位
   if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
        [self.locationManager startUpdatingLocation];
       return;
    }

    //定位权限被用户禁用
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        if (self.failureBlock) {
            NSError *error=[NSError errorWithDomain:@"未授权定位" code:-2 userInfo:@{@"定位权限":@"禁用"}];
            self.failureBlock(error);
  
        }
     }
    
}
#pragma mark----CLLocationManagerDelegate----
#pragma mark 经纬度反编码
//此回调开启定位后会不断调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"aaaaa");
    //1.结束定位
    [self.locationManager stopUpdatingLocation];
    //2.取坐标
    CLLocation * location=[locations lastObject];
    //3.反编码
    CLGeocoder *Geocoder=[[CLGeocoder alloc] init];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [Geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         //编码错误
        if (error&&self.failureBlock) {
            self.failureBlock(error);
            return ;
         }

         //1.传出地址
        CLPlacemark *placemark=[placemarks firstObject];
         
         if (placemark.addressDictionary&&self.localAddressCompletion) {
             self.localAddressCompletion(placemark.addressDictionary);
             return;
         }
         //2.传出城市
         if (placemark.addressDictionary[@"City"]&&self.localCityCompletion){
           self.localCityCompletion(placemark.addressDictionary[@"City"]);
                 return;
            }
     }];

}

#pragma mark 定位失败回调
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}
@end
