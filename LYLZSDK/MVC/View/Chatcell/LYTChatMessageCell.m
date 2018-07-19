//
//  LYTChatMessageCell.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatMessageCell.h"
#import "LYTChatMessageCellFrame.h"
#import "LYTChatTextContentView.h"
#import "LYTChatImageContentView.h"
#import "LYTChatVoiceContentView.h"
#import "LYTChatFileContentView.h"

#import "UIColor+LYColor.h"
#import "UIView+Frame.h"
#import "UIImage+BundleImage.h"
#import "UIImageView+HPWYSWebCache.h"
#import "UIImage+Bundle.h"


@interface LYTChatMessageCell()<LYTChatMessageContentViewDelegate>

@property (nonatomic,strong) UIImageView *icon;

@property (nonatomic,strong) NSString *contentStr;

//发送loading
@property (nonatomic,strong) UIActivityIndicatorView *traningActivityIndicator;

//重发按钮
@property (nonatomic,strong) UIButton *retryButton;

//阅后即焚按钮
@property (nonatomic,strong) UIImageView *burnMsgImageIcon;

/** 阅后即焚倒计时 */
@property (nonatomic,strong) UIButton *burndelayTimeButton;

/** 阅后即焚蒙版 */
@property (nonatomic,strong) UIView *burnMarkView;

@end
@implementation LYTChatMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.icon = [[UIImageView alloc]init];
//        self.icon.layer.cornerRadius = 20;
//        self.icon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.icon];
    }
    return self;
}

- (void)setCellFrame:(LYTChatMessageCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    self.icon.frame = cellFrame.iconRect;
    // 设置头像
    if (cellFrame.chartMessage.isSender) {//Myhead
        
        [self.icon hpwys_setImageWithURL:[NSURL URLWithString:cellFrame.chartMessage.sendUserHeadUrl] placeholderImage:[UIImage lyt_chatImageNamed:@"me_icon"] completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                return ;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //开启图片上下文
                UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
                //裁切
                //裁切范围
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                [path addClip];
                //绘制图片
                [image drawAtPoint:CGPointZero];
                //从上下文中获得裁切好的图片
                UIImage *circularImage =UIGraphicsGetImageFromCurrentImageContext();
                //关闭图片上下文
                UIGraphicsEndImageContext();
                //显示
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.icon.image = circularImage;
                });
            });
            
        }];
    } else {
        [self.icon hpwys_setImageWithURL:[NSURL URLWithString:cellFrame.chartMessage.sendUserHeadUrl] placeholderImage:[UIImage lyt_chatImageNamed:@"meiconholder"] completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                return ;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //开启图片上下文
                UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
                //裁切
                //裁切范围
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                [path addClip];
                //绘制图片
                [image drawAtPoint:CGPointZero];
                //从上下文中获得裁切好的图片
                UIImage *circularImage =UIGraphicsGetImageFromCurrentImageContext();
                //关闭图片上下文
                UIGraphicsEndImageContext();
                //显示
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.icon.image = circularImage;
                });
            });
            
        }];
    }

    [self addBubbleViewModel:_cellFrame];
    [self.retryButton setHidden:[self retryButtonHidden]];

    // 是否显示阅后即焚图标
    if (cellFrame.chartMessage.flag) { // 是阅后即焚消息
        //4.cell监听时间
        //[[LYTSDK sharedSDK].conversationManager addDelegate:_cellFrame];

        //NSInteger curentTime  =  [[LYTSDK sharedSDK].conversationManager chatTableQuaryDelayTimeForMessage:self.cellFrame.chartMessage];
        if (cellFrame.chartMessage.status) { // 已读
            self.burndelayTimeButton.hidden = NO;
            self.burnMsgImageIcon.hidden = YES;
            // 是否是自己发的
            self.burnMarkView.hidden = YES;
//            NSString *time;
//            if (curentTime) {
//                time = [NSString stringWithFormat:@"%zd",curentTime];
//
//            } else {
//                time = @"";
//
//            }

//            [self.burndelayTimeButton setTitle:time forState:UIControlStateNormal];

        } else {  // 未读
            self.burndelayTimeButton.hidden = YES;
            self.burnMsgImageIcon.hidden = NO;
            // 是否是自己发的
            if (cellFrame.chartMessage.isSender || cellFrame.chartMessage.sessionType != LYTSessionTypeP2P) {
                self.burnMarkView.hidden = YES;
            } else {
                self.burnMarkView.hidden = NO;
            }
        }
    } else { // 不是阅后即焚消息
        //4.移除cell监听时间
        //[[LYTSDK sharedSDK].conversationManager deleteDelegate:self];

        self.burnMarkView.hidden = YES;
        self.burndelayTimeButton.hidden = YES;
        self.burnMsgImageIcon.hidden = YES;
    }
    [self refreshData];
}

