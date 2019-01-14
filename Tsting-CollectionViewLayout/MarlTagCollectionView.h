//
//  MarlTagCollectionView.h
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/6.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MarlTagCollectionViewDelegate<NSObject>
- (NSInteger)marl_tagCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;


@end
@interface MarlTagCollectionView : UIView
/** 数据源 */
@property (nonatomic, strong) NSArray *dataSourceArray;
/** cell 高度 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 刷新数据
 */
- (void)reloadData;
@end
