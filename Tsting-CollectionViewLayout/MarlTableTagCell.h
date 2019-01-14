//
//  MarlTableTagCell.h
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/6.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarlTableTagCell;
@protocol MarlTableTagCellDelegate <NSObject>

/**
 代理回传当前cell & 最后高度

 @param cell 当前cell
 @param height 改变后的高度
 */
- (void)cell:(MarlTableTagCell *)cell heightDidChanged:(CGFloat)height;

@end

@interface MarlTableTagCell : UITableViewCell
/** datasource */
@property (nonatomic, strong) NSArray *datasource;
/** delegate */
@property (nonatomic, weak) id<MarlTableTagCellDelegate> delegate;

@end
