//
//  LZSessionListViewController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZSessionListViewController.h"
#import "LYLZChatManager.h"
#import "LZChatViewController.h"
#import "LYLZUserInfo.h"
#import "LYLZSystemMessageViewController.h"


@interface LZSessionListViewController ()
<
LYLZChatListViewDelegate
>
/** 消息列表 */
@property (nonatomic,weak) LYLZChatListView * listView;
/** <#des#> */
@property (nonatomic,weak) UIImageView * bgImageView;
@end


@implementation LZSessionListViewController

// 联系人 这里使用假数据写死 （根据每个公司自己的用户信息管理以及请求逻辑去获取）
- (id)contactDataSource {
    return @[
             @{@"userId" : @"133220010010", @"userName" : @"嬴政" ,@"picture" : @"http://ftp.71chat.com/C10086/2016-11-21/A52CDD48-5078-47FB-A598-FBF16C181627/cc19c37e7e2e4585b9202aec5fc57821.Jpeg"},
             @{@"userId" : @"133220010011", @"userName" : @"项羽",@"picture" : @"http://ftp.71chat.com/C10086/2016-12-26/A62CCB9E-F126-49BA-A95C-B234DC9B8FBA/4edaa7d118fe4427a00fe4806be9d83f.jpg"},
             @{@"userId" : @"133220010012", @"userName" : @"刘邦",@"picture" : @"http://ftp.71chat.com/C10086/2016-11-16/92FE635E-FBBC-4849-92E4-F5C4EC77CCED/af2e27e5a13243489661594bedafff9d.jpg"},
             @{@"userId" : @"133220010013", @"userName" : @"扶苏",@"picture" : @"http://ftp.71chat.com/C10086/2016-12-02/P148047014777726/0930778de44644689a75c21306ba4625.jpg"},
             @{@"userId" : @"133220010014", @"userName" : @"张良",@"picture" : @"http://ftp.71chat.com/C10086/2016-11-17/67909CD9-015E-4539-A7CD-BE26C841DB8A/7ec66d80e4fd4f3c85525bfb69655c2b.jpg"},
             @{@"userId" : @"954", @"userName" : @"boge",@"picture" : @"http://ftp.71chat.com/C10086/2016-11-16/6AD487CF-F7AA-4930-93B9-4F57BCB63334/0bdfe0b1376a43fcaf49c831cbf996ab.jpg"},
             @{@"userId" : @"hhly2017", @"userName" : @"华海乐盈",@"picture" : @"http://ftp.71chat.com/C10086/2016-11-15/5993F0BA-FC11-4C81-A6A7-234EB5298EC9/3451e4fbdd574581a74167a02521e1b3.jpghttp://ftp.71chat.com/C10086/2016-11-15/5993F0BA-FC11-4C81-A6A7-234EB5298EC9/3451e4fbdd574581a74167a02521e1b3.jpg"},
             @{@"userId" : @"cde768eba38a421eb7bd9ea72fc1e36c_373", @"userName" : @"体育IP",@"picture" : @"http://ftp.71chat.com/C10086/2017-02-20/E407C2D2-551A-4D2E-A17C-9FFB7B3A2A71/6706f90f527c4ceabb6e73880953f4f3.jpg"},
             @{@"userId" : @"CA1B96321A9341359751F9322105EAF7", @"userName" : @"用户A",@"picture" : @"http://ftp.71chat.com/UP:01/dba318fed793ea9caf9973d308f7dbd6.png"},
             @{@"userId" : @"9B31F79364624E1D87CFB06E72AC2BE9", @"userName" : @"用户B",@"picture" : @"http://ftp.71chat.com/UP:01/429cd8225abf056e857deabd31fcc794.jpg"},
             ];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"背景-1"];
    [self.view addSubview:bgView];
    _bgImageView = bgView;
    [self loadContact];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    self.bgImageView.frame = CGRectMake(0, 0, width, 200);
    self.listView.frame = CGRectMake(0, 200,width,height - 200);
}

- (void)loadContact {
    
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray <LYLZUserInfo *>*userInfos = [LYLZUserInfo objectArrayFromJsonArray:[self contactDataSource]];
        [[LYLZChatManager shareManager] updateContactWithContactsInfo:userInfos complete:^(LYTError *error) {
            NSLog(@"更新联系人%@",error);
        }];
        
    });
    //NSMutableArray *contactsM = [[LYTUserBaseInfo objectArrayWithKeyValuesArray:[self contactDataSource]] mutableCopy]; // 联系人假数据
}

#pragma mark - LYLZChatListViewDelegate
- (BOOL)shoudEmptyConversationWitChatListView:(LYLZChatListView *)chatListView whenDeleteList:(LYLZSessionList *)list {
    // 删除系统消息记录 但删除用户聊天记录
    return list.sessionListType == LYLZSessionListTypeSystem;
}

- (void)chatListView:(LYLZChatListView *)chatListView didSelectedSessionList:(LYLZSessionList *)sessionList {
    if (sessionList.sessionListType == LYLZSessionListTypeSystem ||
        sessionList.sessionListType == LYLZSessionListTypeInteractive ||
        sessionList.sessionListType == LYLZSessionListTypeComment) {
        // 进入系统 消息界面
        LYLZSystemMessageViewController *vc = [[LYLZSystemMessageViewController alloc]  init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        // 进入聊天
        [self pushChatViewWithTargetId:sessionList.targetId];
    }
}

- (void)didFetchSessionStatus:(LYLZChatSessionStatus)statu {
    NSLog(@"会话结束,弹框出来");
    if (statu == LYLZChatSessionStatus_Sponsor_Ending) {
        UIAlertController *alert = [[UIAlertController alloc] init];
        UIAlertAction  * action = [UIAlertAction actionWithTitle:@"hahh" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 进入聊天界面
- (void)pushChatViewWithTargetId:(NSString *)targetId {
    // 创建控制器
    LZChatViewController *chatVc = [[LZChatViewController alloc] initWithTargetId:targetId chatIdentity:_chatIdentity];
    
    // push 进去
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark - LAZY LOAD
- (LYLZChatListView *)listView {
    if (!_listView) {
        LYLZChatListView *listViwe = [[LYLZChatListView alloc] init];
        [self.view addSubview:listViwe];
        listViwe.delegate = self;
        _listView = listViwe;
    }
    return _listView;
}

@end
