//
//  LYAssetGridViewController.m
//  TaiYangHua
//
//  Created by Lc on 16/2/15.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYAssetGridViewController.h"
#import "LYAssetGridCell.h"
#import "LYAssetViewController.h"
#import "LYAssetGridToolBar.h"
#import "LYAsset.h"
#import "HPWYSProgressHUD.h"
#import "UIView+Frame.h"
#import "NSArray+InvertedOrder.h"



#define margin 3
#define col 3
#define toolBarHeight 55

@interface LYAssetGridViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, LYAssetGridCellDelegate, LYAssetGridToolBarDelegate, LYAssetViewControllerDelegate>

@property (weak, nonatomic) LYAssetGridToolBar *assetGridToolBar;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray *assetArray;
@property (assign, nonatomic) NSInteger selectedImageCount;

@property (strong, nonatomic) PHFetchResult *allPhotos;
@property (weak, nonatomic) id<LYAssetGridViewControllerDelegate> delegate;


@end

@implementation LYAssetGridViewController

static NSString *const TYHAssetGridViewCellId = @"TYHAssetGridViewCellId";
// 缩略图
static CGSize AssetGridThumbnailSize;

+ (void)showIamgeSelectorWithNavClass:(Class)navClass Delegate:(id<LYAssetGridViewControllerDelegate>) delegate {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) { //相册权限未开启
        [self showAlertView];
        
    }else if(status == PHAuthorizationStatusNotDetermined){ // 第一次安装程序
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAssetGridViewWithNavClass:navClass Delegate:delegate];
                });
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        [self showAssetGridViewWithNavClass:navClass Delegate:delegate];
    }
}

//void lyt_getPhotoAuthorizationStatusComplete(void(^complete)(LYPHAuthorizationStatus status)) {
//    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//    if (status == PHAuthorizationStatusDenied) { //相册权限未开启
//        complete(LYPHAuthorizationStatusDenied);
//    }else if(status == PHAuthorizationStatusNotDetermined){ // 第一次安装程序
//        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
//            //授权后直接打开照片库
//            if (status == PHAuthorizationStatusAuthorized){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    complete(LYPHAuthorizationStatuAuthorized);
//                });
//            }
//        }];
//    }else if (status == PHAuthorizationStatusAuthorized){
//        complete(LYPHAuthorizationStatuAuthorized);
//    }else {
//        complete(LYPHAuthorizationStatusRestricted);
//    }
//}

/** 提示打开权限 */
+ (void)showAlertView {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

/** 选择图片的按钮 */
+ (void)showAssetGridViewWithNavClass:(Class)navClass Delegate:(id<LYAssetGridViewControllerDelegate>) delegate {
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 9) {
        option.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    
    
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:option];
    
    LYAssetGridViewController *assetGridViewController = [[self alloc] init];
    assetGridViewController.delegate = delegate;
    assetGridViewController.allPhotos = allPhotos;
    UINavigationController *nav = [(UINavigationController *)[navClass alloc] initWithRootViewController:assetGridViewController];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - lazy
- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    
    return _selectedItems;
}

- (NSMutableArray *)assetArray
{
    if (!_assetArray) {
        NSMutableArray *temp = [NSMutableArray array];
        
        for (PHAsset *asset in self.allPhotos) {
            LYAsset *internalAsset = [LYAsset internalAssetWith:asset];
            [temp addObject:internalAsset];
        }
        
        _assetArray =[temp invertedOrderArray];
    }
    
    return _assetArray;
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNav];
    [self setupCollectionView];
    [self setupToolbar];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.collectionView reloadData];
//}


- (void)setupNav
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickReturnButton) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)clickReturnButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(assetGridViewControllerdidCancel:)]) {
            [_delegate assetGridViewControllerdidCancel:self];
        }
    }];
}

