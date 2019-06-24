//
//  ZFTopView.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/11.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFTopView : UIView

@property (nonatomic, copy) void(^enterFullScreen)(void);

@property (nonatomic, weak) id<ZFBDelegate> delegate;
// 播放器
@property (nonatomic, assign) BOOL isFullScreen;

@end

NS_ASSUME_NONNULL_END
