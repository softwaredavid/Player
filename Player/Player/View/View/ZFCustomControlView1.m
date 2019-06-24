//
//  ZFCustomControlView1.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2019/6/5.
//  Copyright © 2019 紫枫. All rights reserved.
//

#import "ZFCustomControlView1.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayer.h>
#import "ZFSliderView.h"
#import "UIImageView+ZFCache.h"
#import "ZFTopView.h"
#import "ZFBottomView.h"
#import "ZFFastView.h"
#import "ZFCoverView.h"
#import "ZFVolumeBrightnessView.h"
#import "ZFConfig.h"
#import "ZFEvent.h"
#import "ZFContinuePlayView.h"
#import "ZFloadFailView.h"
#import <ZFPlayer/ZFOrientationObserver.h>

@interface ZFCustomControlView1 () <ZFSliderViewDelegate,ZFBDelegate,BottomDelegate>
/// 底部工具栏
@property (nonatomic, strong) ZFBottomView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong) ZFTopView *topToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;
// 选择view
@property (nonatomic, strong) ZFCoverView *coverView;
// 继续播放的view
@property (nonatomic, strong) ZFContinuePlayView *continueView;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, assign) BOOL controlViewAppeared;
@property (nonatomic, strong) dispatch_block_t afterBlock;
/// 加载loading
@property (nonatomic, strong) ZFSpeedLoadingView *activity;
@property (nonatomic, strong) ZFloadFailView *failView;
@property (nonatomic, assign) CGFloat sumTime;
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
// 快进 快退 view
@property (nonatomic, strong) ZFFastView *fastView;
@property (nonatomic, strong) ZFVolumeBrightnessView *volumeBrightnessView;
@property (nonatomic, strong) ZFOrientationObserver *observer;
// 事件处理
@property (nonatomic, strong) ZFEvent *event;

@end

@implementation ZFCustomControlView1
@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
        [self makeSubViewsAction];
        
        self.autoFadeTimeInterval = 0.2;
        self.autoHiddenTimeInterval = 2.5;
        
        [self resetControlView];
        self.clipsToBounds = YES;
        _isBack = NO;
        _event = [[ZFEvent alloc] init];
    }
    return self;
}

// 添加子控件
- (void)addSubviews {
    [self addSubview:self.topToolView];
    [self addSubview:self.bottomToolView];
    [self addSubview:self.activity];
    [self addSubview:self.playOrPauseBtn];
    [self addSubview:self.fastView];
    [self addSubview:self.volumeBrightnessView];
    [self addSubview:self.lockBtn];
    [self addSubview:self.coverView];
    [self addSubview:self.continueView];
    [self addSubview:self.failView];
}

- (void)makeSubViewsAction {
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
    [self.bottomToolView setButtonStatus:selected];
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

#pragma mark - 添加子控件约束

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    self.coverImageView.frame = self.bounds;
    self.bgImgView.frame = self.bounds;
    
    min_w = 80;
    min_h = 80;
    self.activity.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.activity.zf_centerX = self.zf_centerX;
    self.activity.zf_centerY = self.zf_centerY + 10;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = (iPhoneX && self.player.isFullScreen) ? 80 : 40;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_h = (iPhoneX && self.player.isFullScreen) ? 100 : 40;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_y = min_view_h - min_h - 25;
    min_h = -200;
    self.continueView.frame = CGRectMake(min_x, min_y, 240, 30);
    
    min_x = 0;
    min_y = 0;
    min_w = 44;
    min_h = min_w;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.center = self.center;
    
    min_w = 140;
    min_h = 80;
    self.fastView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fastView.center = self.center;
    
    min_x = 0;
    min_y = iPhoneX ? 54 : 30;
    min_w = 170;
    min_h = 35;
    self.volumeBrightnessView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.volumeBrightnessView.zf_centerX = self.zf_centerX;
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.zf_centerY = self.zf_centerY;
    
    self.coverView.frame = CGRectMake(0, 0, self.zf_width, self.zf_height);
    self.coverView.alpha = 0;
    [self.bottomToolView hiddeQxbtn:_isBack];
    [_event resetFramePlayer: self];
    
    self.failView.frame = CGRectMake(0, 0, 150, 30);
    self.failView.zf_centerX = self.zf_centerX;
    self.failView.zf_centerY = self.zf_centerY;
    self.failView.hidden = YES;
    
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        self.playOrPauseBtn.alpha = 0;
        self.lockBtn.alpha = 0;
    } else {
        self.topToolView.zf_y = 0;
        self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        if (_isBack) {
            self.playOrPauseBtn.alpha = 0;
        } else {
            self.playOrPauseBtn.alpha = 1;
        }
        self.lockBtn.alpha = 1;
    }
}

