//
//  AppDelegate+YDSetupViewController.h
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (YDSetupViewController)

- (void)configRootVC:(UIApplication *)application;

- (UIViewController *)currentVC;

- (UITabBarController *)rootTabBarController;

@end

NS_ASSUME_NONNULL_END