- (void)setupCollectionView
{
    CGFloat WH = (self.view.width - (margin * (col + 1))) / col;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(WH, WH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolBarHeight) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    
    collectionView.alwaysBounceVertical = YES;
    [collectionView registerClass:[LYAssetGridCell class] forCellWithReuseIdentifier:TYHAssetGridViewCellId];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = flowLayout.itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)setupToolbar
{
    LYAssetGridToolBar *toolbar = [[LYAssetGridToolBar alloc] initWithFrame:CGRectMake(0, self.view.height - toolBarHeight - 64, self.view.width, toolBarHeight)];
    toolbar.delegate = self;
    _assetGridToolBar = toolbar;
    [self.view addSubview:_assetGridToolBar];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYAssetGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TYHAssetGridViewCellId forIndexPath:indexPath];
    
    LYAsset *internalAsset = self.assetArray[indexPath.item];
    internalAsset.assetGridThumbnailSize = AssetGridThumbnailSize;
    cell.internalAsset = internalAsset;
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYAssetViewController *assetVc = [[LYAssetViewController alloc] init];
    assetVc.assetArray = self.assetArray; 
    assetVc.selectedItems = self.selectedItems;
    assetVc.index = indexPath.item;
    assetVc.delegate = self;
    [self.navigationController pushViewController:assetVc animated:YES];
}

#pragma mark - LYAssetGridToolBarDelegate
// 点击了预览
- (void)didClickPreviewInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar
{
    LYAssetViewController *assetVc = [[LYAssetViewController alloc] init];
    assetVc.delegate = self;
    assetVc.assetArray = self.selectedItems;
    // 深拷贝不可少
    assetVc.selectedItems = [self.selectedItems mutableCopy];
    [self.navigationController pushViewController:assetVc animated:YES];
}

// 监听assetGridToolBar发送按钮
- (void)didClickSenderButtonInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(assetGridViewController:didSenderImages:)]) {
            [self.delegate assetGridViewController:self didSenderImages:self.selectedItems];
        }
    }];
    
}

#pragma mark - LYAssetViewControllerDelegate
// 监听assetView中选中的图片
- (void)AssetViewController:(LYAssetViewController *)AssetViewController selectedItemsInAssetViewController:(NSMutableArray *)selectedItems
{
    for (LYAsset *internalAsset in self.assetArray) {
        for (LYAsset *internalSelectedAsset in selectedItems) {
            if ([[internalAsset class]isMemberOfClass:[internalSelectedAsset class]]) {
                internalAsset.selected = YES;
            }
        }
    }
    
    self.selectedItems = selectedItems;
    self.selectedImageCount = selectedItems.count;
    self.assetGridToolBar.selectedItems = self.selectedItems;
    [self.collectionView reloadData];
}

// 监听assetView中发送按钮
- (void)AssetViewController:(LYAssetViewController *)AssetViewController didClickSenderButton:(NSMutableArray *)selectedItems
{
    self.selectedItems = selectedItems;
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(assetGridViewController:didSenderImages:)]) {
            [self.delegate assetGridViewController:self didSenderImages:self.selectedItems];
        }
    }];
//    if ([self.delegate respondsToSelector:@selector(assetGridViewController:didSenderImages:)]) {
//        [self.delegate assetGridViewController:self didSenderImages:self.selectedItems];
//    }
}

#define maxSelectedImageCount 5
// 最大选择图片数 不实现默认为5
- (NSInteger)maxSelectedCount {
    if ([self.delegate respondsToSelector:@selector(maxSelectedCount)]) {
        NSInteger count = [self.delegate maxSelectedCount];
        return (count > 0) ? count : maxSelectedImageCount;
    }
    return maxSelectedImageCount;
}

// 监听assetGridCell中选中的图片
#pragma mark - LYAssetGridCellDelegate
- (void)assetGridCell:(LYAssetGridCell *)assetGridCell isSelected:(BOOL)selected isNeedToAdd:(void (^)(BOOL))add
{
    if (selected) {
        self.selectedImageCount += 1;
        NSInteger maxCount = [self maxSelectedCount];
        if (self.selectedImageCount > maxCount) {
            self.selectedImageCount = maxCount;
            [HPWYSProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"图片最多选择%zd张",maxCount]];
            if (add) add(NO);
            return;
        }
        [self.selectedItems addObject:assetGridCell.internalAsset];
       
    } else {
        self.selectedImageCount -= 1;
        [self.selectedItems removeObject:assetGridCell.internalAsset];
    }
    
    if (add) add(YES);
    self.assetGridToolBar.selectedItems = self.selectedItems;
}
@end
