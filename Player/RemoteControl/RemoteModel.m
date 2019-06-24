
//
//  RemoteModel.m
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "RemoteModel.h"

@implementation RemoteModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"中业网校";
        _img = @"default_icon";
        _rate = 1.0;
    }
    return self;
}

@end