- (void)addBubbleViewModel:(LYTChatMessageCellFrame *)cellFrame {
    LYTMessageType bodyType = cellFrame.chartMessage.messageBody.bodyType;
    
    if (_bubbleView == nil) {
        switch (bodyType) {
            
            case LYTMessageTypeText: {
                _bubbleView = [[LYTChatTextContentView alloc] initWithFrame:CGRectZero];
                [self.contentView addSubview:_bubbleView];
            } break;
                
            case LYTMessageTypeImage: {
                _bubbleView = [[LYTChatImageContentView alloc] initWithFrame:CGRectZero];
                [self.contentView addSubview:_bubbleView];
            } break;
                
            case LYTMessageTypeVoice: {
                _bubbleView = [[LYTChatVoiceContentView alloc] initWithFrame:CGRectZero];
                [self.contentView addSubview:_bubbleView];
            } break;
                
            case LYTMessageTypeFile: {
                _bubbleView = [[LYTChatFileContentView alloc] initWithFrame:CGRectZero];
                [self.contentView addSubview:_bubbleView];
            } break;
                
            default: {
                //NSAssert(NO, @"未知的消息类型");
            } break;
        }

    }
    
    _bubbleView.cellFrame = cellFrame;
    _bubbleView.delegate = self;
    _bubbleView.frame = cellFrame.bubbleViewFrame;
    [_bubbleView setupData];
    
    // 蒙版Frame
    self.burnMarkView.frame = cellFrame.bubbleViewFrame;
}

/** 重发按钮 */
- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_retryButton setImage:[UIImage lyt_chatImageNamed:@"error_detail.png"] forState:UIControlStateNormal];
        [_retryButton setImage:[UIImage imageFromFileSelectorBunldeWithNamed:@"error_detail.png"] forState:UIControlStateNormal];
        
//        [_retryButton setImage:[UIImage imageNamed:@"error_detail.png"] forState:UIControlStateHighlighted];
        
        [_retryButton setImage:[UIImage imageFromFileSelectorBunldeWithNamed:@"error_detail.png"] forState:UIControlStateHighlighted];
        
        [_retryButton setFrame:CGRectMake(0, 0, 25, 25)];
        [_retryButton addTarget:self action:@selector(onRetryMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_retryButton];
        
        _retryButton.hidden = YES;
    }
    return _retryButton;
}

/** 阅后即焚蒙版 */
- (UIView *)burnMarkView {
    if (!_burnMarkView) {
        _burnMarkView = [[UIView alloc] init];
        UILabel *showContenAlertView = [[UILabel alloc] init];
        showContenAlertView.text = @"点击查看";
        showContenAlertView.font = [UIFont systemFontOfSize:15];
        showContenAlertView.textColor = [UIColor redColor];
        [showContenAlertView sizeToFit];
        showContenAlertView.y = 10;
        showContenAlertView.x = 10;
        [_burnMarkView addSubview:showContenAlertView];
        _burnMarkView.backgroundColor = colore0eGrey;
        [_burnMarkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBurnMarkShowContent)]];
        [self.contentView addSubview:_burnMarkView];
    }
    return _burnMarkView;
}

