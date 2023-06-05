//
//  YDLoginViewModel.m
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#import "YDLoginViewModel.h"
#import "YDLoginCommand.h"
#import "YDRegisterCommand.h"

@implementation YDLoginViewModel

- (RACSignal *)login:(NSString *)userAccount userPassword:(NSString *)userPassword {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [YDLoginCommand ydCommandSetParame:^(__kindof YDLoginCommand * _Nonnull request) {
            request.input_userAccount = userAccount;
            request.input_userPassword = userPassword;
            } completion:^(__kindof YDLoginCommand * _Nonnull request) {
                [SVProgressHUD dismiss];
                if (request.error) {
                    YDLogError(@"登录失败：%@", request.error);
                    [subscriber sendError:request.error];
                }else{
                    YDUser *user = request.user;
                    [[MMKV defaultMMKV] setString:userAccount forKey:YDPlistCurrentUserUID];
                    [subscriber sendNext:user];
                    [subscriber sendCompleted];
                }
            }];
        return nil;
    }];
}

- (RACSignal *)userRegister:(NSString *)userAccount userPassword:(NSString *)userPassword {

    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [YDRegisterCommand ydCommandSetParame:^(__kindof YDRegisterCommand * _Nonnull request) {
            request.input_userAccount = userAccount;
            request.input_userPassword = userPassword;
            } completion:^(__kindof YDRegisterCommand * _Nonnull request) {
                [SVProgressHUD dismiss];
                if (request.error) {
                    YDLogError(@"注册失败：%@", request.error);
                    [subscriber sendError:request.error];
                }else{
                    YDUser *user = request.user;
                    [[MMKV defaultMMKV] setString:userAccount forKey:YDPlistCurrentUserUID];
                    [subscriber sendNext:user];
                    [subscriber sendCompleted];
                }
                
            }];
        return nil;
    }];
}
@end
