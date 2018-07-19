//
//  LYTLZBaseChatViewController.m
//  LZSDKDemo
//
//  Created by hhly on 2017/8/30.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "HistoryChatListViewController.h"
#import "UIColor+LYColor.h"
#import "LYTimeBannerModel.h"
#import "LYSessionTimeBannerCell.h"
#import "LYTChatMessageCellFrame.h"
#import "LYTChatMessageCell.h"
#import "LYCOMRefresh.h"
#import "LYTChatImageContentView.h"
#import "LYTChatVoiceContentView.h"
#import "LYTChatFileContentView.h"
#import "LYFileObjModel.h"
#import "LYFlieLookUpVC.h"
#import "LYAudioPlayerHelper.h"
#import "LYPhotoBrowseView.h"
#import "HPWYSProgressHUD.h"
#import "LYLZSDK.h"
#import "LYPhotoBrowseView.h"
#import "LYLZChatManager+Private.h"
#import "LZSystemMessageTableViewCell.h"
#import "LYTMessageBody+LYPhotoBrowsePotoProtocol.h"

@interface HistoryChatListViewController ()<UITableViewDelegate, UITableViewDataSource,LYTChatMessageCellDelegate>

@property (nonatomic, weak) id LYTLZHistoryChatListViewDelegate;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic,strong) LYTChatMessageContentView *tempContentView;

/** 选择点击的是哪一行 */
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation HistoryChatListViewController
- (instancetype)init {
    if (self = [super init]) {
        self.headMargin = 0.f;
        self.bottomMargin = 0.f;
    }
    return self;
}

- (void)setChartCount:(NSInteger)chartCount {
    if (chartCount <= 0) {
        _chartCount = 20;
    } else {
        _chartCount = chartCount;
    }


    if (_chartCount >= 100) {
        _chartCount = 100;
    }

}

- (void)setFromIndex:(NSInteger)fromIndex {
    if (fromIndex < 1) {
        _fromIndex = 1;
    } else {
        _fromIndex = fromIndex;
    }
}


/** 消息模型 */
- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMySubviews];
    
    [self loadMoreData];
}

- (void)addMySubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.listViewY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.listViewY - self.bottomMargin) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.allowsSelection = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = BackGroundColor;
    tableView.tableHeaderView = self.headView;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    tableView.footer = [LYCOMRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 加载更多历史消息
- (void)loadMoreData {
    if ([self.userId isKindOfClass:[NSString class]] &&
        self.userId.length &&
        [self.lawyerId isKindOfClass: [NSString class]] &&
        self.lawyerId.length) {


        [_instanceSDK.conversationManager fetchHistoryMsgWithSessionId:self.sessionId fromIndex:self.fromIndex count:self.chartCount complete:^(NSArray<LYTMessage *> *mesages, LYTError *error) {
            if (error) {
                NSLog(@"从本地数据库中获取数据");
                //annotation by ys 2017.11.05 由UI层自己维护
        //        [self getDataFromLocalWithModel:sessionModel];
                return ;
            }

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //annotation by ys 2017.11.05 由UI层自己维护
//                [_instanceSDK.conversationManager addHistoryMessageToLocalDB:messageList sessionModel:sessionModel complete:^(LYTError *error) {
//                    if (error) {
//                        NSLog(@"保存历史消息到本地数据库中时 失败。");
//                    }
//                }];


                self.fromIndex += self.chartCount;
                for (LYTMessage *message in mesages) {
                    // add by zhangsg 2017.10.11 过滤红包消息和订单消息
                    if ([self shouldHiddenMessage:message]) {
                        continue;
                    }

                    //默认 律师在左边，客户在右边  hjl
                    if ([message.sendUserId isEqualToString:self.userId]) {
                        message.isSender = YES;
                    } else {
                        message.isSender = NO;
                    }
                    [self.messageArray addObject:[[LYTChatMessageCellFrame alloc] initWithChartModel:message]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //数据是否获取完
                    if (mesages.count < self.chartCount) {
                        self.tableView.footer.state = LYCOMRefreshStateNoMoreData;
                    } else {
                        [self.tableView.footer endRefreshing];

                    }
                    [self.tableView reloadData];

                });
            });
        }];


    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.messageArray removeAllObjects];
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 从本地获取数据
//annotation by ys 2017.11.06
//- (void)getDataFromLocalWithModel:(LYTCreateSessionModel *)model {
//
//
//    if ([self.userId isKindOfClass:[NSString class]] &&
//        self.userId.length &&
//        [self.lawyerId isKindOfClass: [NSString class]] &&
//        self.lawyerId.length) {
//
//
//        //查库
//
//        [_instanceSDK.conversationManager fetchHistoryMsgFromDBWithModel:model fromIndex:self.fromIndex count:self.chartCount complete:^(NSArray<LYTMessage *> *messageList, LYTError *error) {
//            if (messageList.count == 0) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [HPWYSProgressHUD showErrorWithStatus:@"网络错误"];
//                });
//                [self.tableView.footer endRefreshing];
//            } else {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    self.fromIndex += self.chartCount;
//                    for (LYTMessage *message in messageList) {
//                        // add by zhangsg 2017.10.11  过滤红包消息和订单消息
//                        if ([self shouldHiddenMessage:message]) {
//                            continue;
//                        }
//
//                        //默认 律师在左边，客户在右边  hjl
//                        if ([message.sendUserId isEqualToString:self.userId]) {
//                            message.isSender = YES;
//                        } else {
//                            message.isSender = NO;
//                        }
//
//                        [self.messageArray addObject:[[LYTChatMessageCellFrame alloc] initWithChartModel:message]];
//                    }
//
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.tableView.footer endRefreshing];
//                        [self.tableView reloadData];
//                    });
//                });
//            }
//        }];
//    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.messageArray removeAllObjects];
//            [self.tableView.footer endRefreshing];
//            [self.tableView reloadData];
//        });
//    }
//}

