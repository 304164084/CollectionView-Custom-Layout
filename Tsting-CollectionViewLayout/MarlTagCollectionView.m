//
//  MarlTagCollectionView.m
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/6.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import "MarlTagCollectionView.h"
#import "MarlTstingTagCell.h"
#import "MarlTagFlowLayout.h"

#import <Masonry.h>

@interface MarlTagCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** collectionView */
@property (nonatomic, strong) UICollectionView *cltView;


@end

@implementation MarlTagCollectionView
- (NSArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSArray array];
    }
    return _dataSourceArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initializeDefaultPropertyValue];
        [self setupViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                   datasource:(NSArray *)datasouce
{
    if (self = [super initWithFrame:frame]) {
        [self initializeDefaultPropertyValue];
        [self setupViews];
    }
    return self;
}
// MARK: - 初始化默认数据
- (void)initializeDefaultPropertyValue
{
    // 默认高度
    self.itemHeight = 40.f;
}
- (void)setupViews
{
    // init custom flow layout
    MarlTagFlowLayout *flowLayout = [[MarlTagFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    __weak typeof(self)weakSelf = self;
    flowLayout.totalHeightHandler = ^(CGFloat height) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CGRect frame = strongSelf.cltView.frame;
        frame.size.height = height;
        strongSelf.cltView.frame = frame;
        // 同步 view 高度
        CGRect selfFrame = strongSelf.frame;
        selfFrame.size.height = strongSelf.cltView.frame.size.height;
        strongSelf.frame = selfFrame;
    };
    // init collectionView
    _cltView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1) collectionViewLayout:flowLayout];
    _cltView.backgroundColor = self.backgroundColor;
    _cltView.delegate = self;
    _cltView.dataSource = self;
    
    // register cell
    [_cltView registerClass:[MarlTstingTagCell class] forCellWithReuseIdentifier:@"MarlTstingTagCellID"];
    [self addSubview:_cltView];
}
// MARK: - reload
- (void)reloadData
{
    [self.cltView reloadData];
}
// MARK: - delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MarlTstingTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarlTstingTagCellID" forIndexPath:indexPath];
    [cell setTitle:self.dataSourceArray[indexPath.row] tag:indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.dataSourceArray[indexPath.row];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    CGSize size = CGSizeMake(width , self.itemHeight);
    
    return size;
}
@end
