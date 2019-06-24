//
//  ZFTimerView.m
//  Player
//
//  Created by MAc on 2019/6/21.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "ZFTimerView.h"
#import "ZFCoverModel.h"
#import "ZFconfig.h"

@interface ZFTimerView()<UIGestureRecognizerDelegate>
@end

@implementation ZFTimerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self initSourceArray];
        [self setUI];
        [self addGes];
    }
    return self;
}

- (void)addGes {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)tapClick {
    [self removeFromSuperview];
}

// 切换横屏 竖屏是需要重新调用该方法
- (void)resetFrame {
    [self setUI];
}

- (void)setUI {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    coverView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 90;
    CGFloat height = 44;
    for (int i = 0; i < self.sourceArray.count; i ++) {
        CGRect frame = CGRectMake(x, y, width, height);
        ZFCoverModel *model = self.sourceArray[i];
        UIButton *btn = [self createBtn:frame title:model.text];
        if (model.isSelected) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        if (i == 1) {
            x = 0;
            y = 50;
        } else {
            x = CGRectGetMaxX(btn.frame) + 20;
        }
        [coverView addSubview:btn];
    }
    [self addSubview:coverView];
}

- (UIButton *)createBtn: (CGRect)frame title: (NSString *)text {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.tintColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClick: (UIButton *)btn {
    [self removeFromSuperview];
    NSString *title = btn.currentTitle;
    for (ZFCoverModel *model in self.sourceArray) {
        if ([model.text isEqualToString:title]) {
            model.isSelected = YES;
            [self handleTime:model.timerType];
        } else {
            model.isSelected = NO;
        }
    }
}

- (void)handleTime: (ZFVideoTimerType)type {
    switch (type) {
        case ZFVideoTimerNO:
            self.time(-1);
            break;
        case ZFVideoTimerCurrent:
            self.time(0);
            break;
        case ZFVideoTimer30:
            self.time(30 * 30);
            break;
        case ZFVideoTimer60:
            self.time(60 * 60);
            break;
        default:
            break;
    }
}

- (void)initSourceArray {
    _sourceArray = [ZFConfig shareInstance].timesArray;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIView *view = gestureRecognizer.view;
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
