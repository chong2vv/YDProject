//
//  YDHomePageViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDHomePageViewController.h"
#import "YDHiddenFunctionViewController.h"

@interface YDHomePageViewController ()

@end

@implementation YDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self oppenHiddenFunctionVC];
    [self configTestUI];
    
    [[YDLoginViewModel shared].subject subscribeNext:^(id  _Nullable x) {
        YDLogInfo(@"HomeVC logout----- %@", x);
    }];
}

- (void)oppenHiddenFunctionVC {
    [self.navigationController.navigationBar whenFiveTapped:^{
        yd_dispatch_async_main_safe(^{
            [YDRouter openHiddenFunction];
            YDLogInfo(@"==== 进入隐藏功能 ====");
        });
    }];
}

- (void)configTestUI {
    UIButton *testLoginBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:testLoginBt];
    [testLoginBt setTitle:@"登录判断" forState:UIControlStateNormal];
    [testLoginBt addTarget:self action:@selector(userLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [testLoginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
}

- (void)userLoginAction {
//    [[YDLoginViewModel shared] logout];
    if([YDLoginViewModel checkAndLoginWithTypeComplete:nil]) {
        
    }
}


@end
