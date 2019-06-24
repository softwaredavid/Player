//
//  PlayerTool.m
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "PlayerTool.h"

@implementation PlayerTool

+ (RemoteModel *)covertData: (ZFCoverModel *)model {
    RemoteModel *data = [[RemoteModel alloc] init];
    data.title = model.text;
    data.name = @"中业网校";
    data.rate = 1.0;
    data.img = @"default_icon";
    return data;
}

@end
