//
//  LYLZSystemMessageViewController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/12.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZSystemMessageViewController.h"
#import "LYTSDK.h"
#import "LYLZChatManager+Private.h"
#import "NSObject+SGExtention.h"
#import "NSString+TextSize.h"
#import "LYTCommonHeader.h"
#import "LZSystemNotiCell.h"
#import "LYLZChatManager+Private.h"


@interface LYLZSystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate,LYTSDKChatManagerDelegate>

@property (nonatomic,weak) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray <LZSystemNotiModel *> * dataSource;

@end

@implementation LYLZSystemMessageViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建视图
    [self tableView];
    
    // 加载数据
    [self loadAllData];
    
    // 添加代理
    [_instanceSDK.chatManager addDelegate:self];
}

- (void)dealloc {
    [_instanceSDK.chatManager deleteDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 进入聊天室
    [_instanceSDK.chatManager enterChatSession:[LYLZChatManager shareManager].systemNotiId];
//    [_instanceSDK.chatManager enterChatSessionWithTargetId:[LYLZChatManager shareManager].systemNotiId sessionType:LYTSessionTypeP2P];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 退出聊天室
    [_instanceSDK.chatManager exitChatSession];
//    [_instanceSDK.chatManager exitCurrentChatSession];
}

#pragma mark - 数据处理
- (LZSystemNotiModel *)notiModelWithMessage:(LYTMessage *)msg {
    NSString *content = [[msg.content sg_JSONDictionary] objectForKey:@"content"];
    LZSystemNotiModel *model = [[LZSystemNotiModel alloc] initWithContent:content time:[NSString stringWithFormat:@"%zd",msg.messageTime/1000]];
    return model;
}

- (void)loadAllData {
    [_instanceSDK.conversationManager dbChatTableGetMessagesFromSession:[LYLZChatManager shareManager].systemNotiId messageId:nil count:LYTMaxCount queryDirection:LYTQueryDirectionUp complete:^(NSArray<LYTMessage *> *messages, LYTError *error) {
        
//    [_instanceSDK.conversationManager dbChatTableGetMessage:[LYLZChatManager shareManager].systemNotiId messageVernierIndex:LYTMaxVernierIndex vernierChatIndexMessageId:nil count:LYTMaxCount messageOption:0 messageType:0 complete:^(NSArray<LYTMessage *> *messages, LYTError *error) {
       
        if (messages.count == 0) {
            return;
        }
        
        [messages enumerateObjectsUsingBlock:^(LYTMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataSource insertObject:[self notiModelWithMessage:obj] atIndex:0];
        }];

        [self.tableView reloadData];
    }];
}

#pragma mark - chat manager delegate
// 在线
- (void)didReceiveAMessage:(LYTMessage *)msg {
    if ([msg.sendUserId isEqualToString:[LYLZChatManager shareManager].systemNotiId]) {
        [self.dataSource insertObject:[self notiModelWithMessage:msg] atIndex:0];
        [self.tableView reloadData];
    }
}

// 离线
- (void)didReceiveOfflineMessages:(NSArray<LYTMessage *> *)messages {
    if (![messages.firstObject.sendUserId isEqualToString:[LYLZChatManager shareManager].systemNotiId]) {
        return;
    }
    
    [messages enumerateObjectsUsingBlock:^(LYTMessage * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSource insertObject:[self notiModelWithMessage:msg] atIndex:0];
    }];
    [self.tableView reloadData];
    
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZSystemNotiCell *cell = (LZSystemNotiCell *)[tableView dequeueReusableCellWithIdentifier:@"LYLZSystemMessageViewController_CELL_REUSE_ID"];
    
    cell.systemNoti = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataSource[indexPath.row].cellHeight;
}

#pragma mark - cell Separator
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

}

-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc] init];
        _tableView = tableView;
        [self.view addSubview:tableView];
        
        [tableView registerClass:[LZSystemNotiCell class] forCellReuseIdentifier:@"LYLZSystemMessageViewController_CELL_REUSE_ID"];
        
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;
        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        CGRect frame = self.view.bounds;
        if (self.navigationController) {
            frame.size.height -= 64;
        }
        tableView.frame = frame;
        
    }
    return _tableView;
}

- (NSMutableArray<LZSystemNotiModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
