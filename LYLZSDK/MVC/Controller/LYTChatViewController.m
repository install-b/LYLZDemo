//
//  LYTChatRoomViewController.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatViewController+PrivateAPI.h"
#import "HPWYSProgressHUD.h"
#import "LYRefreshHeader.h"
#import "LYPhotoBrowseView.h"
#import "LYTUserBaseInfo.h"
#import "LYTMessageBody+LYPhotoBrowsePotoProtocol.h"
#import "LYLZChatManager.h"
#import "LYLZChatManager+Private.h"


@implementation LYTChatViewController
#pragma mark - init
- (instancetype)init {
    return nil;
}

- (instancetype)initWithTargetId:(NSString *)targetId sessionType:(LYTChatType)sessionType {
    if (targetId.length == 0 || sessionType == LYTChatTypeUnkown) {
        return nil;
    }
    
    if (self = [super init]) {
        _targetId = targetId;
        _chatType = sessionType;
        _showTimeInterval = 60000;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = BackGroundColor;
        [self addRefreshActionWithTableview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - data source
/** 消息模型 */
- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (NSArray<NSDictionary *> *)moreItems {
    if (!_moreItems) {
        _moreItems = [NSArray arrayWithArray:[self moreItemArray]];
    }
    return _moreItems;
}

- (NSArray *)moreItemArray {
    return nil;
}

- (void)reloadToolBar {
    [self.toolBar endInputEditing];
    self.moreItems = nil;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控件
    [self setupSubView];
    // 添加通知
    [self addNotification];
    // 添加代理
    [self addDelegate];
    // 加载新的消息
    [self reloadNewData];
}

- (void)viewDidAppear:(BOOL)animated {
//    [_sharedSDK.chatManager enterChatSessionWithTargetId:self.targetId sessionType:(LYTSessionType)self.chatType];
    [_sharedSDK.chatManager enterChatSession:self.sessionId];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 布局
    [self layoutInputViewWithToolBarHeight:self.toolBar.height keyboardHeight:self.keyBoardHeight];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_sharedSDK.chatManager exitChatSession];
    [_sharedSDK.chatManager deleteDelegate:self];
    [_sharedSDK.conversationManager deleteDelegate:self];
}
#pragma mark - setUps
- (void)addDelegate {
    [_sharedSDK.chatManager addDelegate:self];
    [_sharedSDK.conversationManager addDelegate:self];
}

- (void)setupSubView {
    self.view.backgroundColor = BackGroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *inputContainer = [[UIView alloc] init];
    inputContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self.view addSubview:inputContainer];
    self.inputContainer = inputContainer;
    // 配置输入框
    [self setupInputContainer:inputContainer];
}

// 设置输入框内容
- (void)setupInputContainer:(UIView *)inputContainer {
    UIView *inputTopView = [[UIView alloc] init];
    [inputContainer addSubview:inputTopView];
    self.inputTopView = inputTopView;
    
    UIView *inputBottomView = [[UIView alloc] init];
    [inputContainer addSubview:inputBottomView];
    self.inputBottomView = inputBottomView;
    
    LYInputToolBar *toolBar = [self createToolBar];
    [inputContainer addSubview:toolBar];
    self.toolBar = toolBar;
    
    [self layoutInputViewWithToolBarHeight:inputToolBarDefailtHeight keyboardHeight:self.keyBoardHeight];
    
    LYWeakSelf
    // 高度监听
    toolBar.inputBarHeight = ^(CGFloat height) {
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf layoutInputViewWithToolBarHeight:height keyboardHeight:weakSelf.keyBoardHeight];
            
            [weakSelf.view layoutIfNeeded];
        }];
    };
}

- (LYInputToolBar *)createToolBar {
    // 键盘
    LYInputToolBar *toolBar = [[LYInputToolBar alloc] init];
    toolBar.delegate = self;
    toolBar.AddButtonArray = self.moreItems;
    
    return toolBar;
}
#pragma mark 子类可重写的方法
- (void)addRefreshActionWithTableview:(UITableView *)tableView  {
    tableView.header = [LYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOldSeesionDate)];
}

