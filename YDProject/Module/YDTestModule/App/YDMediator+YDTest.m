//
//  YDMediator+YDTest.m
//  YDProject
//
//  Created by 王远东 on 2024/12/21.
//

#import "YDMediator+YDTest.h"
NSString * const kMediatorTargetTest = @"YDAppTest";
NSString * const kMediatorTestAction = @"startTestAppWithParams";

@implementation YDMediator (YDTest)

- (UIViewController *)startTestParams:(NSDictionary *)aParams navigationController:(UINavigationController *)aNav {
    return [self performTarget:kMediatorTargetTest  action:kMediatorTestAction params:[self handleParam:aParams type:1 navigationController:aNav]];
}

- (UIViewController *)startTestParams:(NSDictionary *)aParams {
    return [self startTestParams:aParams navigationController:nil];
}


@end
