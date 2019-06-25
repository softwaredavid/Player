//
//  ZFVideo.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFVideo.h"
#import "ZFCoverModel.h"
#import "ZFCustomControlView1.h"
#import "UIImageView+ZFCache.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import "ZFEvent.h"
#import "ZFUtilities.h"
#import "RemoteTool.h"
#import "PlayerTool.h"
#import "ZFTimer.h"
#import "ZFReplayView.h"

// http://pte6fikwt.bkt.clouddn.com/play_default_img.jpg
static NSString *kVideoCover = @"htt";

@interface ZFVideo()<RemoteDelegate>

@property (nonatomic, strong) ZFIJKPlayerManager *playerManager;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFCoverModel *curentModel;
@property (nonatomic, strong) RemoteTool *remoteTools;
@property (nonatomic, strong) ZFCustomControlView1 *view;
@property (nonatomic, strong) UIImageView *stopView;
@property (nonatomic, assign) NSInteger lastPlayIndex;

@end

@implementation ZFVideo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _remoteTools = [[RemoteTool alloc] init];
        _remoteTools.delegate = self;
        _lastPlayIndex = -1;
        [self addNotify];
    }
    return self;
}

- (instancetype)initContinerView: (UIImageView *)view {
    self = [self init];
    if (self) {
        self.view = [ZFCustomControlView1 new];
        _playerManager = [[ZFIJKPlayerManager alloc] init];
        _player = [ZFPlayerController playerWithPlayerManager:_playerManager containerView:view];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_ERROR];
        [IJKFFMoviePlayerController setLogReport:NO];
        _stopView = view;
        
        [view setImageWithURLString:kVideoCover placeholder:[UIImage imageNamed:@"play_default_img.jpg"]];
        _player.controlView = self.view;
        _player.pauseWhenAppResignActive = NO;
    }
    return self;
}

#pragma 播放器配置

- (void)setTitle: (NSString *)title bgImg: (NSString *)bgImg currentVideo: (ZFCoverModel *)model {
    self.curentModel = model;
    [self.view showTitle:title coverURLString:bgImg fullScreenMode:ZFFullScreenModeAutomatic];
    for (ZFCoverModel *item in self.videos) {
        if ([item.videoId isEqualToString:model.videoId]) {
            item.isSelected = YES;
        } else {
            item.isSelected = NO;
        }
    }
    [self configPlayer];
}

// 继续上次播放
- (void)configPlayer {
    __weak typeof(self) weakSelf = self;
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        NSTimeInterval current = currentTime;
        if (currentTime >= duration - 10) { // 播放结束从头开始
            current = 0;
        }
        weakSelf.lastPlayIndex = weakSelf.player.currentPlayIndex;
        [ZFTimer saveTime:current key:weakSelf.curentModel.videoId];
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        weakSelf.curentModel = [weakSelf getCurrentPlayData];
        NSTimeInterval time = [ZFTimer getTime:weakSelf.curentModel.videoId];
        if (!weakSelf.curentModel.isContinuePlay) {
            time = 0;
        } else {
            if (time > 1 &&  weakSelf.player.currentPlayIndex != weakSelf.lastPlayIndex) {
                NSString *textTime = [ZFUtilities convertTimeSecond:time];
                [weakSelf.view showContinueView:textTime];
            }
        }
        [weakSelf.player seekToTime:time completionHandler:^(BOOL finished) {}];
    };
    
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        if ([weakSelf isLast]) {
           // [weakSelf.player stop];
           // [weakSelf replayView];
        } else {
            [weakSelf.player playTheNext];
            [weakSelf.delegate currentPlayIndex:weakSelf.player.currentPlayIndex];
        }
    };
}