- (CGFloat)heightForTimeDownView {
    return 0;
}

- (CGFloat)inputButtomHeight {
    return 0;
}

#pragma mark layout
- (void)layoutInputViewWithToolBarHeight:(CGFloat)toolBarHeight keyboardHeight:(CGFloat)keyboardHeight {
    
    CGFloat topHeight = [self heightForTimeDownView];
    CGFloat buttomHeight = self.inputButtomHeight;
    CGFloat inputHeight = topHeight + buttomHeight  + toolBarHeight;
    CGFloat width = self.view.width;
    CGFloat tableViewHeight = self.view.height - inputHeight - keyboardHeight;
    
    _keyBoardHeight = keyboardHeight;
    
    self.tableView.frame = CGRectMake(0, 0, width, tableViewHeight);
    
    _inputContainer.frame = CGRectMake(0, tableViewHeight,width,inputHeight + topHeight);
    
    _inputTopView.frame = CGRectMake(0, 0, width, topHeight);
    if (topHeight > 0) {
        _inputTopView.subviews.lastObject.frame = _inputTopView.bounds;
    }
    _toolBar.frame = CGRectMake(0, topHeight,width, toolBarHeight);
    _inputBottomView.frame = CGRectMake(0, topHeight + toolBarHeight, width, buttomHeight);
    if (buttomHeight > 0) {
        _inputBottomView.subviews.lastObject.frame = _inputBottomView.bounds;
    }
}
#pragma mark load data
- (void)reloadNewData {
    //查询本地消息记录
    [_sharedSDK.conversationManager dbChatTableGetMessagesFromSession:self.sessionId messageId:self.messageID count:self.count queryDirection:LYTQueryDirectionUp  complete:^(NSArray<LYTMessage *> *messages, LYTError *error) {
         for (LYTMessage *msg in messages) {
             [self addMessage:msg scrollToBottom:NO];
         }
         
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 [self scrollToBottomWithAnima:NO needReloadData:YES];
                                                             });
    }];
}

// 下拉刷新更多聊天数据
- (void)loadOldSeesionDate {
    LYWeakSelf
    // 判断是否有聊天数据，有的话就取出最早的一条消息，去请求更多聊天数据
    if (self.messageArray.count == 0) {
        [HPWYSProgressHUD showInfoWithStatus:@"没有聊天数据"];
        [weakSelf.tableView.header endRefreshing];
        return;
    }
    
    // 查找界面上最早的一条消息
    LYTChatMessageCellFrame *messageFrame = nil;
    for (LYTChatMessageCellFrame *msg in self.messageArray) {
        if ([msg isKindOfClass:[LYTChatMessageCellFrame class]]) {
            messageFrame = msg;
            break;
        }
    }
    if (!messageFrame) {
        return;
    }
    

    //查询本地消息记录
    [_sharedSDK.conversationManager dbChatTableGetMessagesFromSession:self.sessionId messageId:self.messageID count:self.count queryDirection:LYTQueryDirectionUp complete:^(NSArray<LYTMessage *> *messages, LYTError *error) {
        
        //
        for (NSInteger index = messages.count - 1; index >= 0; index--) {
            [weakSelf insertMessage:messages[index]];
        }
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.header endRefreshing];
        });
        
        
    }];
    
}

//// 查询方式
//- (LYTMessageQueryOption)messageQueryOption {
//    return ((LYTSessionType)self.chatType == LYTSessionTypeP2P) ? LYTMessageQueryOptionP2PNormal : LYTMessageQueryOptionMultiChatNormal;
//}

