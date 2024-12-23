//
//  YDAppTest.m
//  YDProject
//
//  Created by 王远东 on 2024/12/21.
//

#import "YDAppTest.h"
#import "YDTestViewController.h"

@implementation YDAppTest

- (UIViewController *)startTestAppWithParams:(NSDictionary *)aParams {
    YDTestViewController *vc = [[YDTestViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController = aParams[@"nav"];
    [self showViewController:vc showType:EYDMediatorShowTypePush animated:YES completion:nil];
    return vc;
}

@end
