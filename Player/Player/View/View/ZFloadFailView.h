//
//  ZFloadFailView.h
//  Player
//
//  Created by MAc on 2019/6/24.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reload)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ZFloadFailView : UIView

@property (nonatomic, copy) reload reload;

@end

NS_ASSUME_NONNULL_END
