//
//  ZFCustomControlView1.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2019/6/5.
//  Copyright © 2019 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFSpeedLoadingView.h"
#import "ZFCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFCustomControlView1 : UIView <ZFPlayerMediaControl,VideDelgate>

/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;
/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;
// 选集
@property (nonatomic, strong) NSArray *videos;
// 更多
@property (nonatomic, strong) NSArray *moreMeuns;
// 倍速
@property (nonatomic, strong) NSArray *rates;
// 清晰度
@property (nonatomic, strong) NSArray *qxs;
// 是不是后台银屏播放
@property (nonatomic, assign) BOOL isBack;

/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode;

// 展示上次继续播放的视屏
- (void)showContinueView: (NSString *)text;

// 展示上次继续播放的视屏
- (void)hiddenContinueView;

@end

NS_ASSUME_NONNULL_END