/** 阅后即焚标识 */
- (UIImageView *)burnMsgImageIcon {
//    if (!_burnMsgImageIcon) {
//        _burnMsgImageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"burn_icon"]];
//        [_burnMsgImageIcon setFrame:CGRectMake(0, 0, 20, 20)];
//        [self.contentView addSubview:_burnMsgImageIcon];
//        _burnMsgImageIcon.hidden = YES;
//    }
    return _burnMsgImageIcon;
}

/** 倒计时 */
- (UIButton *)burndelayTimeButton {
//    if(!_burndelayTimeButton){
//
//        _burndelayTimeButton = [[UIButton alloc] init];
//        [_burndelayTimeButton setFrame:CGRectMake(0, 0, 20, 20)];
//        _burndelayTimeButton.backgroundColor = [UIColor redColor];
//        [_burndelayTimeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _burndelayTimeButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        _burndelayTimeButton.enabled = NO;
//        _burndelayTimeButton.layer.cornerRadius = 10;
//        _burndelayTimeButton.layer.masksToBounds = YES;
//        [self.contentView addSubview:_burndelayTimeButton];
//
//    }
    return _burndelayTimeButton;
}

/** 发送状态 */
- (UIActivityIndicatorView *)traningActivityIndicator {
    if (!_traningActivityIndicator) {
        
        _traningActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
        _traningActivityIndicator.color = color969Grey;
        
        [self.contentView addSubview:_traningActivityIndicator];
        _traningActivityIndicator.hidden = YES;
    }
    return _traningActivityIndicator;
}

/** 刷新 */
- (void)refreshData {
    if ([self checkData]) {
        [self.retryButton setHidden:[self retryButtonHidden]];
        
        if ([self activityIndicatorHidden]) {
            [self.traningActivityIndicator stopAnimating];
        } else {
            [self.traningActivityIndicator startAnimating];
        }
        
        [_traningActivityIndicator setHidden:[self activityIndicatorHidden]];
        [self setNeedsLayout];
    }
}

/**是否隐藏**/
- (BOOL)activityIndicatorHidden {
    if (self.cellFrame.chartMessage.sendStatus == LYTMessageStateSuccess ||
        self.cellFrame.chartMessage.sendStatus == LYTMessageStateFail ||
        !self.cellFrame.chartMessage.isSender){
        return YES;
        
    } else {
        return NO;
    }
}

- (BOOL)retryButtonHidden {
    if (self.cellFrame.chartMessage.sendStatus == LYTMessageStateFail) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutRetryButton];
    [self layoutActivityIndicator];
    [self layoutBurnMsgImageIcon];
}

- (CGFloat)retryButtonBubblePadding {
    BOOL isFromMe = self.cellFrame.chartMessage.isSender;
    
    if (self.cellFrame.chartMessage.messageType == LYTMessageTypeVoice) {
        return isFromMe ? 15 : 13;
    }
    
    return isFromMe ? 8 : 10;
}

- (void)layoutRetryButton {
    
    if (!self.retryButton.isHidden) {
        
        CGFloat centerX = 0;
        
        if (self.cellFrame.chartMessage.isSender) {
            
            centerX = CGRectGetMinX(_bubbleView.frame) - [self retryButtonBubblePadding] - CGRectGetWidth(_retryButton.bounds) * 0.5;
        }
        
        _retryButton.center = CGPointMake(centerX, _bubbleView.center.y);
    }
}

- (void)layoutActivityIndicator {
    
    if (self.traningActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        centerX = CGRectGetMinX(_bubbleView.frame) - [self retryButtonBubblePadding] - CGRectGetWidth(_traningActivityIndicator.bounds) * 0.5;
        self.traningActivityIndicator.center = CGPointMake(centerX,_bubbleView.center.y);
    }
    
}

- (BOOL)checkData {
    return [self.cellFrame isKindOfClass:[LYTChatMessageCellFrame class]];
}

