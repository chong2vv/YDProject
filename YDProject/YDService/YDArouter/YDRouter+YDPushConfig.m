//
//  YDRouter+YDPushConfig.m
//  YDProject
//
//  Created by 王远东 on 2023/6/12.
//

#import "YDRouter+YDPushConfig.h"

@implementation YDRouter (YDPushConfig)

// 进入隐藏功能页面（路由方式解耦）
+ (void)openHiddenFunction {
    [YDRouter openURLStr:@"ydproject://hiddenFunction" finish:^(id result) {
        UIViewController *vc = result;
        vc.hidesBottomBarWhenPushed = YES;
        if([YDAppDelegate currentVC]) {
            [[YDAppDelegate currentVC].navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
