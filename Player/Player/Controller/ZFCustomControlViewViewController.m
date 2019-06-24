//
//  ZFCustomControlViewViewController.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2019/6/5.
//  Copyright © 2019 紫枫. All rights reserved.
//

#import "ZFCustomControlViewViewController.h"
#import "ZFVideo.h"
#import "ZFCoverModel.h"
#import "ZFConfig.h"

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface ZFCustomControlViewViewController ()

@property (nonatomic, strong) ZFVideo *zf_video;

@end

@implementation ZFCustomControlViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusView];
    
    CGFloat x = 0;
    CGFloat y = 20;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    CGRect frame = CGRectMake(x, y, w, h);
    
    UIImageView *playerView = [[UIImageView alloc] initWithFrame:frame];
    [self.view addSubview:playerView];
    
    _zf_video =[[ZFVideo alloc] initContinerView:playerView];
    

//    @weakify(self)
//    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
//        @strongify(self)
//        [self setNeedsStatusBarAppearanceUpdate];
//    };
//
//    /// 播放完成
//    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
//        @strongify(self)
//        [self.player.currentPlayerManager replay];
//        [self.player playTheNext];
//        if (!self.player.isLastAssetURL) {
//            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
//            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
//        } else {
//            [self.player stop];
//        }
//    };

    
    ZFCoverModel *mModel3 = [[ZFCoverModel alloc] init];
    mModel3.text = @"分享";
    mModel3.playUrl = @"http://cdnaliyunv.zhongye.net/201904/1d6a2530-9b86-4660-b575-4795185a8201/67187ef5-2fbd-4bb6-9d51-ad126fcc5e09/output.m3u8";
    mModel3.heightUrl = @"http://cdnaliyunv.zhongye.net/201904/1d6a2530-9b86-4660-b575-4795185a8201/67187ef5-2fbd-4bb6-9d51-ad126fcc5e09/output.m3u8";
    mModel3.lowUrl = @"http://cdnaliyunv.zhongye.net/201904/1d6a2530-9b86-4660-b575-4795185a8201/67187ef5-2fbd-4bb6-9d51-ad126fcc5e09/output.m3u8";
    [_zf_video playWithData:mModel3];
    // 配置清晰度 更多 倍速 默认数据
    _zf_video.qxs = [ZFConfig shareInstance].qxArray;
    _zf_video.moreMeuns = [ZFConfig shareInstance].moreArray;
    _zf_video.rates = [ZFConfig shareInstance].ratesArray;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 400, 40, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:btn];

}

- (void)btnClick {
    ZFCoverModel *mModel3 = [[ZFCoverModel alloc] init];
    mModel3.text = @"分享";
    mModel3.playUrl = @"http://cdnaliyunv.zhongye.net/201904/1d6a2530-9b86-4660-b575-4795185a8201/67187ef5-2fbd-4bb6-9d51-ad126fcc5e09/output.m3u8";
    [_zf_video playWithData:mModel3];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_zf_video viewWillAppear];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_zf_video viewWillDisappear];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}




- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}
//
//- (BOOL)prefersStatusBarHidden {
//    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
//    return NO;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}
//
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
