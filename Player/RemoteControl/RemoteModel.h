//
//  RemoteModel.h
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteModel : NSObject
@property (nonatomic, copy) NSString *totalTime;
@property (nonatomic, copy) NSString *currtentTime;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat rate;
@end

NS_ASSUME_NONNULL_END
