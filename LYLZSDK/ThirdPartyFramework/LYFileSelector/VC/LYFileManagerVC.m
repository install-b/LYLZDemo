//
//  ViewController.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//



///屏幕高度/宽度
#define LYScreenWidth        [UIScreen mainScreen].bounds.size.width
#define LYScreenHeight       [UIScreen mainScreen].bounds.size.height


#import "LYFileManagerVC.h"
#import "LYFlieLookUpVC.h"

#import "LYFileObjModel.h"

#import "LYFileViewCell.h"
#import "LYFileManagerToolBar.h"
#import "LYFileDepartmentView.h"


#import "UIColor+HexColor.h"
#import "NSFileManager+Tool.h"


CGFloat departmentH = 48;
CGFloat departmentY = 0;
CGFloat toolBarHeight = 49;

@interface LYFileManagerVC ()
<UITableViewDelegate,
UITableViewDataSource,
LYFileManagerToolBarDelegate,
LYFileDepartmentViewDelegate
>

@property (strong, nonatomic) LYFileDepartmentView *departmentView;
@property (strong, nonatomic) LYFileManagerToolBar *assetGridToolBar;
@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (nonatomic,strong) UITableView *tabvlew;
@property (nonatomic,strong) NSMutableArray *fileList;
@property (nonatomic,strong) NSMutableArray *allfileArray;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) NSArray *depatmentArray;

//@property (strong, nonatomic) LYInputToolBar *inputToolBar;

@property (copy, nonatomic) NSString *sessionId;

/** 文件位置 */
@property (nonatomic,copy)NSString * homeFilePath;
@end

@implementation LYFileManagerVC


- (instancetype)initWithHomeFilePath:(NSString *)homeFilePath {
    if (self = [super init]) {
        self.homeFilePath = homeFilePath;
    }
    return self;
}
- (void)setHomeFilePath:(NSString *)homeFilePath {
    _homeFilePath = homeFilePath;
    [[NSFileManager defaultManager] creatFileDirection:homeFilePath];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的文件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setClickPartmentView];
    
    [self loadData];
    [self tabvlew];
    [self setupToolbar];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    //[btn setTitleColor:color8FD forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(closeVcClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)closeVcClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)depatmentArray
{
    if (_depatmentArray == nil) {
        _depatmentArray = @[@"全部",@"音乐",@"文档",@"应用",@"其他"];
        
    }
     return  _depatmentArray;
}
- (UITableView *)tabvlew
{
    if (_tabvlew == nil) {
        CGRect frame = CGRectMake(0,departmentY + departmentH + 10, LYScreenWidth, LYScreenHeight - departmentY - toolBarHeight - departmentH - 10);
        _tabvlew = [[UITableView alloc]   initWithFrame:frame style:UITableViewStylePlain];
        _tabvlew.tableFooterView = [[UIView alloc] init];
        _tabvlew.delegate = self;
        _tabvlew.dataSource = self;
        _tabvlew.bounces = NO;
        [self.view addSubview:self.tabvlew];

    }
    return _tabvlew;
}
- (void)setupToolbar
{
    LYFileManagerToolBar *toolbar = [[LYFileManagerToolBar alloc] initWithFrame:CGRectMake(0, LYScreenHeight - toolBarHeight - 64, LYScreenWidth, toolBarHeight)];
    toolbar.delegate = self;
    _assetGridToolBar = toolbar;
    _assetGridToolBar.backgroundColor = [UIColor colorWithHexString:@"Eff1f3"];//[UIColor lightGrayColor];
    [self.view addSubview:_assetGridToolBar];
}
- (void)setClickPartmentView
{
    
    [self departmentView];
}
- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = @[].mutableCopy;
    }
    return _selectedItems;
}

