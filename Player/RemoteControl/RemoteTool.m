
//
//  RemoteTool.m
//  Player
//
//  Created by MAc on 2019/6/20.
//  Copyright © 2019年 MAc. All rights reserved.
//

#import "RemoteTool.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation RemoteTool

- (void)addRemote {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    [self addNextCommond];
    [self addPrevousCommand];
    
    MPRemoteCommand *pauseCommand = [commandCenter pauseCommand];
    [pauseCommand setEnabled:YES];
    [pauseCommand addTarget:self action:@selector(pause)];
    
    MPRemoteCommand *playCommand = [commandCenter playCommand];
    [playCommand setEnabled:YES];
    [playCommand addTarget:self action:@selector(play)];
}

- (void)addPrevousCommand {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    MPRemoteCommand *previousCommand = [commandCenter previousTrackCommand];
    [previousCommand setEnabled:YES];
    [previousCommand addTarget:self action:@selector(previous)];
}

- (void)addNextCommond {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    MPRemoteCommand *nextCommand = [commandCenter nextTrackCommand];
    [nextCommand setEnabled:YES];
    [nextCommand addTarget:self action:@selector(next)];
}

- (void)removeNextCommand {
     MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
     [[commandCenter nextTrackCommand] removeTarget:self];
}

- (void)removePreviousCommand {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [[commandCenter previousTrackCommand] removeTarget:self];
}

- (void)removeAll {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [[commandCenter previousTrackCommand] removeTarget:self];
    [[commandCenter nextTrackCommand] removeTarget:self];
    [[commandCenter pauseCommand] removeTarget:self];
    [[commandCenter playCommand] removeTarget:self];
}

- (void)previous {
    [self.delegate previousModel:^(RemoteModel *model) {
        [RemoteTool updateInfo:model];
    }];
}

- (void)next {
    [self.delegate nextModel:^(RemoteModel *model) {
        [RemoteTool updateInfo:model];
    }];
}

- (void)pause {
    [self.delegate stop];
}

- (void)play {
    [self.delegate play];
}

+ (void)updateInfo: (RemoteModel *)model {
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MPMediaItemPropertyTitle] = model.title;
    info[MPMediaItemPropertyAlbumTitle] = model.name;
    
    UIImage *img = [UIImage imageNamed:model.img];
    MPMediaItemArtwork *artwork;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 10.0) {
        artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(40, 40) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return [UIImage imageNamed:model.img];
        }];
    } else {
       artwork = [[MPMediaItemArtwork alloc] initWithImage:img];
    }
    info[MPMediaItemPropertyArtwork] = artwork;
    
    info[MPMediaItemPropertyPlaybackDuration] = @([model.totalTime doubleValue]);
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @([model.currtentTime doubleValue]);
    info[MPNowPlayingInfoPropertyPlaybackRate] = @(model.rate);

    center.nowPlayingInfo = info;
}


@end
