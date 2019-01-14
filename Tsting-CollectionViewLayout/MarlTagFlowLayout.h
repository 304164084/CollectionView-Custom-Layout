//
//  MyFlowLayout.h
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/5.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarlTagFlowLayout : UICollectionViewFlowLayout
/** 总高度 */
@property (nonatomic, copy) void (^totalHeightHandler)(CGFloat height);
/** 顶部间距 */
@property (nonatomic, assign) CGFloat topSpace;
/** 列/排间距 */
@property (nonatomic, assign) CGFloat lineSpace;
/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpace;
/** 左侧cell与collectionView的间距 */
@property (nonatomic, assign) CGFloat leadingSpace;
/** 右侧cell与collectionView的间距 */
@property (nonatomic, assign) CGFloat trailingSpace;
/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets marlEdgeInsets;
@end
