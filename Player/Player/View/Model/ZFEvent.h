//
//  ZFTool.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFCoverView.h"
#import <ZFPlayer/ZFPlayer.h>
#import "ZFBottomView.h"
#import "ZFCustomControlView1.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFEvent : NSObject

// top vc
+ (UIViewController*)currentViewController;

// 处理各种事件
- (void)slectFunc: (ZFCoverModel *)model view: (ZFCoverView *)view palyer:(ZFPlayerController *)player toolView: (ZFBottomView *)toolView deleView: (ZFCustomControlView1 *)delView;

- (void)back: (ZFPlayerController *)player;

- (void)resetFramePlayer: (UIView *)cview;

@end

NS_ASSUME_NONNULL_END
