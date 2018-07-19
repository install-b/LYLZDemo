//
//  LYTMessageListCell.m
//  LYLink
//
//  Created by SYLing on 2016/12/7.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYTMessageListCell.h"

#import "NSString+MLExpression.h"
#import "LYDateHandleTool.h"

#import "LYTCommonHeader.h"
#import "UIImage+Utility.h"
#import "UIImageView+HPWYSWebCache.h"

@interface LYTMessageListCell()


///** 详细会话 */
//@property (weak, nonatomic) UILabel *detailSessionLabel;
/** 未读 */
@property (weak, nonatomic) UIButton *unreadCountButton;
/** 时间 */
@property (weak, nonatomic) UILabel *timeLabel;
/** 下划线 */
@property (nonatomic ,weak) UIView *lineView;

@end
@implementation LYTMessageListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle WithIdentifier:(NSString *)identifier
{
    LYTMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:cellStyle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 添加控件
        UIImageView *headerImageView = [[UIImageView alloc] init];
//        if (iPhone6SP) {
//            headerImageView.layer.cornerRadius = 28;
//        } else {
//            headerImageView.layer.cornerRadius = 23;
//        }
//        headerImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:headerImageView];
        _headerImageView = headerImageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor getColor:@"333333"];
        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        [self contentLabel];
//        UILabel *detailSessionLabel = [[UILabel alloc] init];
//        detailSessionLabel.numberOfLines = 1;
//        detailSessionLabel.font = [UIFont systemFontOfSize:13];
//        detailSessionLabel.textColor = [UIColor getColor:@"666666"];
//        [self.contentView addSubview:detailSessionLabel];
//        _detailSessionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _detailSessionLabel = detailSessionLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = LYColor(200, 200, 200);
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
        
        UIButton *unreadCountButton = [[UIButton alloc] init];
        unreadCountButton.backgroundColor = [UIColor redColor];
        [unreadCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        unreadCountButton.titleLabel.font = [UIFont systemFontOfSize:12];
        unreadCountButton.enabled = NO;
        unreadCountButton.layer.cornerRadius = 10;
        unreadCountButton.layer.masksToBounds = YES;
        unreadCountButton.hidden = YES;
        [self.contentView addSubview:unreadCountButton];
        _unreadCountButton = unreadCountButton;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = BackGroundColor;
        [self.contentView addSubview:lineView];
        _lineView = lineView;
        // 添加约束
        [self setSubViewLayout];
    }
    return self;
}
- (MLEmojiLabel *)contentLabel{
    if (_contentLabel == nil) {
        MLEmojiLabel *emojiLable = [MLEmojiLabel new];
        _contentLabel = emojiLable;
        //下面是自定义表情正则和图像plist的例子
        _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _contentLabel.customEmojiPlistName = @"ClippedExpression.bundle/expression.plist";
        _contentLabel.customEmojiBundleName = @"ClippedExpression";
        _contentLabel.isNeedAtAndPoundSign = YES;
        _contentLabel.numberOfLines=0;
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor getColor:@"666666"];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (void)setSubViewLayout {
    [self.headerImageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
        if (iPhone6SP) {
            make.width.height.equalTo(@(56));
        } else {
            make.width.height.equalTo(@(46));
        }
    }];
    
    CGFloat lableW = LYScreenW - 66 - 130;
    
    [self.nameLabel hpwys_remakeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.headerImageView.hpwys_right).offset(12);
        //make.right.equalTo(self.timeLabel.hpwys_left).offset(-12);
        make.width.lessThanOrEqualTo(@(lableW));
    }];
    
    
    [self.contentLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.headerImageView.hpwys_right).offset(10);
        make.height.equalTo(@16);
        make.width.equalTo(@(lableW));
    }];
    
    
    [self.timeLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    [self.unreadCountButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-11);
        make.right.equalTo(self.timeLabel);
        make.width.equalTo(@(20)).priorityMedium();
        make.height.equalTo(@(20));
        ;
    }];
    
    [self.lineView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView.hpwys_bottom).offset(-1);
    }];

}

//annotation by ys 2017.11.06
// 设置外部数据模型
//- (void)setOutsideSessionListModel:(LYTMessageList *)outsideSessionListModel {
//    _outsideSessionListModel = outsideSessionListModel;

//    [self.headerImageView hpwys_setImageWithURL:[NSURL URLWithString:outsideSessionListModel.listHeadUrl] placeholderImage:[UIImage lyt_chatImageNamed:@"vistorHead"] completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, NSURL *imageURL) {
//        if (!image) {
//            return ;
//        }
//        //显示
//        self.headerImageView.image = [image roundImage];// circularImage;
//    }];
//
//    self.nameLabel.text = outsideSessionListModel.listTitle;
//    NSString  *timeString = (outsideSessionListModel.messageTime.length < 11) ? outsideSessionListModel.messageTime : [outsideSessionListModel.messageTime substringToIndex:10];
//
//    if (outsideSessionListModel.lastMessage) {
//        self.timeLabel.hidden = NO;
//         self.timeLabel.text = [LYDateHandleTool showTime:[timeString floatValue] showDetail:YES];
//    } else {
//        self.timeLabel.hidden = YES;
//    }
//
//    self.contentLabel.text = outsideSessionListModel.listTitleDescription;
//
//    self.unreadCount = outsideSessionListModel.unreadCount;
//}
//
//
//- (void)setUnreadCount:(NSInteger)unreadCount {
//    if (unreadCount > 0) {
//        self.unreadCountButton.hidden = NO;
//
//        if (unreadCount > 99) {
//            [self.unreadCountButton hpwys_updateConstraints:^(HPWYSConstraintMaker *make) {
//                make.width.equalTo(@(30));
//            }];
//        }else{
//            [self.unreadCountButton hpwys_updateConstraints:^(HPWYSConstraintMaker *make) {
//                make.width.equalTo(@(20));
//            }];
//        }
//        [self.unreadCountButton setTitle:[NSString stringWithFormat:@"%zd",unreadCount] forState:UIControlStateNormal];
//    } else {
//        self.unreadCountButton.hidden = YES;
//    }
    
//}

@end
