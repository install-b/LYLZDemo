//
//  LYLZChatListView.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZChatListView.h"
#import "LYTCommonHeader.h"
#import "LYTMessageListCell.h"
#import "LYRefreshHeader.h"
#import "LYLZMessageListCell.h"
#import "LYLZChatManager+Private.h"


@interface LYLZChatListView () <UITableViewDelegate,UITableViewDataSource>
/** 会话列表模型数组 */
@property (nonatomic ,strong) NSMutableArray <LYTMessageList *>*listArray;

/** 控制器视图 */
@property (nonatomic ,weak) UITableView *tableView;

/** <#des#> */
@property(nonatomic,assign) NSInteger unreadCount;
@end

@implementation LYLZChatListView
- (NSMutableArray *)listArray {
    if (!_listArray) {

        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
            //互动消息模型
//            LYTMessageList *InteractiveList = [[LYTMessageList alloc] init];
//            InteractiveList.targetId = [LYLZChatManager shareManager].interactiveNotiId;
//            [tempArray addObject:InteractiveList];
            
            //评论消息模型
//            LYTMessageList *commenyList = [[LYTMessageList alloc] init];
//            commenyList.targetId = [LYLZChatManager shareManager].commentNotiId;
//            [tempArray addObject:commenyList];
        }
        
        //系统消息模型
//        LYTMessageList *systemList = [[LYTMessageList alloc] init];
//        systemList.targetId = [LYLZChatManager shareManager].systemNotiId;
//        [tempArray addObject:systemList];
        _listArray = tempArray;
        
    }
    return _listArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUps];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUps];
}

- (void)setUps {
//    [_instanceSDK.chatListManager addDelegate:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}


#pragma mark - 从数据库获取消息列表
- (void)reloadData {
    // 数据库查找消息列表
//    LYWeakSelf
//    [_instanceSDK.chatListManager queryAllchatListNeedFresh:^(NSArray<LYTMessageList *> *array) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            weakSelf.listArray = [self arrayFromList:array];
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView.header endRefreshing];
//        });
//    }];
    
}

#pragma mark - 添加消息列表项
//- (NSMutableArray <LYTMessageList *> *)arrayFromList:(NSArray<LYTMessageList *> *)array {
//
//    if (array.count == 0) {
//
//         NSMutableArray *tempArray = [NSMutableArray array];
//
//        if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
            //互动消息模型
           
//            LYTMessageList *InteractiveList = [[LYTMessageList alloc] init];
//            InteractiveList.targetId = [LYLZChatManager shareManager].interactiveNotiId;
//            [tempArray addObject:InteractiveList];
            
            //评论消息模型
//            LYTMessageList *commenyList = [[LYTMessageList alloc] init];
//            commenyList.targetId = [LYLZChatManager shareManager].commentNotiId;
//            [tempArray addObject:commenyList];
//        }

        
        //系统消息模型
//        LYTMessageList *systemList = [[LYTMessageList alloc] init];
//        systemList.targetId = [LYLZChatManager shareManager].systemNotiId;
//        [tempArray addObject:systemList];
//        return tempArray;
//    }
//
//    NSMutableArray *arrayM = array.mutableCopy;
//    __block BOOL hasSystemMessage = NO;
//    __block BOOL hasInteractiveMessage = NO;
//    __block BOOL hasCommentMessage = NO;
//    __block NSInteger nureadNunber = 0;
    
    
//    [array enumerateObjectsUsingBlock:^(LYTMessageList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
//        NSLog(@"______= %@",obj.targetId);
        
//        //系统消息
//        if ([obj.targetId isEqualToString:[LYLZChatManager shareManager].systemNotiId]) {
//            [arrayM removeObject:obj];
//            if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
//                if (hasInteractiveMessage&&hasCommentMessage) {
//                    [arrayM insertObject:obj atIndex:2];
//
//                } else if ((hasInteractiveMessage&&!hasCommentMessage) ||(!hasInteractiveMessage&&hasCommentMessage)){
//                    [arrayM insertObject:obj atIndex:1];
//
//                } else {
//                    [arrayM insertObject:obj atIndex:0];
//                }
//            } else {
//              [arrayM insertObject:obj atIndex:0];
//            }
//            hasSystemMessage = YES;
//        }
//
//        //评论消息
//        if ([obj.targetId isEqualToString:[LYLZChatManager shareManager].commentNotiId]) {
//
//            [arrayM removeObject:obj];
//
//            if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
//                if (hasInteractiveMessage){
//                    [arrayM insertObject:obj atIndex:1];
//
//                } else {
//                    [arrayM insertObject:obj atIndex:0];
//                }
//               hasCommentMessage = YES;
//            }
//        }
//
//        //互动消息
//        if ([obj.targetId isEqualToString:[LYLZChatManager shareManager].interactiveNotiId]) {
//            [arrayM removeObject:obj];
//            if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
//               [arrayM insertObject:obj atIndex:0];
//               hasInteractiveMessage = YES;
//           }
//        }
//
//
//        if([obj.targetId isEqualToString:_instanceSDK.currentUser] || obj.sessionType != LYTSessionTypeP2P){
//            // remove自己
//            [arrayM removeObject:obj];
//        }
//    }];
//
//    if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
//        if (!hasInteractiveMessage) {
//            LYTMessageList *list = [[LYTMessageList alloc] init];
//            list.targetId = [LYLZChatManager shareManager].interactiveNotiId;
//            [arrayM insertObject:list atIndex:0];
//        }
//
//        if (!hasCommentMessage) {
//            LYTMessageList *list = [[LYTMessageList alloc] init];
//            list.targetId = [LYLZChatManager shareManager].commentNotiId;
//            [arrayM insertObject:list atIndex:1];
//        }
//
//        if (!hasSystemMessage) {
//            LYTMessageList *list = [[LYTMessageList alloc] init];
//            list.targetId = [LYLZChatManager shareManager].systemNotiId;
//            [arrayM insertObject:list atIndex:2];
//        }
//
//    } else {
//        if (!hasSystemMessage) {
//            LYTMessageList *list = [[LYTMessageList alloc] init];
//            list.targetId = [LYLZChatManager shareManager].systemNotiId;
//            [arrayM insertObject:list atIndex:0];
//        }
//    }
    