/** 倒序插入 **/
- (void)insertMessage:(LYTMessage *)message {
    if (self.lastTimeInterval - message.messageTime > self.showTimeInterval) {
        // 如果第一个为时间cell,则不用插入时间
        if (![self.messageArray.firstObject isKindOfClass:[LYTimeBannerModel class]]) {
            NSString *timeStr = [NSString stringWithFormat:@"%lld",(long long)message.messageTime];
            LYTimeBannerModel *banner = [LYTimeBannerModel bannerWithTimerString:[timeStr timeString]];
            [self.messageArray insertObject:banner atIndex:0];
        }
    }
    self.lastTimeInterval = message.messageTime;
    
    //message.isSender = [message.sendUserId isEqualToString:[LYLZChatManager shareManager].currentUserId];
    
    [self.messageArray insertObject:[[LYTChatMessageCellFrame alloc] initWithChartModel:message] atIndex:0];
}

// 根据情况插入数据 add by zhangsg 2017.3.10
- (void)addMessage:(LYTMessage *)message scrollToBottom:(BOOL)isScroll {
    
    if (!message) {
        return;
    }
    if (message.messageTime - self.lastTimeInterval > self.showTimeInterval) {
        NSString *timeStr = [NSString stringWithFormat:@"%lld",(long long)message.messageTime];
        LYTimeBannerModel *banner = [LYTimeBannerModel bannerWithTimerString:[timeStr timeString]];
        [self.messageArray addObject:banner];
        
    }
    self.lastTimeInterval = message.messageTime;
    message.isSender = [message.sendUserId isEqualToString:[LYLZChatManager shareManager].currentUserId];
    [self.messageArray addObject:[[LYTChatMessageCellFrame alloc] initWithChartModel:message]];
    dispatch_async(dispatch_get_main_queue(), ^{
         !isScroll ? : [self scrollToBottomWithAnima:NO needReloadData:YES];
    });
   
}

#pragma mark - send message method 发送消息
- (void)sendTextMessageWithString:(NSString *)textString {
    // 解析文字
    textString = [textString stringByReplacingEmojiCheatCodesToUnicode];
    textString = [textString strSwitchFromJsonStr];
    
    // 构造一个文字消息
    LYTTextMessageBody *textBody = [[LYTTextMessageBody alloc] initWithText:textString];
    LYTMessage *message = [[LYTMessage alloc] initWithMessageBody:textBody];
    // 接受者id
    message.targetId = self.targetId;
    if(DestructMessageMode){
        message.flag = 1;
    }
    // 聊天室
    message.sessionType = (LYTSessionType)self.chatType;
    if (![textString isEqualToString:@""] || textString != nil) {
        [self sendMessageWithMessage:message];
    }
}

- (void)sendVoiceMessageWithVoiceDuration:(NSInteger)aDuration recordPath:(NSString *)recordPath  {
    // 开始上传发送
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    // 构造一个语音消息
    LYTVoiceMessageBody *voiceBody = [[LYTVoiceMessageBody alloc] initWithFilePath:[NSString stringWithFormat:@"%@/records/%@",[paths objectAtIndex:0],recordPath] displayName:@"voice"];
    voiceBody.duration = aDuration;
    LYTMessage *message = [[LYTMessage alloc] initWithMessageBody:voiceBody];
    
    // 接受者id
    message.targetId = self.targetId;
    if(DestructMessageMode) {
        message.flag = 1;
    }
    
    // 点对点聊天
    message.sessionType = (LYTSessionType)self.chatType;
    [self sendMessageWithMessage:message];
}

/** 发送消息总入口 */
- (void)sendMessageWithMessage:(LYTMessage *)message{
    /****************************************************************/
    LYWeakSelf
    message.sendStatus = LYTMessageStateBegin;
    message.sendUserId = [LYLZChatManager shareManager].currentUserId;
    message.messageTime = [[NSDate date] timeIntervalSince1970]*1000;
    //#warning sender
    message.isSender = YES;
    //NSLog(@"davidhuang - 开始发送消息(%@)\n 底层SDK的当前userid(%@)",message,_sharedSDK.currentUser);
    
    // 恢复单行
    [self recoverKeyinputView];
    
    // 根据情况插入数据 modify by zhangsg 2017.3.10
    [self addMessage:message scrollToBottom:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [_sharedSDK.chatManager sendMessageWithModel:message shouldSaveMessageInDB:YES progress:nil complete:^(LYTError *error, LYTMessageSendState statues) {
            if (error) {
                //            NSLog(@"发送消息状态 = %zd,message = %zd",statues,message.sendStatus);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
        }];
    });
}

