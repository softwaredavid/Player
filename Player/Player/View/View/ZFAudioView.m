//
//  ZFAudioView.m
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "ZFAudioView.h"
#import "ZFCoverModel.h"

@implementation ZFAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBakcView];
    }
    return self;
}

// 音频后台播放
- (void)setBakcView {
    CGFloat width = (self.frame.size.width - 30) / 3;
    CGFloat height = self.frame.size.height / 2;
    CGFloat vx = width / 2;
    CGFloat vy = height-22;
    NSArray *array = @[@"音频后台播放",@"切回视频"];
    for (int i = 0; i < array.count; i ++) {
        NSString *text = array[i];
        CGRect frame = CGRectMake(vx, vy, width, 44);
        UIButton *btn = [self createBtn:frame title:text];
        btn.tag = 5000 + i;
        if ([text isEqualToString:@"切回视频"]) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        vx = CGRectGetMaxX(btn.frame) + 30;
        [self addSubview:btn];
    }
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

- (void)resetFrame {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self setBakcView];
}

- (void)btnClick: (UIButton *)btn {
    [self handleVideo:btn.currentTitle];
}

- (void)handleVideo: (NSString *)text {
    ZFCoverModel *model = [[ZFCoverModel alloc] init];
    model.type = ZFVideoBackAudio;
    if ([text isEqualToString:@"音频后台播放"]) {
        model.videoPlayType = ZFVideoPlayTypeBack;
    }
    if ([text isEqualToString:@"切回视频"]) {
        model.videoPlayType = ZFVideoPlayTypeVideo;
    }
    [self.delegate slectFunc:model];
}
@end
