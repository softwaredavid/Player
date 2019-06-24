//
//  ZFCoverView.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFCoverView.h"
#import "ZFCoverModel.h"

@interface ZFCoverView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) ZFCoverModel *currentModel;

@end

@implementation ZFCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self addges];
    }
    return self;
}

- (void)addges {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

- (void)addSubviews {
    [self addSubview:self.tabView];
    [self addSubview:self.coverView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.type == ZFCoverViewQX) {
        self.tabView.frame = CGRectMake(0, 0, self.frame.size.width, 142);
        self.tabView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    } else if (self.type == ZFCoverViewSelect) {
        self.tabView.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-20);
        self.tabView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    
    self.coverView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma 根据不同的状态处理不同的UI事件

- (void)resetBg {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
}

- (void)setType:(ZFCoverViewType)type {
    if (type) {
        _type = type;
        [self layoutSubviews];
        [self resetUI];
    }
}

- (void)resetUI {
    [self disMiss];
    switch (self.type) {
        case ZFCoverViewRate:
            if (self.rates.count <= 0) {
                self.alpha = 0;
                return;
            }
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            [self setRateView];
            break;
        case ZFCoverViewQX:
            if (self.qxs.count <= 0) {
                self.alpha = 0;
                return ;
            }
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            [self setQxView];
            break;
        case ZFCoverViewMore:
            if (self.moreMeuns.count <= 0) {
                self.alpha = 0;
                return;
            }
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            [self setMoreMenuView];
            break;
        case ZFCoverViewSelect:
            if (self.sources.count <= 0) {
                self.alpha = 0;
                return ;
            }
            self.tabView.hidden = NO;
            self.coverView.hidden = YES;
            break;
        case ZFVideoShare:
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            break;
        case ZFCoverViewAudio:
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            break;
        case ZFCoverViewTimer:
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            break;
        case ZFCoverViewEve:
            self.tabView.hidden = YES;
            self.coverView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma button 的点击事件

- (void)btnClick: (UIButton *)btn {
    NSInteger tag = btn.tag - 100;
    switch (self.type) {
        case ZFCoverViewRate:
            [self disMiss];
            self.currentModel = self.rates[tag];
            [self resetSelect:self.currentModel arrays:self.rates];
            [self.delegate slectFunc:self.currentModel];
            break;
        case ZFCoverViewQX:
            [self disMiss];
            self.currentModel = self.qxs[tag];
            [self resetSelect:self.currentModel arrays:self.qxs];
            [self.delegate slectFunc:self.currentModel];
            break;
        case ZFCoverViewMore:
            self.currentModel = self.moreMeuns[tag];
            [self resetType];
            if (tag == 0 || tag == 1) {
                 [self resetSelect:self.currentModel arrays:self.moreMeuns];
            }
            break;
        case ZFCoverViewSelect:
            [self disMiss];
            self.currentModel = self.sources[tag];
            [self resetSelect:self.currentModel arrays:self.sources];
            [self.delegate slectFunc:self.currentModel];
            break;
        default:
            break;
    }
}

- (void)resetType {
    switch (self.currentModel.type) {
        case ZFVideoBackAudio:
            self.type = ZFCoverViewAudio;
            [self handleVideo:@"音频后台播放"];
            break;
        case ZFVideoEve:
            self.type = ZFCoverViewEve;
            break;
        case ZFVideoShare:
            self.type = ZFCoverViewShare;
            break;
        case ZFVideoTimer:
            [self timerPlay];
            self.type = ZFCoverViewTimer;
            break;
        default:
            break;
    }
}

- (void)resetSelect: (ZFCoverModel *)model arrays: (NSArray *)array {
    [array enumerateObjectsUsingBlock:^(ZFCoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    model.isSelected = YES;
}

- (void)tapClick {
    [self disMiss];
    self.alpha = 0;
}

- (void)disMiss {
    [self.coverView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)timerPlay {
    [self tapClick];
    ZFCoverModel *model = [[ZFCoverModel alloc] init];
    model.type = ZFVideoTimer;
    [self.delegate slectFunc:model];
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

#pragma tabview 的代理方法

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cover_reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cover_reuse"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZFCoverModel *model = _sources[indexPath.row];
    cell.textLabel.text = model.text;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    if (model.isSelected) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _sources.count;
}

#pragma 处理各种不同状态的UI

- (void)setQxView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, self.frame.size.height/2-35, self.frame.size.width - 60, 70)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.coverView addSubview:contentView];
    
    CGFloat vx = 0;
    CGFloat vy = 0;
    CGFloat width = contentView.frame.size.width / self.qxs.count;
    for (int i = 0; i < self.qxs.count; i ++) {
        ZFCoverModel *model = self.qxs[i];
        CGRect frame = CGRectMake(vx, vy, width, 44);
        UIButton *btn = [self createBtn:frame title:model.text];
        btn.tag = 100 + i;
        if (model.isSelected) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        if (vx + btn.frame.size.width + 5 > contentView.frame.size.width) {
            vy += 90;
            vx = 0;
        } else {
            vx = CGRectGetMaxX(btn.frame);
        }
        [contentView addSubview:btn];
    }
}

- (void)setRateView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, self.frame.size.height/2-35, self.frame.size.width - 60, 70)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.coverView addSubview:contentView];
    
    CGFloat vx = 0;
    CGFloat vy = 0;
    CGFloat width = contentView.frame.size.width / self.rates.count;
    for (int i = 0; i < self.rates.count; i ++) {
        ZFCoverModel *model = self.rates[i];
        CGRect frame = CGRectMake(vx, vy, width, 44);
        UIButton *btn = [self createBtn:frame title:model.text];
        btn.tag = 100 + i;
        if (model.isSelected) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        if (vx + btn.frame.size.width + 5 > contentView.frame.size.width) {
            vy += 90;
            vx = 0;
        } else {
            vx = CGRectGetMaxX(btn.frame);
        }
        [contentView addSubview:btn];
    }
}

- (void)setMoreMenuView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2+35, self.frame.size.width - 10, 70)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.coverView addSubview:contentView];
    
    CGFloat vx = 0;
    CGFloat vy = 0;
    CGFloat width = contentView.frame.size.width / self.moreMeuns.count;
    for (int i = 0; i < self.moreMeuns.count; i ++) {
        ZFCoverModel *model = self.moreMeuns[i];
        CGRect frame = CGRectMake(vx, vy, width, 70);
        UIButton *btn = [self createMenuBtn:frame title:model.text img:model.img];
        if (model.isSelected) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        btn.tag = 100 + i;
        if (vx + btn.frame.size.width + 10 > self.frame.size.width) {
            vy += 80;
            vx = 0;
        }
        vx = CGRectGetMaxX(btn.frame);
        [contentView addSubview:btn];
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

- (UIButton *)createMenuBtn: (CGRect)frame title: (NSString *)title img: (NSString *)img {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.tintColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.backgroundColor = [UIColor clearColor];
    }
    return _tabView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}
@end
