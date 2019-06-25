//
//  ZFBottomView.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/11.
//  Copyright © 2019年 紫枫. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFCoverModel.h"
#import "ZFSliderView.h"

@protocol BottomDelegate <NSObject>
- (void)sliderTouchBegan:(float)value slider: (ZFSliderView *)sliderView;
- (void)sliderTouchEnded:(float)value slider: (ZFSliderView *)sliderView;
- (NSString *)sliderValueChanged:(float)value slider: (ZFSliderView *)sliderView;
- (void)sliderTapped:(float)value slider: (ZFSliderView *)sliderView;
- (void)pause: (UIButton *)btn;
- (void)fullScreen;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ZFBottomView : UIView

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, weak) id<ZFBDelegate> delegate;
@property (nonatomic, weak) id<BottomDelegate> bottomDelegate;

- (void)setButtonStatus: (BOOL)status;

- (void)setRateText: (NSString *)text;

- (void)setQxText: (NSString *)text;

- (void)sliderEnd;

- (void)resetContent;

- (void)setBufferValue: (CGFloat)bufferValue;

- (void)hiddeQxbtn: (BOOL)isHidden;

//isSlider 是不是快进
- (void)setProgress: (CGFloat)progress currentTime: (NSString *)currentTime totalTime: (NSString *)totalTime isSlider: (BOOL)isSlider;

@end

NS_ASSUME_NONNULL_END
