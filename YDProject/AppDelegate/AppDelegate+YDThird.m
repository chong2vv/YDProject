//
//  AppDelegate+YDThird.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "AppDelegate+YDThird.h"

#import <YDPreLoader/YDPreLoaderManager.h>

@implementation AppDelegate (YDThird)

- (void)thirdPartyConfig:(UIApplication *)application {
    //开启bugly
    [Bugly startWithAppId:buglyKey];
    
    [MMKV initializeMMKV:nil];
    
    
    //开启预下载
    [YDPreLoaderManager startProxy];
}

@end
