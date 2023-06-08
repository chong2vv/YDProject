//
//  YDURLHandle.m
//  YDRouter
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDURLHandle.h"
#import "YDURLHelper.h"
#import "YDRouter.h"


@interface YDURLHandle ()

@property (nonatomic, copy) NSString *ydSchemaUrl;

@end

@implementation YDURLHandle

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static YDURLHandle *handel = nil;
    dispatch_once(&onceToken, ^{
        handel = [[YDURLHandle alloc] init];
    });
    return handel;
}


- (instancetype)init {
    if (self = [super init]) {
        self.ydSchemaUrl = @"YDProject";
        [YDRouter setup];
    }
    return self;
}

- (void)setSchemaUrl:(NSString *)schemaUrl {
    self.ydSchemaUrl = schemaUrl;
}

- (BOOL)openURLStr:(NSString *)urlStr {
    return [self openURLStr:urlStr userInfo:nil finish:NULL];
}


- (BOOL)openURLStr:(NSString *)urlStr finish:(void (^)(id))finishHandler {
    return [self openURLStr:urlStr userInfo:nil finish:finishHandler];
}

- (BOOL)openURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo {
    return [self openURLStr:urlStr userInfo:userInfo finish:NULL];
}

- (BOOL)openURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo finish:(void (^)(id))finishHandler {
    YDURLHelper *hyrUrl = [YDURLHelper URLWithString:urlStr];
    
    NSString *scheme = [hyrUrl.scheme lowercaseString];
    
    // 外部 URL Schemes
    // 支付宝支付
    // 自定义 URL 跳转页面
    if ( [scheme isEqualToString:[[YDRouter sharedInstance].schemeUrl?:self.ydSchemaUrl lowercaseString]]
        && [self handleCustomerURLStr:urlStr userInfo:userInfo finish:finishHandler]){
        
        [self handleCustomerURLStr:urlStr userInfo:userInfo finish:^(id result) {
            UIViewController *vc = result;
        }];
        
        return YES;
    }
    
    // 微信支付
    // 微信分享、登录
    // 微博登录
    // 友盟分享
    
    if ([scheme isEqualToString:@"http" ]||[scheme isEqualToString:@"https"]) {
        // h5
        [self handleWebURLStr:urlStr];
        return YES;
    }
    return NO;
}

// native
- (BOOL)handleCustomerURLStr:(NSString*) urlStr  userInfo:(NSDictionary *)userInfo finish:(void (^)(id result))finishHandler{
    // native
    YDURLHelper *hyrUrl = [YDURLHelper URLWithString:urlStr];
    [YDRouter openURL:hyrUrl withUserInfo:userInfo finish:finishHandler];
    return YES;
}

// h5
- (BOOL)handleWebURLStr:(NSString *) urlStr{
    // h5 转换 native
    [self gotoWebView:urlStr withTitle:@""];
    
    return YES;
}

- (void)gotoWebView:(NSString*)url
          withTitle:(NSString*)title{
    if (!([url hasPrefix:@"http://"] ||
          [url hasPrefix:@"https://"])) {
        url = [NSString stringWithFormat:@"https://%@", url];
    }
}

@end
