//
//  LYTChatImageView.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatImageView.h"

#import "LYTCommonHeader.h"
#import "UIImage+BundleImage.h"
#import "LYTMessage.h"

@interface LYTChatImageView()

@end
@implementation LYTChatImageView
- (UIImageView *)imageContainer
{
    if (!_imageContainer) {
        _imageContainer = [[UIImageView alloc] init];
        _imageContainer.contentMode = UIViewContentModeScaleAspectFill;
        _imageContainer.clipsToBounds = YES;
        _imageContainer.backgroundColor = [UIColor whiteColor]   ;
        _imageContainer.userInteractionEnabled = YES;
//        _imageContainer.layer.masksToBounds = YES;
//        _imageContainer.layer.cornerRadius = 10;
    }
    return _imageContainer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        [self addSubview:self.imageContainer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    UIEdgeInsets insets = (_chatMessage.isSender) ? UIEdgeInsetsMake(7, 6, 7, 10) : UIEdgeInsetsMake(7, 10, 7, 6);
   
    [self.imageContainer hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.edges.hpwys_equalTo(insets);
    }];
}

- (void)setChatMessage:(LYTMessage *)chatMessage
{
    _chatMessage = chatMessage;
    LYTImageMessageBody *imageMessageBody = (LYTImageMessageBody *)chatMessage.messageBody;
    
    //cell循环利用的时候-->要重新布局
    UIEdgeInsets insets = (_chatMessage.isSender) ? UIEdgeInsetsMake(7, 6, 7, 10) : UIEdgeInsetsMake(7, 10, 7, 6);
    
    [self.imageContainer hpwys_remakeConstraints:^(HPWYSConstraintMaker *make) {
        make.edges.hpwys_equalTo(insets);
    }];
    
    
    // 1、有本地图片
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:imageMessageBody.localPath];
    if (savedImage) {
        self.imageContainer.image = savedImage;
        return;
    }
    // 2、没有本地图片或者本地图片找不到 网络获取
    UIImage *placeholder = [UIImage lyt_chatImageNamed:@"placeholder_icon"];
    NSURL *url = [NSURL URLWithString:imageMessageBody.fileUrl];
    // 加载图片
    [self.imageContainer hpwys_setImageWithURL:url placeholderImage:placeholder];
    
    
}
@end
