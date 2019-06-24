//
//  ZFCoverView.h
//  ZFPlayer_Example
//
//  Created by MAc on 2019/6/17.
//  Copyright © 2019年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFCoverView : UIView
// 选集
@property (nonatomic, strong) NSArray *videos;
// 更多
@property (nonatomic, strong) NSArray *moreMeuns;
// 倍速
@property (nonatomic, strong) NSArray *rates;
// 清晰度
@property (nonatomic, strong) NSArray *qxs;

@property (nonatomic, assign) ZFCoverViewType type;
@property (nonatomic, strong) NSMutableArray *sources;

@property (nonatomic, weak) id<VideDelgate> delegate;

- (void)resetUI;

@end

NS_ASSUME_NONNULL_END
