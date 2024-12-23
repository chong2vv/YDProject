//
//  YDTestViewController.m
//  YDProject
//
//  Created by 王远东 on 2024/12/21.
//

#import "YDTestViewController.h"

@interface YDTestViewController ()

@end

@implementation YDTestViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configDataSource];
    [self configObserve];
}

#pragma mark - private
- (void)configUI {
    self.title = @"测试页面";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configDataSource {
    
}

- (void)configObserve {
    
}

#pragma mark getter

@end
