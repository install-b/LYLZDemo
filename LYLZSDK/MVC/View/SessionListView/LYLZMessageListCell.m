//
//  LYLZMessageListCell.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/7.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZMessageListCell.h"
#import "LYTSDK.h"
#import "UIImage+BundleImage.h"
#import "LYLZChatManager+Private.h"
#import "NSObject+SGExtention.h"
#import "LYLZmessageBody.h"
#import "UIImageView+HPWYSWebCache.h"

typedef void(^LYTCommetBlock)(void);

@implementation LYLZMessageListCell

//annotation by ys 2017.11.06
//- (void)setOutsideSessionListModel:(LYTMessageList *)outsideSessionListModel {
//    [super setOutsideSessionListModel:outsideSessionListModel];
//    if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
        /*
         @{@"" : @"{@"num" : 0,@"title" : @"13232"}"}
         */
//        LYTCommetBlock block = ^{
//            id temp = [outsideSessionListModel.lastMessage.content sg_JSONDictionary][@"content"];
//            id temp1 = [temp sg_JSONDictionary];
//            if (temp1) {
//                self.contentLabel.text = temp1[@"content"];
//            } else {
//                self.contentLabel.text = nil;
//            }
//            [self setUnreadCount:[temp1[@"num"] integerValue]];
//        };
//
//        if ([outsideSessionListModel.targetId isEqualToString:[LYLZChatManager shareManager].interactiveNotiId]) { //互动消息
//            [self.headerImageView hpwys_setImageWithURL:nil placeholderImage:[UIImage lyt_chatImageNamed:@"互动消息"]];
//            self.nameLabel.text = @"互动消息";
//            // 设置未读数
//            block();
//        }else if ([outsideSessionListModel.targetId isEqualToString:[LYLZChatManager shareManager].commentNotiId]) { //评论消息
//            [self.headerImageView hpwys_setImageWithURL:nil placeholderImage:[UIImage lyt_chatImageNamed:@"评论消息"]];
//            self.nameLabel.text = @"评论消息";
//            // 设置未读数
//            block();
//        }
//    }
//
//    if ([outsideSessionListModel.targetId isEqualToString:[LYLZChatManager shareManager].systemNotiId]) { //系统消息
//       [self.headerImageView hpwys_setImageWithURL:nil placeholderImage:[UIImage lyt_chatImageNamed:@"系统消息"]];
//        self.nameLabel.text = @"系统消息";
//        self.contentLabel.text = [outsideSessionListModel.lastMessage.content sg_JSONDictionary][@"content"];
//
//    } else if (outsideSessionListModel.lastMessage.messageType == LYLZmessageBodyTypeOrder ||
//              outsideSessionListModel.lastMessage.messageType == LYLZmessageBodyTypeRedPacket) {
//        //聊天消息
//        id temp = [outsideSessionListModel.lastMessage.content sg_JSONDictionary];
//        if (temp) {
//            self.contentLabel.text = [outsideSessionListModel.lastMessage.content sg_JSONDictionary][@"bodyMsg"];
//        } else {
//            self.contentLabel.text = nil;
//        }
//
//    }
//}
@end