- (void)viewWillAppear {
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear {
    self.player.viewControllerDisappear = YES;
}


# pragma 数据配置

- (void)playWithData: (ZFCoverModel *)model {
    NSString *URLString = [model.playUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:URLString];
    _player.assetURLs = @[url];
    [self setTitle:model.text bgImg:model.img currentVideo:model];
    [self playIndex:0];
    self.videos = @[model];
}

- (void)playWithDatas: (NSArray<ZFCoverModel *> *)datas index: (NSInteger)index  {
    NSInteger playIndex = index;
    _player.assetURLs = [self getUrlsArray:datas];
    if (index > _player.assetURLs.count || index < 0) {
        playIndex = 0;
    }
    ZFCoverModel *model = datas[playIndex];
    [self setTitle:model.text bgImg:model.img currentVideo:model];
    [self playIndex:playIndex];
    self.videos = datas;
}

- (void)playIndex: (NSInteger)index {
    [_player playTheIndex:index];
}

- (BOOL)isLast {
    if (self.player.assetURLs.count == 0) {
        return YES;
    }
    return _player.isLastAssetURL;
}

- (BOOL)isFirst {
    if (self.player.assetURLs.count == 0) {
        return YES;
    }
    return _player.isFirstAssetURL;
}

- (NSMutableArray *)getUrlsArray: (NSArray<ZFCoverModel *> *)datas {
    NSMutableArray *array = [NSMutableArray array];
    for (ZFCoverModel *model in datas) {
        NSString *urlStr = model.playUrl;
        NSURL *url = [NSURL URLWithString:urlStr];
        [array addObject:url];
    }
    return array;
}

- (ZFCoverModel *)getCurrentPlayData {
    NSInteger index = _player.currentPlayIndex;
    if (index < _videos.count) {
        return  _videos[index];
    }
    return nil;
}


#pragma 远程控制

- (void)addCommand {
    if ([self isLast]) {
        [_remoteTools removeNextCommand];
    } else {
        [_remoteTools addNextCommond];
    }
    if ([self isFirst]) {
        [_remoteTools removePreviousCommand];
    } else {
        [_remoteTools addPrevousCommand];
    }
}

- (void)nextModel: (RemoteData)act {
    [self.player playTheNext];
    [self addCommand];
    RemoteModel *model = [PlayerTool covertData:[self getCurrentPlayData]];
    act(model);
}

- (void)previousModel: (RemoteData)act {
    [self.player playThePrevious];
    [self addCommand];
    RemoteModel *model = [PlayerTool covertData:[self getCurrentPlayData]];
    act(model);
}

- (void)stop {
    [self.player.currentPlayerManager pause];
}

- (void)play {
    [self.player.currentPlayerManager play];
}

- (void)addNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBack)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leaveBack)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)enterBack {
    [_remoteTools addRemote];
    RemoteModel *model = [PlayerTool covertData:self.curentModel];
    model.totalTime = [NSString stringWithFormat:@"%f",_player.totalTime];
    model.currtentTime = [NSString stringWithFormat:@"%f",_player.currentTime];
    [RemoteTool updateInfo:model];
    if (!self.videos || self.videos.count <= 1) {
        [_remoteTools removePreviousCommand];
        [_remoteTools removeNextCommand];
    }
}

- (void)leaveBack {
    [_remoteTools removeAll];
}

#pragma 数据配置

- (void)setView:(ZFCustomControlView1 *)view {
    if (view) {
        _view = view;
        _view.qxs = self.qxs;
        _view.moreMeuns = self.moreMeuns;
        _view.rates = self.rates;
        _view.videos = self.videos;
        _player = _view.player;
    }
}

- (void)setQxs:(NSArray *)qxs {
    if (qxs) {
        _qxs = qxs;
        self.view.qxs = qxs;
    }
}

- (void)setRates:(NSArray *)rates {
    if (rates) {
        _rates = rates;
        self.view.rates = rates;
    }
}

- (void)setVideos:(NSArray *)videos {
    if (videos) {
        _videos = videos;
        self.view.videos = videos;
    }
}

- (void)setMoreMeuns:(NSArray *)moreMeuns {
    if (moreMeuns) {
        _moreMeuns = moreMeuns;
        self.view.moreMeuns = moreMeuns;
    }
}

#pragma replay
- (void)replayView {
    ZFReplayView *replay = [[ZFReplayView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    replay.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    __weak typeof(self) weakSelf = self;
    replay.replay = ^{
        [weakSelf playWithData:weakSelf.curentModel];
    };
    [_stopView addSubview:replay];
}

#pragma delloc

- (void)dealloc
{
    [_remoteTools removeAll];
}

@end
