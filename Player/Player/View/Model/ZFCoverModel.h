//
//  ZFCoverModel.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZFCoverViewType) {
    ZFCoverViewRate = 2,       // 倍速
    ZFCoverViewQX, // 清晰度
    ZFCoverViewMore, // 更多
    ZFCoverViewSelect, // 选择播放哪一集
    ZFCoverViewBack, // 返回
    ZFCoverViewTV, // TV
    ZFCoverViewDwonload, // 下载
    ZFCoverViewBackground,// 后台
    ZFCoverViewAudio, // 音频包房
    ZFCoverViewTimer, // 定时关闭
    ZFCoverViewEve, // 评价
    ZFCoverViewShare // 分享
};

typedef NS_ENUM(NSInteger, ZFVideoType) {
    ZFVideoRate = 2,       // 倍速
    ZFVideoQX, // 清晰度
    ZFVideoBackAudio, //后台
    ZFVideoTimer, // 定时关闭
    ZFVideoEve, // 评价
    ZFVideoShare, // 分享
    ZFVideoDownload, // 下载
    ZFVideoTV // 投屏
};

typedef NS_ENUM(NSInteger, ZFVideoPlayRate) {
    ZFVideoRate8X = 2,       // 0.8
    ZFVideoRate1X, // 1x
    ZFVideoRate25X, // 1.25
    ZFVideoRate5X, // 1.5x
    ZFVideoRate2X // 2x
};

typedef NS_ENUM(NSInteger, ZFVideoPlayQx) {
    ZFVideoPlayHeight = 2,       // 高清
    ZFVideoPlayMiddle, // 普清
    ZFVideoPlaylow // 模糊
};

typedef NS_ENUM(NSInteger, ZFVideoPlayType) {
    ZFVideoPlayTypeBack = 2,       // 音频后台播放
    ZFVideoPlayTypeVideo //  视屏播放
};

typedef NS_ENUM(NSInteger, ZFVideoTimerType) {
    ZFVideoTimerNO = 2,       // 不开启定时关闭
    ZFVideoTimerCurrent, //  播放完当前
    ZFVideoTimer30, // 30 分钟定时关闭
    ZFVideoTimer60  // 60 分钟定时关闭
};

@interface ZFCoverModel : UIView

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *text;
// 唯一标识视频的id
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *playUrl; // 普清
@property (nonatomic, copy) NSString *heightUrl; // 高清
@property (nonatomic, copy) NSString *lowUrl; // 模糊
@property (nonatomic, assign) BOOL isSelected;
// 是不是继续上次播放
@property (nonatomic, assign) BOOL isContinuePlay;
// 必填项
@property (nonatomic, assign) ZFVideoType type;
// type 为倍速播放时 必填
@property (nonatomic, assign) ZFVideoPlayRate rateType;
// type 为清晰度时 必填
@property (nonatomic, assign) ZFVideoPlayQx qxType;
// 音频后台播放
@property (nonatomic, assign) ZFVideoPlayType videoPlayType;
// 银屏定时关闭
@property (nonatomic, assign) ZFVideoTimerType timerType;

@end

@protocol ZFBDelegate <NSObject>

- (void)buttonClick: (ZFCoverViewType )type button: (UIButton *)btn;

@end

@protocol VideDelgate <NSObject>

// 选择功能键
- (void)slectFunc: (ZFCoverModel *)model;

@end

NS_ASSUME_NONNULL_END
