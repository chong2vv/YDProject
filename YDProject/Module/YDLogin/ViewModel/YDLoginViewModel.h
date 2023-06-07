//
//  YDLoginViewModel.h
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDLoginViewModel : NSObject


- (RACSignal *)login:(NSString *)userAccount userPassword:(NSString *)userPassword;

- (RACSignal *)userRegister:(NSString *)userAccount userPassword:(NSString *)userPassword;

- (RACSignal *)updateUser:(YDUser *)user;

- (RACSignal *)sendCode:(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END
