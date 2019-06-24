//
//  ZFContinuePlayView.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFContinuePlayView.h"
#import "UIView+ZFFrame.h"

@interface ZFContinuePlayView()

@property (nonatomic, strong) UIButton *closeBtn;
// 重新开始 播放
@property (nonatomic, strong) UIButton *begainBtn;
@property (nonatomic, strong) UILabel *lastPlay;

@end

@implementation ZFContinuePlayView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubvies];
        [self addAct];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_h = self.frame.size.height;
    
    _closeBtn.frame = CGRectMake(min_x, 0, 30, min_h);
    
    min_x = CGRectGetMaxX(_closeBtn.frame);
    _lastPlay.frame = CGRectMake(min_x, 5, _lastPlay.frame.size.width, 20);
    
    min_x = CGRectGetMaxX(_lastPlay.frame) + 10;
    _begainBtn.frame = CGRectMake(min_x, 0, 70, min_h);
    
}

- (void)addSubvies {
    [self addSubview:self.closeBtn];
    [self addSubview:self.lastPlay];
    [self addSubview:self.begainBtn];
}

- (void)addAct {
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_begainBtn addTarget:self action:@selector(begain) forControlEvents:UIControlEventTouchUpInside];
}

- (void)close {
    [self disMiss];
}

- (void)begain {
    [self disMiss];
    self.begainAct();
}

- (void)disMiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.zf_x = -300;
        self.alpha = 0;
    }];
}

- (void)setTime: (NSString *)time {
    _lastPlay.text = [NSString stringWithFormat:@"上次播放到：%@",time];
    [_lastPlay sizeToFit];
    [self layoutSubviews];
}

#pragma create ui

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tvImg = [[UIImage imageNamed:@"zf_cha"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_closeBtn setImage:tvImg forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)begainBtn {
    if (!_begainBtn) {
        _begainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_begainBtn setTitle:@"重新开始" forState:UIControlStateNormal];
        _begainBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_begainBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _begainBtn;
}

- (UILabel *)lastPlay {
    if (!_lastPlay) {
        _lastPlay = [[UILabel alloc] init];
        _lastPlay.text = @"上次播放到：";
        _lastPlay.textColor = [UIColor whiteColor];
        _lastPlay.font = [UIFont systemFontOfSize:13.0];
        _lastPlay.frame = CGRectMake(0, 0, 100, 20);
        [_lastPlay sizeToFit];
    }
    return _lastPlay;
}
@end
