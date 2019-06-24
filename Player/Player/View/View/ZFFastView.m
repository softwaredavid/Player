//
//  ZFFastView.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/13.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFFastView.h"
#import "ZFSliderView.h"
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"

@interface ZFFastView()
// 图片
@property (nonatomic, strong) UIImageView *fastImageView;
// 时间
@property (nonatomic, strong) UILabel *fasttimeLabel;
// 进度条
@property (nonatomic, strong) ZFSliderView *progressView;
@end

@implementation ZFFastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.fastImageView];
    [self addSubview:self.fasttimeLabel];
    [self addSubview:self.progressView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    
    min_w = 32;
    min_x = (self.zf_width - min_w) / 2;
    min_y = 5;
    min_h = 32;
    self.fastImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = self.fastImageView.zf_bottom + 2;
    min_w = self.zf_width;
    min_h = 20;
    self.fasttimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 12;
    min_y = self.fasttimeLabel.zf_bottom + 5;
    min_w = self.zf_width - 2 * min_x;
    min_h = 10;
    self.progressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

#pragma config data

- (void)setCurrentTime: (NSString *)currentTime totalTime: (NSString *)totalTime
              progress: (CGFloat)progress img: (UIImage *)img {
    _fasttimeLabel.text = [NSString stringWithFormat:@"%@ / %@", currentTime,totalTime];
    _fastImageView.image = img;
    _progressView.value = progress;
}


#pragma create ui

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fasttimeLabel {
    if (!_fasttimeLabel) {
        _fasttimeLabel = [[UILabel alloc] init];
        _fasttimeLabel.textColor = [UIColor whiteColor];
        _fasttimeLabel.textAlignment = NSTextAlignmentCenter;
        _fasttimeLabel.font = [UIFont systemFontOfSize:14.0];
        _fasttimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fasttimeLabel;
}

- (ZFSliderView *)progressView {
    if (!_progressView) {
        _progressView = [[ZFSliderView alloc] init];
        _progressView = [[ZFSliderView alloc] init];
        _progressView.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        _progressView.minimumTrackTintColor = [UIColor whiteColor];
        _progressView.sliderHeight = 2;
        _progressView.isHideSliderBlock = NO;
    }
    return _progressView;
}

@end
