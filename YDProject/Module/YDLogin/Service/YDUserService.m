//
//  YDUserService.m
//  YDProject
//
//  Created by 王远东 on 2023/6/7.
//

#import "YDUserService.h"
#import "YDMediator+YDLogin.h"
#import "AppDelegate+YDSetupViewController.h"

@interface YDUserService ()

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) NSString *user_id;

@end

@implementation YDUserService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        [[self getUid] subscribeNext:^(NSString *x) {
            @strongify(self);
            self.user_id = x;
        }];
    }
    return self;
}

- (void)logout {
    [[MMKV defaultMMKV] removeValueForKey:YDPlistCurrentUserUID];
}

- (void)login {
    [[MMKV defaultMMKV] setString:@"10001" forKey:YDPlistCurrentUserUID];
}

- (RACSignal *)getUid {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 在这里订阅 MMKV 存储值的变化
        // 当值发生变化时，通过 [subscriber sendNext:] 发送变化的值
        // 在适当的时机使用 [subscriber sendCompleted] 来结束信号
        
        // 示例代码
        // 监听某个 key 的变化
        [[NSNotificationCenter defaultCenter] addObserverForName:@"MMKVValueChangedNotification" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSString *changedKey = note.userInfo[@"key"];
            if ([changedKey isEqualToString:YDPlistCurrentUserUID]) {
                NSString *uid = [[MMKV defaultMMKV] getStringForKey:changedKey];
                [subscriber sendNext:uid];
            }
        }];
        
        return nil;
    }];
}

+(BOOL)checkAndLoginWithTypeComplete:(void (^)(BOOL isLogin))completion {
    
    if ([YDUserConfig shared].isLogin) {
        return YES;
    }else {
        // 如果已弹出登录 就不要再次弹出登录
        if ([self isShowLoginVc]) {
            return NO;
        }
        
        [YDUserService startLoginWithTypeComplete:^(BOOL result) {
            if (completion) completion(result);
        }];
    }
    
    
    return NO;
}

+(void)startLoginWithTypeComplete:(void (^)(BOOL result))completion {
    // 登录成功回调
    void (^successCallback)(BOOL,NSInteger,NSDictionary *) = ^(BOOL login, NSInteger loginType, NSDictionary *successInfo){
        if (!login) {
            if (completion)  completion(NO);
            return;
        }
        
        YDUser *user = [[YDUserConfig shared] getCurrentUser];
        if ([user isEmpty]) {
            if (completion)  completion(NO);
        }else {
            if (completion)  completion(YES);
        }
        
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:successCallback forKey:@"successCallback"];
    NSLog(@"登录params ===== %@",params);
    // 防止二次弹出登录页面逻辑 -- start
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LoginVCIsShow"] == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginVCIsShow"];
        });
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoginVCIsShow"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginVCIsShow"];
    });
    [[YDMediator sharedInstance] startLoginParams:params];
    
}

///当前显示的是否是登录VC
+ (BOOL)isShowLoginVc{
    return [self currentVC];
}

/// 获取当前显示的vc
+ (BOOL)currentVC
{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentViewControllerFromRootVC:rootVc];
}

/// 获取当前显示的vc
/// @param vc 传入rootVC
+ (BOOL)getCurrentViewControllerFromRootVC:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVc = (UINavigationController *)vc;
        for (UIViewController *vc in navVc.viewControllers) {
            if ([NSStringFromClass(vc.class) isEqualToString:@"YDLoginViewController"]) {
                NSLog(@"show vc = login %@",vc.class);
                NSLog(@"show vc = 已经弹出登录 不需要再次弹出");
                return YES;
            }
        }
        return [self getCurrentViewControllerFromRootVC:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getCurrentViewControllerFromRootVC:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getCurrentViewControllerFromRootVC:vc.presentedViewController];
        } else {
            if ([NSStringFromClass(vc.class) isEqualToString:@"YDLoginViewController"]) {
                NSLog(@"show vc = login %@",vc.class);
                NSLog(@"show vc = 已经弹出登录 不需要再次弹出登录");
                return YES;
            }
        }
    }
    return NO;
}

@end
