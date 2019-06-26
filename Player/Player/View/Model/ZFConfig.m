//
//  ZFConfig.m
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import "ZFConfig.h"

static ZFConfig *_singleInstance = nil;

@implementation ZFConfig

+ (nullable instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleInstance == nil) {
            _singleInstance = [[self alloc]init];
            _singleInstance.prefix = @"video_pre";
        }
    });
    return _singleInstance;
}

- (NSArray *)qxArray {
    if (!_qxArray) {
        ZFCoverModel *model = [[ZFCoverModel alloc] init];
        model.isSelected = YES;
        model.type = ZFVideoQX;
        model.qxType = ZFVideoPlaylow;
        model.text = @"标清";
        
        ZFCoverModel *model1 = [[ZFCoverModel alloc] init];
        model1.type = ZFVideoQX;
        model1.qxType = ZFVideoPlayMiddle;
        model1.text = @"高清";
        
        ZFCoverModel *model2 = [[ZFCoverModel alloc] init];
        model2.type = ZFVideoQX;
        model2.qxType = ZFVideoPlayHeight;
        model2.text = @"超清";
        
        _qxArray = @[model,model1,model2];
    }
    return _qxArray;
}

- (NSArray *)moreArray {
    if (!_moreArray) {
        ZFCoverModel *mModel = [[ZFCoverModel alloc] init];
        mModel.type = ZFVideoTimer;
        mModel.text = @"定时关闭";
        mModel.img = @"zf_time";
        
        ZFCoverModel *mModel1 = [[ZFCoverModel alloc] init];
        mModel1.type = ZFVideoBackAudio;
        mModel1.text = @"音频后台播放";
        mModel1.img = @"zf_bg";
        
        
//        ZFCoverModel *mModel2 = [[ZFCoverModel alloc] init];
//        mModel2.type = ZFVideoEve;
//        mModel2.text = @"课程评价";
//        mModel2.img = @"zf_pingjia";
        
        ZFCoverModel *mModel3 = [[ZFCoverModel alloc] init];
        mModel3.type = ZFVideoShare;
        mModel3.text = @"分享";
        mModel3.img = @"zf_share";
        _moreArray = @[mModel,mModel1,/*mModel2,*/mModel3];
    }
    return _moreArray;
}

- (NSArray *)ratesArray {
    if (!_ratesArray) {
        ZFCoverModel *sModel = [[ZFCoverModel alloc] init];
        sModel.type = ZFVideoRate;
        sModel.rateType = ZFVideoRate8X;
        sModel.text = @"0.8 x";
        
        ZFCoverModel *sModel1 = [[ZFCoverModel alloc] init];
        sModel1.type = ZFVideoRate;
        sModel1.rateType = ZFVideoRate1X;
        sModel1.isSelected = YES;
        sModel1.text = @"1.0 x";
        
        ZFCoverModel *sModel2 = [[ZFCoverModel alloc] init];
        sModel2.type = ZFVideoRate;
        sModel2.rateType = ZFVideoRate25X;
        sModel2.text = @"1.25 x";
        
        ZFCoverModel *sModel3 = [[ZFCoverModel alloc] init];
        sModel3.type = ZFVideoRate;
        sModel3.rateType = ZFVideoRate5X;
        sModel3.text = @"1.5 x";
        
        ZFCoverModel *sModel4 = [[ZFCoverModel alloc] init];
        sModel4.type = ZFVideoRate;
        sModel4.rateType = ZFVideoRate2X;
        sModel4.text = @"2.0 x";
        _ratesArray = @[sModel,sModel1,sModel2,sModel3,sModel4];
    }
    return _ratesArray;
}

- (NSArray *)timesArray {
    if (!_timesArray) {
        ZFCoverModel *model = [[ZFCoverModel alloc] init];
        model.text = @"不开启";
        model.timerType = ZFVideoTimerNO;
        model.isSelected = YES;
        
        ZFCoverModel *model1 = [[ZFCoverModel alloc] init];
        model1.timerType = ZFVideoTimerCurrent;
        model1.text = @"播放完当前";
        
        ZFCoverModel *model2 = [[ZFCoverModel alloc] init];
        model2.timerType = ZFVideoTimer30;
        model2.text = @"30:00";
        
        ZFCoverModel *model3 = [[ZFCoverModel alloc] init];
        model3.timerType = ZFVideoTimer60;
        model3.text = @"60:00";
        
        _timesArray = @[model,model1,model2,model3];
    }
    return _timesArray;
}

- (void)resetSelect {
    _currentQx = 0;
    _rate = 1.0;
    [_timesArray enumerateObjectsUsingBlock:^(ZFCoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.text isEqualToString:@"不开启"]) {
            obj.isSelected = YES;
        } else {
            obj.isSelected = NO;
        }
    }];
    [_ratesArray enumerateObjectsUsingBlock:^(ZFCoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.text isEqualToString:@"1.0 x"]) {
            obj.isSelected = YES;
        } else {
            obj.isSelected = NO;
        }
    }];
    [_moreArray enumerateObjectsUsingBlock:^(ZFCoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    [_qxArray enumerateObjectsUsingBlock:^(ZFCoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.text isEqualToString:@"标清"]) {
            obj.isSelected = YES;
        } else {
            obj.isSelected = NO;
        }
    }];
}
@end
