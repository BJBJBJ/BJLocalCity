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
@interface BJLocalCity()<CLLocationManagerDelegate>

@property (nonatomic , strong)CLLocationManager *locationManager;
@property(nonatomic,copy)localCityCallBack localCallBack;
@property(nonatomic,copy)failure failure;
@property(nonatomic,copy)localAddressCallBack localAddressCallBack;
@end

@implementation BJLocalCity
static BJLocalCity* instance;

+(BJLocalCity*)Shared{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          instance = [[BJLocalCity alloc] init];
        });
    }
    return instance;
}
+(void)startLocalAddressSuccess:(localAddressCallBack)localAddressCallBack failure:(failure)failure{
    
    BJLocalCity *local=[BJLocalCity Shared];
    [local startLocation];
    
    local.localAddressCallBack=^(NSDictionary*dict){
        localAddressCallBack(dict);
    };
    
    local.failure=^(NSError *error){
        
        failure(error);
    };

}
+(void)startLocalCitySuccess:(localCityCallBack)localCallBack failure:(failure)failure{
    
    BJLocalCity *local=[BJLocalCity Shared];
    [local startLocation];
   local.localCallBack=^(NSString*city){
    
        localCallBack(city);
    };
    local.failure=^(NSError *error){
        
        failure(error);
    };
}

/**
 *  开始定位
 */
-(void)startLocation{

    
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    CLLocationDistance distance=10.0;
    self.locationManager .distanceFilter=distance;
    

    if (![CLLocationManager locationServicesEnabled]){//定位不可用
        NSLog(@"--%@--定位服务不可用",[self class]);
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]<8.0){//8.0以下
        
       [self.locationManager startUpdatingLocation];//开启定位
        return;
    }
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){//未确定授权状态
        
        [self.locationManager requestAlwaysAuthorization];//设置状态
        [self.locationManager startUpdatingLocation];
        
        return;
    }
   if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
        [self.locationManager startUpdatingLocation];
       return;
    }
    
    
    
}
#pragma mark----定位代理-经纬度反编码----

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.locationManager stopUpdatingLocation];//结束定位
    //反编码
    CLGeocoder *Geocoder=[[CLGeocoder alloc] init];
    CLLocation * location=[locations lastObject];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [Geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
            if (error&&self.failure) {
                
            self.failure(error);
           
              return ;
            }
         
         //传出地址
        CLPlacemark *placemark=[placemarks firstObject];
         
         if (placemark.addressDictionary&&self.localAddressCallBack) {
             self.localAddressCallBack(placemark.addressDictionary);
             return;
         }
         
         
         if (placemark.addressDictionary[@"City"]&&self.localCallBack){
           self.localCallBack(placemark.addressDictionary[@"City"]);
                 return;
            }
    
     }];

}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (self.failure) {
        self.failure(error);
    }
    
}
@end
