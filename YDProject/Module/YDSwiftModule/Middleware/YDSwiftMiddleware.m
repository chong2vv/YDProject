//
//  YDSwiftMiddleware.m
//  YDProject
//
//  Created by 王远东 on 2024/12/22.
//

#import "YDSwiftMiddleware.h"

@implementation YDSwiftMiddleware

+ (NSArray<YDUser *> *)selectAllUser {
    __block NSArray *userArray;
    [[[YDDB shareInstance] selectAllUser] subscribeNext:^(NSArray <YDUser *> *x) {
        userArray = x;
    }];
    return userArray;
}

@end
