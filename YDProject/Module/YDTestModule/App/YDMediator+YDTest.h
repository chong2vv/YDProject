//
//  YDMediator+YDTest.h
//  YDProject
//
//  Created by 王远东 on 2024/12/21.
//

#import "YDMediator.h"


@interface YDMediator (YDTest)

- (UIViewController *)startTestParams:(NSDictionary *)aParams navigationController:(UINavigationController *)aNav;
- (UIViewController *)startTestParams:(NSDictionary *)aParams;

@end