#pragma mark - private
/** 重置ControlView */
- (void)resetControlView {
    self.lockBtn.alpha               = 1;
    self.bottomToolView.alpha        = 1;
    [self.bottomToolView resetContent];
    self.backgroundColor             = [UIColor clearColor];
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    if (_isBack) {
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.playOrPauseBtn.alpha = 1;
    }
    self.isShow                      = YES;
    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.player.statusBarHidden      = NO;
}

- (void)hideControlView {
    self.lockBtn.alpha               = 0;
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.playOrPauseBtn.alpha        = 0;
}

// 展示上次继续播放的视屏
- (void)showContinueView: (NSString *)text {
    [self.continueView setTime:text];
    [UIView animateWithDuration:0.5 animations:^{
        self.continueView.zf_x = 10;
        self.continueView.alpha = 1;
    }];
    // 不点及关闭2秒 后自动隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenContinueView];
    });
}

// 展示上次继续播放的视屏
- (void)hiddenContinueView {
    [self.continueView disMiss];
}

- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    @weakify(self)
    self.afterBlock = dispatch_block_create(0, ^{
        @strongify(self)
        [self hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoHiddenTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = NO;
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {}];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    [self autoFadeOutControlView];
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {}];
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    UIView *touchView = touch.view;
    if ([touchView isKindOfClass:[UIButton class]] || [touchView isKindOfClass:[ZFSliderView class]]) {
        return NO;
    }
    return YES;
}

/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode {
   // UIImage *placeholder = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:self.bgImgView.bounds.size];
    UIImage *placeHolder = [UIImage imageNamed:@"play_default_img.jpg"];
    [self resetControlView];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    [self.coverImageView setImageWithURLString:coverUrl placeholder:placeHolder];
    [self.bgImgView setImageWithURLString:coverUrl placeholder:placeHolder];
}

- (void)sliderValueChangingValue:(CGFloat)value isForward:(BOOL)forward {
    /// 显示控制层
    [self showControlViewWithAnimated:NO];
    [self cancelAutoFadeOutControlView];
    UIImage *img;
    self.fastView.hidden = NO;
    self.fastView.alpha = 1;
    if (forward) {
        img = ZFPlayer_Image(@"ZFPlayer_fast_forward");
    } else {
        img = ZFPlayer_Image(@"ZFPlayer_fast_backward");
    }
    NSString *draggedTime = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    NSString *totalTime = [ZFUtilities convertTimeSecond:self.player.totalTime];
    [self.fastView setCurrentTime:draggedTime totalTime:totalTime progress:value img:img];
    [self.bottomToolView setProgress:value currentTime:draggedTime totalTime:totalTime isSlider:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:0.1];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformMakeTranslation(forward?8:-8, 0);
    }];
    
}

/// 隐藏快进视图
- (void)hideFastView {
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformIdentity;
        self.fastView.alpha = 0;
    } completion:^(BOOL finished) {
        self.fastView.hidden = YES;
    }];
}

