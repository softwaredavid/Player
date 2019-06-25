//
//  ZFBottomView.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/11.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFBottomView.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayer.h>

@interface ZFBottomView()<ZFSliderViewDelegate>
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 暂停按钮
@property (nonatomic, strong) UIButton *pauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 清晰度
@property (nonatomic, strong) UIButton *qxBtn;
/// 倍速按钮
@property (nonatomic, strong) UIButton *speedBtn;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@end

@implementation ZFBottomView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self addActon];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        self.layer.contents = (id)image.CGImage;
        _isFullScreen = NO;
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.pauseBtn];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.slider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.qxBtn];
    [self addSubview:self.speedBtn];
    [self addSubview:self.fullScreenBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_margin = 10;

    min_w = 40;
    min_h = 44;
    min_x = 0;
    min_y = 0;
    self.pauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);

    min_y = 12;
    CGFloat currentX = CGRectGetMaxX(self.pauseBtn.frame);
    self.currentTimeLabel.frame = CGRectMake(currentX, min_y, 60, 20);

    CGFloat slideX = CGRectGetMaxX(self.currentTimeLabel.frame) + min_margin;
    min_w = min_view_w - slideX - min_margin - (44) * 3 - 50;
    self.slider.frame = CGRectMake(slideX, 0, min_w, min_h);

    CGFloat totalX = CGRectGetMaxX(self.slider.frame) + min_margin;
    self.totalTimeLabel.frame = CGRectMake(totalX, min_y, 60, 20);

    min_y = 0;
    CGFloat qxX = CGRectGetMaxX(self.totalTimeLabel.frame);
    min_w = 40;
    self.qxBtn.frame = CGRectMake(qxX, min_y, min_w, min_h);

    CGFloat speedX = CGRectGetMaxX(self.qxBtn.frame);
    self.speedBtn.frame = CGRectMake(speedX, min_y, min_w, min_h);

    CGFloat fullX = CGRectGetMaxX(self.speedBtn.frame);
    self.fullScreenBtn.frame = CGRectMake(fullX, min_y, min_w, min_h);
    
    if (self.isFullScreen) {
        [_fullScreenBtn setImage:nil forState:UIControlStateNormal];
        [_fullScreenBtn setImage:nil forState:UIControlStateSelected];
        [_fullScreenBtn setTitle:@"选集" forState:UIControlStateNormal];
        [_fullScreenBtn setTitle:@"选集" forState:UIControlStateSelected];
    } else {
        [_fullScreenBtn setTitle:nil forState:UIControlStateNormal];
        [_fullScreenBtn setTitle:nil forState:UIControlStateSelected];
        [_fullScreenBtn setImage:[ZFPlayer_Image(@"ZFPlayer_fullscreen") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[ZFPlayer_Image(@"ZFPlayer_shrinkscreen") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }

}

- (void)hiddeQxbtn: (BOOL)isHidden {
    _qxBtn.hidden = isHidden;
}

#pragma add action

- (void)addActon {
    [self.pauseBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.qxBtn addTarget:self action:@selector(qxAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.speedBtn addTarget:self action:@selector(speedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pauseAction: (UIButton *)btn {
    [self.bottomDelegate pause:btn];
}

- (void)qxAction: (UIButton *)btn {
    [self.delegate buttonClick:ZFCoverViewQX button:btn];
}

- (void)speedAction: (UIButton *)btn {
    [self.delegate buttonClick:ZFCoverViewRate button:btn];
}

- (void)fullScreenAction: (UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"选集"]) {
        [self.delegate buttonClick:ZFCoverViewSelect button:btn];
        return;
    }
    [self.bottomDelegate fullScreen];
}

#pragma create ui

- (void)setButtonStatus: (BOOL)status {
    self.pauseBtn.selected = !status;
}

- (void)resetContent {
    self.totalTimeLabel.text = @"00:00";
    self.currentTimeLabel.text = @"00:00";
    self.slider.value = 0;
    self.slider.bufferValue = 0;
}

- (void)setRateText: (NSString *)text {
    [_speedBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setQxText: (NSString *)text {
    [_qxBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setBufferValue:(CGFloat)bufferValue {
    self.slider.bufferValue = bufferValue;
}

- (void)setProgress: (CGFloat)progress currentTime: (NSString *)currentTime totalTime: (NSString *)totalTime isSlider: (BOOL)isSlider {
    if (self.slider.isdragging) { return; }
    self.slider.value = progress;
    self.totalTimeLabel.text = totalTime;
    self.currentTimeLabel.text = currentTime;
    self.slider.isdragging = isSlider;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

- (void)sliderEnd {
     self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _pauseBtn.tintColor = [UIColor clearColor];
        [_pauseBtn setImage: [ZFPlayer_Image(@"ZFPlayer_pause") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_pauseBtn setImage:[ZFPlayer_Image(@"ZFPlayer_play") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }
    return _pauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[ZFPlayer_Image(@"ZFPlayer_slider") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _totalTimeLabel;
}

- (UIButton *)qxBtn {
    if (!_qxBtn) {
        _qxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qxBtn setTitle:@"标 清" forState:UIControlStateNormal];
        _qxBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_qxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _qxBtn;
}

- (UIButton *)speedBtn {
    if (!_speedBtn) {
        _speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speedBtn setTitle:@"1.0 x" forState:UIControlStateNormal];
        _speedBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _speedBtn;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_fullScreenBtn setImage:[ZFPlayer_Image(@"ZFPlayer_fullscreen") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[ZFPlayer_Image(@"ZFPlayer_shrinkscreen") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        _fullScreenBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

#pragma slider delegate

- (void)sliderTouchBegan:(float)value {
    [self.bottomDelegate sliderTouchBegan:value slider:self.slider];
}

- (void)sliderTouchEnded:(float)value {
    [self.bottomDelegate sliderTouchEnded:value slider:self.slider];
}

- (void)sliderValueChanged:(float)value {
     NSString *text = [self.bottomDelegate sliderValueChanged:value slider:self.slider];
     self.currentTimeLabel.text = text;
}

- (void)sliderTapped:(float)value {
    [self.bottomDelegate sliderTapped:value slider:self.slider];
}
@end
