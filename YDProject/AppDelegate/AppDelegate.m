//
//  AppDelegate.m
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#import "AppDelegate.h"
#import "AppDelegate+YDServicePush.h"
#import "AppDelegate+YDAvoidCrash.h"
#import "AppDelegate+YDThird.h"
#import "AppDelegate+YDSetupViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册推送
    [self registerForRemoteNotifications:application didFinishLaunchingWithOptions:launchOptions];
    
    //开启第三方配置，如bugly
    [self thirdPartyConfig:application];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //常规写法，同一界面响应时的排他性
    [[UIButton appearance] setExclusiveTouch:YES];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [[UITabBar appearance] setTranslucent:NO];
    }
    
    //配置root vc
    [self configRootVC:application];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

@end
