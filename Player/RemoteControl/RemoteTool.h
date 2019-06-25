//
//  RemoteTool.h
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteModel.h"

typedef void(^RemoteData)(RemoteModel *);

@protocol RemoteDelegate <NSObject>

- (void)nextModel: (RemoteData)act;
- (void)previousModel: (RemoteData)act;
- (void)stop;
- (void)play;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RemoteTool : NSObject

@property (nonatomic, weak) id<RemoteDelegate> delegate;

- (void)addRemote;

- (void)removeNextCommand;

- (void)removePreviousCommand;

- (void)addPrevousCommand;

- (void)addNextCommond;

- (void)removeAll;

+ (void)updateInfo: (RemoteModel *)model;


@end

NS_ASSUME_NONNULL_END
