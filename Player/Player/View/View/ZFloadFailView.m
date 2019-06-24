
//
//  ZFloadFailView.m
//  Player
//
//  Created by MAc on 2019/6/24.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "ZFloadFailView.h"

@interface ZFloadFailView()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation ZFloadFailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _btn.frame = CGRectMake(0, 0, 140, 20);
    _btn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"加载失败, 点击重试" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (void)btnClick {
    self.reload();
}

@end
