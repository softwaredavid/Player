//
//  ZFConfig.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFConfig : NSObject

// 视频播放本地存储的 前缀 默认为 一个 video_pre
@property (nonatomic, copy) NSString *prefix;
// 清晰度数据
@property (nonatomic, strong) NSArray *qxArray;
// 更多数据配置
@property (nonatomic, strong) NSArray *moreArray;
// 倍速播放数据
@property (nonatomic, strong) NSArray *ratesArray;
// 定时播放数据
@property (nonatomic, strong) NSArray *timesArray;
// 清晰度
@property (nonatomic, assign) NSInteger currentQx;
// 倍速
@property (nonatomic, assign) NSInteger rate;

+ (nullable instancetype)shareInstance;

- (void)resetSelect;

@end

NS_ASSUME_NONNULL_END