/** 布局阅后即焚图标 */
- (void)layoutBurnMsgImageIcon {
    if (!self.burnMsgImageIcon.isHidden) {
        CGFloat burnX = 0;
        CGFloat burnY = 0;
        if (self.cellFrame.chartMessage.isSender) { // YES 是自己发的，NO是别人发的
            
            burnX = CGRectGetMinX(_bubbleView.frame) - 10;
            burnY = CGRectGetMinY(_bubbleView.frame);
            
        } else {
            
            burnX = CGRectGetMaxX(_bubbleView.frame) - 10;
            burnY = CGRectGetMinY(_bubbleView.frame);
            
        }
        
        _burnMsgImageIcon.x = burnX;
        _burnMsgImageIcon.y = burnY;
    }
    
    // 倒数计数
    if (!self.cellFrame.chartMessage.isSender) {
        
        self.burndelayTimeButton.x = CGRectGetMaxX(_bubbleView.frame) - 10;
        _burndelayTimeButton.y = CGRectGetMinY(_bubbleView.frame);
        
    } else {
        
        self.burndelayTimeButton.hidden = YES;
        
    }
}

#pragma mark - LYTChatMessageContentViewDelegate
// 点击蒙版查看消息
- (void)clickBurnMarkShowContent {
    
    if ([self.delegate respondsToSelector:@selector(messageCell:clickBurnMark:content:)]) {
        
        [self.delegate messageCell:self clickBurnMark:self.burnMarkView content:self.cellFrame];
        
    }
}

// 点击内容
-(void)chatCellTapPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel {
    
    if ([self.delegate respondsToSelector:@selector(messageCell:chatCellTapPress:content:)]) {
        
        [self.delegate messageCell:self chatCellTapPress:contentView content:frameModel];
        
    }
}

// 长按内容
-(void)chartCellLongPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel {
    [self becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(messageCell:chartCellLongPress:content:)]) {
        
        [self.delegate messageCell:self chartCellLongPress:contentView content:frameModel];
        
    }
}

// 复制
- (void)copy:(id)sender {
    if ([self.delegate respondsToSelector:@selector(messageCellCopy:)]) {
        
        [self.delegate messageCellCopy:self];
        
    }
}

// 删除
- (void)delete:(id)sender {
    if ([self.delegate respondsToSelector:@selector(messageCellDelete:)]) {
        
        [self.delegate messageCellDelete:self];
        
    }
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(copy:)) {
        
        return YES;
        
    } else if (action == @selector(delete:)) {
        
        return YES;
    }
    
    return NO;
}

/** 重发按钮点击 */
- (void)onRetryMessage {
    if ([self.delegate respondsToSelector:@selector(messageCell:onRetryContent:)]) {
        
        [self.delegate messageCell:self onRetryContent:self.cellFrame];
        [self refreshData];
        
    }
}

#pragma mark - 
+ (instancetype)cellInTable:(UITableView*)tableView forMessageMode:(LYTChatMessageCellFrame *)model {
   
    NSString *reusedId  = [self reuseIDWithMessageType:model.chartMessage.messageType];
    
    LYTChatMessageCell *cell = (LYTChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:reusedId];
    
    if (cell == nil) {
        cell = (LYTChatMessageCell *) [[LYTChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.cellFrame = model;
    
    return cell;
}

+ (NSString *)reuseIDWithMessageType:(LYTMessageType)type {
    static NSDictionary *reusedIdMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reusedIdMap = @{
                        @(LYTMessageTypeText)       : @"LYTMessageTypeText_REUSE",
                        @(LYTMessageTypeImage)      : @"LYTMessageTypeImage_REUSE",
                        @(LYTMessageTypeVoice)      : @"LYTMessageTypeVoice_REUSE",
                        //@(LYTMessageTypeTipMsg)     : @"LYTMessageTypeTipMsg_REUSE",
                        @(LYTMessageTypeFile)       : @"LYTMessageTypeFile_REUSE" ,
                      };
    });
    
    return reusedIdMap[@(type)] ?: [NSString stringWithFormat:@"unknown message type <%zd>",type];
}

@end