#pragma mark - LYInputToolBarDelegate 输入框代理
/** 发送语音 */
- (void)inputToolBar:(LYInputToolBar *)inputToolBar didSendVoiceDuration:(NSInteger)aDuration recordPath:(NSString *)recordPath {
    [self sendVoiceMessageWithVoiceDuration:aDuration recordPath:recordPath];
}

// 更多按钮点击事件
- (void)inputToolBar:(LYInputToolBar *)inputToolBar didSelectMoreItemIndex:(NSInteger)itemIndex {
    // 1、结束编辑
    [inputToolBar endInputEditing];
    
    // 2、获取映射方法
    SEL selector = NSSelectorFromString(self.moreItems[itemIndex][@"selector"]);
    
    // 3、方法未实现校验
    if (![self respondsToSelector:selector]) {
        //NSAssert(nil, @"-[%@ %@]方法未实现",self.class,NSStringFromSelector(selector));
        NSLog(@"ys--方法未实现");
        return;
    }
    // 4、 执行方法 解除ARC 警告
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
}

/** 发送文字 */
- (void)inputToolBar:(LYInputToolBar *)inputToolBar didSendTextString:(NSString *)textString {
    [self sendTextMessageWithString:textString];
}

#pragma mark - LYInputToolBarDelegate 录音
// 录音 禁止所有操作
- (void)inputToolBarDidStartRecord:(LYInputToolBar *)inputToolBar {
    self.view.userInteractionEnabled = NO;
}
- (void)inputToolBarDidEndRecord:(LYInputToolBar *)inputToolBar {
    self.view.userInteractionEnabled = YES;
}

- (void)inputToolBarMicrophoneUnAvailability:(LYInputToolBar *)inputToolBar {
    NSDictionary *appInfo = [NSBundle mainBundle].infoDictionary;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置麦克风" message:[NSString stringWithFormat:@"请在“设置-隐私-麦克风”选项中允许“%@”app访问你的麦克风",appInfo[@"CFBundleDisplayName"] ? : appInfo[@"CFBundleName"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        inputToolBar.isOpenMicrophoneInput = NO;
    }];
    [alert addAction:comfirmAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/** 即将切换到更多界面 */
- (void)inputToolBarWillSwitchAddView:(LYInputToolBar *)inputToolBar {
    self.keyBoradSwitchState = LYkeyBoradSwitchStateUpcoming;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutInputViewWithToolBarHeight:inputToolBar.height keyboardHeight:200];
    } completion:^(BOOL finished) {
        self.keyBoradSwitchState = LYkeyBoradSwitchStateNormal;
    }];
}

/** 即将切换到表情界面 */
- (void)inputToolBarWillSwitchEmotion:(LYInputToolBar *)inputToolBar {
    self.keyBoradSwitchState = LYkeyBoradSwitchStateUpcoming;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutInputViewWithToolBarHeight:inputToolBar.height keyboardHeight:200];
    } completion:^(BOOL finished) {
         self.keyBoradSwitchState = LYkeyBoradSwitchStateNormal;
    }];
    
}

/** 即将展示切换到输入键盘 */
- (void)inputToolBarWillSwitchKeyBorad:(LYInputToolBar *)inputToolBar {
    //self.keyBoradSwitch = NO;
     self.keyBoradSwitchState = LYkeyBoradSwitchStateTextInput;
}

