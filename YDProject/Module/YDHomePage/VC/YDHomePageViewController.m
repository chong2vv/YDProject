//
//  YDHomePageViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDHomePageViewController.h"
#import "YDHiddenFunctionViewController.h"
#import "YDMediator+YDTest.h"
#import "YDTestViewController.h"
#import "YDTimer.h"

static NSString *homeTimerName = @"YDHomeTimerName";

@interface YDHomePageViewController ()

@end

@implementation YDHomePageViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 布局UI、数据，注册回调
    [self configUI];
    [self configDataSource];
    [self configObserve];
    // 隐藏方法
    [self oppenHiddenFunctionVC];
}

- (void)configUI {
    [self setTitle:@"首页"];
    
    UIButton *testLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:testLoginBtn];
    [testLoginBtn setTitle:@"Objective-C测试页面" forState:UIControlStateNormal];
    [testLoginBtn addTarget:self action:@selector(_testAction) forControlEvents:UIControlEventTouchUpInside];
    [testLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *swiftTestLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:swiftTestLoginBtn];
    [swiftTestLoginBtn setTitle:@"Swift测试页面" forState:UIControlStateNormal];
    [swiftTestLoginBtn addTarget:self action:@selector(_swiftTestAction) forControlEvents:UIControlEventTouchUpInside];
    [swiftTestLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(testLoginBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - private
- (void)configDataSource {
    
}

- (void)configObserve {
    [[YDLoginEngine shared].subject subscribeNext:^(id  _Nullable x) {
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

- (void)_testAction {
    UIView *v = [[UIView alloc] init];
    [self.view addSubview:v];
    [v removeFromSuperview];
    return;
    
    [[YDMediator sharedInstance] startTestParams:nil navigationController:self.navigationController];
}

- (void)_swiftTestAction {
    UIViewController *vc = [YDSwiftModuleViewController creatVC];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_userLoginAction {
    if([YDLoginEngine checkAndLoginWithTypeComplete:nil]) {
        
    }
}

#pragma mark 计时器
- (void)_createTimer {
    [self _releaseTimer];
    [[YDTimer sharedTimer] scheduledTimerWithName:homeTimerName timerType:YDTimerTypeManualRelease queue:nil timeInterval:5 leewayInseconds:0 handler:^BOOL{
        
        return NO;
    }];
}

- (void)_releaseTimer {
    [[YDTimer sharedTimer] invalidateWithTimerName:homeTimerName];
}

- (void)dealloc {
    [self _releaseTimer];
}

@end
