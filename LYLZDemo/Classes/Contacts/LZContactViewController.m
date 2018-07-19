//
//  LZContactViewController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZContactViewController.h"
#import "LYLZUserInfo.h"
#import "LZChatViewController.h"

@interface LZContactViewController () <UITableViewDataSource,UITableViewDelegate>

/** <#des#> */
@property (nonatomic,weak) UITableView * tableView;

/** <#des#> */
@property (nonatomic,strong) NSArray <LYLZUserInfo *>* contacts;

@end

@implementation LZContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"联系人";
    // 假数据
    self.contacts = [LYLZUserInfo objectArrayFromJsonArray:[self contactDataSource]];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LYLZUserInfo * userInfo = self.contacts[indexPath.row];
    
    LZChatViewController *chatVc = [[LZChatViewController alloc] initWithTargetId:userInfo.userId chatIdentity:self.chatIdentity];
    
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZContactViewController_cell_reuse_id"];
    
    cell.textLabel.text = self.contacts[indexPath.row].userName;
    
    return cell;
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"LZContactViewController_cell_reuse_id"];
        
        tableView.frame = self.view.bounds;
    }
    return _tableView;
}


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

@end
