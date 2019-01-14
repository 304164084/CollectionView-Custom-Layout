//
//  SecondViewController.m
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/7.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import "SecondViewController.h"
#import "MarlTagFlowLayout.h"
#import "MarlTstingTagCell.h"

@interface SecondViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** collectionViw */
@property (nonatomic, strong) UICollectionView *cltView;
/** data */
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SecondViewController
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.dataArray = [NSArray arrayWithObjects:@"Typhoon",@"Nabi",@"was",@"a",@"powerful",@"typhoon",@"that",@"struck",@"southwestern",@"Japan",@"in ",@"September",@"2005",@".",@"The",@"14th",@"named",@"storm",@"of",@"the",@"2005",@"Pacific",@"typhoon",@"season",@"Nabi",@"formed",@"on",@"August",@"29",@"to",@"the",@"east", @"Typhoon",@"Nabi", nil];
        
            [self.cltView reloadData];
    });
}
// MARK: - create collecitonView
- (void)createCollectionView
{
    MarlTagFlowLayout *flowLayout = [[MarlTagFlowLayout alloc] init];
    /// 此时设置已经失效, （内部已经设置默认方式).
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 20.f;
    flowLayout.minimumLineSpacing = 20.f;
    __weak typeof(self)weakSelf = self;
    flowLayout.totalHeightHandler = ^(CGFloat height) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CGRect frame = strongSelf.cltView.frame;
        frame.size.height = height;
        strongSelf.cltView.frame = frame;
    };
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width - 40, 200) collectionViewLayout:flowLayout];
    //
    collectionView.backgroundColor = [UIColor colorWithRed:225.f green:225.f blue:100.f alpha:1.f];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[MarlTstingTagCell class] forCellWithReuseIdentifier:@"MarlTstingTagCellID"];
    _cltView = collectionView;
    // 添加一个监听, 监听collectionView的高度变化
    [self.cltView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.view addSubview:collectionView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.cltView reloadData];
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

// MARK: - delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MarlTstingTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarlTstingTagCellID" forIndexPath:indexPath];
    [cell setTitle:self.dataArray[indexPath.row] tag:indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.dataArray[indexPath.row];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    CGSize size = CGSizeMake(width , 40.f);

    return size;
}
@end
