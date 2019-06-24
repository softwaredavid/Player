//
//  ZFContinuePlayView.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

typedef void(^begain)(void);

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFContinuePlayView : UIView

@property (nonatomic, copy) begain begainAct;

- (void)setTime: (NSString *)time;

- (void)disMiss;

@end

NS_ASSUME_NONNULL_END
