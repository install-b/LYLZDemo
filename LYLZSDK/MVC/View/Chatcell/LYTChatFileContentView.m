//
//  LYTChatFileContentView.m
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/16.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatFileContentView.h"
#import "UIColor+LYColor.h"
#import "HPWYsonry.h"
#import "UIImage+Bundle.h"

@interface LYTChatFileContentView ()
/** 图标 */
@property (nonatomic,weak) UIImageView * fileIcon;
/** 标题 */
@property (nonatomic,weak) UILabel * fileTileLabel;
/** 文件大小 */
@property (nonatomic,weak) UILabel * fileSizeLabel;
/** 发送下载状态 */
@property (nonatomic,weak) UILabel * fileStateLabel;
@end

@implementation LYTChatFileContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSetUps];
    }
    return self;
}
- (void)initSetUps {
    // 构造子控件
    UIImageView *fileIcon = [[UIImageView alloc] init];
    UILabel *fileTileLable = [[UILabel alloc] init];
    UILabel *fileSizeLable = [[UILabel alloc] init];
    UILabel *fileSendStateLabe = [[UILabel alloc] init];
    
    // 设置属性
    fileTileLable.textColor = [UIColor getColor:@"999999"];
    fileTileLable.font = [UIFont systemFontOfSize:16];
    
    fileSizeLable.textColor = [UIColor getColor:@"333333"];
    fileSizeLable.font = [UIFont systemFontOfSize:14];
    
    fileSendStateLabe.textColor = [UIColor getColor:@"333333"];
    fileSendStateLabe.font = [UIFont systemFontOfSize:14];
    
    
    // 添加子控件
    _fileIcon = fileIcon;
    [self addSubview:fileIcon];
    _fileTileLabel = fileTileLable;
    [self addSubview:fileTileLable];
    _fileSizeLabel = fileSizeLable;
    [self addSubview:fileSizeLable];
    _fileStateLabel = fileSendStateLabe;
    [self addSubview:fileSendStateLabe];
    
    
    // 布局子控件
    CGFloat iconWidth = 48.0f;
    CGFloat insetSpace = 15.0f;
    CGFloat margin = 10.0f;
    [fileIcon hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self).offset(insetSpace);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(iconWidth));
    }];
    
    [fileTileLable hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(fileIcon);
        make.left.equalTo(fileIcon.hpwys_right).offset(margin);
        make.right.equalTo(self).offset(-insetSpace);
    }];
    
    [fileSizeLable hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.bottom.equalTo(fileIcon);
        make.left.equalTo(fileIcon.hpwys_right).offset(margin);
    }];
    
    [fileSendStateLabe hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
         make.bottom.equalTo(fileIcon);
         make.right.equalTo(self).offset(-insetSpace);
    }];
}
- (void)setupData {
    LYTFileMessageBody *fileBody = (LYTFileMessageBody *)self.cellFrame.chartMessage.messageBody;
    
    
    if (self.cellFrame.chartMessage.isSender) {
        if (fileBody.fileUrl) {
            self.fileIcon.image = [UIImage imageWithFileURLString:fileBody.fileUrl];
        } else {
            self.fileIcon.image = [UIImage imageWithFileURLString:fileBody.localPath];
        }
        
    } else {
        
        self.fileIcon.image = [UIImage imageWithFileURLString:fileBody.fileUrl];
    }
   self.fileTileLabel.text = fileBody.fileName ? : fileBody.fileUrl;
}

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if ( tapGestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    

    if([self.delegate respondsToSelector:@selector(chatCellTapPress:content:)]){
        [self.delegate chatCellTapPress:self content:self.cellFrame];
    }
    
    
}
@end
