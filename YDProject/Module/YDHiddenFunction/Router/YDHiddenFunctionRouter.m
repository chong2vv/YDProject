//
//  YDHiddenFunctionRouter.m
//  YDProject
//
//  Created by 王远东 on 2023/6/12.
//

#import "YDHiddenFunctionRouter.h"
#import "YDHiddenFunctionViewController.h"

@implementation YDHiddenFunctionRouter

+ (void)load {
    [self setup];
}

+ (void)setup {
    [[YDRouter sharedInstance] registerURLPattern:@"hiddenFunction" toHandler:^(NSDictionary *userInfo) {
        YDHiddenFunctionViewController * svc = [[YDHiddenFunctionViewController alloc] init];
        void(^callback)(id result) = userInfo[@"^"];
        callback(svc);
    }];
}

@end
