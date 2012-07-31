//
//  SongListViewController.h
//  KoreaMusic
//
//  Created by 刘 利伟 on 12-8-1.
//  Copyright (c) 2012年 ybnews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>  
#import "Hprose.h"

@protocol Phpox
-(oneway void) getSongList:(int)id selector:(SEL)selector delegate:(id)delegate;
@end

@interface SongListViewController : UIViewController
{
    NSArray *songarr;
}
@property (retain, nonatomic) IBOutlet HproseClient *hpClient;

@end
