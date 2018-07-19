//
//  LYAssetViewController.m
//  TaiYangHua
//
//  Created by Lc on 16/2/16.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYAssetViewController.h"
#import "LYAssetCell.h"
#import "LYAsset.h"
#import "UIView+Frame.h"
#import "UIColor+HexColor.h"
#import "HPWYsonry.h"
#import "HPWYSProgressHUD.h"
#import "UIImage+Bundle.h"
#import "UIImageView+AssetImage.h"

#define toolbarHeight 44

@interface LYAssetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LYAsset *internalAsset;
@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *senderButton;

// 当前图片索引
@property (assign, nonatomic) NSInteger lastItem;

@end

@implementation LYAssetViewController

static NSString * const LYAssetViewCellId = @"LYAssetViewCellId";
static UIButton *selectedButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupCollectionView];
    [self setupToolbar];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 进入界面按钮的显示状态
    LYAsset *internalAsset = self.assetArray[self.index];
    selectedButton.selected = internalAsset.isSelected;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateSenderButtonStatus];
}

- (void)setupNav
{
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage lyt_selectorImageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(clickBackButton)];
    UIButton *backBtn = [[UIButton alloc] init];
    //[backBtn setImage:[UIImage lyt_selectorImageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [selectedButton setBackgroundImage:[UIImage lyt_selectorImageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateSelected];
    [selectedButton setBackgroundImage:[UIImage lyt_selectorImageNamed:@"photo_original_def"] forState:UIControlStateNormal];
    
    [selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchDown
     ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectedButton];
}

- (void)setupToolbar
{
    // 底部工具条
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - toolbarHeight - 64 , self.view.width, toolbarHeight)];
    toolbar.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [self.view addSubview:toolbar];
    
    // 原图按钮
    UIButton *originalButton = [[UIButton alloc] init];
    [originalButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [originalButton setTitle:@"原图" forState:UIControlStateNormal];
    [originalButton setTitleColor:LYColor(93, 93, 93) forState:UIControlStateNormal];
    [originalButton setTitleColor:LYColor(224, 224, 224) forState:UIControlStateSelected];
    [originalButton setImage:[UIImage lyt_selectorImageNamed:@"preview_original_def"] forState:UIControlStateNormal];
    [originalButton setImage:[UIImage lyt_selectorImageNamed:@"photo_original_sel"] forState:UIControlStateSelected];
    [originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [originalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [originalButton addTarget:self action:@selector(clickOriginalButton:) forControlEvents:UIControlEventTouchUpInside];
    _originalButton = originalButton;
    [toolbar addSubview:_originalButton];
    [_originalButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(toolbar).offset(10);
        make.width.equalTo(@(120));
        make.centerY.equalTo(toolbar);
    }];
    
    // 发送按钮
    UIButton *senderButton = [[UIButton alloc] init];
    [senderButton setTitle:@"发送" forState:UIControlStateDisabled];
    [senderButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [senderButton setTitleColor:LYColor(93, 93, 93) forState:UIControlStateDisabled];
    [senderButton setTitleColor:LYColor(224, 224, 224) forState:UIControlStateNormal];
    [senderButton setEnabled:NO];
    [senderButton addTarget:self action:@selector(clickSenderButton) forControlEvents:UIControlEventTouchUpInside];
    _senderButton = senderButton;
    [toolbar addSubview:_senderButton];
    [_senderButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.right.equalTo(toolbar).offset(-10);
        make.centerY.equalTo(toolbar);
    }];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(self.view.width, self.view.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - toolbarHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolbarHeight) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor blackColor];

    [collectionView registerClass:[LYAssetCell class] forCellWithReuseIdentifier:LYAssetViewCellId];
    [self.view addSubview:collectionView];
    
    // 进入当前控制器后,显示的图片
    [collectionView setContentOffset:CGPointMake(self.view.width * self.index, 0)];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYAssetViewCellId forIndexPath:indexPath];
    LYAsset *internalAsset = self.assetArray[indexPath.item];

