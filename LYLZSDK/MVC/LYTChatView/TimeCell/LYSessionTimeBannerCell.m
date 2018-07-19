//
//  LYSessionTimeBannerCell.m
//  LYLink
//
//  Created by SYLing on 2016/12/21.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYSessionTimeBannerCell.h"
#import "UIColor+LYColor.h"
#import "UIView+Frame.h"

@interface LYSessionTimeBannerCell()

@property (weak, nonatomic) UILabel *timeLabel;

@end

@implementation LYSessionTimeBannerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle WithIdentifier:(NSString *)identifier
{
    LYSessionTimeBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LYSessionTimeBannerCell alloc] initWithStyle:cellStyle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = LYColor(236, 241, 244);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *tm = [[UILabel alloc] init];
        tm.font = [UIFont systemFontOfSize:12];
        tm.textColor = [UIColor lightGrayColor];
        tm.textAlignment = NSTextAlignmentCenter;
        tm.backgroundColor = LYColor(225,232,237);
        tm.layer.masksToBounds = YES;
        tm.layer.cornerRadius = 3;
        _timeLabel = tm;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (void)setTime:(NSString *)time
{
    _time = time;
    self.timeLabel.text = time;
    [self.timeLabel sizeToFit];
    // 新设计 shaoyl 3.75 是计算得到
    self.timeLabel.y = 3.75;
    self.timeLabel.height = 18;
    self.timeLabel.width += 8;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLabel.centerX = self.centerX;
}


@end
