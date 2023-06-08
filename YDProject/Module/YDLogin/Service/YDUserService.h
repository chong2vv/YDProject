//
//  YDUserService.h
//  YDProject
//
//  Created by 王远东 on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDUserService : NSObject
@property (nonatomic, assign, readonly) NSString *user_id;

+ (instancetype)shared;

+ (BOOL)checkAndLoginWithTypeComplete:(void (^)(BOOL isLogin))completion;

- (BOOL)isLogin;

- (void)logout;
- (void)login;
@end

NS_ASSUME_NONNULL_END
