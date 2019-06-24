//
//  ZFTimer.m
//  Player
//
//  Created by MAc on 2019/6/21.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "ZFTimer.h"
#import "ZFConfig.h"

@interface ZFTimer()

@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZFTimer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.times -= 1;
            if (self.times <= 0) { // 倒计时结束
                self.endAction(self.times);
                [self.timer setFireDate:[NSDate distantFuture]];
            }
        }];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

// 多长时间后关闭 -1时关闭定时器 等于0 代表播放完当前
- (void)afterClose: (NSInteger)time {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.times = time;
    if (time < 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
    } else {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}


#pragma 处理 继续上次播放的问题

+ (void)setTime: (NSString *)time key: (NSString *)key {
    NSString *pre_key = [ZFConfig shareInstance].prefix;
    NSString *save_key = [NSString stringWithFormat:@"%@_%@",pre_key,key];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:save_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSTimeInterval)getTime: (NSString *)key {
    NSString *pre_key = [ZFConfig shareInstance].prefix;
    NSString *save_key = [NSString stringWithFormat:@"%@_%@",pre_key,key];
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:save_key];
    return [time doubleValue];
}

+ (void)saveTime: (NSTimeInterval )time key: (NSString *)key {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *save_time = [NSString stringWithFormat:@"%f",time];
        [ZFTimer setTime: save_time key:key];
    });
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
