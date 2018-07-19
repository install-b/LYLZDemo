//
//  LYTLZChatViewController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/4.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYTLZChatViewController.h"
#import "LYTChatViewController+PrivateAPI.h"
#import "LYLZInputToolBar.h"
#import "LYLZSendRedpackageVc.h"
#import "LZSystemMessageTableViewCell.h"
#import "LYLZChatManager+Private.h"
#import "LYTMessageTipView.h"
#import "NSObject+SGExtention.h"
#import "LYAsset.h"
#import "LYTFileImageSelectorNav.h"

@interface LYTLZChatViewController ()
<
LYAssetGridViewControllerDelegate,
LYFileSelectVcDelegate,
LYTMessageTipViewDelegate,
LYTChatMessageOrderCellDelegate
>

/** 聊天身份 */
@property(nonatomic,assign) LYLZChatIdentity chatIdentity;

/** 新消息提示 */
@property (nonatomic,weak) LYTMessageTipView * tipView;


@end

@implementation LYTLZChatViewController

- (instancetype)initWithTargetId:(NSString *)targetId chatIdentity:(LYLZChatIdentity)chatIdentity {
    if (self = [super initWithTargetId:targetId sessionType:LYTChatTypeP2P]) {
        
        _chatIdentity = chatIdentity;
    }
    return self;
}

- (NSArray *)moreItemArray {
    if (_chatIdentity == LYLZChatIdentityLawyer) {
        return  @[
                  @{
                      @"image" : @"图片-1",
                      @"title" : @" 图 片",
                      @"selector" : @"sendImageMessage"
                    },
                  @{
                      @"image" : @"文件-1",
                      @"title" : @" 文 件" ,
                      @"selector" : @"sendFileMessage"
                      },
                  ] ;
    } else {
        return @[
                 @{
                     @"image" : @"图片-1",
                     @"title" : @" 图 片" ,
                     @"selector" : @"sendImageMessage"
                     },
                 @{
                     @"image" : @"文件-1",
                     @"title" : @" 文 件" ,
                     @"selector" : @"sendFileMessage"
                     },
                 @{
                     @"image" : @"红包" ,
                     @"title" : @"发送红包" ,
                     @"selector" : @"sendPacketMessage"
                     },
                 
                 
                 ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tipView];
}

- (void)viewWillAppear:(BOOL)animated {
    //检查是否需要弹框(只有客服端需要弹框)
    if (![LYLZChatManager shareManager].isShowCMTandInterMessage) {
        [self presentMyMessageView];
    }
}

- (void)presentMyMessageView {
//    [_sharedSDK.chatListManager fetchSessionStatusById:self.targetId complete:^(LYTSDKSessionStatus status, LYTError *error) {
//        if (error) {
//            return ;
//        }
//        // 传送状态
//        [self didFetchSessionStatus:(LYLZChatSessionStatus)status];
//    }];
}

// 子类实现
- (void)didFetchSessionStatus:(LYLZChatSessionStatus)statu {
}


- (LYInputToolBar *)createToolBar {
    // 键盘
    LYInputToolBar *toolBar = [[LYLZInputToolBar alloc] init];
    toolBar.delegate = self;
    toolBar.AddButtonArray = self.moreItems;
    
    return toolBar;
}

- (void)setInputEnable:(BOOL)inputEnable {
    [(LYLZInputToolBar *)self.toolBar setInputEnable:inputEnable];
}

- (BOOL)isInputEnable {
    return [(LYLZInputToolBar *)self.toolBar isInputEnable];
}




#pragma mark - chatMangerDelegate
- (void)didReceiveOfflineMessages:(NSArray<LYTMessage *> *)messages {
    // 拦截聊天
    if (messages.count && ![messages.lastObject.sendUserId isEqualToString:self.targetId]) {
        return [self showOtherMessageInTopWithMessage:messages.lastObject];
    }
    
    [messages enumerateObjectsUsingBlock:^(LYTMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (message.messageType < 3900 && message.sendUserName.length == 0) {
            if ([message.sendUserId isEqualToString:[LYLZChatManager shareManager].currentUserId] &&
                (message.messageType == LYLZMessageTypeOrder ||
                 message.messageType == LYLZMessageTypeRePacket)) {
                    return ;
                }
            id <LYTUserBaseInfoProtocol> userInfo = [[LYLZChatManager shareManager] userInfoWithUserId:message.sendUserId];
            if (userInfo) {
                message.sendUserName = userInfo.userName;
                message.sendUserHeadUrl = userInfo.picture;
            }
        }
    }];
    // 从代理中获取
    return [super didReceiveOfflineMessages:messages];
}

- (void)didReceiveAMessage:(LYTMessage *)message {
    if ([message.sendUserId isEqualToString:[LYLZChatManager shareManager].currentUserId] &&
        (message.messageType == LYLZMessageTypeOrder ||
         message.messageType == LYLZMessageTypeRePacket)) {
            return ;
        }
    
    if (![message.sendUserId isEqualToString:self.targetId]) {
        // 横幅展示
        return [self showOtherMessageInTopWithMessage:message];
    }
     // 从代理中获取头像
    if (message.messageType < 3900 && message.sendUserHeadUrl.length == 0) {
        id <LYTUserBaseInfoProtocol> userInfo = [[LYLZChatManager shareManager] userInfoWithUserId:message.sendUserId];
        if (userInfo) {
            message.sendUserName = userInfo.userName;
            message.sendUserHeadUrl = userInfo.picture;
        }
    }
    
    //收到律师端结束会话(弹框)
    if (message.messageType == LYTMessageTypePush ) {
        //判断是否在当前控制器
        if ([self.targetId isEqualToString:message.targetId] || [message.targetId isEqualToString:[LYLZChatManager shareManager].currentUserId]) {
            // 用户端
            if (![LYLZChatManager shareManager].isShowCMTandInterMessage) {
                [self didFetchSessionStatus:LYLZChatSessionStatus_Sponsor_Ending];
            }
        }
        return;
    }
    // 父类实现(会判断是否在当前控制器,插入数据)
    
    return [super didReceiveAMessage:message];
}

- (void)showOtherMessageInTopWithMessage:(LYTMessage *)message {
    if (message.sendUserName.length == 0) {
        id <LYTUserBaseInfoProtocol> userInfo = [[LYLZChatManager shareManager] userInfoWithUserId:message.sendUserId];
        if (userInfo) {
            message.sendUserName = userInfo.userName;
            message.sendUserHeadUrl = userInfo.picture;
        }
    }
    [self.tipView showWithMessage:message];
}

#pragma mark - over write 重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageFrame:(LYTChatMessageCellFrame *)frame {
    if ( [frame.chartMessage messageType] > 3900) {
        LZSystemMessageTableViewCell *cell = [LZSystemMessageTableViewCell cellInTable:tableView forMessageMode:[frame messageBody]];
        cell.delegate = self;
        return cell;
    }
    return [super tableView:tableView cellForMessageFrame:frame];
}


