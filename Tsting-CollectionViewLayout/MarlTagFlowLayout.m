//
//  MyFlowLayout.m
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/5.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import "MarlTagFlowLayout.h"


static int _rowCount = 0;
static CGFloat _previousSectionMaxY = 0.f;

@interface MarlTagFlowLayout ()
/** collectionView宽 */
@property (nonatomic, assign) CGFloat collectionViewWidth;
/** 可布局的宽度. collectionView.width - leadingSpace - trailingSpace */
@property (nonatomic, assign) CGFloat layoutWidth;
/** 改变后的attributes集合 */
@property (nonatomic, strong) NSMutableArray *changedAttributes;
/** 前一个cell属性 */
@property (nonatomic, strong) UICollectionViewLayoutAttributes *previousLayoutAttributes;
/** 上一组最大y值 ...(下一组的起始y值 = 上一组footerview的最大y值 + 此组的header高度 + 间距) 但是在此不设header & footer 最后公式为 上一组最大y值(即高度) + 间距 */
//@property (nonatomic, assign) CGFloat previousSectionMaxY;
/** 最后的高度 */
@property (nonatomic, assign) CGFloat totalHeight;
@end

@implementation MarlTagFlowLayout
//- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
//{
//    _lineSpace = minimumLineSpacing;
//}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}
- (void)prepareLayout
{
    [super prepareLayout];
//    NSLog(@"collectionView.frame-->%@, item.sieze-->%@", NSStringFromCGRect(self.collectionView.frame), NSStringFromCGSize(self.itemSize));
    
    // collectionView宽
    self.collectionViewWidth = self.collectionView.frame.size.width;
    // property default value
    self.rowSpace = 10.f;
    self.lineSpace = 10.f;
    self.topSpace = 10.f;
    self.leadingSpace = 10.f;
    self.trailingSpace = 10.f;
    // 默认不支持滚动(最后高度相当于是确定的，所以这样设置，避免滑动)
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //内部button的内边距
    self.marlEdgeInsets = UIEdgeInsetsMake(0, 5.f, 0, 5.f);
    // 可布局的宽度
    self.layoutWidth = self.collectionViewWidth - self.leadingSpace - self.trailingSpace;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat totalHeight = 0.f;
    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];

            if (j == count - 1) {
                CGFloat curSectionHeight = CGRectGetMaxY(attributes.frame) + self.rowSpace;
//                NSLog(@"sectionHeight-->%f", curSectionHeight);
                totalHeight = curSectionHeight;
            }
            
            [tmpAttributes addObject:attributes];
        }
    }
    NSLog(@"totoalHeight-->%f", totalHeight);
    if (_totalHeightHandler) {
        if (totalHeight < 1) {
            totalHeight = 1;
        }
        self.totalHeight = totalHeight;
        _totalHeightHandler(totalHeight);
    }
    // 重置数据
    self.previousLayoutAttributes = nil;
    _rowCount = 0;
    _previousSectionMaxY = 0.f;
    return tmpAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *currentAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = currentAttributes.frame;
    
    CGFloat currentItemHeight = frame.size.height + self.marlEdgeInsets.top + self.marlEdgeInsets.bottom;
    CGFloat currentItemWidth = frame.size.width + self.marlEdgeInsets.left + self.marlEdgeInsets.right;
    CGFloat currentItemY = frame.origin.y;
    CGFloat currentItemX = frame.origin.x;
    // 判断是否为同一组
    if (self.previousLayoutAttributes && indexPath.section != self.previousLayoutAttributes.indexPath.section) {
        _rowCount = 0;
        _previousSectionMaxY = CGRectGetMaxY(self.previousLayoutAttributes.frame) + self.rowSpace * 3;
        self.previousLayoutAttributes = nil;
    }
    if ((CGRectGetMaxX(self.previousLayoutAttributes.frame) + self.lineSpace + currentItemWidth) <= (self.collectionViewWidth - self.leadingSpace)) {
        currentItemX = self.previousLayoutAttributes ? (CGRectGetMaxX(self.previousLayoutAttributes.frame) + self.lineSpace) : self.leadingSpace;
        currentItemY = self.topSpace + (currentItemHeight + self.rowSpace) * _rowCount + _previousSectionMaxY;
    } else {
        _rowCount++;
        currentItemY = self.topSpace + (currentItemHeight + self.rowSpace) * _rowCount + _previousSectionMaxY;
        currentItemX = self.leadingSpace;
    }
    frame.origin = CGPointMake(currentItemX, currentItemY);
    frame.size = CGSizeMake(currentItemWidth, currentItemHeight);
    currentAttributes.frame = frame;
    _previousLayoutAttributes = currentAttributes;
//    NSLog(@"cur-->%@---itemSize-->%@", currentAttributes, NSStringFromCGSize(self.itemSize));

    return currentAttributes;
    
}
- (NSMutableArray *)changedAttributes
{
    if (!_changedAttributes) {
        _changedAttributes = [NSMutableArray array];
    }
    return _changedAttributes;
}
- (CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake([super collectionViewContentSize].width, self.totalHeight);
    NSLog(@"contentSize == %@", NSStringFromCGSize(size));
    return size;
}

@end
