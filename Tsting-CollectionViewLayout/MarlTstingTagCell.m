//
//  MarlTstingTagCell.m
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/5.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import "MarlTstingTagCell.h"

@interface MarlTstingTagCell ()
/** tagButton */
@property (nonatomic, strong) UIButton *tagButton;
@end

@implementation MarlTstingTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = RandomColor;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tagButton setTitle:@"" forState:UIControlStateNormal];
    [_tagButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [_tagButton setTitle:@"" forState:UIControlStateSelected];
    [_tagButton addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tagButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    _tagButton.layer.cornerRadius = 5.f;
    _tagButton.layer.borderColor = [UIColor blackColor].CGColor;
    _tagButton.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_tagButton];
    [_tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(self.contentView);
    }];
    
    self.contentView.layer.cornerRadius = 5.f;
    
}

- (void)actionClicked:(UIButton *)button
{
    NSLog(@"tag-->%ld", button.tag);
}

- (void)setTitle:(NSString *)title tag:(NSUInteger)tag
{
    _title = title;
    
    [self.tagButton setTitle:title forState:UIControlStateNormal];
    self.tagButton.tag = tag;
}

@end