- (LYFileDepartmentView *)departmentView
{
    if (_departmentView == nil) {
        CGRect frame = CGRectMake(0, departmentY, LYScreenWidth, departmentH);
        _departmentView = [[LYFileDepartmentView alloc] initWithParts:self.depatmentArray withFrame:frame];
        _departmentView.lyt_delegate = self;
        [self.view addSubview:_departmentView];
    }
    return _departmentView;
}
#pragma mark - loadData
- (void)loadData{
    [_fileList removeAllObjects];
    self.allfileArray = @[].mutableCopy;
    self.view.backgroundColor =  backColor;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (!_homeFilePath) {
        self.homeFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LYFileCache"];
    }

    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath:_homeFilePath error: NULL];
   
    for(NSString *str in subPathsArray){
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat:@"%@/%@",_homeFilePath, str] isDirectory: &isDirectory];
        BOOL imageFile = [str hasSuffix:@".png"] || [str hasSuffix:@".jpg"];
        if (!isDirectory && !imageFile){
        LYFileObjModel *object = [[LYFileObjModel alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@",_homeFilePath, str]];
        [self.allfileArray addObject: object];
        }
    }
    self.fileList = self.allfileArray.mutableCopy;
    [self.tabvlew reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fileList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYFileViewCell *cell = (LYFileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
         cell = [[LYFileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    LYFileObjModel *actualFile = [_fileList objectAtIndex:indexPath.row];
    cell.model = actualFile;
    __weak typeof(self) weakSelf = self;
    cell.Clickblock = ^(LYFileObjModel *model,UIButton *btn){
        if (weakSelf.selectedItems.count>=5 && btn.selected) {
            btn.selected =  NO;
            model.select = btn.selected;
            //[weakSelf.view makeToast:@"最多支持5个文件选择" duration:0.5 position:CSToastPositionCenter];
            return ;
        }
        if ([weakSelf checkFileSize:model]) {
            if (btn.isSelected) {
                [weakSelf.selectedItems addObject:model];
                weakSelf.assetGridToolBar.selectedItems = weakSelf.selectedItems;
            }else{
                [weakSelf.selectedItems removeObject:model];
                weakSelf.assetGridToolBar.selectedItems = weakSelf.selectedItems;
            }
        }else{
            //[weakSelf.view makeToast:@"暂时不支持超过5MB的文件" duration:0.5 position:CSToastPositionCenter];
            btn.selected =  NO;
            model.select = btn.selected;
        }
    };
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LYFileObjModel *actualFile = [_fileList objectAtIndex:indexPath.row];
    LYFlieLookUpVC *vc = [[LYFlieLookUpVC alloc] initWithFileModel:actualFile];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --LYDepartmentViewDelegate

- (void)departmentView:(LYFileDepartmentView *)departmentView didScrollToIndex:(NSInteger)index{
    [self setOrigArray];
    switch (index) {
        case 0:
        {
            self.fileList = self.allfileArray.mutableCopy;
            [self.fileList enumerateObjectsUsingBlock:^(LYFileObjModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            }];
            [self.tabvlew reloadData];
            
        }
            break;
        case 1:
        {
            [self.fileList removeAllObjects];
            for (LYFileObjModel * model in self.allfileArray) {
            if (model.fileType == MKFileTypeAudioVidio) {
                    [self.fileList addObject:model];
                }
            }
            [self.tabvlew reloadData];
        }
            break;
        case 2:
        {
            [self.fileList removeAllObjects];
            for (LYFileObjModel * model in self.allfileArray) {
                if (model.fileType == MKFileTypeTxt) {
                    [self.fileList addObject:model];
                }
            }
            [self.tabvlew reloadData];
        }
            break;
        case 3:
        {
            [self.fileList removeAllObjects];
            for (LYFileObjModel * model in self.allfileArray) {
                if (model.fileType == MKFileTypeApplication) {
                    [self.fileList addObject:model];
                }
            }
            [self.tabvlew reloadData];
        }
            break;
        case 4:
        {
            [self.fileList removeAllObjects];
            for (LYFileObjModel * model in self.allfileArray) {
                if (model.fileType == MKFileTypeUnknown) {
                    [self.fileList addObject:model];
                }
            }
            [self.tabvlew reloadData];
            
        }break;
        default:
            break;
    }
}

- (void)setOrigArray{
    for (LYFileObjModel *model  in self.selectedItems) {
        [self.allfileArray enumerateObjectsUsingBlock:^(LYFileObjModel *origModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([origModel.filePath isEqualToString:model.filePath]) {
                origModel.select = model.select;
            
            }
        }];
    }
}
#pragma mark --TYHInternalAssetGridToolBarDelegate
- (void)didClickPreviewInAssetGridToolBar:(LYFileManagerToolBar *)internalAssetGridToolBar{
    
}
- (void)didClickSenderButtonInAssetGridToolBar:(LYFileManagerToolBar *)internalAssetGridToolBar {
    if ([self.fileSelectVcDelegate respondsToSelector:@selector(fileViewControler:Selected:)]) {
        [self.fileSelectVcDelegate fileViewControler:self Selected:self.selectedItems];
    }
}

- (BOOL )checkFileSize:(LYFileObjModel *)model
{
    if (model.fileSizefloat >= 5000000) {
        return NO;
    }
    return YES;
}
@end
