//
//  ZFFastView.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/13.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFFastView : UIView

- (void)setCurrentTime: (NSString *)currentTime totalTime: (NSString *)totalTime
              progress: (CGFloat)progress img: (UIImage *)img;


@end

NS_ASSUME_NONNULL_END
