//
//  ZCLocalCity.h
//  ZCInsurance
//
//  Created by zbj-mac on 16/3/18.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^localCallBack)(NSString*city);
typedef void (^failure)(NSError*failure);
@interface BJLocalCity : NSObject
/**
 *  单例
 *
 *  @return BJLocalCity
 */
+(BJLocalCity*)Shared;
/**
 *  开启定位
 *
 *  @param localCallBack 定位回调
 *  @param failure       定位失败
 */
+(void)startLocalCitySuccess:(localCallBack)localCallBack failure:(failure)failure;
@end
