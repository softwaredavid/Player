//
//  ZFVideo.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.

// 每个视屏都要做对应的设置

#import <Foundation/Foundation.h>
#import "ZFCoverModel.h"
#import "ZFCustomControlView1.h"

@protocol ZFVideoDelegate <NSObject>

- (void)currentPlayData: (ZFCoverModel *)data index: (NSInteger)index;
// 除了后台播放 和 定时播放之外 其他所有的辅助功能走此代理方法
- (void)videoOtherFunc: (ZFCoverModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN
@interface ZFVideo : NSObject
// 选集
@property (nonatomic, strong) NSArray *videos;
// 更多
@property (nonatomic, strong) NSArray *moreMeuns;
// 倍速 默认为 0.8 1.0 1.25 1.5 2
@property (nonatomic, strong) NSArray *rates;
// 清晰度 默认 为 定时关闭 音频后台播放 课程评价 分享
@property (nonatomic, strong) NSArray *qxs;

@property (nonatomic, weak) id<ZFVideoDelegate> delegate;

- (instancetype)initContinerView: (UIImageView *)view;

- (void)setTitle: (NSString *)title bgImg: (NSString *)bgImg currentVideo: (ZFCoverModel *)model;

// 这两个方法要在相应的viewcontroller中调用 必须调用
- (void)viewWillAppear;

- (void)viewWillDisappear;

//f播放一个
- (void)playWithData: (ZFCoverModel *)model;

// 播放一组
- (void)playWithDatas: (NSArray<ZFCoverModel *> *)datas index: (NSInteger)index;

// 播放一组中的某一个
- (void)playIndex: (NSInteger)index;

@end

NS_ASSUME_NONNULL_END
