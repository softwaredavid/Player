//
//  ZFTopView.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/11.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFTopView.h"
#import <ZFPlayer/ZFPlayer.h>
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"

@interface ZFTopView()
// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 投屏btn
@property (nonatomic, strong) UIButton *tvBtn;
// 更多按钮
@property (nonatomic, strong) UIButton *moreBtn;
// 下载按钮
@property (nonatomic, strong) UIButton *downloadBtn;

@end

@implementation ZFTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        self.layer.contents = (id)image.CGImage;
        _isFullScreen = NO;
        [self addSubViews];
        [self addAction];
    }
    return self;
}

#pragma addsubviews

- (void)addSubViews {
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tvBtn];
    [self addSubview:self.downloadBtn];
    [self addSubview:self.moreBtn];
}

#pragma layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_margin = 9;
    
    min_w = 44;
    min_h = 44;
    min_x = min_margin;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 44;
    min_h = 44;
    min_x = min_view_w - min_margin - 44;
    self.moreBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 44;
    min_h = 44;
    min_x = min_view_w - (min_margin+44) * 2;
    self.tvBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 44;
    min_h = 44;
    min_x = min_view_w - (min_margin+44) * 3;
    self.downloadBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = min_view_w - (min_margin+44) * 3;
    min_h = 44;
    min_x = min_view_w - (min_margin+44);
    self.titleLabel.frame = CGRectMake(54, min_y, min_w, min_view_h);
    
    if (_isFullScreen) {
        [self horizontalScreen];
    } else {
        [self verticalScreen];
    }
}

#pragma add action

- (void)addAction {
    [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tvBtn addTarget:self action:@selector(tvAction:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction: (UIButton *)btn {
    if (_isFullScreen) {
        self.enterFullScreen();
        return;
    }
    [self.delegate buttonClick:ZFCoverViewBack button:btn];
}

- (void)tvAction: (UIButton *)btn {
    [self.delegate buttonClick:ZFCoverViewTV button:btn];
}

- (void)downloadAction: (UIButton *)btn {
    [self.delegate buttonClick:ZFCoverViewDwonload button:btn];
}

- (void)moreAction: (UIButton *)btn {
    [self.delegate buttonClick:ZFCoverViewMore button:btn];
}

#pragma hidden and show views

- (void)verticalScreen {
    _downloadBtn.hidden = YES;
    _titleLabel.hidden = NO;
}

// 横屏
- (void)horizontalScreen {
    _downloadBtn.hidden = NO;
    _titleLabel.hidden = YES;
}

#pragma create ui

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *backImg = [[UIImage imageNamed:@"zf_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_backBtn setImage:backImg forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)tvBtn {
    if (!_tvBtn) {
        _tvBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *tvImg = [[UIImage imageNamed:@"zf_tv"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_tvBtn setImage:tvImg forState:UIControlStateNormal];
    }
    return _tvBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *downloadImg = [[UIImage imageNamed:@"zf_download"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_downloadBtn setImage:downloadImg forState:UIControlStateNormal];
    }
    return _downloadBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *moreImg = [[UIImage imageNamed:@"zf_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_moreBtn setImage:moreImg forState:UIControlStateNormal];
    }
    return _moreBtn;
}
@end
