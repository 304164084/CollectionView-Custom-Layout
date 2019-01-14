//
//  MarlTableTagCell.m
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/6.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import "MarlTableTagCell.h"
#import "MarlTagCollectionView.h"
#import "MarlTagFlowLayout.h"
#import "MarlTstingTagCell.h"

@interface MarlTableTagCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** clsView */
@property (nonatomic, strong) UICollectionView *clsView;
@end

@implementation MarlTableTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        self.contentView.backgroundColor = [UIColor yellowColor];

    }
    return self;
}
// MARK: - 给collectionView添加一个监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"change-->%@", change);
    
    if([keyPath isEqualToString:@"frame"]) {
        CGRect oldFrame = CGRectNull;
        CGRect newFrame = CGRectNull;
        if([change objectForKey:@"old"] != [NSNull null]) {
            oldFrame = [[change objectForKey:@"old"] CGRectValue];
        }
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
        }
        NSLog(@"new-->%@, old-->%@", NSStringFromCGRect(newFrame), NSStringFromCGRect(oldFrame));
        // 判断相同则不更新
        if (newFrame.size.height != oldFrame.size.height) {
            NSLog(@"响应代理, 重新获取数据");
            if ([self.delegate respondsToSelector:@selector(cell:heightDidChanged:)]) {
                [self.delegate cell:self heightDidChanged:newFrame.size.height];
            }
        } else {
            NSLog(@"吊事不干, 维持原状");
        }
        /*
         * 在tableviewcell里面给collectionView的frame设置监听, copy以上代码。
         * 然后在收到监听的方法里, 把 newFrame&当前的cell 通过代理的方式传到tableview所在的View里(传给代理).
         * 接着, 在代理方法里, 将高度赋值给一个代理的属性上. 然后刷新(reloadData)高度.
         * over.
         */
    }
    
}
// MARK: - setup collectionView
- (void)setupViews
{
    MarlTagFlowLayout *flowLayout = [[MarlTagFlowLayout alloc] init];
    /// 此时设置已经失效, （内部已经设置默认方式).
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    __weak typeof(self)weakSelf = self;
    flowLayout.totalHeightHandler = ^(CGFloat height) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CGRect frame = strongSelf.clsView.frame;
        frame.size.height = height;
        strongSelf.clsView.frame = frame;
    };
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor colorWithRed:225.f green:225.f blue:100.f alpha:1.f];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //
    collectionView.backgroundColor = [UIColor greenColor];
    
    [collectionView registerClass:[MarlTstingTagCell class] forCellWithReuseIdentifier:@"MarlTstingTagCellID"];
    // 添加监听
    [collectionView addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    
    _clsView = collectionView;
    [self.contentView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}
// MARK: - 移除监听
- (void)dealloc
{
    NSLog(@"%@ did dealloced!", [self class]);
    [self.clsView removeObserver:self forKeyPath:@"frame"];
}
// MARK: - datasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MarlTstingTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarlTstingTagCellID" forIndexPath:indexPath];
    [cell setTitle:self.datasource[indexPath.row] tag:indexPath.row];
    return cell;
}
// MARK: - flow layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.datasource[indexPath.row];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    CGSize size = CGSizeMake(width , 40.f);

    return size;
}
// MARK: - 为collectionView设置数据
- (void)setDatasource:(NSArray *)datasource
{
    _datasource = datasource;
    [self.clsView reloadData];
}

/*
 * 将collectionView相关的进行二次封装, 将其封装到一个view中, 使其初始化, 代理等操作封装起来。
 */

@end
