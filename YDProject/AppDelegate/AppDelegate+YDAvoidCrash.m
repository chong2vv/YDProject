//
//  AppDelegate+YDAvoidCrash.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "AppDelegate+YDAvoidCrash.h"
#import "YDLoggerUploadService.h"
#import <fishhook/fishhook.h>
#import <YDPreventCrash/YDAvoidCrash.h>

@implementation AppDelegate (YDAvoidCrash)

- (void)becomeEffective {
    // 可以配合YDLogger日志库进行日志收集，方便排查问题。当然，这里如果已有日志库的话可以使用自己的日志库
    [[YDLogService shared] startLogNeedHook:YES];
    // 设置开启的防护的文件前缀，建议可以由服务端配置
    [YDAvoidCrash setAvoidCrashEnableMethodPrefixList:@[@"YD", @"NS", @"UI"]];
    // 开启防护
    [YDAvoidCrash becomeAllEffective];
    // 接收日志信息回调
    [YDAvoidCrash setupBlock:^(NSException *exception, NSString *defaultToDo, NSDictionary *info) {
        YDLogError(@"%@", info);
    }];
    
}


@end
