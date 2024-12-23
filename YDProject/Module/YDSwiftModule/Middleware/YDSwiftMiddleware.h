//
//  YDSwiftMiddleware.h
//  YDProject
//
//  Created by 王远东 on 2024/12/22.
//

#import <Foundation/Foundation.h>
#import "YDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDSwiftMiddleware : NSObject

+ (NSArray <YDUser *> *)selectAllUser;

@end

NS_ASSUME_NONNULL_END
