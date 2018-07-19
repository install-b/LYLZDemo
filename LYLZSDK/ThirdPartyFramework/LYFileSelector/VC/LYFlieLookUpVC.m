//
//  FlieLookUpVC.m
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYFlieLookUpVC.h"
#import <QuickLook/QuickLook.h>
#import "LYUnOpenFileView.h"
#import "LYFileObjModel.h"
#import "HPWYsonry.h"
#import "LYDownFileView.h"


@interface LYFlieLookUpVC ()
<UIDocumentInteractionControllerDelegate,
LYDownFileViewDelegate
>

@property (nonatomic,strong) LYFileObjModel *actualmodel;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) LYUnOpenFileView *unOpenfileView;
@property (nonatomic,strong) LYDownFileView *downView;

@end

@implementation LYFlieLookUpVC

- (instancetype)initWithFileModel:(LYFileObjModel *)fileModel;
{
    if ((fileModel.filePath == nil || [fileModel.filePath isEqualToString:@""]) && fileModel.fileUrl == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        _actualmodel = fileModel;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件详情";
    
    NSFileManager *manger = [NSFileManager defaultManager];
    __weak typeof(self) weakSelf = self;

    if ([manger fileExistsAtPath:_actualmodel.filePath]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf loadData];
        });
    }

    else{
        [self downView];
    }

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _documentInteraction = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [_unOpenfileView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.edges.hpwys_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        weakSelf.unOpenfileView.backgroundColor = [UIColor whiteColor];
        
    }];
    [_downView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.edges.hpwys_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        weakSelf.downView.backgroundColor = [UIColor whiteColor];
    }];
}

#pragma mark - open file
- (void)loadData{
    
    self.documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_actualmodel.filePath]];
    _documentInteraction.delegate = self;
    
    if(![self.documentInteraction presentPreviewAnimated:NO]){
        // 不能打开的文件
        __weak typeof(self) weakself = self;
        self.unOpenfileView.Clickblock = ^(LYFileObjModel *model){
            
            [weakself.documentInteraction presentOpenInMenuFromRect:weakself.view.frame
                                                             inView:weakself.view
                                                           animated:YES];
        };
    }
}

#pragma mark - LYDownFileViewDelegate
/**
 下载完成回调
 */
- (void)downFileView:(LYDownFileView *)downloadView didCompleteDownloadFile:(NSDictionary *)response {
    if (response) {
        _actualmodel.name = response[@"fileName"];
        _actualmodel.fileSize = response[@"fileSize"];
        _actualmodel.filePath = response[@"filePath"];
        [self loadData];
        if ([self.delegate respondsToSelector:@selector(fileLookUpVC:didDownLoadFileForFileModel:)]) {
            [self.delegate fileLookUpVC:self didDownLoadFileForFileModel:_actualmodel];
        }
    }else {
        //!self.downloadCompleteBlock ?: self.downloadCompleteBlock(downloadView.model);
        if ([self.delegate respondsToSelector:@selector(fileLookUpVC:didDownLoadFileError:)]) {
            [self.delegate fileLookUpVC:self didDownLoadFileError:[NSError errorWithDomain:@"下载失败" code:0 userInfo:nil]];
        }
    }
}

/**
 是否允许自动下载当前文件
 */
- (BOOL)downFileView:(LYDownFileView *)downloadView shouldAutoDownloadFileCurrentNet:(NSInteger)currentNet{
    return NO;
}
#pragma mark -UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;

}

// Preview presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
    
}
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Options menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller {
    
}
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    
}

// Open in menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    
}
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
}

// Synchronous.  May be called when inside preview.  Usually followed by app termination.  Can use willBegin... to set annotation.
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application {
    
}
- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application {
    
}

#pragma mark - lazy load
- (LYDownFileView *)downView {
    if (_downView == nil) {
        _downView = [[LYDownFileView alloc] init];
        _downView.model = _actualmodel;
        [self.view addSubview:_downView];
        _downView.delegate = self;
    }
    return _downView;
}
- (LYUnOpenFileView *)unOpenfileView
{
    if (_unOpenfileView == nil) {
        _unOpenfileView = [[LYUnOpenFileView alloc] init];
        _unOpenfileView.model =_actualmodel;
        [self.view addSubview:_unOpenfileView];
    }
    return _unOpenfileView;
}
@end
