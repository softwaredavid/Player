//
//  ZFTimer.h
//  Player
//
//  Created by MAc on 2019/6/21.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZFPlayer/ZFPlayer.h>

typedef void(^endAction)(NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface ZFTimer : NSObject

@property (nonatomic, copy) endAction endAction;

// 多长时间后关闭 -1时关闭定时器 等于0 代表播放完当前
- (void)afterClose: (NSInteger)time;

// 保存时间
+ (void)saveTime: (NSTimeInterval )time key: (NSString *)key ;

// 获取时间
+ (NSTimeInterval)getTime: (NSString *)key;

@end

NS_ASSUME_NONNULL_END
