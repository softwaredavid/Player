//
//  ZFCoverModel.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFCoverModel.h"

@implementation ZFCoverModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isContinuePlay = YES;
    }
    return self;
}

- (void)setPlayUrl:(NSString *)playUrl {
    if (playUrl) {
        _playUrl = playUrl;
        _videoId = playUrl;
    }
}

@end