- (BOOL)shouldHiddenMessage:(LYTMessage *)message {
    if (message.messageType > 3900) {
        return YES;
    }
    return NO;
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 时间栅栏
    if ([self.messageArray[indexPath.row] isKindOfClass:[LYTimeBannerModel class]]) {
        LYSessionTimeBannerCell *bannerCell = [LYSessionTimeBannerCell cellWithTableView:tableView cellStyle:UITableViewCellStyleSubtitle WithIdentifier:@"timeBannerCell"];
        LYTimeBannerModel *banner = self.messageArray[indexPath.row];
        bannerCell.time = banner.timerString;
        return bannerCell;
        
    }
     // 普通消息
    else if ([self.messageArray[indexPath.row] isKindOfClass:[LYTChatMessageCellFrame class]]) {
       
        return [self tableView:tableView cellForMessageFrame:self.messageArray[indexPath.row]];
    }
    // 未知消息
    else {
        NSLog(@"未知类型的cell");
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageFrame:(LYTChatMessageCellFrame *)frame {
    // 常规消息
    UITableViewCell *cell = [LYTChatMessageCell cellInTable:tableView forMessageMode:frame];
    if([cell isKindOfClass:[LYTChatMessageCell class]]){
        LYTChatMessageCell *MessageCell = (LYTChatMessageCell *)cell;
        MessageCell.delegate = self;
    }
    return cell;
}
#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.messageArray[indexPath.row] isKindOfClass:[LYTimeBannerModel class]]){
        return 25.5;
        
    } else if ([self.messageArray[indexPath.row] isKindOfClass:[LYTChatMessageCellFrame class]]) {
        LYTChatMessageCellFrame *Messageframe = self.messageArray[indexPath.row];
        return Messageframe.cellHeight;
        
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 0;
    }
    return self.headMargin;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
#pragma mark - clicks
/** 点击cell */
-(void)messageCell:(LYTChatMessageCell *)messageCell chatCellTapPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel
{
    if ([contentView isKindOfClass:[LYTChatVoiceContentView class]]) { // 播放声音
        return [self playVoiceWithContentView:(LYTChatVoiceContentView *)contentView ContentModel:frameModel];
    } else if ([contentView isKindOfClass:[LYTChatImageContentView class]]){// 查看图片

        return [self bowserPhotoWithContentView:(LYTChatImageContentView *)contentView content:frameModel];
    } else if ([contentView isKindOfClass:[LYTChatFileContentView class]]) {
        LYTFileMessageBody *fileBody = (LYTFileMessageBody *)frameModel.chartMessage.messageBody;
        
        LYFileObjModel *fileModel = [[LYFileObjModel alloc] init];
        fileModel.fileUrl = fileBody.fileUrl;
        fileModel.filePath = fileBody.localPath;
        fileModel.name = fileBody.fileName;
        
        LYFlieLookUpVC *lookFileVc = [[LYFlieLookUpVC alloc] initWithFileModel:fileModel];
        [self.navigationController pushViewController:lookFileVc animated:YES];
    }
}


- (void)messageCellDelete:(LYTChatMessageCell *)messageCell {
    //NSLog(@"delete cell  row = %zd", self.indexPath.row);
}

// 播放语音
- (void)playVoiceWithContentView:(LYTChatVoiceContentView *)contentView ContentModel:(LYTChatMessageCellFrame *)frameModel {
    LYTChatVoiceContentView *tempcontentView = (LYTChatVoiceContentView *)_tempContentView;
    if ([tempcontentView isKindOfClass:[LYTChatVoiceContentView class]]) {
        [tempcontentView stopAnimating];
    }
    
    [_instanceSDK.conversationManager checkMessage:frameModel.chartMessage complete:nil];
    
    
    // 判断播放的语音路径
    LYTVoiceMessageBody *tempMessageBody = (LYTVoiceMessageBody *)_tempContentView.cellFrame.chartMessage.messageBody;
    LYTVoiceMessageBody *contenMessageBody = (LYTVoiceMessageBody *)contentView.cellFrame.chartMessage.messageBody;
    if ([tempMessageBody.localPath isEqualToString:contenMessageBody.localPath]){
        [[LYAudioPlayerHelper shareInstance] stopAudio];
        self.tempContentView = nil;
        
    } else {
        self.tempContentView = contentView;
        LYTChatVoiceContentView *tempcontentView = (LYTChatVoiceContentView *)self.tempContentView;
        
        [tempcontentView startAnimating];
        LYTVoiceMessageBody *playMessageBody = (LYTVoiceMessageBody *)frameModel.chartMessage.messageBody;
        CGFloat duration = playMessageBody.duration;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tempcontentView stopAnimating];
            _tempContentView = nil;
        });
        //播放音乐
        [[LYAudioPlayerHelper shareInstance] managerAudioWithFileName:playMessageBody.localPath toPlay:YES];
    }
}

