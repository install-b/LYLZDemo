//
//  LYTMessageListCell.h
//  LYLink
//
//  Created by SYLing on 2016/12/7.
//  Copyright © 2016年 HHLY. All rights reserved.
//
//  聊天列表样式的cell

#import <UIKit/UIKit.h>
@class LYTMessageList;

#import "MLEmojiLabel.h"
@interface LYTMessageListCell : UITableViewCell
/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle WithIdentifier:(NSString *)identifier;

//annotation by ys 2017.11.06
/** 外部通话的模型 */
//@property (strong, nonatomic) LYTMessageList *outsideSessionListModel;

/** 头像 */
@property (weak, nonatomic) UIImageView *headerImageView;

/** 昵称 */
@property (weak, nonatomic) UILabel *nameLabel;

@property (nonatomic,weak) MLEmojiLabel *contentLabel;

- (void)setUnreadCount:(NSInteger)unreadCount;
@end
