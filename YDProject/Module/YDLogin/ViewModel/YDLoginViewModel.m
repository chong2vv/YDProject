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

@implementation YDLoginViewModel

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

- (void)saveUser:(YDUser *)user {
    [[MMKV defaultMMKV] setString:user.uid forKey:YDPlistCurrentUserUID];
    [[[YDDB shareInstance] insertWithUserModel:user] subscribeNext:^(NSString *x) {
        NSString *uid = x;
        YDLogDebug(@"wyd - 用户保存信息成功 uid:%@", uid);
    }];
}
@end
