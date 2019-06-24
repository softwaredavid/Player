//
//  ZFAlertView.m
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "ZFAlertView.h"

@implementation ZFAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (void)showtext: (NSString *)text {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 2;
    label.text = text;
    label.frame = CGRectMake(window.frame.size.width/2-50, window.frame.size.height - 60, 100, 20);
    [window addSubview:label];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

@end