- (void)bowserPhotoWithContentView:(LYTChatImageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel{
    
    NSInteger index = 0;
    NSInteger currentIndex = 0;
    NSMutableArray<LYPhotoBrowsePotoProtocol> *photos = [NSMutableArray<LYPhotoBrowsePotoProtocol> array];
    
    for (id data in self.messageArray) {
        if ([[data class] isSubclassOfClass:[LYTChatMessageCellFrame class]]){
            LYTChatMessageCellFrame *dataFrameModel = (LYTChatMessageCellFrame *)data;
            if ([[dataFrameModel.chartMessage.messageBody class] isSubclassOfClass:[LYTImageMessageBody class]]) {
                [photos addObject:dataFrameModel.chartMessage.messageBody];
               
                if (dataFrameModel == frameModel) {
                    currentIndex = index;
                }
                index++;
            }
        }
    }
    LYPhotoBrowseView *browser = [[LYPhotoBrowseView alloc] init];
    browser.message = frameModel.chartMessage.messageBody;
    browser.datasource = photos;
    browser.index = currentIndex;
    browser.frame = [UIScreen mainScreen].bounds;
    [browser showWithView:contentView.photoView.imageContainer];
}

// 长按cell
-(void)messageCell:(LYTChatMessageCell *)messageCell chartCellLongPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:messageCell];
    self.indexPath = indexpath;
    [[UIMenuController sharedMenuController] setTargetRect:contentView.bounds inView:contentView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

// 复制
- (void)messageCellCopy:(LYTChatMessageCell *)messageCell {
    
    //    NSLog(@"Copy cell  row = %zd", self.indexPath.row);
    LYTChatMessageCellFrame *copyFrame = self.messageArray[self.indexPath.row];
    LYTTextMessageBody *textBody = (LYTTextMessageBody *)copyFrame.chartMessage.messageBody;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:textBody.showText];
}


#pragma mark - LYTChatMessageCellFrameDestrucDelegate
- (void)chatMessageModelWillDelete:(LYTChatMessageCellFrame *)model {
    NSInteger row =  [self.messageArray indexOfObject:model];
    if(row > self.messageArray.count) return;
    [self.messageArray removeObject:model];
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)chatMessageModelWillRefreshStatu:(LYTChatMessageCellFrame *)model {
    NSInteger row = [self.messageArray indexOfObject:model];
    if(row > self.messageArray.count) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - override method
- (void)setIsLeft:(BOOL)isLeft {
    NSLog(@"历史聊天界面,固定律师的聊天在做，客户的聊天在右,注意对比头像与其内容是否一致。");
}

@end
