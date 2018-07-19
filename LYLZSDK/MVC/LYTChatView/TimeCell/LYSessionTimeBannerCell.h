//
//  LYSessionTimeBannerCell.h
//  LYLink
//
//  Created by SYLing on 2016/12/21.
//  Copyright © 2016年 HHLY. All rights reserved.
//
// 聊天界面的时间显示的cell

#import <UIKit/UIKit.h>

@interface LYSessionTimeBannerCell : UITableViewCell

/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle WithIdentifier:(NSString *)identifier;

// 显示的时间
@property (copy, nonatomic) NSString *time;

@end