////取消录音
//- (void)inputToolBarCancelRecord:(LYInputToolBar *)inputToolBar {
//    
//}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.messageArray[indexPath.row] isKindOfClass:[LYTimeBannerModel class]]) {
        // 时间
        LYSessionTimeBannerCell *bannerCell = [LYSessionTimeBannerCell cellWithTableView:tableView cellStyle:UITableViewCellStyleSubtitle WithIdentifier:@"timeBannerCell"];
        LYTimeBannerModel *banner = self.messageArray[indexPath.row];
        bannerCell.time = banner.timerString;
        return bannerCell;
        
    } else if ([self.messageArray[indexPath.row] isKindOfClass:[LYTChatMessageCellFrame class]]) {
        
        // 消息
        return [self tableView:tableView cellForMessageFrame:self.messageArray[indexPath.row]];
    }
    
    else {
        NSLog(@"未知类型的cell");
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageFrame:(LYTChatMessageCellFrame *)frame {
    UITableViewCell *cell = [LYTChatMessageCell cellInTable:tableView forMessageMode:frame];
    if([cell isKindOfClass:[LYTChatMessageCell class]]){
        LYTChatMessageCell *MessageCell = (LYTChatMessageCell *)cell;
        MessageCell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.messageArray[indexPath.row] isKindOfClass:[LYTimeBannerModel class]]){
        return 25.5;
    } else if ([self.messageArray[indexPath.row] isKindOfClass:[LYTChatMessageCellFrame class]]){
        LYTChatMessageCellFrame *Messageframe = self.messageArray[indexPath.row];
        return Messageframe.cellHeight;
    } else {
        return 0;
    }
}

#pragma mark - LYTSDKChatManagerDelegate
/** 收到一条消息 */
- (void)didReceiveAMessage:(LYTMessage *)message {
    // 判断聊天是否在当前控制器
    if ([self.targetId isEqualToString:message.targetId] || [message.targetId isEqualToString:[LYLZChatManager shareManager].currentUserId]) {
        // 根据情况插入数据 modify by zhangsg 2017.3.10
        [self addMessage:message scrollToBottom:YES];
    }
}

// 接收到离线消息 刚刚登录或者刚刚进入到前台的时后会收到 （注意:自己维护未读数和聊天记录需要实现; 自己不维护就不需要实现）
- (void)didReceiveOfflineMessages:(NSArray<LYTMessage *> *)messages {
    if (messages.count > 0) {
        LYTMessage *compMessage = messages[0];
        if ([self.targetId isEqualToString:compMessage.targetId]) { // 是否是和本条会话的聊天记录
            for (LYTMessage *message in messages) {
                [self.messageArray addObject:[[LYTChatMessageCellFrame alloc] initWithChartModel:message]];
            }
            [self scrollToBottomWithAnima:NO needReloadData:YES];
        }
    }
}

- (void)didReceiveRevokeMessage:(LYTMessage *)revokeMessage byUser:(NSString *)userId {
    // do nothing
}

#pragma mark - cell events
/** 重发按钮 */
- (void)messageCell:(LYTChatMessageCell *)messageCell onRetryContent:(LYTChatMessageCellFrame *)frameModel {
    // 3.在发送此条数据
    [self reSendMessageWithMessage:frameModel.chartMessage];
}

/** 重发送消息 */
- (void)reSendMessageWithMessage:(LYTMessage *)message{
    /****************************************************************/
    /****************************************************************/
    LYWeakSelf
    message.sendStatus = LYTMessageStateBegin;
    message.sendUserId = _sharedSDK.currentUser;
    message.messageTime = [[NSString UUIDTimestamp] integerValue];
    [self recoverKeyinputView]; // 恢复单行
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_sharedSDK.chatManager sendMessageWithModel:message shouldSaveMessageInDB:YES progress:nil complete:^(LYTError *error, LYTMessageSendState statues) {
            //NSLog(@"xiaoxizhuangtai = %zd",statues);
            //        NSLog(@"消息重发状态 = %zd,message = %zd",statues,message.sendStatus);
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.tableView reloadData];
            });
           
        }];
    });
   
}

