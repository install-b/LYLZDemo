//
//  LYInputEmotionViewCell.h
//  LYLink
//
//  Created by SYLing on 2016/12/19.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYInputEmotionViewCell, LYEmotion;
@protocol LYInputEmotionViewCellDelegate <NSObject>

@required
- (void)inputEmotionCell:(LYInputEmotionViewCell *)inputEmotionCell didClickEmotion:(LYEmotion *)emotion;
- (void)inputEmotionCellClickDeleteEmotion:(LYInputEmotionViewCell *)inputEmotionCell;

@end

@interface LYInputEmotionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSArray *emotions;
@property (weak, nonatomic) id<LYInputEmotionViewCellDelegate> delegate;
@end
