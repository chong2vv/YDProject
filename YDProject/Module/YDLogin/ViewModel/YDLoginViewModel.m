//
//  YDLoginViewModel.m
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#import "YDLoginViewModel.h"
#import "YDLoginCommand.h"
#import "YDRegisterCommand.h"
#import "YDUserInfoUpdateCommand.h"
#import "YDSendCodeCommand.h"
#import "YDMediator+YDLogin.h"

@interface YDLoginViewModel ()

@property (nonatomic, copy)NSString *uid;
@property (nonatomic, strong) RACSubject *subject;
@end

@implementation YDLoginViewModel

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
        self.subject = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)login:(NSString *)userAccount userPassword:(NSString *)userPassword {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [YDLoginCommand ydCommandSetParame:^(__kindof YDLoginCommand * _Nonnull request) {
            request.input_userAccount = userAccount;
            request.input_userPassword = userPassword;
        } completion:^(__kindof YDLoginCommand * _Nonnull request) {
            @strongify(self)
            if (request.error) {
                YDLogError(@"登录失败：%@", request.error);
                [subscriber sendError:request.error];
            }else{
                YDUser *user = request.user;
                [self saveUser:user];
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)userRegister:(NSString *)userAccount userPassword:(NSString *)userPassword {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [YDRegisterCommand ydCommandSetParame:^(__kindof YDRegisterCommand * _Nonnull request) {
            request.input_userAccount = userAccount;
            request.input_userPassword = userPassword;
        } completion:^(__kindof YDRegisterCommand * _Nonnull request) {
            @strongify(self)
            [SVProgressHUD dismiss];
            if (request.error) {
                YDLogError(@"注册失败：%@", request.error);
                [subscriber sendError:request.error];
            }else{
                YDUser *user = request.user;
                [self saveUser:user];
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }
            
        }];
        return nil;
    }];
}

- (RACSignal *)updateUser:(YDUser *)user {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [YDUserInfoUpdateCommand ydCommandSetParame:^(__kindof YDUserInfoUpdateCommand * _Nonnull request) {
            request.input_uid = user.uid;
            request.input_user = [user yy_modelToJSONString];
            
        } completion:^(__kindof YDUserInfoUpdateCommand * _Nonnull request) {
            @strongify(self)
            if (request.error) {
                YDLogError(@"更新失败：%@", request.error);
                [subscriber sendError:request.error];
            }else{
                YDUser *user = request.user;
                [self saveUser:user];
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }
            
        }];
        return nil;
    }];
}

- (RACSignal *)sendCode:(NSString *)phoneNumber {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [YDSendCodeCommand ydCommandSetParame:^(__kindof YDSendCodeCommand * _Nonnull request) {
            request.input_userAccount = phoneNumber;
        } completion:^(__kindof YDSendCodeCommand * _Nonnull request) {
            if (request.error) {
                YDLogError(@"发送失败：%@", request.error);
                [subscriber sendError:request.error];
            }else{
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (void)logout {
    [[MMKV defaultMMKV] removeValueForKey:YDPlistCurrentUserUID];
    [self.subject sendNext:@{@"Logout":@"1"}];
}

- (void)saveUser:(YDUser *)user {
    [[MMKV defaultMMKV] setString:user.uid forKey:YDPlistCurrentUserUID];
    [[[YDDB shareInstance] insertWithUserModel:user] subscribeNext:^(NSString *x) {
        NSString *uid = x;
        YDLogDebug(@"wyd - 用户保存信息成功 uid:%@", uid);
    }];
}

- (NSString *)uid {
    return [[MMKV defaultMMKV] valueForKey:YDPlistCurrentUserUID];
}

- (BOOL)isLogin {
    if (self.uid.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark ------------ 登录检测 ------------
+ (BOOL)checkAndLoginWithTypeComplete:(void (^)(BOOL isLogin))completion {
    
    if ([YDLoginViewModel shared].isLogin) {
        return YES;
    }else {
        // 如果已弹出登录 就不要再次弹出登录
        if ([self isShowLoginVc]) {
            return NO;
        }
        
        [YDLoginViewModel startLoginWithTypeComplete:^(BOOL result) {
            if (completion) completion(result);
        }];
    }
    
    return NO;
}

+ (void)startLoginWithTypeComplete:(void (^)(BOOL result))completion {
    // 登录成功回调
    void (^successCallback)(BOOL,NSInteger,NSDictionary *) = ^(BOOL login, NSInteger loginType, NSDictionary *successInfo){
        if (!login) {
            if (completion)  completion(NO);
            return;
        }
        [[[YDDB shareInstance] selectUserWithUid:[YDLoginViewModel shared].uid] subscribeNext:^(YDUser *x) {
            if (completion)  completion(YES);
        } error:^(NSError * _Nullable error) {
            if (completion)  completion(NO);
        }];
        
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
