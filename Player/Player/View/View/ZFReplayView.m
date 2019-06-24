//
//  ZFReplayView.m
//  Player
//
//  Created by MAc on 2019/6/24.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "ZFReplayView.h"

@implementation ZFReplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [self createMenuBtn:frame title:@"重新播放" img:@"re_play"];
        [self addSubview:btn];
    }
    return self;
}

- (UIButton *)createMenuBtn: (CGRect)frame title: (NSString *)title img: (NSString *)img {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.tintColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    CGFloat imageWith = btn.imageView.frame.size.width;
    CGFloat imageHeight = btn.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = btn.titleLabel.frame.size.width;
        labelHeight = btn.titleLabel.frame.size.height;
    }
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/1.2, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-labelHeight-5/1.2, 0, 0, -labelWidth)];
    return btn;
}


- (void)btnClick {
    [self removeFromSuperview];
    self.replay();
}

@end