//    return arrayM;
//}

#pragma mark - 被动刷新列表
- (void)chatListNeedRefreshNotification:(NSArray<LYTMessageList *> *)data {
    [self reloadData];
}

#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYTMessageListCell *cell = [LYLZMessageListCell cellWithTableView:tableView cellStyle:UITableViewCellStyleSubtitle WithIdentifier:@"messageListCell"];
    //annotation by ys 2017.11.06
//    cell.outsideSessionListModel = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

// annotation by ys 2017.11.06
//    // 取消展示
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    // 获取模型
//    LYLZSessionList *sessionList = [self sessionListWithMessageList:self.listArray[indexPath.row]];
//    sessionList.rowIndex = indexPath.row;
//
//    if (sessionList.sessionListType != LYLZSessionListTypeInteractive &&
//        sessionList.sessionListType != LYLZSessionListTypeComment) {
        //清空消息未读数
       
//        [_instanceSDK.conversationManager clearConversasionUnreadCountWithTargetId:self.listArray[indexPath.row].targetId sessionType:LYTSessionTypeP2P complete:nil];
//    } else {
//        NSLog(@"hjl-点击了评论消息或者或者互动消息。 应用方负责该消息的已读状态的清理工作。");
//    }


    //跳转聊天界面或者系统消息界面
//    if ([self.delegate respondsToSelector:@selector(chatListView:didSelectedSessionList:)]) {
//        [self.delegate chatListView:self didSelectedSessionList:sessionList];
//    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //有互动与评论消息
    if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
        if (indexPath.row == 0 ||
            indexPath.row == 1 ||
            indexPath.row == 2 ) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return indexPath.row;
    }
    
}


#pragma mark - table view delegate
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        LYTMessageList *list = self.listArray[indexPath.row];
        LYWeakSelf
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            LYLZSessionList *sessionList = [self sessionListWithMessageList:list];
            BOOL empty = ([self.delegate respondsToSelector:@selector(shoudEmptyConversationWitChatListView:whenDeleteList:)] && [weakSelf.delegate shoudEmptyConversationWitChatListView:weakSelf whenDeleteList:sessionList]);
            // 删除
//annotation by ys 2017.11.06
//            [_instanceSDK.chatListManager delChatListWithMessageList:list shouldEmptyConversationMessages:empty complete:nil];
            [weakSelf.listArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
            
        }];
 //annotation by ys 2017.11.06
//        UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:list.isTop ? @"取消置顶" : @"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//            // 置顶
//            [_instanceSDK.chatListManager updateSessionChatListSetTop:!list.isTop targetId:list.targetId succeed:^(BOOL result) {
//                [weakSelf reloadData];
//            }];
//        }];
//        return @[deleteAction,topAction];
    }
    return nil;
}


- (LYLZSessionList *)sessionListWithMessageList:(LYTMessageList *)messageList {
    //annotation by ys 2017.11.06
//    LYLZSessionList *sessionList = [[LYLZSessionList alloc] init];
//    sessionList.targetId = messageList.targetId;
//
//    if ([LYLZChatManager shareManager].isShowCMTandInterMessage) {
//        if ([messageList.targetId isEqualToString:[LYLZChatManager shareManager].systemNotiId]) { //系统消息类型
//            sessionList.sessionListType = LYLZSessionListTypeSystem;
//
//        } else if ([messageList.targetId isEqualToString:[LYLZChatManager shareManager].interactiveNotiId]) { // 互动消息类型
//            sessionList.sessionListType = LYLZSessionListTypeInteractive;
//
//        } else if ([messageList.targetId isEqualToString:[LYLZChatManager shareManager].commentNotiId]) { //评论消息类型
//            sessionList.sessionListType = LYLZSessionListTypeComment;
//
//        } else { //个人消息类型
//            sessionList.sessionListType = LYLZSessionListTypePerson;
//
//        }
//    } else {
//        if ([messageList.targetId isEqualToString:[LYLZChatManager shareManager].systemNotiId]) { //系统消息类型
//            sessionList.sessionListType = LYLZSessionListTypeSystem;
//
//        } else { //个人消息类型
//            sessionList.sessionListType = LYLZSessionListTypePerson;
//
//        }
//    }
//
//
//    sessionList.targetName = messageList.listTitle;
//
//    return sessionList;
    return nil;
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = BackGroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;

        tableView.header = [LYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
        
        _tableView = tableView;
        if (iPhone6SP) {
            tableView.rowHeight = 70;
        } else {
            tableView.rowHeight = 60;
        }
        [self addSubview:tableView];
    }
    return _tableView;
}

@end
