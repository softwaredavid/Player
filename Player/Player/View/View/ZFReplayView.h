//
//  ZFReplayView.h
//  Player
//
//  Created by MAc on 2019/6/24.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFReplayView : UIView

@property (nonatomic, copy) void(^replay)(void);

@end

NS_ASSUME_NONNULL_END