//    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat multiple = [UIScreen mainScreen].scale;
//    
//    CGFloat aspectRatio = internalAsset.asset.pixelWidth / (CGFloat)internalAsset.asset.pixelHeight;
//    CGFloat pixelWidth = photoWidth * multiple;
//    CGFloat pixelHeight = pixelWidth / aspectRatio;
//    
//    [[PHImageManager defaultManager] requestImageForAsset:internalAsset.asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        cell.imageView.image = result;
//    }];
    [cell.imageView setImageWithAsset:internalAsset.asset];
    
    // 存储当前显示的图片和索引
    self.internalAsset = internalAsset;
    self.lastItem = indexPath.item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果相等,代表cell没有更换
    if (indexPath.item == self.lastItem) return;
    LYAsset *internalAsset = self.assetArray[self.lastItem];
    selectedButton.selected = internalAsset.isSelected;
    
    // 滚动后,计算当前图片的大小
    if (self.originalButton.selected == YES) {
        [self.originalButton setTitle:[NSString stringWithFormat:@"%@(%@)", @"原图", self.internalAsset.bytes]forState:UIControlStateSelected];
    }
}

// 页码设置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self collectionViewDidEndScroll:scrollView];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self collectionViewDidEndScroll:scrollView];
    
}
- (void)collectionViewDidEndScroll:(UIScrollView *)scrollView {
    self.index =  (NSInteger)(scrollView.contentOffset.x / scrollView.width);
    //self.pageControl.currentPage = (NSInteger)(collectionView.contentOffset.x / collectionView.width);
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    selectedButton.selected = [(LYAsset *)self.assetArray[index] isSelected];
}


#pragma mark - AllButtonAction
- (void)clickOriginalButton:(UIButton *)button
{
    button.selected = !button.isSelected;
    
    // 点击后,计算当前图片的大小
    if (button.isSelected == YES) {
        [button setTitle:[NSString stringWithFormat:@"%@(%@)", @"原图", self.internalAsset.bytes]forState:UIControlStateSelected];
    }
}

- (void)clickBackButton
{
    if ([self.delegate respondsToSelector:@selector(AssetViewController:selectedItemsInAssetViewController:)]) {
        [self.delegate AssetViewController:self selectedItemsInAssetViewController:self.selectedItems];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSenderButton
{
    
    if ([self.delegate respondsToSelector:@selector(AssetViewController:didClickSenderButton:)]) {
        [self.delegate AssetViewController:self didClickSenderButton:self.selectedItems];
    }
}

- (void)clickSelectedButton:(UIButton *)selectedButton
{
    BOOL selected = !selectedButton.isSelected;
    if (selected == YES) {
        NSInteger maxCount = [self.delegate maxSelectedCount];
        if (self.selectedItems.count >= maxCount) {
//#warning HUD
            [HPWYSProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"图片最多选择%zd张",maxCount]];
            //[MBProgressHUD showError:[NSString stringWithFormat:@"图片最多选择%zd张",maxCount]];
            return;
        }	
    }
    
    selectedButton.selected = !selectedButton.isSelected;
    // 当前显示的图片
    LYAsset *internalAsset = self.assetArray[self.index];
    internalAsset.selected = selectedButton.isSelected;
    
    // 添加/删除
    if (internalAsset.isSelected) {
        [self.selectedItems addObject:internalAsset];
    } else {
        [self.selectedItems removeObject:internalAsset];
    }
    
    [self updateSenderButtonStatus];
    
}
// 更新按钮的状态
- (void)updateSenderButtonStatus
{
    if (self.selectedItems.count == 0) {
        self.senderButton.enabled = NO;
    } else {
        self.senderButton.enabled = YES;
        [self.senderButton setTitle:[NSString stringWithFormat:@"(%ld)%@", (unsigned long)self.selectedItems.count, @"发送"] forState:UIControlStateNormal];
    }
}

@end