#pragma mark - ZFPlayerControlViewDelegate
/// 手势筛选，返回NO不响应该手势
- (BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(nonnull UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen && gestureType != ZFPlayerGestureTypeSingleTap) {
        return NO;
    }
    return [self shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
}

/// 单击手势事件
- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (self.player.lockedScreen) {
        [self hideControlViewWithAnimated:YES];
        self.lockBtn.alpha = 1;
        return;
    }
    if (!self.player) return;
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen) {
        [self.player enterFullScreen:YES animated:YES];
    } else {
        if (self.controlViewAppeared) {
            [self hideControlViewWithAnimated:YES];
        } else {
            /// 显示之前先把控制层复位，先隐藏后显示
            [self hideControlViewWithAnimated:NO];
            [self showControlViewWithAnimated:YES];
        }
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl {
    [self playPauseButtonClickAction:self.playOrPauseBtn];
}

/// 开始滑动手势事件
- (void)gestureBeganPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location {
    if (direction == ZFPanDirectionH) {
        self.sumTime = self.player.currentTime;
    }
}

/// 滑动中手势事件
- (void)gestureChangedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location withVelocity:(CGPoint)velocity {
    if (direction == ZFPanDirectionH) {
        // 每次滑动需要叠加时间
        self.sumTime += velocity.x / 200;
        // 需要限定sumTime的范围
        NSTimeInterval totalMovieDuration = self.player.totalTime;
        if (totalMovieDuration == 0) return;
        if (self.sumTime > totalMovieDuration) self.sumTime = totalMovieDuration;
        if (self.sumTime < 0) self.sumTime = 0;
        BOOL style = NO;
        if (velocity.x > 0) style = YES;
        if (velocity.x < 0) style = NO;
        if (velocity.x == 0) return;
        [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
    } else if (direction == ZFPanDirectionV) {
        if (location == ZFPanLocationLeft) { /// 调节亮度
            self.player.brightness -= (velocity.y) / 10000;
            [self.volumeBrightnessView updateProgress:self.player.brightness withVolumeBrightnessType:ZFVolumeBrightnessTypeumeBrightness];
        } else if (location == ZFPanLocationRight) { /// 调节声音
            self.player.volume -= (velocity.y) / 10000;
            [self.volumeBrightnessView updateProgress:self.player.volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
        }
    }
}

/// 滑动结束手势事件
- (void)gestureEndedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location {
    @weakify(self)
    if (direction == ZFPanDirectionH && self.sumTime >= 0 && self.player.totalTime > 0) {
        [self.player seekToTime:self.sumTime completionHandler:^(BOOL finished) {
            @strongify(self)
            /// 左右滑动调节播放进度
            [self.bottomToolView sliderEnd];
            if (self.controlViewAppeared) {
                [self autoFadeOutControlView];
            }
        }];
        self.sumTime = 0;
    }
}

/// 捏合手势事件，这里改变了视频的填充模式
- (void)gesturePinched:(ZFPlayerGestureControl *)gestureControl scale:(float)scale {
    if (scale > 1) {
        self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    } else {
        self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
    }
}

/// 准备播放
- (void)videoPlayer:(ZFPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL {
    [self hideControlViewWithAnimated:NO];
}

/// 播放状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state {
    self.failView.hidden = YES;
    if (state == ZFPlayerPlayStatePlaying) {
        [self playBtnSelectedState:YES];
        /// 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled) {
            [self.activity startAnimating];
        } else if ((videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled || videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStatePrepare)) {
            [self.activity startAnimating];
        }
    } else if (state == ZFPlayerPlayStatePaused) {
        [self playBtnSelectedState:NO];
        /// 暂停的时候隐藏loading
        [self.activity stopAnimating];
    } else if (state == ZFPlayerPlayStatePlayFailed) {
        [self.activity stopAnimating];
        self.failView.hidden = NO;
    }
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
    } else if (state == ZFPlayerLoadStatePlaythroughOK || state == ZFPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
        self.player.currentPlayerManager.view.backgroundColor = [UIColor blackColor];
    }
    if (state == ZFPlayerLoadStateStalled && videoPlayer.currentPlayerManager.isPlaying) {
        [self.activity startAnimating];
    } else if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    [self.activity stopAnimating];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
    NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
    [self.bottomToolView setProgress:videoPlayer.progress currentTime:currentTimeString totalTime:totalTimeString isSlider:NO];
}

/// 缓冲改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    [self.bottomToolView setBufferValue:videoPlayer.bufferProgress];
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    
}

/// 视频view即将旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationWillChange:(ZFOrientationObserver *)observer {
    if (videoPlayer.isSmallFloatViewShow) {
        if (observer.isFullScreen) {
            self.controlViewAppeared = NO;
            [self cancelAutoFadeOutControlView];
        }
    }
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

/// 视频view已经旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationDidChanged:(ZFOrientationObserver *)observer {
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
    [self layoutIfNeeded];
    [self setNeedsDisplay];
}

/// 锁定旋转方向
- (void)lockedVideoPlayer:(ZFPlayerController *)videoPlayer lockedScreen:(BOOL)locked {
    [self showControlViewWithAnimated:YES];
}

#pragma mark - setter
- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
    [self screenObserver];
    /// 解决播放时候黑屏闪一下问题
    [player.currentPlayerManager.view insertSubview:self.bgImgView atIndex:0];
    [player.currentPlayerManager.view insertSubview:self.coverImageView atIndex:1];
    self.coverImageView.frame = player.currentPlayerManager.view.bounds;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bgImgView.frame = player.currentPlayerManager.view.bounds;
    self.bgImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma delegate

