//
//  BJLocalCity.h
//  BJLocalCity
//
//  Created by zbj-mac on 16/3/18.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJLocalCity : NSObject
/** 单例*/
+(BJLocalCity*)bj_shared;
/**
 *  开启定位 返回地址数组
 *  @param localAddressCompletion  定位回调成功返回地址数组
 *  @param failure                 定位失败
 */
+(void)bj_startLocalAddressSuccess:(void(^)(NSDictionary*address))localAddressCompletion failure:(void(^)(NSError*failure))failureBlock;
/**
 *  开启定位 返回城市
 *  @param localCityCompletion   定位回调成功返回城市
 *  @param failure               定位失败
 */
+(void)bj_startLocalCitySuccess:(void(^)(NSString*city))localCityCompletion failure:(void(^)(NSError*failure))failureBlock;
@end
