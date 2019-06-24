//
//  PlayerTool.h
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteModel.h"
#import "ZFCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerTool : NSObject

+ (RemoteModel *)covertData: (ZFCoverModel *)model;

@end

NS_ASSUME_NONNULL_END
