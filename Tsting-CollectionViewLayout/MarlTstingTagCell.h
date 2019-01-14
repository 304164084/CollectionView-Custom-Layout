//
//  MarlTstingTagCell.h
//  Tsting-CollectionViewLayout
//
//  Created by bonlion on 2018/9/5.
//  Copyright © 2018年 dasui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarlTstingTagCell : UICollectionViewCell
/** data */
@property (nonatomic, copy) NSString *title;

- (void)setTitle:(NSString *)title tag:(NSUInteger)tag;
@end
