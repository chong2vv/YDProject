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

@end

NS_ASSUME_NONNULL_END
