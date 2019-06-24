//
//  ZFTool.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFEvent.h"
#import "ZFConfig.h"
#import "ZFAlertView.h"
#import "ZFAudioView.h"
#import "ZFTimerView.h"
#import "ZFTimer.h"
#import <ZFPlayer/ZFIJKPlayerManager.h>

@interface ZFEvent()

@property (nonatomic) NSInteger times;
@property (nonatomic, strong) ZFTimer *zftimer;
// 是不是关闭了定时播放 默认为 不开启定时播放
@property (nonatomic) BOOL isClose;
@property (nonatomic, strong) ZFPlayerController *player;

@end

@implementation ZFEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configTimer];
        _isClose = true;
    }
    return self;
}

+ (UIViewController*)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}


- (void)back: (ZFPlayerController *)player {
    [player stop];
    [[ZFEvent currentViewController].navigationController popViewControllerAnimated:YES];
}

// 各种功能处理
- (void)slectFunc: (ZFCoverModel *)model view: (ZFCoverView *)view palyer:(ZFPlayerController *)player toolView: (ZFBottomView *)toolView deleView: (ZFCustomControlView1 *)delView {
    self.player = player;
    switch (model.type) {
        case ZFVideoRate:
            view.alpha = 0;
            [self ratePlay:model.rateType text:model.text player:player view:toolView];
            break;
        case ZFVideoQX:
            view.alpha = 0;
            [self setQxUrl:delView.videos[player.currentPlayIndex] type:model.qxType palyer:player];
            break;
        case ZFVideoBackAudio:
            [self audioPlayType:model.videoPlayType player:player delView:delView];
            break;
        case ZFVideoTimer:
            [self timePlay:player];
            break;
        default:
            break;
    }
}

- (void)configTimer {
    _zftimer = [[ZFTimer alloc] init];
    __weak typeof(self) weakSelf = self;
    _zftimer.endAction = ^(NSInteger time) {
        if (weakSelf.isClose) {
            [weakSelf.player stop];
        }
    };
}

// 定时播放
- (void)timePlay: (ZFPlayerController *)play {
    ZFTimerView *timeView = [[ZFTimerView alloc] initWithFrame:play.controlView.bounds];
    timeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    timeView.tag = 10001; // 倒计时播放
    __weak typeof(self) weakSelf = self;
    timeView.time = ^(NSInteger time) {
        if (time == -1) {
            weakSelf.isClose = NO;
        } else if (time == 0) {
            weakSelf.isClose = YES;
            weakSelf.times = weakSelf.player.totalTime - weakSelf.player.currentTime;
        } else {
            weakSelf.isClose = YES;
            weakSelf.times = time;
        }
        [weakSelf.zftimer afterClose:weakSelf.times];
    };
    [play.controlView insertSubview:timeView atIndex:0];
}

// 音频播放
- (void)audioPlayType: (ZFVideoPlayType)type player: (ZFPlayerController *)player delView: (ZFCustomControlView1 *)delView {
    switch (type) {
        case ZFVideoPlayTypeBack:
            delView.isBack = YES;
            [self backgroundPlay:YES player:player del:delView];
            break;
        case ZFVideoPlayTypeVideo:
            delView.isBack = NO;
            [self backgroundPlay:NO player:player del:delView];
            break;
        default:
            break;
    }
}

- (void)backgroundPlay: (BOOL)isBack player: (ZFPlayerController *)play del: (ZFCustomControlView1 *)delView {
    ZFAudioView *view = [play.controlView viewWithTag:1000];
    if (isBack) { // 当前正处在音频播放 无需重新增加view
        if (view) {
            [ZFAlertView showtext:@"音频播放中..."];
            return;
        }
    }
    if (isBack) {
        view = [[ZFAudioView alloc] initWithFrame:play.controlView.bounds];
        view.backgroundColor = [UIColor blackColor];
        view.tag = 1000;
        view.delegate = delView;
        [play.controlView insertSubview:view atIndex:0];
    } else {
        [view removeFromSuperview];
    }
}

- (void)resetFramePlayer: (UIView *)cview {
    ZFAudioView *view = [cview viewWithTag:1000];
    view.frame = cview.bounds;
    [view resetFrame];
    
    ZFTimerView *timerView = [cview viewWithTag:10001];
    timerView.frame = cview.bounds;
    [timerView resetFrame];
}

// 切换清晰度
- (void)setQxUrl: (ZFCoverModel *)model type: (ZFVideoPlayQx)type palyer:(ZFPlayerController *)player {
    NSString *qxURl = @"";
    switch (type) {
        case ZFVideoPlayHeight:
            qxURl = model.heightUrl;
            break;
        case ZFVideoPlayMiddle:
            qxURl = model.playUrl;
            break;
        case ZFVideoPlaylow:
            qxURl = model.lowUrl;
            break;
        default:
            qxURl = model.playUrl;
            break;
    }
    NSTimeInterval time = player.currentTime;
    player.assetURL = [NSURL URLWithString:qxURl];
    [self seekPostion:time player:player];
}

// 切换URL 后快
- (void)seekPostion: (NSTimeInterval)time player: (ZFPlayerController *)player {
    [player seekToTime:time completionHandler:^(BOOL finished) {}];
}

// 倍速
- (void)ratePlay: (ZFVideoPlayRate)type text: (NSString *)text player: (ZFPlayerController *)player view: (ZFBottomView *)view {
    CGFloat rate = 1.0;
    switch (type) {
        case ZFVideoRate8X:
            rate = 0.8;
            break;
        case ZFVideoRate1X:
            rate = 1.0;
            break;
        case ZFVideoRate25X:
            rate = 1.25;
            break;
        case ZFVideoRate5X:
            rate = 1.5;
            break;
        case ZFVideoRate2X:
            rate = 2.0;
            break;
        default:
            break;
    }
    [view setRateText:text];
    player.currentPlayerManager.rate = rate;
}


@end
