//
//  LZSystemNotiCell.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/14.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZSystemNotiCell.h"
#import "UIColor+LYColor.h"
#import "LYDateHandleTool.h"
#import "NSString+TextSize.h"
#import "LYTCommonHeader.h"



#define CONTENT_FONT [UIFont systemFontOfSize:16]
#define TIME_FONT [UIFont systemFontOfSize:13]

#define marginX  10
#define marginY  15

@interface LZSystemNotiModel ()

/** <#des#> */
@property(nonatomic,assign) CGRect contentFrame ;

/** <#des#> */
@property(nonatomic,assign) CGRect timeFrame;

/** <#des#> */
@property (nonatomic,copy)NSString * timeString;

/** <#des#> */
@property (nonatomic,copy)NSString * content;

@end


@implementation LZSystemNotiModel


- (instancetype)initWithContent:(NSString *)content time:(NSString *)time {
    if (self = [super init]) {
        _content = content;
        _timeString = [LYDateHandleTool showTime:[time floatValue] showDetail:YES];
        [self caculateCellFrame];
    }
    
    return self;
}

- (void)caculateCellFrame {
    CGFloat cellHeight = 0;
    CGFloat maxWidth = LYScreenW - 2*marginX;
    
    CGFloat contentH = [_content heightWithFont:CONTENT_FONT MaxWidth:maxWidth];
    
    _contentFrame = CGRectMake(marginX, marginY, maxWidth, contentH);
    cellHeight += CGRectGetMaxY(_contentFrame) ;
    
    
    CGFloat timeHeight = [_timeString heightWithFont:TIME_FONT MaxWidth:HUGE];
    
    _timeFrame = CGRectMake(marginX, cellHeight + marginX, maxWidth, timeHeight);
    
    if (timeHeight) {
        cellHeight += timeHeight + marginX;
    }
    
    _cellHeight = cellHeight + marginY;
    
    
}
@end




#pragma mark -

@interface LZSystemNotiCell ()

/** <#des#> */
@property (nonatomic,weak) UILabel * notiLabel;

/** <#des#> */
@property (nonatomic,weak) UILabel * timeLabel;

@end

@implementation LZSystemNotiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self initSetUp];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSetUp];
}

- (void)initSetUp {
    // 内容
    UILabel *notiLable = [[UILabel alloc] init];
    notiLable.font = [UIFont systemFontOfSize:16];
    notiLable.textColor = LYColor(75, 75, 75);
    notiLable.numberOfLines = 0;
    [self.contentView addSubview:notiLable];
    self.notiLabel = notiLable;
    
    // 时间
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.font = [UIFont systemFontOfSize:13];
    timeLable.textColor = LYColor(183, 183, 183);
    [self.contentView addSubview:timeLable];
    self.timeLabel = timeLable;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSystemNoti:(LZSystemNotiModel *)systemNoti {
    _systemNoti = systemNoti;
    
    _notiLabel.text = systemNoti.content;
    _timeLabel.text = systemNoti.timeString;
    _timeLabel.frame = systemNoti.timeFrame;
    _notiLabel.frame = systemNoti.contentFrame;

}

@end