- (void)setShowTimeDownView:(BOOL)showTimeDownView {
    _showTimeDownView = showTimeDownView;
    
    if (showTimeDownView && [self heightForTimeDownView] > 0) {
        UIView *view = [self contentViewForTimeDownView];
        
        if ([view isKindOfClass:[UIView class]]) {
            [self.inputTopView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
        }
        [self.inputTopView addSubview:view];
    } else {
        [self.inputTopView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    [self layoutInputViewWithToolBarHeight:self.toolBar.height keyboardHeight:self.keyBoardHeight];
}

- (CGFloat)heightForTimeDownView {
    return 0.0f;
}

- (UIView *)contentViewForTimeDownView {
    return nil;
}
- (void)insertMessage:(LYTMessage *)message {
    if ([self shouldShowMessage:message]) {
        [super insertMessage:message];
    }
}

- (void)addMessage:(LYTMessage *)message scrollToBottom:(BOOL)isScroll {
    if ([self shouldShowMessage:message]) {
        [super addMessage:message scrollToBottom:isScroll];
    }
}

- (BOOL)shouldShowMessage:(LYTMessage *)message {
    
    if ([message.sendUserId isEqualToString:[LYLZChatManager shareManager].currentUserId] &&
        (message.messageType == LYLZMessageTypeOrder ||
         message.messageType == LYLZMessageTypeRePacket)) {
        return NO;
    }

    if (message.messageType == LYLZMessageTypeSessionBox) {
        return NO;
    }
    return message ? YES : NO;
}

#pragma mark - more item click
- (void)sendPacketMessage {
    
    LYLZSendRedpackageVc *redpackageVc = [[LYLZSendRedpackageVc alloc] init];
    redpackageVc.lawler = self.targetId;
    
    if (self.navigationController) {
        [self.navigationController pushViewController:redpackageVc animated:YES];
    }else {
        [self presentViewController:redpackageVc animated:YES completion:nil];
    }
    
}

// 发送图片
- (void)sendImageMessage {
    [LYAssetGridViewController showIamgeSelectorWithNavClass:[LYTFileImageSelectorNav class] Delegate:self];
    
}

- (void)sendFileMessage {
    // 发送文件
    NSString * logPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/COM.HHLY.LYTSDK/fileCaches"];
    // 打开文件选择器
    LYFileManagerVC * fileVc = [[LYFileManagerVC alloc] initWithHomeFilePath:logPath];
    fileVc.fileSelectVcDelegate = self;
    
    LYTFileImageSelectorNav *nav = [[LYTFileImageSelectorNav alloc] initWithRootViewController:fileVc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LYAssetGridViewControllerDelegate 图片选择控制器代理
// 点击发送按钮
- (void)assetGridViewController:(LYAssetGridViewController *)assetGridViewController didSenderImages:(NSMutableArray *)imageArray {
    
    for (LYAsset *asset in imageArray) {
        
        PHAsset *phAsset = asset.asset;
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",phAsset.localIdentifier];
        NSString *cachesPath = [NSString iamgeCachesPathWithImageName:fileName];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        LYWeakSelf
        [[PHImageManager defaultManager] requestImageDataForAsset:phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            NSData *tumbnailImageData = nil;
            if (asset.dataLength > 1024 * 1024 * 0.1) {
                UIImage *image = [UIImage imageWithData:imageData];
                image = [image compressImageWithTargetWidth:1000];
                NSData *tumbnailImageData = [imageData compressImage:image toMaxFileSize:1024 *1024 *0.1];
                
                [tumbnailImageData writeToFile:cachesPath atomically:YES];
            } else {
                tumbnailImageData = imageData;
                [tumbnailImageData writeToFile:cachesPath atomically:YES];
            }
            
            // 发送图片
            // 开始上传发送
            // 构造一个图片消息
            LYTImageMessageBody *imageBody = [[LYTImageMessageBody alloc] initWithFilePath:cachesPath displayName:@"image"];
            
            LYTMessage *message = [[LYTMessage alloc] initWithMessageBody:imageBody sessionType:(LYTSessionType)self.chatType targetId:self.targetId];
            if(DestructMessageMode){
                message.flag = 1;
            }
            [weakSelf sendMessageWithMessage:message];
        }];
    }
}

// 点击关闭按钮
- (void)assetGridViewControllerdidCancel:(LYAssetGridViewController *)assetGridViewController {
    
}

#pragma mark -  LYTChatMessageOrderCellDelegate
- (void)chatMessageOrderCell:(LZChatMessageOrderCell *)orderCell didClickJumpWithInfo:(id)jumpInfo {
    [self didClickJumpWithInfo:jumpInfo];
}
// 点击了跳转
- (void)didClickJumpWithInfo:(id)jumpInfo {
    
}

#pragma mark - LYTMessageTipViewDelegate
- (void)messageTipView:(LYTMessageTipView *)tipView didSelectMessage:(NSString *)message {

}

#pragma mark - LYFileSelectVcDelegate
- (void)fileViewControler:(LYFileManagerVC *)fileVC Selected:(NSArray <LYFileObjModel *> *)fileModels {
    
    //[self.navigationController popViewControllerAnimated:YES];
    [fileVC dismissViewControllerAnimated:YES completion:nil];
    
    [fileModels enumerateObjectsUsingBlock:^(LYFileObjModel * _Nonnull fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LYTFileMessageBody *fileBody = [[LYTFileMessageBody alloc] initWithFilePath:fileModel.filePath displayName:fileModel.name];
        LYTMessage *fileMessage = [[LYTMessage alloc] initWithMessageBody:fileBody];
        
        fileMessage.sessionType = (LYTSessionType)self.chatType;
        fileMessage.targetId = self.targetId;
        
        [self sendMessageWithMessage:fileMessage];
    }];
}

- (LYTMessageTipView *)tipView {
    if (!_tipView) {
        LYTMessageTipView *tipView = [[LYTMessageTipView alloc] initWithFrame:CGRectMake(0, - 36, LYScreenW, 36)];
        _tipView = tipView;
        _tipView.delegate = self;
        [self.view addSubview:tipView];
    }
    return _tipView;;
}
@end
