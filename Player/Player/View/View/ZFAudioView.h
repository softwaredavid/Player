//
//  ZFAudioView.h
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFAudioView : UIView


@property (nonatomic, weak) id<VideDelgate> delegate;

- (void)resetFrame;

@end

NS_ASSUME_NONNULL_END