- (void)buttonClick:(ZFCoverViewType)type button:(nonnull UIButton *)btn {
    self.coverView.rates = self.rates;
    self.coverView.qxs = self.qxs;
    self.coverView.videos = self.videos;
    self.coverView.moreMeuns = self.moreMeuns;
    self.coverView.alpha = 1;
    if (_isBack) {
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.playOrPauseBtn.alpha = 1;
    }
    if (type == ZFCoverViewBack) { // 返回
        [_event back:self.player];
    } else {
        self.coverView.type = type;
    }
}

- (void)slectFunc: (ZFCoverModel *)model {
    if (_isBack) {
        self.coverView.alpha = 0;
    }
    [_event slectFunc: model view: self.coverView palyer:self.player toolView: self.bottomToolView deleView:self];
}

#pragma bottomview delegate

- (void)sliderTouchBegan:(float)value slider: (ZFSliderView *)sliderView {
    sliderView.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value slider: (ZFSliderView *)sliderView {
    if (self.player.totalTime > 0) {
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            if (finished) {
                sliderView.isdragging = NO;
            }
        }];
    } else {
        sliderView.isdragging = NO;
    }
}

- (NSString *)sliderValueChanged:(float)value slider: (ZFSliderView *)sliderView {
    if (self.player.totalTime == 0) {
        sliderView.value = 0;
        return nil;
    }
    sliderView.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    return currentTimeString;
}

- (void)sliderTapped:(float)value slider: (ZFSliderView *)sliderView {
    if (self.player.totalTime > 0) {
        sliderView.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                sliderView.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        sliderView.isdragging = NO;
        sliderView.value = 0;
    }
}

- (void)pause: (UIButton *)btn {
    btn.isSelected ? [self.player.currentPlayerManager play] :[self.player.currentPlayerManager pause];
}

- (void)fullScreen {
    [self.player enterFullScreen:!self.player.isFullScreen animated:NO];
}

#pragma mark - 屏幕旋转事件处理

- (void)screenObserver {
    __weak typeof(self) weakSelf = self;
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        weakSelf.topToolView.isFullScreen = isFullScreen;
        weakSelf.bottomToolView.isFullScreen = isFullScreen;
    };
}

#pragma mark - getter

- (ZFSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[ZFSpeedLoadingView alloc] init];
    }
    return _activity;
}

- (ZFloadFailView *)failView {
    if (!_failView) {
        _failView = [[ZFloadFailView alloc] init];
        __weak typeof(self) weakSelf = self;
        _failView.reload = ^{
            [weakSelf.player.currentPlayerManager reloadPlayer];
        };
    }
    return _failView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"new_allPlay_44x44_") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"new_allPause_44x44_") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (ZFTopView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[ZFTopView alloc] init];
        _topToolView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _topToolView.enterFullScreen = ^{
            [weakSelf.player enterFullScreen:!weakSelf.player.isFullScreen animated:YES];
        };
    }
    return _topToolView;
}

- (ZFBottomView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[ZFBottomView alloc] init];
        _bottomToolView.delegate = self;
        _bottomToolView.bottomDelegate = self;
    }
    return _bottomToolView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (ZFFastView *)fastView {
    if (!_fastView) {
        _fastView = [[ZFFastView alloc] init];
        _fastView.hidden = YES;
    }
    return _fastView;
}

- (ZFVolumeBrightnessView *)volumeBrightnessView {
    if (!_volumeBrightnessView) {
        _volumeBrightnessView = [[ZFVolumeBrightnessView alloc] init];
        _volumeBrightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _volumeBrightnessView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn.alpha = 0;
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (ZFCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[ZFCoverView alloc] init];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _coverView.delegate = self;
    }
    return _coverView;
}

- (ZFContinuePlayView *)continueView {
    if (!_continueView) {
        _continueView = [[ZFContinuePlayView alloc] init];
        _continueView.layer.masksToBounds = YES;
        _continueView.layer.cornerRadius = 3;
        _continueView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _continueView.alpha = 0;
        __weak typeof(self) weakSelf = self;
        _continueView.begainAct = ^{ // 重新开始
            [weakSelf.player seekToTime:0 completionHandler:^(BOOL finished) {}];
        };
    }
    return _continueView;
}

@end