/** 点击cell */
-(void)messageCell:(LYTChatMessageCell *)messageCell chatCellTapPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel
{
    if ([contentView isKindOfClass:[LYTChatVoiceContentView class]]) { // 播放声音
        return [self playVoiceWithContentView:(LYTChatVoiceContentView *)contentView ContentModel:frameModel];
    } else if ([contentView isKindOfClass:[LYTChatImageContentView class]]){// 查看图片
        [self.toolBar endInputEditing];
        return [self bowserPhotoWithContentView:(LYTChatImageContentView *)contentView content:frameModel];
    } else if ([contentView isKindOfClass:[LYTChatFileContentView class]]) {
        [self.toolBar endInputEditing];
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
    
    [_sharedSDK.conversationManager checkMessage:frameModel.chartMessage complete:nil];
    
    
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

// 查看大图
- (void)bowserPhotoWithContentView:(LYTChatImageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel{
    
    NSInteger index = 0;
    NSInteger currentIndex = 0;
    NSMutableArray  <LYPhotoBrowsePotoProtocol>*photos = (NSMutableArray  <LYPhotoBrowsePotoProtocol>*)[NSMutableArray array];
    
    for (id data in self.messageArray) {
        if ([[data class] isSubclassOfClass:[LYTChatMessageCellFrame class]]){
            LYTChatMessageCellFrame *dataFrameModel = (LYTChatMessageCellFrame *)data;
            if ([[dataFrameModel.chartMessage.messageBody class] isSubclassOfClass:[LYTImageMessageBody class]]) {
                [photos addObject:dataFrameModel.chartMessage.messageBody];
                //LYTImageMessageBody *imageMessage = (LYTImageMessageBody *)dataFrameModel.chartMessage.messageBody;
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

    LYTChatMessageCellFrame *copyFrame = self.messageArray[self.indexPath.row];
    LYTTextMessageBody *textBody = (LYTTextMessageBody *)copyFrame.chartMessage.messageBody;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:textBody.showText];
}

#pragma mark - 键盘隐藏通知
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.toolBar endInputEditing];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    if (self.keyBoradSwitchState == LYkeyBoradSwitchStateUpcoming) {
        return;
    }
    
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = LYScreenH - frame.origin.y;
    if (self.keyBoradSwitchState == LYkeyBoradSwitchStateTextInput) {
        if (height == 0) {
             return;
        }
        self.keyBoradSwitchState = LYkeyBoradSwitchStateNormal;
    }
    
    self.keyBoardHeight = height;
    LYWeakSelf
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   
    [UIView animateWithDuration:duration animations:^{
        [weakSelf layoutInputViewWithToolBarHeight:weakSelf.toolBar.height keyboardHeight:self.keyBoardHeight];
        [weakSelf.view layoutIfNeeded];
    }];
    [self scrollToBottomWithAnima:NO needReloadData:NO];
}

// 键盘恢复单行
- (void)recoverKeyinputView {
    [self layoutInputViewWithToolBarHeight:inputToolBarDefailtHeight keyboardHeight:self.keyBoardHeight];
}

// 滚到最后一行
- (void)scrollToBottomWithAnima:(BOOL)anima needReloadData:(BOOL)isNeed {
    if (self.messageArray.count == 0)return;
    if (isNeed) {
        [self.tableView reloadData];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:anima];
}

- (void)setChatInsets:(UIEdgeInsets)chatInsets {
    
    _chatInsets = chatInsets;
    
    UIEdgeInsets insets = self.tableView.contentInset;
    
    self.tableView.contentInset = UIEdgeInsetsMake(insets.top + chatInsets.top, insets.left + chatInsets.left, insets.bottom + chatInsets.bottom, insets.right + chatInsets.right);
    
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
@end
