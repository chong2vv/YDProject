//
//  YDRouter+YDPushConfig.m
//  YDProject
//
//  Created by 王远东 on 2023/6/12.
//

#import "YDRouter+YDPushConfig.h"

@implementation YDRouter (YDPushConfig)

+ (void)openHiddenFunction {
    [YDRouter openURLStr:@"ydproject://hiddenFunction" finish:^(id result) {
        UIViewController *vc = result;
        if([YDAppDelegate currentVC]) {
            [[YDAppDelegate currentVC].navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
