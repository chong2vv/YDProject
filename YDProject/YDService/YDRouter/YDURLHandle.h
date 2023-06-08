//
//  YDURLHandle.h
//  YDRouter
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Router [YDURLHandle sharedManager]


@interface YDURLHandle : NSObject

+ (instancetype)sharedManager;

/**
 设置schemaUrl，默认YDProject。 路由跳转 schemaUrl://XXXX
 */
- (void)setSchemaUrl:(NSString *)schemaUrl;

- (BOOL)openURLStr:(NSString *)urlStr;

- (BOOL)openURLStr:(NSString *)urlStr finish:(void (^)(id result))finishHandler;

- (BOOL)openURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo;

- (BOOL)openURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo finish:(void (^)(id result))finishHandler;

- (BOOL)handleMethodURLStr:(NSString *)urlStr;

- (BOOL)handleMethodURLStr:(NSString *)urlStr finish:(void (^)(id result))finishHandler;

- (BOOL)handleMethodURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo;

- (BOOL)handleMethodURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo finish:(void (^)(id result))finishHandler;


@end

