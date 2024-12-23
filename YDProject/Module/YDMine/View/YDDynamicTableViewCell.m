//
//  YDDynamicTableViewCell.m
//  YDProject
//
//  Created by 王远东 on 2024/12/23.
//

#import "YDDynamicTableViewCell.h"



@implementation YDDynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark private

- (void)configUI {
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(8);
                make.left.equalTo(self.contentView).offset(16);
                make.right.equalTo(self.contentView).offset(-16);
                make.bottom.equalTo(self.contentView).offset(-8);
    }];
}

#pragma mark getter

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.scrollEnabled = NO; // 禁用滚动
        _textView.translatesAutoresizingMaskIntoConstraints = NO; // 启用 Auto Layout
        _textView.layer.cornerRadius = 6;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 0.8;
    }
    return _textView;
}

@end
