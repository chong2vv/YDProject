//
//  YDMineViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDMineViewController.h"
#import "YDDynamicTableViewCell.h"

@interface YDMineViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) YDTableView *homeTableView;
@property (nonatomic, copy) NSMutableArray <NSString *> *dataList;
@property (nonatomic, strong) NSMutableArray *userList;

@end

@implementation YDMineViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configDataSource];
    
    //监听列表数据变化进行列表更新
    @weakify(self);
    //首页列表数据赋值，过滤无效数据
    RAC(self, userList) = [[[YDDB shareInstance] selectAllUser]
                        map:^id(NSMutableArray *userArray) {
                            if (userArray.count > 0) {
                                //
                            } else {
                                YDUser *user = [[YDUser alloc] init];
                                user.uid = @"12312321";
                                user.userName = @"七月";
                                [userArray removeAllObjects];
                                [userArray addObject:user];
                                
                            }
                            return userArray;
                        }];
    
    //监听列表数据变化进行列表更新
    [RACObserve(self, userList) subscribeNext:^(id x) {
        @strongify(self);
        [self loadUserList];
    }];
    
}

#pragma mark - private
- (void)configUI {
    // 添加 "编辑" 按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(toggleEditingMode)];
    [self.view addSubview:self.homeTableView];
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
}

- (void)configDataSource {
    [self.dataList addObject:@"1"];
    [self.dataList addObject:@"2"];
    [self.dataList addObject:@"3"];
    [self.homeTableView reloadData];
}

- (void)loadUserList {
    
}


- (void)toggleEditingMode {
    [self.homeTableView setEditing:!self.homeTableView.isEditing animated:YES];
    self.navigationItem.rightBarButtonItem.title = self.homeTableView.isEditing ? @"Done" : @"Edit";
}

#pragma mark - Delegate
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableCell"];
    if (!cell) {
        cell = [[YDDynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineTableCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textView.text = self.dataList[indexPath.row];
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.row;
    return cell;
}

// 允许单元格被拖动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES; // 所有单元格都可以被移动
}

// 更新数据源以反映新的顺序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *movedObject = self.dataList[sourceIndexPath.row];
    [self.dataList removeObjectAtIndex:sourceIndexPath.row];
    [self.dataList insertObject:movedObject atIndex:destinationIndexPath.row];
}

// 允许进入编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *title = self.dataList[indexPath.row];
//    if ([title isEqualToString:@"1"]) {
//        YDLogInfo(@"点击第1个");
//        NSArray *array = @[@"1", @"2", @"3"];
//        NSLog(@"%@", array[10]);
//    }else if ([title isEqualToString:@"2"]) {
//        YDLogInfo(@"点击第2个");
//        NSLog(@"===== %@ ======", self.userList);
//    }else if ([title isEqualToString:@"3"]) {
//        YDLogInfo(@"点击第3个");
//    }else {
//        YDLogError(@"没有这个类型");
//    }
//}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger row = textView.tag;
    self.dataList[row] = textView.text; // 更新数据源

    // 通知 UITableView 更新高度
    [UIView setAnimationsEnabled:NO]; // 禁用动画，避免闪烁
    [self.homeTableView beginUpdates];
    [self.homeTableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

#pragma mark getter
- (YDTableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[YDTableView alloc] init];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.estimatedRowHeight = 44.0; // 设置估算行高
        _homeTableView.rowHeight = UITableViewAutomaticDimension; // 自动计算行高
        
//        @weakify(self);
//        [_homeTableView setMJRefreshing:^{
//            @strongify(self);
//            [self configDataSource];
//        } loadMoreData:^{
//            @strongify(self);
//            [self configDataSource];
//        }];
    }
    return _homeTableView;
}

- (NSMutableArray *)userList {
    if (!_userList) {
        _userList = [NSMutableArray array];
    }
    return _userList;
}

- (NSMutableArray<NSString *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
