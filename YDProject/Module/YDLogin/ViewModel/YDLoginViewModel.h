//
//  YDLoginViewModel.h
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#import <Foundation/Foundation.h>
@class YDUser;
NS_ASSUME_NONNULL_BEGIN

@interface YDLoginViewModel : NSObject
@property (nonatomic, strong, readonly) RACSubject *subject;
@property (nonatomic, copy, readonly)NSString *uid;
@property (nonatomic, assign, readonly) BOOL isLogin;

+ (instancetype)shared;

+ (BOOL)checkAndLoginWithTypeComplete:(void (^)(BOOL isLogin))completion;

- (RACSignal *)login:(NSString *)userAccount userPassword:(NSString *)userPassword;

- (RACSignal *)userRegister:(NSString *)userAccount userPassword:(NSString *)userPassword;

- (RACSignal *)updateUser:(YDUser *)user;

- (RACSignal *)sendCode:(NSString *)phoneNumber;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
