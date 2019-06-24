//
//  ZFTimerView.h
//  Player
//
//  Created by MAc on 2019/6/21.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^timer)(NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface ZFTimerView : UIView

@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, copy) timer time;
- (void)resetFrame;

@end

NS_ASSUME_NONNULL_END
