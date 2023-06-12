//
//  YDLoginRouter.m
//  YDProject
//
//  Created by 王远东 on 2023/6/8.
//

#import "YDLoginRouter.h"
#import "YDLoginViewController.h"

@implementation YDLoginRouter

+ (void)load {
    [self setup];
}

+ (void)setup {
    [YDRouter.sharedInstance registerURLPattern:@"YDCheckLogin" toHandler:^(NSDictionary *userInfo) {
        NSDictionary *aParams = userInfo;
        YDLoginViewController *svc = [YDLoginViewController new];
        svc.modalPresentationStyle = UIModalPresentationFullScreen;
        svc.successCallback = [aParams objectForKey:kSuccessCallback];
        void(^callback)(id result) = userInfo[@"^"];
        callback(svc);
    }];
}
@end
